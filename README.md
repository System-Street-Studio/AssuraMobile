# AssuraMobile
Mobile Application of assura

# Assura Mobile Application

This is the mobile application part of the FAMS (Fixed Asset Management System).

## Proposed Folder Structure (Admin Division - QR Scanning)

For a clean and scalable implementation of QR scanning in the Admin division, the following feature-based structure is recommended:

```text
lib/
├── core/                # Common constants, themes, and utilities
│   ├── constants/       # App-wide constants (colors, strings, API endpoints)
│   ├── theme/           # Global styling and fonts
│   └── utils/           # Helper functions (QR parsing, data validation)
├── features/            # Feature-specific modules
│   └── admin/           # Admin division features
│       ├── data/        # Data handling (Models, Repositories, APIs)
│       │   ├── models/  # QR Data models
│       │   └── repos/   # Repository implementations
│       ├── logic/       # Business logic (Bloc, Provider, or Controllers)
│       └── presentation/ # UI components
│           ├── screens/ # QR Scanner screen, Admin Dashboards
│           └── widgets/ # Reusable UI components
├── services/            # Low-level external services (Camera, Scanner)
│   └── qr_service.dart  # QR scanning core implementation
└── main.dart            # Application entry point
```

### Key Components:
- **Presentation**: UI screens for capturing and displaying asset data.
- **Logic**: Reactive logic for handling scanning states and processing results.
- **Data**: Models and repositories for fetching/updating asset details based on scanned IDs.
ation of assura
