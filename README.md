# HDFC Bank - Family Asset Tracker

A production-grade Family Asset & Wealth Tracking application designed for HDFC Bank customers to track, manage, and visualize consolidated family net worth with granular, directional privacy controls.

---

## Key Features

- **Consolidated & Personal Portfolio Tracking:** Real-time dual overview of Total Family Net Worth and Personal Assets with dynamic returns and asset allocation breakdown.
- **Dynamic Real-Time Calculations:** Zero static values—portfolio totals, returns, category percentages, and charts update dynamically with any asset or visibility change.
- **Directional Profile Privacy:** Independent visibility controls between family members. Hiding your profile hides your holdings from a member while still allowing you to view their shared assets. Unauthorized access displays a secure privacy lock screen.
- **Multi-Asset Portfolio Support:** Supports 6 asset classes (Equity, Real Estate, Gold, Crypto, Mutual Funds, Fixed Deposits/Other) with custom asset type management.
- **Full Asset Lifecycle:** Add, edit, and delete holdings in real time across family members.
- **Self-Identifying Filter:** Holdings filter clearly highlights the active account with `(Self)` for rapid navigation.
- **Centralized Profile Switching:** Exactly one canonical switcher located under Settings > Family Circle for seamless account switching.
- **Local Database Persistence:** SharedPreferences-backed local database with default seeding, credential authentication, PIN validation, and session management.

---

## Demo Family Accounts

All default accounts use PIN: **`1234`**

| Name | Role | Mobile Number | Default Status |
| :--- | :--- | :--- | :--- |
| **Krish (Father)** | Primary Account Holder | `9876543210` | Default Active User |
| **Trish (Mother)** | Mother | `9876543211` | Family Circle Member |
| **Akshay (Child 1)** | Child 1 | `9876543212` | Family Circle Member |
| **Abhishek (Child 2)** | Child 2 | `9876543213` | Family Circle Member |

---

## Getting Started

### Prerequisites
- Flutter SDK (Channel stable, version >= 3.0.0)
- Dart SDK (version >= 3.0.0)

### Run Application

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Chrome / Web
flutter run -d chrome

# Or run on available device
flutter run
```

### Run Test Suite

```bash
flutter test
```

---

## Technology Stack

- **Framework:** Flutter (Web & Mobile responsive)
- **Language:** Dart
- **State Management:** ChangeNotifier / ListenableBuilder
- **Design System:** HDFC Brand Colors & Typography (`#004B87` Deep Navy, `#ED1C24` Red, `#001C38` Navy)
- **Local Storage:** `shared_preferences` with in-memory fallback
