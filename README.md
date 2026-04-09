# 🌾 Kisan Sahayak – Smart AI Assistant for Farmers

Kisan Sahayak is a **Flutter-based mobile application** designed to empower farmers by providing **real-time assistance, market insights, weather updates, disease detection, voice-based navigation, and offline diary management** — all in one simple and farmer-friendly app.

---

## 🚀 Key Features

### 🎙️ Voice Assistant (Multilingual)
- Voice-based navigation for farmers
- Supports **multiple Indian languages**
- Commands like:
  - Weather updates
  - Mandi prices
  - Disease detection
  - Diary access

---

### 🌦️ Weather Information
- Current weather details
- Forecast-based UI
- Simple and readable format for farmers

---

### 📊 Mandi Bhav (Market Prices)
- **Static dataset (offline-ready)** for demo & hackathon
- Covers:
  - Multiple Indian states
  - Major cities per state
  - Multiple crops (wheat, rice, soybean, etc.)
- Shows:
  - Current price
  - Previous 3–5 days history
  - Trend graph (price increase/decrease)

---

### 🌱 Crop Disease Detection (AI-powered)
- Image upload from:
  - Camera
  - Gallery
- AI model integration using **Roboflow API**
- Detects crop diseases from images
- Designed for future model upgrades

---

### 📔 Farmer Diary (Offline Storage)
- Farmers can:
  - Write daily notes
  - Store farming activities
- Data is saved **offline** (SharedPreferences)
- Can view previously saved entries anytime

---

## 🛠️ Tech Stack

| Layer | Technology |
|------|-----------|
| Frontend | Flutter (Dart) |
| AI Model | Roboflow Hosted API |
| Charts | Flutter Chart Widgets |
| Voice | Speech-to-Text |
| Storage | SharedPreferences (Offline) |
| Platform | Android |
| Version Control | Git & GitHub |

---

## 📱 Supported Platforms
- ✅ Android (Primary)
- ⚠️ Web (Limited: camera & mic restrictions)

---

## 🧑‍🌾 Target Users
- Small & marginal farmers
- Rural users with limited technical knowledge
- Voice-first interaction users

---

## 📦 Installation & Run

### Prerequisites
- Flutter SDK
- Android Studio
- Android Emulator or Real Device

### Steps
```bash
flutter pub get
flutter run
