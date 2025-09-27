import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/core/extension/build_extension.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                cartItem.menuItem.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.fastfood,
                      color: colorScheme.primary.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.menuItem.name,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (cartItem.quantity > 1) {
                    HapticFeedback.lightImpact();
                    onQuantityChanged(cartItem.quantity - 1);
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cartItem.quantity > 1
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 16,
                    color: cartItem.quantity > 1
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                cartItem.quantity.toString(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onQuantityChanged(cartItem.quantity + 1);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(Icons.add, size: 16, color: colorScheme.primary),
                ),
              ),

              const SizedBox(width: 12),

              // Remove button
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onRemove();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.close, size: 16, color: colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
