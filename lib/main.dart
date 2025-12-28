import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';

// Import our services and models  
import 'services/voice_service.dart';
import 'services/context_service.dart';
import 'services/gemini_service.dart';
import 'models/live_context.dart';

// Import glassmorphism widgets
import 'widgets/glass_message_bubble.dart';
import 'widgets/glass_input_area.dart';
import 'widgets/glass_background.dart';

void main() {
  // Initialize logging for the entire app
  VoiceService.configureLogging(level: Level.INFO);
  
  runApp(const NethraApp());
}

class NethraApp extends StatelessWidget {
  const NethraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        Provider(create: (_) => VoiceService()),
        Provider(create: (_) => ContextService()),
      ],
      child: MaterialApp(
        title: 'Nethra - Namma Guide',
        theme: _buildTheme(),
        home: const ChatScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      primaryColor: Colors.purpleAccent,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isLoading = false;
  
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isListening => _isListening;
  bool get isLoading => _isLoading;

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void setListening(bool listening) {
    _isListening = listening;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late VoiceService _voiceService;
  late ContextService _contextService;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Add initialization state tracking
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    
    // Get services from context
    _voiceService = context.read<VoiceService>();
    _contextService = context.read<ContextService>();
    
    // Add welcome message immediately
    _addWelcomeMessage();
    
    // Start background services WITHOUT awaiting (UI First!)
    _startBackgroundServices();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage.assistant(
      "🌟 Welcome to Namma Bengaluru! I'm Nethra, your local guide.",
    );
    context.read<ChatProvider>().addMessage(welcomeMessage);
  }

  void _startBackgroundServices() async {
    final chatProvider = context.read<ChatProvider>();
    
    try {
      // Debug Log: Starting initialization
      chatProvider.addMessage(ChatMessage.assistant("🧠 Initializing Brain..."));
      _scrollToBottom();
      
      // Initialize AI Logic with Gemini
      await AILogic.initModel();
      chatProvider.addMessage(ChatMessage.assistant("✅ Brain Active! Gemini AI ready with Bengaluru persona!"));
      _scrollToBottom();
      
      // Initialize Voice Service
      chatProvider.addMessage(ChatMessage.assistant("🎤 Initializing Voice..."));
      _scrollToBottom();
      
      await _voiceService.initialize();
      chatProvider.addMessage(ChatMessage.assistant("✅ Voice Active!"));
      _scrollToBottom();
      
      // All systems ready
      chatProvider.addMessage(ChatMessage.assistant(
        "🚀 All systems ready! Ask me about traffic, food, or getting around Bengaluru!"
      ));
      _scrollToBottom();
      
      // Mark initialization as complete
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
      
    } catch (e) {
      // Error handling with visible feedback
      chatProvider.addMessage(ChatMessage.assistant("❌ Error: $e"));
      chatProvider.addMessage(ChatMessage.assistant(
        "Don't worry! You can still chat with me using text input."
      ));
      _scrollToBottom();
      
      // Mark initialization as complete with error
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleUserInput(String input) async {
    if (input.trim().isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    
    // Add user message
    final userMessage = ChatMessage.user(input);
    chatProvider.addMessage(userMessage);
    chatProvider.setLoading(true);

    try {
      // Get AI response using Gemini with proper steering (now async)
      final liveContext = await _contextService.getCurrentContext();
      final response = await AILogic.getResponse(input, liveContext);
      
      // Add AI response
      final aiMessage = ChatMessage.assistant(response);
      chatProvider.addMessage(aiMessage);

      // Try to speak response if voice is available
      if (_voiceService.isInitialized && mounted) {
        await _voiceService.speak(response, isBlindMode: false);
      }
      
    } catch (e) {
      // Error handling with haptic feedback
      if (mounted) {
        await HapticPatterns.errorAlert();
        final errorMessage = ChatMessage.assistant(
          "Sorry macha, I'm having trouble right now. Please try again! 😅",
        );
        chatProvider.addMessage(errorMessage);
      }
    } finally {
      if (mounted) {
        chatProvider.setLoading(false);
      }
    }

    // Clear input and scroll to bottom
    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startVoiceInput() async {
    final chatProvider = context.read<ChatProvider>();
    
    if (!_voiceService.isInitialized) {
      _showSnackBar('Voice service not ready yet. Please wait...');
      return;
    }

    chatProvider.setListening(true);

    await _voiceService.startListening(
      onResult: (result) {
        if (result.trim().isNotEmpty) {
          _handleUserInput(result);
        }
      },
      onComplete: () {
        chatProvider.setListening(false);
      },
    );
  }

  void _stopVoiceInput() async {
    await _voiceService.stopListening();
    if (mounted) {
      context.read<ChatProvider>().setListening(false);
    }
  }

  void _showSnackBar(String message) async {
    // Light haptic for notifications
    await HapticPatterns.lightTap();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.purpleAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen during initialization
    if (_isInitializing) {
      return _buildInitializationLoadingScreen();
    }
    
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final contextService = context.read<ContextService>();
        final isBlindMode = contextService.isBlindMode;
        
        return GlassBackground(
          isBlindMode: isBlindMode,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: GlassAppBar(
              title: 'Namma Guide',
              isBlindMode: isBlindMode,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(child: _buildChatArea(chatProvider, isBlindMode)),
                  if (chatProvider.isLoading) 
                    GlassLoadingIndicator(
                      isBlindMode: isBlindMode,
                    ),
                  _buildInputArea(chatProvider, isBlindMode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatArea(ChatProvider chatProvider, bool isBlindMode) {
    if (chatProvider.messages.isEmpty) {
      return Center(
        child: GlassLoadingIndicator(
          message: 'Welcome to Namma Bengaluru!',
          isBlindMode: isBlindMode,
        ),
      );
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(bottom: 8), // Add bottom padding to prevent overflow
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: chatProvider.messages.length,
        itemBuilder: (context, index) {
          final message = chatProvider.messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4), // Add spacing between messages
            child: GlassMessageBubble(
              message: message,
              isBlindMode: isBlindMode,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitializationLoadingScreen() {
    final contextService = context.read<ContextService>();
    final isBlindMode = contextService.isBlindMode;
    
    return GlassBackground(
      isBlindMode: isBlindMode,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: GlassLoadingIndicator(
            message: 'Initializing Nethra...',
            isBlindMode: isBlindMode,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider, bool isBlindMode) {
    return GlassInputArea(
      controller: _textController,
      onSend: () => _handleUserInput(_textController.text),
      onVoiceStart: _startVoiceInput,
      onVoiceStop: _stopVoiceInput,
      isListening: chatProvider.isListening,
      isBlindMode: isBlindMode,
    );
  }
}