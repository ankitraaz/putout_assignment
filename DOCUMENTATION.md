# 📖 Kutoot — Complete App Documentation

> **Kutoot** — *Shop. Earn. Repeat.*
> A premium Shopping & Rewards Flutter application with feature-first clean architecture.

---

## 📋 Table of Contents

1. [App Overview](#-app-overview)
2. [Tech Stack & Dependencies](#-tech-stack--dependencies)
3. [Architecture & Project Structure](#-architecture--project-structure)
4. [Data Layer](#-data-layer)
5. [State Management (Riverpod Providers)](#-state-management-riverpod-providers)
6. [Screen-wise Functionality Breakdown](#-screen-wise-functionality-breakdown)
7. [Reusable Widgets](#-reusable-widgets)
8. [Design System (Theme, Colors, Dimensions)](#-design-system)
9. [Performance Optimizations](#-performance-optimizations)
10. [Build & Deployment](#-build--deployment)

---

## 🧩 App Overview

| Property        | Detail                              |
|-----------------|-------------------------------------|
| **App Name**    | Kutoot                              |
| **Package**     | `kuttot`                            |
| **Version**     | 1.0.0+1                             |
| **Min SDK**     | Android 21 (Lollipop)               |
| **Flutter SDK** | ^3.11.4                             |
| **Platform**    | Android, iOS, Web, Desktop          |
| **Tagline**     | *Shop. Earn. Repeat.*               |

Kutoot is a shopping & rewards platform where users can discover nearby stores, earn rewards by completing challenges, subscribe to membership plans, and manage their profiles — all within a fast, native experience.

---

## 🛠 Tech Stack & Dependencies

| Dependency              | Version   | Purpose                                     |
|-------------------------|-----------|---------------------------------------------|
| `flutter_riverpod`      | ^2.6.1    | State management (reactive, provider-based)  |
| `shared_preferences`    | ^2.5.5    | Persisting profile data (name, phone)        |
| `hive`                  | ^2.2.3    | Fast local NoSQL database for data caching   |
| `hive_flutter`          | ^1.1.0    | Flutter adapter for Hive (init, box access)  |
| `google_fonts`          | ^8.0.2    | Premium fonts (Inter, Oswald, Great Vibes)   |
| `cupertino_icons`       | ^1.0.8    | iOS-style icons                              |
| `flutter_launcher_icons`| ^0.14.4   | Custom app icon generation                   |

---

## 🏛 Architecture & Project Structure

The app follows a **Feature-First Clean Architecture** — each feature has its own folder with a presentation layer, while shared logic lives in `core/` and `data/`.

```
lib/
├── main.dart                          # App entry point
├── core/                              # Shared app-wide code
│   ├── constants/
│   │   ├── app_colors.dart            # All color constants & gradients
│   │   ├── app_dimens.dart            # Spacing, radius, elevation, sizes
│   │   └── app_strings.dart           # Static text / labels
│   ├── providers/
│   │   ├── app_providers.dart         # Global Riverpod providers (stores, categories, rewards, search, filter)
│   │   └── profile_provider.dart      # User profile state (SharedPreferences based)
│   ├── theme/
│   │   └── app_theme.dart             # Material3 ThemeData configuration
│   └── widgets/
│       └── custom_search_bar.dart     # Reusable search bar widget
│
├── data/                              # Data layer
│   ├── models/
│   │   ├── category_model.dart        # Category data model
│   │   ├── store_model.dart           # Store data model
│   │   ├── reward_model.dart          # Reward data model
│   │   └── plan_model.dart            # Membership plan data model
│   ├── repositories/
│   │   └── data_repository.dart       # JSON loading + Hive caching + Isolate parsing
│   └── dummy_data/                    # (Reserved for future mock data)
│
├── features/                          # Feature modules (screen-wise)
│   ├── splash/presentation/
│   │   └── splash_screen.dart         # Animated splash with branding
│   ├── shell/presentation/
│   │   └── shell_screen.dart          # Bottom nav shell (IndexedStack)
│   ├── home/presentation/
│   │   ├── home_screen.dart           # Main home page
│   │   └── widgets/
│   │       ├── banner_card.dart       # Fashion sale banner
│   │       ├── category_row.dart      # Horizontal category icons
│   │       ├── section_header.dart    # "Nearby Stores" / "Weekly Rewards" header
│   │       └── store_card.dart        # Individual store card (home)
│   ├── search/presentation/
│   │   └── search_screen.dart         # Search placeholder (search is on Home)
│   ├── rewards/presentation/
│   │   └── rewards_screen.dart        # Full rewards listing
│   ├── stores/presentation/
│   │   ├── stores_screen.dart         # All stores with grid view + filters
│   │   └── widgets/
│   │       ├── category_filter_row.dart # Horizontal category chip filters
│   │       └── curated_store_card.dart  # Store card (grid variant)
│   ├── plans/presentation/
│   │   └── plans_screen.dart          # Membership plans (Plus/Gold/Platinum)
│   └── profile/presentation/
│       └── profile_screen.dart        # User account, stats, settings, edit
│
assets/
├── data/
│   ├── categories.json                # 8 categories (Fashion, Food, Grocery, etc.)
│   ├── stores.json                    # 24 stores with images, ratings, discounts
│   ├── rewards.json                   # 5 reward challenges
│   └── plans.json                     # 3 membership plans
├── images/
│   └── app_icon.png                   # App launcher icon
└── fonts/                             # (Google Fonts loaded at runtime)
```

---

## 💾 Data Layer

### Data Models

#### 1. `CategoryModel`
| Field   | Type     | Description                 |
|---------|----------|-----------------------------|
| `id`    | `String` | Unique category ID          |
| `name`  | `String` | Category name (e.g., Fashion, Food) |
| `icon`  | `String` | Material icon name string   |
| `color` | `String` | Hex color code for the icon |

#### 2. `StoreModel`
| Field      | Type     | Description                         |
|------------|----------|-------------------------------------|
| `id`       | `String` | Unique store ID                     |
| `name`     | `String` | Store name (e.g., Zara, Starbucks)  |
| `category` | `String` | Category it belongs to              |
| `rating`   | `double` | Star rating (0.0 – 5.0)            |
| `discount` | `int`    | Discount percentage                 |
| `address`  | `String` | Location / mall name                |
| `imageUrl` | `String` | Unsplash image URL                  |
| `isOpen`   | `bool`   | Whether the store is currently open |

#### 3. `RewardModel`
| Field            | Type           | Description                          |
|------------------|----------------|--------------------------------------|
| `id`             | `String`       | Unique reward ID                     |
| `title`          | `String`       | Reward title (e.g., "3Cr Luxury Villa") |
| `description`    | `String`       | Short description                    |
| `points`         | `int`          | Points needed / earned               |
| `progress`       | `double`       | 0.0 to 1.0 progress fraction        |
| `currentCount`   | `int`          | Current completion count             |
| `targetCount`    | `int`          | Total target count                   |
| `gradientColors` | `List<String>` | Two hex colors for card gradient     |
| `imageUrl`       | `String`       | Background image URL                 |
| `expiresIn`      | `String`       | Time left (e.g., "3 days")          |

#### 4. `PlanModel`
| Field            | Type           | Description                          |
|------------------|----------------|--------------------------------------|
| `id`             | `String`       | Unique plan ID                       |
| `name`           | `String`       | Plan name (KUTOOT PLUS/GOLD/PLATINUM)|
| `price`          | `int`          | Monthly/annual price (₹)            |
| `duration`       | `String`       | Billing period (Monthly/Semi-Annual) |
| `gradientColors` | `List<String>` | Two hex colors for card gradient     |
| `features`       | `List<String>` | List of plan benefits                |
| `isPopular`      | `bool`         | Shows "MOST POPULAR" badge           |

### Data Repository (`DataRepository`)

The repository loads JSON data from assets and applies **Hive caching** with **Isolate-based background parsing**:

```
Flow: Asset JSON → Isolate.run(parse) → Hive cache → Model list
      ↓ (next time)
      Hive cache → Model list (instant, no parsing)
```

**Key Methods:**
| Method           | Returns                  | Data Source              |
|------------------|--------------------------|--------------------------|
| `getCategories()`| `List<CategoryModel>`    | `assets/data/categories.json` |
| `getStores()`    | `List<StoreModel>`       | `assets/data/stores.json`     |
| `getRewards()`   | `List<RewardModel>`      | `assets/data/rewards.json`    |
| `getPlans()`     | `List<PlanModel>`        | `assets/data/plans.json`      |

**Caching Strategy:**
1. First, checks if data exists in the Hive box (`kuttot_cache`)
2. If cached → reads directly from Hive and converts to models (instant)
3. If not cached → loads JSON via `rootBundle.loadString()` → parses on a background isolate via `Isolate.run()` → saves to Hive for future reads

---

## ⚡ State Management (Riverpod Providers)

### Global Providers (`app_providers.dart`)

| Provider                    | Type                                    | Purpose                                           |
|-----------------------------|-----------------------------------------|---------------------------------------------------|
| `categoriesProvider`        | `FutureProvider<List<CategoryModel>>`   | Loads categories from the repository               |
| `storesProvider`            | `FutureProvider<List<StoreModel>>`      | Loads all stores                                   |
| `rewardsProvider`           | `FutureProvider<List<RewardModel>>`     | Loads all rewards                                  |
| `plansProvider`             | `FutureProvider<List<PlanModel>>`       | Loads all plans                                    |
| `searchQueryProvider`       | `StateProvider<String>`                 | Tracks the current search text                     |
| `selectedCategoryProvider`  | `StateProvider<String?>`                | Tracks the selected category filter (default: 'All') |
| `filteredStoresProvider`    | `Provider<AsyncValue<List<StoreModel>>>`| Filters stores based on search query + category    |

### Profile Provider (`profile_provider.dart`)

| Component          | Type                                           | Purpose                              |
|--------------------|------------------------------------------------|--------------------------------------|
| `UserProfile`      | Data class (name, phone)                       | Holds user profile data              |
| `ProfileNotifier`  | `StateNotifier<UserProfile>`                   | Loads/saves profile via SharedPreferences |
| `profileProvider`  | `StateNotifierProvider<ProfileNotifier, UserProfile>` | Global profile access         |

### Shell Provider

| Provider                 | Type                  | Purpose                         |
|--------------------------|-----------------------|---------------------------------|
| `bottomNavIndexProvider` | `StateProvider<int>`  | Tracks the current bottom nav tab index |

### Filtering Logic (`filteredStoresProvider`)

```dart
// This provider combines 2 filters:
// 1. searchQuery — matches against store name or category
// 2. selectedCategory — filters by specific category unless 'All' is selected
stores.where((store) {
  matchesQuery = name.contains(query) || category.contains(query)
  matchesCategory = selectedCategory == 'All' || store.category == selectedCategory
  return matchesQuery && matchesCategory
})
```

---

## 📱 Screen-wise Functionality Breakdown

---

### 1. 🎬 Splash Screen (`splash_screen.dart`)

**Location:** `lib/features/splash/presentation/splash_screen.dart`

| Feature                   | Detail                                        |
|---------------------------|-----------------------------------------------|
| **Duration**              | 2500ms total, then auto-navigates             |
| **Animation Controller**  | `SingleTickerProviderStateMixin`, 1500ms       |
| **Fade Animation**        | 0.0 → 1.0 opacity (0% to 60% of timeline)    |
| **Scale Animation**       | 0.8 → 1.0 scale with `easeOutBack` curve      |
| **Background**            | Full gradient (Maroon → Red)                   |
| **Logo**                  | App icon (120x120, rounded corners, shadow)    |
| **Brand Text**            | "KUTOOT" — KUT (white) + OO (orange) + T (white) |
| **Tagline**               | "Shop. Earn. Repeat." in semi-transparent white |
| **Font**                  | Google Fonts `Inter`                           |

**Functionality:**
- Displays an animated splash for 2.5 seconds on app launch
- `AnimationController` drives a smooth fade-in + scale-up animation
- `onComplete` callback fires to navigate to `ShellScreen`
- Checks `mounted` before navigation to avoid post-dispose crashes

---

### 2. 🐚 Shell Screen (`shell_screen.dart`)

**Location:** `lib/features/shell/presentation/shell_screen.dart`

| Feature                      | Detail                                   |
|------------------------------|------------------------------------------|
| **Navigation Type**          | `BottomNavigationBar` (5 tabs)            |
| **Screen Persistence**       | `IndexedStack` — all screens stay in memory |
| **FAB**                      | QR Code Scanner button (floating, right)  |
| **Bottom Nav Style**         | Rounded top corners (radius: 30), shadow  |

**5 Navigation Tabs:**

| Index | Label     | Icon               | Screen          |
|-------|-----------|---------------------|-----------------|
| 0     | HOME      | `home_filled`       | `HomeScreen`    |
| 1     | REWARDS   | `local_offer`       | `RewardsScreen` |
| 2     | STORES    | `store`             | `StoresScreen`  |
| 3     | PLANS     | `receipt_long`      | `PlansScreen`   |
| 4     | ACCOUNT   | `person`            | `ProfileScreen` |

**Functionality:**
- Uses `IndexedStack` so screens aren't destroyed on tab switch — state is fully preserved
- Tab state is managed via `bottomNavIndexProvider` (Riverpod)
- Any screen can programmatically navigate to another tab (e.g., Home's UPGRADE button jumps to Plans)
- FAB has a QR scanner icon (placeholder, not yet functional)

---

### 3. 🏠 Home Screen (`home_screen.dart`)

**Location:** `lib/features/home/presentation/home_screen.dart`

**This is the app's main dashboard — the majority of functionality is surfaced here.**

#### UI Sections (Top to Bottom):

| Section             | Widget                     | Description                                    |
|---------------------|----------------------------|------------------------------------------------|
| **Header**          | Custom Row                 | Location pill (Mumbai) + KUTOOT logo + UPGRADE button |
| **Search Bar**      | `CustomSearchBar`          | Real-time search, updates `searchQueryProvider` |
| **Banner**          | `BannerCard`               | Fashion sale promotional banner                |
| **Categories**      | `CategoryRow`              | Horizontal scrollable category icons           |
| **Nearby Stores**   | 2-row horizontal ListView  | Store cards in 2 rows, filtered by search      |
| **Weekly Rewards**  | Horizontal ListView        | Reward challenge cards with progress bars       |

#### Header Functionality:
- **Location Pill** — Orange rounded chip showing "MUMBAI" with a dropdown icon
- **KUTOOT Logo** — Styled RichText (KUT in maroon + OO in orange + T in maroon)
- **UPGRADE Button** — Red pill button; tapping it navigates to the Plans tab (index 3)

#### Search Functionality:
- Real-time search — `searchQueryProvider` updates on every keystroke
- `filteredStoresProvider` automatically filters stores by name + category
- The Nearby Stores section on the Home screen updates reactively

#### Nearby Stores:
- Stores are split into 2 rows (50-50 split)
- Horizontal scrollable `ListView.builder` with `BouncingScrollPhysics`
- Uses individual `StoreCard` widgets
- Shows `CircularProgressIndicator` during loading
- Displays "No results found" when the filtered list is empty

#### Weekly Rewards Preview:
- Horizontal scrollable cards (280px wide, 360px tall)
- Background image with a gradient overlay
- "PRIMARY" / "ELIGIBLE" status pill (top-left)
- Reward title + total value display
- Segmented progress bar (8 segments) with percentage
- "SEE ALL" navigates to the Rewards tab

---

### 4. 🔍 Search Screen (`search_screen.dart`)

**Location:** `lib/features/search/presentation/search_screen.dart`

| Feature        | Detail                                        |
|----------------|-----------------------------------------------|
| **Status**     | Placeholder screen                             |
| **Note**       | Search functionality is integrated into Home and Stores screens |

> The search bar on both Home and Stores screens provides real-time filtering. A dedicated Search screen exists as a placeholder for future expansion.

---

### 5. 🎁 Rewards Screen (`rewards_screen.dart`)

**Location:** `lib/features/rewards/presentation/rewards_screen.dart`

| Feature                    | Detail                                      |
|----------------------------|---------------------------------------------|
| **AppBar Title**           | "Weekly Rewards"                             |
| **Subtitle**               | "Complete tasks to earn points!"             |
| **Layout**                 | `CustomScrollView` + `SliverToBoxAdapter`    |
| **Card Design**            | Same design as Home reward cards             |

#### Card Features:
- **Background Image** — Network image with `cacheWidth: 600` for memory optimization
- **Gradient Overlay** — Bottom gradient (transparent → 80% opacity → solid color)
- **Status Pill** — "PRIMARY" (star icon) / "ELIGIBLE" (check icon), alternating
- **Title** — Bold white text, single line with ellipsis overflow
- **Total Value** — Calculated as `targetCount × 100`, formatted with commas (₹)
- **Progress Bar** — 8-segment dashed bar; filled segments are white, unfilled are white24
- **Percentage** — Displays `progress × 100` as an integer

#### Performance:
- `RepaintBoundary` on every card — prevents unnecessary repaints
- `cacheWidth: 600` — reduces image memory footprint
- `errorBuilder` — shows a fallback solid color on network failure

---

### 6. 🏬 Stores Screen (`stores_screen.dart`)

**Location:** `lib/features/stores/presentation/stores_screen.dart`

| Feature                    | Detail                                      |
|----------------------------|---------------------------------------------|
| **Header**                 | Location pill + Logo + Upgrade button        |
| **Search Bar**             | Real-time store search                       |
| **Category Filters**       | Horizontal scrollable chips                  |
| **Store Count**            | Dynamic "X STORES FOUND" label               |
| **Grid View**              | 2-column grid with `CuratedStoreCard`        |

#### Category Filter (`CategoryFilterRow`):
- "All" category is always first
- Additional categories are loaded dynamically from JSON
- Selected chip has an orange background; unselected ones are gray
- Tapping a chip updates `selectedCategoryProvider`
- `filteredStoresProvider` automatically recomputes the filtered list

#### Store Grid:
- `GridView.builder` with `SliverGridDelegateWithFixedCrossAxisCount`
- 2 columns, aspect ratio 0.65
- `BouncingScrollPhysics` for smooth scrolling
- 100px bottom padding for nav bar clearance

#### `CuratedStoreCard` Features:
- Full-bleed store image (network, cached at 300px width)
- **Discount badge** (top-left): "FLAT X% OFF" in an orange pill
- **Rating badge** (top-right): Star icon + rating number in a white pill
- **Store name** — Bold, single line, ellipsis overflow
- **Distance** — Mock distance displayed below the name
- **Action buttons** — "PAY BILL" red button + circular Directions icon

---

### 7. 💳 Plans Screen (`plans_screen.dart`)

**Location:** `lib/features/plans/presentation/plans_screen.dart`

| Feature                     | Detail                                     |
|-----------------------------|--------------------------------------------|
| **AppBar Title**            | "MEMBERSHIP PLANS" (centered, letter-spaced)|
| **Headline**                | "Unlock the Best of Kutoot"                 |
| **Description**             | Plan selection guidance text                |
| **Layout**                  | `CustomScrollView` + `SliverList`           |

#### 3 Membership Plans:

| Plan             | Price   | Duration    | Gradient                | Popular |
|------------------|---------|-------------|-------------------------|---------|
| KUTOOT PLUS      | ₹299    | Monthly     | Maroon → Red            | ❌      |
| KUTOOT GOLD      | ₹999    | Semi-Annual | Orange → Light Orange   | ✅      |
| KUTOOT PLATINUM  | ₹1499   | Annually    | Dark Navy → Deep Blue   | ❌      |

#### Card Features:
- **Gradient background** — Dynamic hex colors parsed from JSON
- **"MOST POPULAR" badge** — White pill, only on the Gold plan
- **Plan name** — Large bold white text (24px)
- **Price** — ₹ amount at 36px + "/duration" subtitle
- **Features list** — Check circle icon + feature text for each benefit
- **"SELECT PLAN" button** — White button, text color matches the gradient
- **Box shadow** — Uses the gradient's primary color at 30% opacity

#### Performance:
- `RepaintBoundary` on every plan card
- `BouncingScrollPhysics` on `CustomScrollView`
- 80px bottom padding for bottom nav clearance

---

### 8. 👤 Profile Screen (`profile_screen.dart`)

**Location:** `lib/features/profile/presentation/profile_screen.dart`

| Feature                     | Detail                                     |
|-----------------------------|--------------------------------------------|
| **Header**                  | Gradient profile header with avatar         |
| **Stats Row**               | Points, Orders, Saved amount cards          |
| **Menu Sections**           | 3 grouped menu sections                     |
| **Edit Profile**            | Dialog with name & phone input              |
| **Logout Button**           | Outlined red button                         |
| **Version Display**         | "Version 1.0.0" at bottom                  |

#### Profile Header:
- Gradient background (Maroon → Red) with rounded bottom corners (32px radius)
- "MY ACCOUNT" subtitle (white70, letter-spaced)
- Circle avatar (80x80) — white border + shadow
- Displays the user's name in bold white — or "Set up your profile" if empty
- Phone number — or "Add your phone number" if not set
- "⭐ GOLD MEMBER" badge — only visible when a name is set

#### Stats Row:
| Stat     | Value    | Color   |
|----------|----------|---------|
| Points   | 2,450    | Red     |
| Orders   | 18       | Orange  |
| Saved    | ₹12.5K   | Green   |

#### Menu Sections:

**My Account:**
| Item            | Icon                    | Badge | Action               |
|-----------------|-------------------------|-------|----------------------|
| Edit Profile    | `person_outline`        | —     | Opens edit dialog    |
| Saved Addresses | `location_on_outlined`  | 3     | —                    |
| Payment Methods | `credit_card`           | —     | —                    |
| My Vouchers     | `card_giftcard`         | 5     | —                    |

**Activity:**
| Item            | Icon                       | Badge |
|-----------------|----------------------------|-------|
| Order History   | `receipt_long_outlined`    | —     |
| My Reviews      | `star_outline`             | 12    |
| Wishlist        | `favorite_outline`         | 8     |
| Reward History  | `loyalty_outlined`         | —     |

**Settings:**
| Item               | Icon                       |
|---------------------|----------------------------|
| Notifications       | `notifications_outlined`   |
| Privacy & Security  | `lock_outline`             |
| Help & Support      | `help_outline`             |
| About Kutoot        | `info_outline`             |

#### Edit Profile Dialog:
- `AlertDialog` with 2 text fields (Name, Phone)
- Cancel button dismisses the dialog
- Save button calls `profileProvider.saveProfile()` to persist via SharedPreferences
- The UI updates reactively through Riverpod

---

## 🧱 Reusable Widgets

### 1. `CustomSearchBar`
| Property    | Type                     | Description                 |
|-------------|--------------------------|------------------------------|
| `onChanged` | `ValueChanged<String>?`  | Text change callback         |
| `hintText`  | `String`                 | Placeholder text             |

- White container with subtle shadow
- Rounded corners (12px)
- Search icon prefix
- Used on: Home Screen, Stores Screen

### 2. `BannerCard`
- Fixed height: 160px
- Red gradient background with layered typography:
  - "SALE." — Large transparent text (62px, Oswald font)
  - "Safhion" — Cursive overlay (62px, Great Vibes font)
  - "FASHIN EON ™" — Small label (15px, Oswald)
  - "FASHION FIESTA" — Gold badge (bottom-left)
  - "Upto 70% Off" — White bold text
- Wrapped in `RepaintBoundary`

### 3. `CategoryRow`
- Horizontal scrollable list
- "ALL" category always appears first (grid icon, red tint)
- Categories loaded dynamically from JSON with color-coded icons
- Fashion category displays an emoji (👕) instead of a Material icon
- Uses `BouncingScrollPhysics`

### 4. `SectionHeader`
| Property   | Type            | Description                    |
|------------|-----------------|--------------------------------|
| `title`    | `String`        | Section title text             |
| `onSeeAll` | `VoidCallback?` | "SEE ALL" button tap callback  |

- Title (18px, bold) + "SEE ALL" link (red text + play arrow icon)

### 5. `StoreCard` (Home variant)
- 140px wide, full-bleed image
- Bottom gradient overlay (transparent → black)
- Discount badge (amber, top-left)
- Store name, star rating, mock distance
- "PAY BILL" button + circular navigate icon at the bottom

### 6. `CuratedStoreCard` (Stores grid variant)
- Full image section (top, expandable) + white content section (bottom)
- Orange discount badge + white rating pill
- Store name, distance, "PAY BILL" + directions button

### 7. `CategoryFilterRow`
- Horizontal chip list with "All" always appearing first
- Selected chip = orange background, unselected = gray
- Dynamically populated from categories JSON
- Updates `selectedCategoryProvider` on tap

---

## 🎨 Design System

### Color Palette (`AppColors`)

| Token            | Hex         | Usage                          |
|------------------|-------------|--------------------------------|
| `primary`        | `#8B1A4A`   | Primary maroon brand color     |
| `primaryDark`    | `#6D1539`   | Darker shade                   |
| `primaryLight`   | `#BE1E48`   | Lighter red variant            |
| `accent`         | `#FF6B6B`   | Accent red                     |
| `accentOrange`   | `#FFA726`   | Orange accent                  |
| `scaffoldBg`     | `#F5F6FA`   | Global background              |
| `cardBg`         | `#FFFFFF`   | Card surface color             |
| `darkBg`         | `#1A1A2E`   | Dark theme / Platinum plan     |
| `textPrimary`    | `#1A1A2E`   | Primary text                   |
| `textSecondary`  | `#6B7280`   | Secondary text                 |
| `textLight`      | `#9CA3AF`   | Light/muted text               |
| `kutootMaroon`   | `#8B1A4A`   | Logo "KUT" + "T" color         |
| `kutootRed`      | `#BE1E48`   | Buttons, badges, selected items|
| `locationOrange` | `#E8803A`   | Location pill, logo "OO", chips|
| `bannerRed`      | `#CC2936`   | Banner gradient start          |
| `bannerDarkRed`  | `#9B1B30`   | Banner gradient end            |
| `starYellow`     | `#FFC107`   | Star rating icon color         |
| `success`        | `#10B981`   | Green (saved amount)           |
| `warning`        | `#F59E0B`   | Warning                        |
| `error`          | `#EF4444`   | Error                          |

### Gradients
| Name              | Colors                          | Usage             |
|-------------------|---------------------------------|-------------------|
| `primaryGradient` | `#8B1A4A` → `#BE1E48`          | Splash, Profile header |
| `bannerGradient`  | `#CC2936` → `#9B1B30`          | Home banner        |
| `darkGradient`    | `#1A1A2E` → `#16213E`          | Platinum plan card |

### Dimensions (`AppDimens`)

| Token              | Value    | Usage                |
|--------------------|----------|----------------------|
| `paddingXS`        | 4.0      | Tiny spacing         |
| `paddingSM`        | 8.0      | Small spacing        |
| `paddingMD`        | 12.0     | Medium spacing       |
| `paddingLG`        | 16.0     | Large / standard     |
| `paddingXL`        | 20.0     | Extra large          |
| `paddingXXL`       | 24.0     | Section spacing      |
| `paddingHuge`      | 32.0     | Huge spacing         |
| `radiusSM`         | 8.0      | Small corner radius  |
| `radiusMD`         | 12.0     | Input fields, cards  |
| `radiusLG`         | 16.0     | Standard cards       |
| `radiusXL`         | 20.0     | Large cards          |
| `radiusRound`      | 50.0     | Fully round          |
| `storeCardWidth`   | 200.0    | Store card width     |
| `storeCardHeight`  | 260.0    | Store card height    |
| `bannerHeight`     | 160.0    | Banner fixed height  |
| `categoryIconSize` | 56.0     | Category icon size   |
| `searchBarHeight`  | 50.0     | Search bar height    |
| `bottomNavHeight`  | 68.0     | Bottom nav height    |

### Theme (`AppTheme.lightTheme`)
- **Material 3** enabled (`useMaterial3: true`)
- **AppBar** — Transparent background, no elevation, no scroll shadow
- **Cards** — White surface, elevation 2, shadow, rounded 16px corners
- **Buttons** — Primary maroon background, white text, rounded 12px
- **Input Fields** — Filled white, no border by default, primary-colored border on focus
- **Bottom Nav** — White background, red for selected items, gray for unselected, fixed type
- **Text Theme** — Full typographic scale from headlineLarge (28px) down to bodySmall (12px)

---

## 🚀 Performance Optimizations

### 1. Isolate-based JSON Parsing
```dart
// JSON parsing is offloaded to a background isolate to keep the UI thread free
final List<dynamic> data = await Isolate.run(() => _parseJsonData(response));
```
- `Isolate.run()` moves JSON parsing to a background thread
- The main UI thread is never blocked — animations and scrolling stay smooth
- Applied consistently across all data types (categories, stores, rewards, plans)

### 2. Hive Caching (Instant Subsequent Reads)
```dart
// First load: Asset → Isolate parse → Hive save
// All subsequent loads: Hive → Model (no parsing needed)
if (box.containsKey(cacheKey)) {
  return box.get(cacheKey); // Instant!
}
```
- First load: parses JSON and caches the result in Hive
- All subsequent loads: reads directly from Hive — **zero parsing overhead**
- Uses a `kuttot_cache` named box

### 3. `RepaintBoundary` Wrapping
```dart
// Every heavy widget is wrapped in RepaintBoundary
RepaintBoundary(child: StoreCard(...))
RepaintBoundary(child: CuratedStoreCard(...))
RepaintBoundary(child: BannerCard(...))
RepaintBoundary(child: PlanCard(...))
RepaintBoundary(child: RewardCard(...))
```
- During scrolling, only visible cards are repainted
- When a parent widget repaints, children within RepaintBoundary are not unnecessarily redrawn
- Results in **significant FPS improvement**, especially on lower-end devices

### 4. Image Optimization (`cacheWidth`)
```dart
Image.network(
  url,
  cacheWidth: 300,  // Store cards
  // or
  cacheWidth: 600,  // Reward cards (larger)
)
```
- Flutter internally decodes images at the specified width instead of full resolution
- Full-resolution images are never loaded into memory
- Achieves **~60-70% memory savings** on high-resolution Unsplash images

### 5. `IndexedStack` for Tab Persistence
```dart
IndexedStack(
  index: currentIndex,
  children: screens, // All 5 screens
)
```
- Screens are not rebuilt on tab switch
- Scroll positions, search queries, and other state are fully preserved
- Trade-off: all 5 screens remain in memory (acceptable for this app's complexity)

### 6. `BouncingScrollPhysics` Across All Lists
- Provides a natural iOS-like bouncing effect
- Ensures smooth scrolling across all scrollable widgets
- Used in: HomeScreen, StoresScreen, PlansScreen, RewardsScreen, CategoryRow, FilterRow

### 7. Riverpod Computed Providers
```dart
final filteredStoresProvider = Provider<AsyncValue<List<StoreModel>>>((ref) {
  // Automatically recomputes only when searchQuery or selectedCategory changes
  // Only widgets watching this specific provider rebuild — not the entire screen
});
```
- Derived/computed state — recomputes only when its inputs change
- Enables fine-grained rebuilds: only the filtered stores section rebuilds, not the entire screen

### 8. Network Image Error Handling
```dart
errorBuilder: (ctx, err, st) => Container(
  color: fallbackColor, // Solid color fallback
)
```
- Graceful fallback on network failures — no blank spaces or error widgets
- Loading states show a small `CircularProgressIndicator` (20x20)

### 9. `const` Constructors
- `const` keyword is used on widgets wherever possible
- Flutter skips rebuild checks for `const` widgets entirely
- Applied to `const EdgeInsets`, `const TextStyle`, `const Icon`, and widget constructors throughout the codebase

---

## 📦 Build & Deployment

### Development Run
```bash
flutter pub get
flutter run
```

### Release APK (Optimized, Split ABI)
```bash
flutter build apk --release --split-per-abi
```
This generates 3 APKs:
- `app-armeabi-v7a-release.apk` — Older ARM devices
- `app-arm64-v8a-release.apk` — Modern ARM64 devices (most common)
- `app-x86_64-release.apk` — Emulators / Intel devices

### Install on Device
```bash
flutter install
```

### Android Permissions
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```
- Only the INTERNET permission is required (for loading network images)
- Hardware acceleration is enabled (`android:hardwareAccelerated="true"`)

---

## 📊 Data Summary

| Data Type    | Count | Source File               |
|--------------|-------|---------------------------|
| Categories   | 8     | `assets/data/categories.json` |
| Stores       | 24    | `assets/data/stores.json`     |
| Rewards      | 5     | `assets/data/rewards.json`    |
| Plans        | 3     | `assets/data/plans.json`      |

### Categories Available
Fashion, Food, Grocery, Electronics, Beauty, Sports, Cafe, Health

### Sample Stores
Zara, H&M, Starbucks, Nike Store, Domino's Pizza, Apple Store, Sephora, Reliance Fresh, McDonald's, Croma, Westside, Reliance Digital, Home Centre, Nykaa Luxe, Shoppers Stop, Pantaloons, Lenskart, Cafe Coffee Day, Puma, IKEA, Burger King, Marks & Spencer, Samsung Store, Bath & Body Works

### Membership Plans
| Plan            | Price  | Duration     | Key Feature                  |
|-----------------|--------|--------------|------------------------------|
| KUTOOT PLUS     | ₹299   | Monthly      | 2x Reward Points multiplier  |
| KUTOOT GOLD     | ₹999   | Semi-Annual  | VIP access + Spa Vouchers    |
| KUTOOT PLATINUM | ₹1499  | Annually     | Stylist + Birthday Gifts     |

---

## 🔗 Navigation Flow

```
App Launch
    │
    ▼
Splash Screen (2.5s, animated)
    │
    ▼
Shell Screen (Bottom Nav)
    ├── [0] Home Screen
    │       ├── Search → filters stores on Home
    │       ├── Banner (static promo)
    │       ├── Categories → horizontal scroll
    │       ├── Nearby Stores → 2-row horizontal scroll (filtered)
    │       ├── Weekly Rewards → horizontal cards
    │       ├── "SEE ALL" (Stores) → navigates to tab[2]
    │       ├── "SEE ALL" (Rewards) → navigates to tab[1]
    │       └── "UPGRADE" → navigates to tab[3]
    │
    ├── [1] Rewards Screen
    │       └── All reward challenges with progress tracking
    │
    ├── [2] Stores Screen
    │       ├── Search → filters stores on grid
    │       ├── Category Chips → filter by category
    │       └── 2-column grid of curated stores
    │
    ├── [3] Plans Screen
    │       └── 3 membership plan cards (Plus/Gold/Platinum)
    │
    └── [4] Profile Screen
            ├── Profile Header (avatar, name, phone, member badge)
            ├── Stats (Points, Orders, Saved)
            ├── My Account menu (Edit Profile, Addresses, Payments, Vouchers)
            ├── Activity menu (Orders, Reviews, Wishlist, Reward History)
            ├── Settings menu (Notifications, Privacy, Help, About)
            ├── Edit Profile Dialog → SharedPreferences persist
            └── Logout button
```

---

> **Last Updated:** April 2026
