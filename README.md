# Market App - Point of Sale System

A simple Point of Sale (POS) application built with Flutter. It allows users to manage products and simulate sales transactions through a shopping cart interface.

This project was developed to demonstrate a modern Flutter architecture using Riverpod for state management and the Isar database for fast, local storage.

## Features

- **Point of Sale (POS):** A sales screen to browse products and add them to a shopping cart.
- **Product Management:** A separate administration screen to Create, Read, Update, and Delete products (CRUD).
- **Inventory Control:** Products have a `stock` quantity that is automatically decremented after a sale is completed.
- **Search and Filter:**
  - Search products by name.
  - Filter products by status: All, In Stock, Out of Stock, or In Cart.
- **Shopping Cart:** 
  - View all items added to the cart.
  - Edit item quantities directly in an editable text field.
  - Real-time calculation of the total price.
- **Simulated Checkout:** 
  - A multi-step checkout process.
  - A mock payment gateway screen to simulate choosing between payment methods like PayPal, Visa, or Mastercard.
- **State Management:** Built using **Riverpod** for robust, scalable, and testable state management.
- **Local Database:** Uses **Isar DB** for a fast, efficient, and easy-to-use local database solution.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation & Setup

1. **Clone the repository:**
   ```sh
   git clone <repository_url>
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Generate Database Files:**
   Isar requires code generation. Run the following command to generate the necessary files. This step is required before running the app and after any changes to the data models.
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application:**
   ```sh
   flutter run
   ```

## App Navigation

- The application starts on the **Sales** screen.
- To access the product administration area, **open the navigation drawer** by swiping from the left edge of the screen or by tapping the menu icon in the top-left corner.
- Select **Product Management** from the drawer to view, create, edit, and delete products.