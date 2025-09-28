import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/core/extension/build_extension.dart';
import 'package:order_food/core/routes/app_routes_import.dart';
import 'package:order_food/core/widgets/loading_shimmer.dart';
import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/cart/presentation/widget/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceVariant,
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: context.colorScheme.surface,
        elevation: 0,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showClearCartDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const LoadingShimmer();
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                // cart items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BlocSelector<CartBloc, CartState, int>(
                          selector: (cartState) {
                            if (cartState is CartLoaded) {
                              return cartState.items
                                  .firstWhere(
                                    (i) =>
                                        i.menuItem.id == cartItem.menuItem.id,
                                    orElse: () => cartItem,
                                  )
                                  .quantity;
                            }
                            return cartItem.quantity;
                          },
                          builder: (context, quantity) {
                            return CartItemCard(
                              key: ValueKey(cartItem.menuItem.id),
                              cartItem: cartItem.copyWith(quantity: quantity),
                              onQuantityChanged: (newQuantity) {
                                if (newQuantity <= 0) {
                                  context.read<CartBloc>().add(
                                    RemoveFromCart(
                                      cartItem.menuItem.id,
                                      cartItem.restaurantId,
                                    ),
                                  );
                                } else {
                                  context.read<CartBloc>().add(
                                    UpdateCartItem(
                                      cartItem.copyWith(quantity: newQuantity),
                                    ),
                                  );
                                }
                              },
                              onRemove: () {
                                context.read<CartBloc>().add(
                                  RemoveFromCart(
                                    cartItem.menuItem.id,
                                    cartItem.restaurantId,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                BlocBuilder<CartBloc, CartState>(
                  buildWhen: (previous, current) =>
                      previous is CartLoaded &&
                      current is CartLoaded &&
                      (previous.subtotal != current.subtotal ||
                          previous.deliveryFee != current.deliveryFee ||
                          previous.tax != current.tax ||
                          previous.total != current.total),
                  builder: (context, summaryState) {
                    if (summaryState is CartLoaded) {
                      return _buildOrderSummary(context, summaryState);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          } else if (state is CartError) {
            return _buildErrorState(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some delicious items to get started!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', state.subtotal),
            const SizedBox(height: 6),
            _buildSummaryRow('Delivery Fee', state.deliveryFee),
            const SizedBox(height: 6),
            _buildSummaryRow('Tax', state.tax),
            const Divider(height: 24, thickness: 1),
            _buildSummaryRow('Total', state.total, isTotal: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.checkout,
                  arguments: CheckoutRouteArgs(
                    cartItems: state.items,
                    subtotal: state.subtotal,
                    deliveryFee: state.deliveryFee,
                    tax: state.tax,
                    total: state.total,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 18 : 15,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 18 : 15,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading cart', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CartBloc>().add(LoadCart());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Clear Cart',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CartBloc>().add(ClearCart());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
