# threads mobile

A **fashion-focused e-commerce mobile app** for the [threadsApp Laravel backend](https://github.com/HannanLK/threadsApp). This Flutter application provides a modern, feature-rich shopping experience for clothing and accessories, integrating with the backend API for all commerce operations.

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [API Integration](#api-integration)
- [License](#license)

---

## About

**threads mobile** is the official mobile frontend for the [threadsApp](https://github.com/HannanLK/threadsApp) Laravel backend. It allows users to browse fashion products, manage their cart and wishlist, checkout, and handle their profile, all from a beautiful and responsive Flutter app.

---

## Features

- User authentication (register, login)
- Product catalog, details, and search
- Shopping cart and checkout
- Wishlist management
- User profile management
- Google Maps integration (store locations, address selection)
- Battery status display
- Gallery access for profile images
- Push/local notifications
- Light/dark mode
- Persistent state with local storage

---

## Project Structure

```
lib/
  Controllers/         # State management (profile, theme, etc.)
  services/            # API and backend service logic
  views/
    components/        # Reusable UI widgets (product cards, nav, etc.)
    screens/           # App screens (login, home, cart, profile, etc.)
assets/
  images/
    Onboarding/        # Onboarding GIFs
    Banner/            # Banner and promotional images
```

---

## Tech Stack

- **Flutter** (Dart)
- **Provider** (state management)
- **HTTP** (API calls)
- **Shared Preferences** (local storage)
- **Image Picker** (gallery access)
- **Geolocator** (location services)
- **Google Maps Flutter** (maps integration)
- **Flutter Local Notifications**
- **Permission Handler**
- **Persistent Bottom Nav Bar**
- **Cached Network Image**
- **Flutter Stripe** (payments)
- **Battery Plus** (battery status)

### SVG Icons via jsDelivr

For beautiful SVG icons, you can use [jsDelivr](https://www.jsdelivr.com/) CDN.  
Example for including an icon in your README:

```markdown
<img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg" width="24" height="24" alt="Flutter"/>
<img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/laravel.svg" width="24" height="24" alt="Laravel"/>
<img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/dart.svg" width="24" height="24" alt="Dart"/>
```

---

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/HannanLK/threadsApp.git
   cd threadsApp
   # For the mobile app, go to the Flutter project directory
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Configure API endpoints:**
   - Update your API base URL in the Flutter app to point to your Laravel backend.

4. **Run the app:**
   ```sh
   flutter run
   ```

5. **For web:**
   ```sh
   flutter run -d chrome
   ```

---

## API Integration

This app communicates with the [threadsApp Laravel backend](https://github.com/HannanLK/threadsApp) via RESTful APIs for all commerce and user operations.  
Make sure your backend is running and accessible to the mobile app.

---

## License

This project is for educational purposes.

---

### Example Tech Stack Icons

<p>
  <img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg" width="32" height="32" alt="Flutter"/>
  <img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/laravel.svg" width="32" height="32" alt="Laravel"/>
  <img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/dart.svg" width="32" height="32" alt="Dart"/>
</p>

---

**References:**
- [threadsApp Laravel Backend](https://github.com/HannanLK/threadsApp)
