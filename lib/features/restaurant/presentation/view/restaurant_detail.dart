import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/features/cart/presentation/view/cart_screen.dart';
import 'package:order_food/features/restaurant/model/resturant.dart';
import 'package:order_food/features/restaurant/presentation/widget/menu_item_card.dart';
import 'package:order_food/core/extension/build_extension.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _categories;
  late ScrollController _scrollController;
  bool _isAppBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _categories = widget.restaurant.menu
        .map((item) => item.category)
        .toSet()
        .toList();
    _tabController = TabController(length: _categories.length, vsync: this);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final isCollapsed = _scrollController.offset > 200;
      if (_isAppBarCollapsed != isCollapsed) {
        setState(() {
          _isAppBarCollapsed = isCollapsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addToCart(MenuItem menuItem) {
    final cartItem = CartItem(
      menuItem: menuItem,
      quantity: 1,
      restaurantId: widget.restaurant.id,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle,
                color: context.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Added to Cart',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    menuItem.name,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: context.colorScheme.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: context.colorScheme.primary,
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const CartScreen()));
          },
        ),
      ),
    );

    HapticFeedback.lightImpact();
  }

  Widget _buildModernInfoChip({
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            context.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: backgroundColor == null
            ? Border.all(
                color: context.colorScheme.outline.withValues(alpha: 0.2),
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color:
                iconColor ??
                (backgroundColor != null
                    ? Colors.white
                    : context.colorScheme.primary),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: backgroundColor != null
                  ? Colors.white
                  : context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: _appBar(colorScheme, context, textTheme),
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image(colorScheme, textTheme),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      widget.restaurant.description,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (widget.restaurant.categories.isNotEmpty) ...[
                      Text(
                        'Categories',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.restaurant.categories
                            .map(
                              (category) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    TabBar(
                      controller: _tabController,
                      tabs: _categories
                          .map((category) => Tab(text: category))
                          .toList(),
                      isScrollable: true,
                      labelColor: colorScheme.primary,
                      unselectedLabelColor: colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                      labelStyle: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 3,
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        controller: _tabController,
                        children: _categories.map((category) {
                          final categoryItems = widget.restaurant.menu
                              .where((item) => item.category == category)
                              .toList();

                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: categoryItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final menuItem = categoryItems[index];
                              return MenuItemCard(
                                menuItem: menuItem,
                                onAddToCart: () => _addToCart(menuItem),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _image(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.5, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.darken,
            child: Image.network(
              widget.restaurant.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 80,
            child: AnimatedOpacity(
              opacity: _isAppBarCollapsed ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildModernInfoChip(
                        icon: Icons.star_rounded,
                        label: '${widget.restaurant.rating}',
                        iconColor: Colors.amber,
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                      ),
                      _buildModernInfoChip(
                        icon: Icons.access_time_rounded,
                        label: '${widget.restaurant.deliveryTime} min',
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                      ),
                      _buildModernInfoChip(
                        icon: Icons.delivery_dining_rounded,
                        label:
                            '\$${widget.restaurant.deliveryFee.toStringAsFixed(2)}',
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(
    ColorScheme colorScheme,
    BuildContext context,
    TextTheme textTheme,
  ) {
    return AppBar(
      surfaceTintColor: colorScheme.background,
      backgroundColor: _isAppBarCollapsed
          ? colorScheme.background
          : Colors.transparent,
      elevation: _isAppBarCollapsed ? 2 : 0,
      foregroundColor: colorScheme.background,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isAppBarCollapsed
              ? Colors.transparent
              : Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _isAppBarCollapsed ? colorScheme.onBackground : Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: AnimatedOpacity(
        opacity: _isAppBarCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          widget.restaurant.name,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isAppBarCollapsed
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.items.length;
              }
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_rounded,
                      color: _isAppBarCollapsed
                          ? colorScheme.onBackground
                          : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          itemCount > 99 ? '99+' : '$itemCount',
                          style: TextStyle(
                            color: colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
