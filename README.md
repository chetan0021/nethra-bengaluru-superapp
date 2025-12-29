# 🏙️ Namma Guide - The Voice-First Bengaluru AI Assistant

![Kiro Hackathon Submission](https://img.shields.io/badge/Kiro%20Hackathon-Submission-purple?style=for-the-badge&logo=flutter)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Google Gemini](https://img.shields.io/badge/Google%20Gemini-4285F4?style=for-the-badge&logo=google&logoColor=white)

> **"Distance in Bengaluru is measured in time, not kilometers"** - Your hyper-local AI guide that speaks like a true Bengalurean

---

## 🤔 The "Why"

Generic AI assistants don't understand that **Silk Board at 6 PM = 2 hours of your life gone**. They don't know that when it rains in Bengaluru, autos disappear faster than free samosas at a tech event. 

**Namma Guide** is different. It's an AI that thinks like a local, talks like your Bengaluru buddy, and gives advice that actually makes sense for our city.

---

## 🌟 The "Agent Steering" Magic ✨

Here's our **secret sauce**: Instead of training a massive model, we use **Agent Steering** - a custom context file that teaches Gemini to be a true Bengalurean.

**[📂 View the Brain (Steering Logic)](assets/product.md)**

### Before vs After Comparison

| Scenario | Generic AI Response | Namma Guide Response |
|----------|-------------------|---------------------|
| **Rain + Travel** | "It is raining. Consider taking an umbrella." | "Ayyo boss! It's pouring. No auto will come. Book Prime SUV or stay home with Bisi Bele Bath." |
| **Peak Hour Traffic** | "Traffic may be heavy during rush hours." | "Silk Board at peak hour? Are you mad macha? Take Metro to Indiranagar instead." |
| **Food Recommendation** | "Here are some restaurants near you." | "Dosa scene ah? Vidyarthi Bhavan for the vibe, CTR for the butter. Adjust maadi!" |

---

## 🛠️ Tech Stack

- **🎯 Frontend:** Flutter (Cross-platform mobile app)
- **🧠 AI Engine:** Google Gemini 2.0 Flash (Latest experimental model)
- **🎤 Voice:** Speech-to-Text + Text-to-Speech with local personality
- **🌤️ Context:** Real-time weather + traffic data (Google APIs)
- **⚡ IDE:** Built with Kiro IDE for rapid development
- **🎨 UI:** Glassmorphism design with cyberpunk Bengaluru aesthetics

---

## ✨ Key Features

### 🎙️ **Voice-First Experience**
- Natural speech recognition optimized for Indian English
- Responds in authentic Bengaluru slang ("Macha", "Guru", "Adjust maadi")
- Accessibility-first design with blind mode support

### 🌧️ **Rain Protocol**
- Detects weather conditions and gives realistic travel advice
- Knows that Bengaluru autos have rain-sensing invisibility cloaks
- Suggests alternatives like "order Bisi Bele Bath and stay home"

### 🚗 **Traffic Intelligence** 
- **Silk Board Mockery:** Actively discourages peak-hour Silk Board attempts
- Real-time traffic data for major Bengaluru routes
- Suggests Metro alternatives with local knowledge

### 🍽️ **Heritage Food Guide**
- Prioritizes local institutions over global chains
- Never suggests McDonald's (because we have standards)
- Knows the difference between CTR butter dosa and Vidyarthi Bhavan experience

### 🎨 **Cyberpunk Bengaluru Aesthetics**
- Glassmorphism UI with neon accents
- Dark theme optimized for late-night coding sessions
- Smooth animations that don't lag (unlike BMTC buses)

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.8.1+)
- Android Studio / VS Code
- A sense of humor about Bengaluru traffic

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/namma-guide.git
cd namma-guide

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Optional: Real Data Setup
For real-time weather and traffic data, add your Google API key:

1. Follow the setup guide: [📋 Google API Setup](GOOGLE_API_SETUP.md)
2. Edit `lib/config/api_config.dart` with your API key
3. Enable Directions API, Places API, and Geocoding API

**Note:** The app works perfectly without API keys using intelligent Bengaluru weather patterns!

---

## 🎯 How Agent Steering Works

Traditional AI training requires massive datasets and computational resources. **Agent Steering** is different:

1. **📝 Context File:** All Bengaluru knowledge lives in `assets/product.md`
2. **🧠 Runtime Injection:** Context is injected into every Gemini API call
3. **⚡ Instant Updates:** Change the personality by editing one file
4. **🎯 Hyper-Local:** Responses are contextually aware of time, weather, and location

This approach makes the AI:
- **Faster to develop** (no model training)
- **Easier to maintain** (edit text files, not neural networks)
- **More accurate** for local use cases
- **Instantly updatable** (new protocols via file edits)

---

## 🏆 What Makes This Worthy

### 🚀 **Innovation**
- **Agent Steering** technique for rapid AI customization
- Voice-first interface optimized for Indian English
- Real-time context injection (weather + traffic + time)

### 🎯 **Problem Solving**
- Addresses the gap in hyper-local AI assistants
- Solves the "generic AI doesn't understand local context" problem
- Makes AI accessible through voice in local languages

### 🛠️ **Technical Excellence**
- Clean Flutter architecture with service layer pattern
- Robust error handling and offline fallbacks
- Comprehensive testing suite
- Production-ready code quality

### 🌍 **Impact**
- Makes AI more inclusive for regional users
- Demonstrates scalable approach for other cities
- Shows how to build culturally-aware AI applications

---

## 🎬 Demo Scenarios

Try these voice commands to see Namma Guide in action:

```
🎤 "How's the weather?"
🤖 "Macha, it's monsoon season! Carry umbrella always. Better safe than soaked."

🎤 "Traffic to Electronic City?"
🤖 "Silk Board is jammed solid - 90 minutes! Take Hosur Road instead, only 45 minutes."

🎤 "Where to eat dosa?"
🤖 "Vidyarthi Bhavan for the vibe, CTR for the butter. Simply don't waste time!"

🎤 "Should I take auto?"
🤖 "It's raining guru! No auto will come. Book Ola Prime or order food and chill."
```

---

## 🤝 Contributing

We welcome contributions! Whether it's:
- 🌧️ Adding new weather patterns
- 🚗 Improving traffic intelligence
- 🍽️ Expanding food recommendations
- 🎨 Enhancing UI/UX
- 🧪 Writing tests

Check out our [Contributing Guidelines](CONTRIBUTING.md) to get started.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Kiro IDE** for the amazing development experience
- **Google Gemini** for the powerful AI capabilities
- **Bengaluru** for being the most beautifully chaotic city
- **Every auto driver** who taught us that "meter illa" is a way of life

---

## 📞 Contact

Built with ❤️ for Bengaluru by Chetan V

- 📧 Email: chetanv.kar@gmail.com


---

**Remember:** In Bengaluru, we don't just build apps - we build experiences that understand our beautiful chaos! 🚀

*"Adjust maadi and enjoy the ride!"* - Namma Guide
