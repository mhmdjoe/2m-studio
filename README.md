# 2M Studio | Photography Portfolio & Booking App

A Flutter mobile and web application for a photography studio: a high-resolution portfolio gallery, an interactive before/after retouching showcase, and a client booking flow, with an admin area for managing the portfolio content through Firebase.

**Live web demo:** https://mhmdjoe.github.io/2m-studio/ (runs in the browser, no install needed)

## What it does

- **Portfolio gallery** - bento/masonry photo grid (`flutter_staggered_grid_view`) with a project detail page per shoot.
- **Before / after retouching slider** - interactive comparison of raw vs retouched photos.
- **Booking flow** - a session booking form that composes a WhatsApp message to the studio with the client's details (`url_launcher`).
- **Admin content management** - an admin login (Firebase Authentication) unlocks adding and editing portfolio projects, stored in Cloud Firestore.
- **Offline-safe data layer** - the gallery ships with seed content and merges in Firestore data when the backend is reachable, so the demo always renders.

## Tech stack

| Layer | Technology |
| :--- | :--- |
| Framework | Flutter (Dart 3.x), Android / iOS / Web |
| Backend | Firebase Core, Firebase Auth, Cloud Firestore, Firebase Storage |
| State management | `flutter_riverpod` |
| Routing | `go_router` |
| UI | `flutter_staggered_grid_view`, `before_after_image_slider`, `animations`, `google_fonts`, `font_awesome_flutter` |

## Project structure

```text
lib/
├── main.dart                        # Entry point, Firebase init
├── firebase_options.dart            # Generated Firebase config
├── models/project.dart              # Project data model
├── features/
│   ├── admin/                       # Firestore repository + admin state (Riverpod)
│   └── retouching_showcase/         # Before/after slider feature
├── pages/
│   ├── home_page.dart               # Landing page
│   ├── portfolio_page.dart          # Gallery
│   ├── project_detail_page.dart     # Single project view
│   ├── booking_page.dart            # Booking form -> WhatsApp
│   ├── about_page.dart, contact_page.dart
│   └── admin/admin_login_page.dart  # Firebase Auth admin login
└── widgets/                         # Navbar, bento grid, reveal animations, custom cursor
```

## Run it locally

```bash
git clone https://github.com/mhmdjoe/2m-studio.git
cd 2m-studio
flutter pub get
flutter run            # or: flutter run -d chrome
```

The app runs without a Firebase backend by falling back to bundled sample projects. To connect your own Firebase project, replace `lib/firebase_options.dart` with the output of `flutterfire configure`.

## Status

Portfolio demo. The studio, photography, and contact details are sample content. Booking submits through WhatsApp rather than a server-side reservation system, and admin access is a single shared account rather than per-user roles.

## License

MIT
