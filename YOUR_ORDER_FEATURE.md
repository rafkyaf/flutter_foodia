# Your Order Feature - Documentation

## Overview
This feature allows users to view their current orders and order history after completing a purchase in the Flutter Foodia application.

## Features Implemented

### 1. Automatic Navigation
- After completing checkout in the cart screen, users are automatically redirected to the "Your Order" page
- The navigation uses `Navigator.pushReplacementNamed(context, '/orders')` to provide a clean transition

### 2. Real-time Order Display
The "Your Order" page displays orders in real-time with the following features:

#### Current Orders (In Progress)
- Orders with status `ON_DELIVERY` are shown with special visual treatment:
  - Orange border and shadow
  - Orange status badge with shipping icon
  - "Track Location" link (for future implementation)

#### Order History (Completed)
- Orders with status `COMPLETED` are shown with:
  - Green status badge with checkmark icon
  - "View Details" link
  - Sorted by most recent first

### 3. User Interface Components

#### Tab Filters
Three tabs are available to filter orders:
- **All**: Shows all orders (current and completed)
- **On Delivery**: Shows only orders in progress
- **Completed**: Shows only completed orders

#### Order Card Information
Each order card displays:
- Order ID (e.g., #0012345)
- Order creation timestamp (relative time: "Just now", "2 hours ago", etc.)
- Order status badge (color-coded)
- Number of items in the order
- List of all items with:
  - Product image (with error fallback)
  - Product name
  - Price and old price (if different)
  - Quantity
- Total amount

#### Pull-to-Refresh
- Users can pull down to refresh the order list
- Useful for checking if order status has changed

#### Empty State
- When no orders are found, displays a helpful message:
  - Icon of a receipt
  - "No orders found" message
  - "Your orders will appear here" subtitle

### 4. Loading and Error Handling

#### Loading Indicator
- Displays a circular progress indicator while fetching orders
- Prevents user interaction during loading

#### Error Handling
- If order fetching fails, displays:
  - Error message
  - Retry button to attempt fetching again
- Error messages are logged to help with debugging

### 5. Data Management

#### OrderProvider
Provides the following methods and getters:
- `fetchOrders()`: Fetches all orders
- `fetchOrdersByStatus(String status)`: Fetches orders by status
- `createOrder(Order order)`: Creates a new order
- `currentOrders`: Getter for orders in progress
- `orderHistory`: Getter for completed orders

#### OrderRepository
Mock implementation with sample data:
- Simulates API delays (500-1000ms)
- Stores orders in memory
- Provides CRUD operations

### 6. Order Creation Flow

1. User adds items to cart
2. User proceeds to checkout in CartScreen
3. Cart items are converted to OrderItems
4. New order is created with:
   - Unique order ID (7-digit number)
   - Current timestamp
   - Status: `ON_DELIVERY`
   - All cart items
5. Order is saved via OrderProvider
6. Cart is cleared
7. Success message is shown
8. User is navigated to "Your Order" page
9. New order appears at the top of the list

## Technical Details

### Files Modified/Created

#### 1. `lib/data/models/order_model.dart`
- Contains `Order` and `OrderItem` classes
- Provides JSON serialization
- Includes helper getters (`totalAmount`, `totalItems`)

#### 2. `lib/repositories/order_repository_impl.dart`
- Mock implementation of OrderRepository
- Fixed status values to use consistent format:
  - `ON_DELIVERY` for current orders
  - `COMPLETED` for finished orders

#### 3. `lib/providers/order_provider.dart`
- Added `currentOrders` getter
- Added `orderHistory` getter
- Manages order state with loading and error handling

#### 4. `lib/presentation/screens/orders/orders_screen.dart`
- Enhanced UI with better visual design
- Added pull-to-refresh functionality
- Added empty state display
- Added timestamp formatting
- Added visual distinction for current orders
- Improved status badges
- Added total amount display

#### 5. `lib/presentation/screens/customer/cart/cart_screen.dart`
- Improved order ID generation
- Handles navigation to orders screen after checkout

### Status Values
The application uses the following status values:
- `ON_DELIVERY`: Order is being delivered (current order)
- `COMPLETED`: Order has been delivered (history)
- `CANCELLED`: Order was cancelled (future feature)

### Design Decisions

1. **Pull-to-Refresh**: Implemented to allow users to manually refresh orders without leaving the page
2. **Relative Timestamps**: Used to make order information more intuitive ("2 hours ago" vs "31/10/2025 14:30")
3. **Visual Distinction**: Current orders have orange borders to immediately catch user attention
4. **Error Fallback for Images**: Product images have fallback icons to handle network errors gracefully
5. **Empty States**: Helpful messages guide users when no orders exist

## Future Enhancements

Potential improvements for this feature:
1. **Real Backend Integration**: Replace mock repository with actual API calls
2. **Order Tracking**: Implement real-time tracking for delivery orders
3. **Order Details Page**: Show detailed information when clicking on an order
4. **Notifications**: Push notifications for order status changes
5. **Order Cancellation**: Allow users to cancel orders
6. **Reorder Functionality**: Quick reorder from order history
7. **Search and Filters**: Search orders by ID or date range
8. **Order Rating**: Allow users to rate completed orders

## Testing

To test this feature:
1. Run the app
2. Add items to cart
3. Proceed to checkout
4. Verify navigation to "Your Order" page
5. Verify new order appears in the list
6. Test tab filtering
7. Test pull-to-refresh
8. Test with no orders (clear mock data)

## Dependencies
This feature uses the following packages:
- `provider`: State management
- `google_fonts`: Typography
- Flutter SDK widgets: Material, RefreshIndicator, etc.
