# Project Structure: Nethra Bengaluru SuperApp

## Root Directory Organization
```
nethra_bengaluru_superapp/
├── lib/                    # Main Dart source code
├── android/               # Android-specific configuration
├── ios/                   # iOS-specific configuration
├── web/                   # Web platform support
├── linux/                 # Linux desktop support
├── macos/                 # macOS desktop support
├── windows/               # Windows desktop support
├── test/                  # Unit and widget tests
├── assets/                # Static assets (fonts, images, sounds)
├── docs/                  # Project documentation
├── .kiro/                 # Kiro IDE configuration and steering
├── pubspec.yaml           # Dependencies and project configuration
└── README.md              # Project overview
```

## Core Source Structure (`lib/`)
```
lib/
├── main.dart              # App entry point and main widget
├── models/                # Data models and entities
│   ├── live_context.dart  # Context data for AI decisions
│   └── chat_message.dart  # Chat message model (in live_context.dart)
├── services/              # Business logic and external integrations
│   ├── ai_logic.dart      # Core AI decision engine
│   ├── voice_service.dart # Speech-to-text and text-to-speech
│   └── context_service.dart # Live context management
├── screens/               # Full-screen UI components
│   └── chat_screen.dart   # Main chat interface (in main.dart)
├── widgets/               # Reusable UI components
│   ├── glass_chat.dart    # Glassmorphism chat bubbles
│   └── voice_button.dart  # Voice input button component
└── theme/                 # Design system and styling
    ├── colors.dart        # Color palette and constants
    ├── typography.dart    # Text styles and font configuration
    └── theme_data.dart    # Flutter theme configuration
```

## Asset Organization (`assets/`)
```
assets/
├── fonts/                 # Custom font files
│   └── .gitkeep          # Placeholder for Poppins font family
├── images/                # UI graphics and icons
│   └── .gitkeep          # Placeholder for app graphics
├── sounds/                # Audio files for haptic feedback
│   └── .gitkeep          # Placeholder for sound effects
└── product.md            # Product definition (used by AI logic)
```

## Test Structure (`test/`)
```
test/
├── ai_logic_test.dart     # Unit tests for AI decision engine
├── widget_test.dart       # Widget tests for UI components
├── voice_service_test.dart # Tests for voice functionality
└── integration_test/      # End-to-end integration tests
    └── app_test.dart      # Full app workflow tests
```

## Platform Configuration

### Android (`android/`)
- `app/build.gradle.kts` - Build configuration and dependencies
- `app/src/main/AndroidManifest.xml` - Permissions and app metadata
- `app/src/main/kotlin/` - Native Android code (minimal)

### iOS (`ios/`)
- `Runner/Info.plist` - App configuration and permissions
- `Runner.xcodeproj/` - Xcode project configuration
- `Runner/` - Native iOS code (minimal)

## Documentation (`docs/`)
```
docs/
├── requirements.md        # Technical requirements and specifications
└── tasks.md              # Development roadmap and task breakdown
```

## Kiro Configuration (`.kiro/`)
```
.kiro/
├── steering/              # AI assistant guidance rules
│   ├── product.md         # Product overview and identity
│   ├── tech.md           # Technology stack and commands
│   └── structure.md      # This file - project organization
└── specs/                # Feature specifications and designs
    ├── app-crash-fix/     # Bug fix specifications
    └── phase3-completion/ # Feature completion specs
```

## Key Architectural Principles

### Service Layer Pattern
- **Services** are singletons that handle external integrations
- **Models** are immutable data classes with factory constructors
- **Widgets** are pure UI components that consume services via Provider

### State Management Flow
```
User Input → Service → Model Update → Provider Notification → UI Rebuild
```

### File Naming Conventions
- **snake_case** for all Dart files and directories
- **PascalCase** for class names
- **camelCase** for variables and methods
- **SCREAMING_SNAKE_CASE** for constants

### Import Organization
1. Dart SDK imports
2. Flutter framework imports
3. Third-party package imports
4. Local project imports (relative paths)

### Code Organization Within Files
1. Imports (grouped as above)
2. Class/enum definitions
3. Constants and static members
4. Instance variables
5. Constructors
6. Public methods
7. Private methods
8. Overrides (build, dispose, etc.)

## Development Workflow
1. **Feature branches** for new functionality
2. **Services first** - implement business logic before UI
3. **Test-driven** - write tests alongside implementation
4. **Accessibility-first** - consider blind mode in all UI decisions
5. **Performance-conscious** - profile glassmorphism effects regularly

## Build Artifacts (Generated)
- `.dart_tool/` - Dart tooling cache
- `build/` - Compiled output
- `.flutter-plugins-dependencies` - Plugin dependency cache
- Platform-specific build directories (ignored in git)