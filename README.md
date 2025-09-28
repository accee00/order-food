# Order Food App

A Flutter-based application for ordering food from restaurants. This app includes features such as browsing restaurants, adding items to the cart, placing orders, and tracking order history.

## Features

- Browse restaurants and their menus.
- Add items to the cart and manage the cart.
- Place orders and track order history.
- Modern UI with light and dark theme support.
- Bloc Test in test/ 

## 📂 Folder Structure

The project follows a modular structure for better scalability and maintainability:

```plaintext
lib/
├── main.dart                 # Entry point of the application
├── core/                     # Core utilities and shared resources
│   ├── bloc/                 # Global app-level BLoC
│   │   ├── app_bloc.dart
│   │   ├── app_event.dart
│   │   └── app_state.dart
│   ├── bloc_provider_table/  # BLoC provider table for dependency injection
│   │   └── bloc_provider.dart
│   ├── di/                   # Dependency injection setup
│   │   ├── di_imports.dart
│   │   └── init_di.dart
│   ├── extension/            # Extensions for Flutter widgets
│   │   └── build_extension.dart
│   ├── routes/               # App navigation and routes
│   │   ├── app_routes.dart
│   │   └── app_routes_import.dart
│   ├── theme/                # App theme and styling
│   │   └── app_theme.dart
│   └── widgets/              # Shared widgets
│       └── loading_shimmer.dart
│
├── features/                 # Feature-specific modules
│   ├── cart/                 # Cart feature
│   │   ├── bloc/             # Cart BLoC
│   │   │   ├── cart_bloc.dart
│   │   │   ├── cart_event.dart
│   │   │   └── cart_state.dart
│   │   ├── model/            # Cart models
│   │   │   └── cart_model.dart
│   │   └── presentation/     # Cart UI
│   │       ├── view/
│   │       │   └── cart_screen.dart
│   │       └── widget/
│   │           └── cart_item_card.dart
│   │
│   ├── order/                # Order feature
│   │   ├── bloc/             # Order BLoC
│   │   │   ├── order_bloc.dart
│   │   │   ├── order_event.dart
│   │   │   └── order_state.dart
│   │   ├── model/            # Order models
│   │   │   └── order_model.dart
│   │   └── presentation/     # Order UI
│   │       ├── view/
│   │       │   ├── check_out_screen.dart
│   │       │   ├── order_history_screen.dart
│   │       │   └── order_track_screen.dart
│   │       └── widget/
│   │           ├── history_shimmer.dart
│   │           └── order_cart.dart
│   │
│   ├── restaurant/           # Restaurant feature
│   │   ├── bloc/             # Restaurant BLoC
│   │   │   ├── restaurant_bloc.dart
│   │   │   ├── restaurant_event.dart
│   │   │   └── restaurant_state.dart
│   │   ├── model/            # Restaurant models
│   │   │   └── resturant.dart
│   │   └── presentation/     # Restaurant UI
│   │       ├── view/
│   │       │   ├── fav_resturant_screen.dart
│   │       │   ├── home_screenn.dart
│   │       │   ├── main_screen.dart
│   │       │   └── restaurant_detail.dart
│   │       └── widget/
│   │           ├── menu_item_card.dart
│   │           └── reataurant_card.dart
│
├── repository/               # Repositories for data handling
│   ├── cart_repo.dart
│   ├── order_repo.dart
│   └── resturant_repo.dart

```

##  Screenshots
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 50 53 AM" src="https://github.com/user-attachments/assets/7266ca34-7510-4bab-b938-574e0a92d6fc" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 50 43 AM" src="https://github.com/user-attachments/assets/72f90a9f-5fae-4e1a-bcb4-b0647ebace31" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 48 26 AM" src="https://github.com/user-attachments/assets/8fa018c4-5c36-4ff8-b023-27f885b9c47e" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 48 30 AM" src="https://github.com/user-attachments/assets/da1771f5-4fa7-4706-916f-b951a1b46aad" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 48 35 AM" src="https://github.com/user-attachments/assets/5311c18d-9102-4371-80a9-22fe7f713301" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 48 43 AM" src="https://github.com/user-attachments/assets/8ec0832b-f68c-4aca-83bb-d84252c46fa3" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 48 53 AM" src="https://github.com/user-attachments/assets/c2a8a4cc-6f32-448f-8243-010c57741502" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 48 57 AM" src="https://github.com/user-attachments/assets/44afbe57-c6cc-43e0-8aca-9286a9b724e6" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 50 30 AM" src="https://github.com/user-attachments/assets/1dbc3054-6f18-4396-9e33-d1eaec45f01c" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 50 33 AM" src="https://github.com/user-attachments/assets/b669fbe4-0cb7-41ed-82eb-ac43df9a22d3" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 50 53 AM" src="https://github.com/user-attachments/assets/27800d5c-4a05-4d67-ad28-b88d69bce43c" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 50 59 AM" src="https://github.com/user-attachments/assets/5e035931-298b-41d7-8f92-50cec1f9e7bf" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 51 05 AM" src="https://github.com/user-attachments/assets/f735b7c3-522f-4602-ad5e-3e6295248ea2" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 51 21 AM" src="https://github.com/user-attachments/assets/89eb0133-718b-4086-8247-7700401f1a39" />
<img width="436" height="786" alt="Screenshot 2025-09-28 at 11 12 24 AM" src="https://github.com/user-attachments/assets/39fae184-dbeb-4827-9cf1-03656fa7218d" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 51 16 AM" src="https://github.com/user-attachments/assets/4ad0931a-fbf3-4d11-a52a-dbd2168d21d2" />
<img width="460" height="877" alt="Screenshot 2025-09-28 at 10 51 02 AM" src="https://github.com/user-attachments/assets/e4d33a84-5997-4096-b24d-73bf620c01e7" />
<img width="436" height="786" alt="Screenshot 2025-09-28 at 11 12 55 AM" src="https://github.com/user-attachments/assets/6dd06e50-8093-4354-a35c-43e2867778b0" />
<img width="436" height="786" alt="Screenshot 2025-09-28 at 11 16 41 AM" src="https://github.com/user-attachments/assets/fe168bca-f460-46bb-a129-e7da09efa4ec" />


## How to Run the Project

Follow these steps to set up and run the project on your local machine:

### Steps

1. Clone the repository:
    git clone https://github.com/accee00/order-food.git
    cd order-food
  
   
2. Install dependencies:
   flutter pub get
  
3. Run the app:
   flutter run
   
