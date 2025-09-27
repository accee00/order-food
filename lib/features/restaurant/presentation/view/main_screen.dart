import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'dart:io';

import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/cart/presentation/view/cart_screen.dart';
import 'package:order_food/features/order/bloc/order_bloc.dart';
import 'package:order_food/features/order/presentation/view/order_history_screen.dart';
import 'package:order_food/features/restaurant/presentation/view/home_screenn.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isAndroid = !kIsWeb && Platform.isAndroid;

    return Scaffold(
      extendBody: true,
      appBar: _buildCustomAppBar(colorScheme, textTheme),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            context.read<OrderBloc>().add(LoadOrderHistory());
          }
        },
        children: const [HomeScreen(), OrderHistoryView(), FavoritesTab()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isAndroid
          ? _buildAndroidNavBar(colorScheme, textTheme)
          : null,
      bottomNavigationBar: isAndroid
          ? null
          : _buildBottomNavigationBar(colorScheme, textTheme),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTabTitle(),
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _getTabSubtitle(),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int itemCount = 0;
            if (state is CartLoaded) {
              itemCount = state.items.length;
            }
            return Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: colorScheme.onPrimaryContainer,
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
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return _buildIOSNavBar(colorScheme, textTheme);
  }

  Widget _buildAndroidNavBar(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: _onTabTapped,
            backgroundColor: Colors.transparent,
            color: colorScheme.onSurfaceVariant,
            activeColor: colorScheme.onPrimary,
            tabBackgroundColor: colorScheme.primary,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tabs: [
              GButton(
                icon: Icons.home_rounded,
                text: 'Home',
                textStyle: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GButton(
                icon: Icons.history_rounded,
                text: 'Orders',
                textStyle: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GButton(
                icon: Icons.favorite_rounded,
                text: 'Favorites',
                textStyle: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIOSNavBar(ColorScheme colorScheme, TextTheme textTheme) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GlassMorphismContainer(
        opacity: 0.15,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIOSNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _buildIOSNavItem(
                icon: Icons.history_rounded,
                label: 'Orders',
                index: 1,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _buildIOSNavItem(
                icon: Icons.favorite_rounded,
                label: 'Favorites',
                index: 2,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIOSNavItem({
    required IconData icon,
    required String label,
    required int index,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Food Delivery';
      case 1:
        return 'Order History';
      case 2:
        return 'Favorites';
      default:
        return 'Food Delivery';
    }
  }

  String _getTabSubtitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Discover delicious food';
      case 1:
        return 'Track your orders';
      case 2:
        return 'Your saved restaurants';
      default:
        return 'Discover delicious food';
    }
  }
}

class OrderHistoryTab extends StatelessWidget {
  const OrderHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Order History',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your past orders will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Favorites Tab
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_rounded, size: 64, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Favorites',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your favorite restaurants will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
