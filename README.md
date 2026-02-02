# 📖 Quran Digital — A Modern Flutter-Based Al-Qur’an Application

**Quran Digital** is a mobile application built with **Flutter** that provides a modern, clean, and user-friendly way to read and explore the Holy Qur’an.  
The app is designed using **Clean Architecture** and **feature-based structure** to ensure scalability, maintainability, and professional-grade code quality.

This application supports reading Surahs and Juz, searching verses, tracking reading history, and viewing daily prayer times.

---

## ✨ Key Features

- 📘 **Read the Qur’an**
  - Complete list of **114 Surahs**
  - **Juz 1–30** navigation
  - Verse-by-verse reading with Arabic text & translation
  - Audio recitation support
  - Auto-scroll to specific verses

- 🔍 **Advanced Search**
  - Search by **Surah name**
  - Search by **verse translation**
  - Direct navigation to the selected verse

- 📌 **Last Read & Reading History**
  - Automatically saves reading progress
  - Stores the last read Surah and verse
  - Displays a history of previously read Surahs
  - One-tap resume reading from the last verse

- 🕌 **Prayer Times**
  - Daily prayer schedule
  - Powered by the **Aladhan Prayer Times API**
  - Designed to support future GPS-based location detection

- ⚡ **Offline-Friendly**
  - Cached Surah and Juz data using local storage
  - Fast access even with limited connectivity

---

## 🗂️ Project Structure

The project follows **Clean Architecture** with a **feature-first approach**:

```

lib/
│
├── core/
│   ├── error/          # Exceptions & failures
│   ├── network/        # API client & connectivity checker
│   ├── usecase/        # Base usecase abstraction
│   └── utils/          # Constants, theme, colors
│
├── features/
│   ├── home/           # Home menu & navigation
│   ├── quran/          # Qur’an reading (Surah, Juz, Ayat)
│   ├── search/         # Search feature
│   ├── last_read/      # Reading history & progress
│   ├── prayer/         # Prayer times
│   └── settings/       # App settings (extensible)
│
└── main.dart           # Application entry point

````

### Architecture Layers
- **Presentation** → UI, Pages, Widgets, Bloc
- **Domain** → Entities, Repositories, Use Cases
- **Data** → Models, Data Sources, Repository Implementations

---

## ⚙️ Technologies Used

- **Flutter**
- **Dart**
- **flutter_bloc**
- **http**
- **shared_preferences**
- **just_audio**
- **scrollable_positioned_list**
- **internet_connection_checker**

---

## 🌐 APIs Used

- 📖 **Qur’an API**  
  https://api.quran.gading.dev

- 🕌 **Prayer Times API**  
  https://aladhan.com/prayer-times-api

---

## 🚀 How to Run the Application

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Hardikasetiyawann/quran-digital.git
````

### 2️⃣ Navigate to the Project Directory

```bash
cd quran-digital
```

### 3️⃣ Install Dependencies

```bash
flutter pub get
```

### 4️⃣ Run the Application

```bash
flutter run
```

---

## 🧭 Roadmap & Future Improvements

* ⭐ Bookmark verses
* 🔔 Prayer time notifications (Adhan)
* 📍 Automatic location detection (GPS)
* 🕋 Qibla direction
* 🔄 Firebase synchronization (multi-device)
* 🌙 Dark mode
* 📊 Reading statistics & insights

---

## 👨‍💻 Author

**Hardika Setiyawan**  
Program Studi Informatika - Universitas Amikom Purwokerto  

---

## 📄 License

This project is **open-source** and intended for educational and personal development purposes.

---

📖 *May this application help users read, reflect, and stay connected with the Qur’an.*

```