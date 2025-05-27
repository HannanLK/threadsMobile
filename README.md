# Threads Mobile

A **fashion-focused e-commerce mobile app** for the [ThreadsApp Laravel backend](https://github.com/HannanLK/threadsApp).  

This Flutter application offers a modern, feature-rich shopping experience for clothing and accessories, integrating seamlessly with the backend API for product, cart, user, and payment operations.

## 📚 Table of Contents

- [About](#about)
- [Features](#features)
- [Project Structure](#project-structure)
- [Technology Used](#technology-used)
- [Installation](#installation)
- [API Integration](#api-integration)
- [License](#license)

## 📱 About

**Threads Mobile** is the official Flutter frontend for [ThreadsApp](https://github.com/HannanLK/threadsApp).  

Users can browse fashion products, manage cart & wishlist, place orders, update profiles, and enjoy interactive UI experiences — including Google Maps, gallery upload, and push notifications.

## ✨ Features

- User authentication (register/login)
- Product catalog with detail views and search
- Cart management and checkout
- Wishlist management
- Profile with gallery image support
- Google Maps integration (store/address selection)
- Battery status display
- Gallery access (Image Picker)
- Push/local notifications
- Light/Dark mode toggle
- Persistent local state with Shared Preferences

---

## 🗂️ Project Structure

```bash
lib/
├── Controllers/ # State management (auth, theme, profile, etc.)
├── services/ # API interaction logic
└── views/
    ├── components/ # Reusable UI widgets
    └── screens/ # Login, Home, Cart, Profile, etc.
assets/
└── images/
    ├── Onboarding/ # Onboarding GIFs
    └── Banner/ # Promo images
```

---

## 🧰 Technology Used

<img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg" width="20"/> **Flutter** – Cross-platform mobile framework  
<img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/dart.svg" width="20"/> **Dart** – Language powering Flutter  
<img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/laravel.svg" width="20"/> **Laravel API** – Threads backend integration  
🧠 **Provider** – State management  
🌐 **HTTP** – API communication  
💾 **Shared Preferences** – Local storage persistence  
🖼️ **Image Picker** – Gallery access  
📍 **Geolocator + Google Maps Flutter** – Address + map features  
🔔 **Local Notifications** – Push & in-app alerts  
🔒 **Permission Handler** – Runtime permissions  
🧭 **Persistent Bottom Nav Bar** – Smooth tab experience  
📦 **Cached Network Image** – Efficient image loading  
💳 **Flutter Stripe** – Payment processing  
🔋 **Battery Plus** – Battery status access  

---

## ⚙️ Installation

### 🔗 Clone the repo:
```bash
git clone https://github.com/HannanLK/threadsApp.git
cd threadsApp  # Navigate to Flutter project
```
### 📦 Install dependencies:
```bash
flutter pub get
```
### Configure your API endpoint:
Update the base URL in your Flutter environment (e.g., `lib/services/api_config.dart`).

This app communicates with the ThreadsApp Laravel backend via RESTful APIs.
Ensure the backend is running and publicly accessible to the mobile client (via localhost tunneling or hosted server).

### 🚀 Run the app:
```bash
flutter run
```
### 📥 Feature-Specific Package Commands
```bash
flutter pub add battery_plus                 # Battery status
flutter pub add image_picker                # Profile image upload
flutter pub add flutter_local_notifications # Push/local notifications
flutter pub add shared_preferences          # Persistent state
flutter pub add geolocator                  # Location services
flutter pub add google_maps_flutter         # Maps integration
flutter pub add flutter_stripe              # Payments
flutter pub add permission_handler          # Runtime permissions
flutter pub add cached_network_image        # Optimized image loading
flutter pub add provider                    # State management
```

https://pub.dev/packages/battery_plus  
https://pub.dev/packages/google_maps_flutter  
https://pub.dev/packages/flutter_stripe  

---

## API Integration

This app communicates with the ThreadsApp Laravel backend via RESTful APIs.  
Ensure the backend is running and accessible to the mobile app.

---

## 📝 License

This project is intended for educational and portfolio purposes.
