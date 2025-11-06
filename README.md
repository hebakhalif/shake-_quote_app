# 🤳 Shake to Get a Quote

A Flutter app that displays **random motivational quotes** when you shake your phone — perfect for instant inspiration during study sessions! 🌟

---

## ✨ Features

- 📱 **Shake detection** using Android accelerometer  
- 💬 **20+ motivational quotes in Arabic**  
- 🎨 **Beautiful animations and modern UI**  
- ⚡ **Real-time response** with smooth transitions  

---

## 🛠️ Tech Stack

| Technology | Purpose |
|-------------|----------|
| **Flutter** | UI and animations |
| **Kotlin** | Native shake detection |
| **EventChannel** | Flutter ↔ Android communication |
| **SensorManager** | Accelerometer integration |

---

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/yourusername/shake-quote-app.git

# Navigate into the project
cd shake-quote-app

# Install dependencies
flutter pub get

# Run the app
flutter run

 Project Structure

lib/
├── main.dart          # Flutter UI & EventChannel
└── quotes_data.dart   # Quotes collection

android/app/src/main/kotlin/
└── MainActivity.kt    # Shake detection logic
