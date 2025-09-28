import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/core/extension/build_extension.dart';
import 'package:order_food/core/widgets/loading_shimmer.dart';
import 'package:order_food/features/restaurant/bloc/restaurant_bloc.dart';
import 'package:order_food/features/restaurant/model/resturant.dart';
import 'package:order_food/features/restaurant/presentation/widget/reataurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // context.read<RestaurantBloc>().add(LoadRestaurants());
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Column(
      children: [
        _buildSearchBar(colorScheme),
        Expanded(child: _buildRestaurantList(colorScheme)),
      ],
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        onChanged: _handleSearchChange,
      ),
    );
  }

  Widget _buildRestaurantList(ColorScheme colorScheme) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return const LoadingShimmer();
        } else if (state is RestaurantLoaded ||
            state is RestaurantDetailLoaded) {
          return _buildRestaurantContent(state.restaurants, colorScheme);
        } else if (state is RestaurantError) {
          return _buildErrorState(state.message, colorScheme);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildRestaurantContent(
    List<Restaurant> restaurants,
    ColorScheme colorScheme,
  ) {
    if (restaurants.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    return RefreshIndicator(
      onRefresh: _refreshRestaurants,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 200),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RestaurantCard(restaurant: restaurant);
        },
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_rounded,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No restaurants found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: colorScheme.error),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _retryLoading, child: const Text('Retry')),
        ],
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<RestaurantBloc>().add(LoadRestaurants());
    setState(() {});
  }

  void _handleSearchChange(String value) {
    setState(() {});
    if (value.isEmpty) {
      context.read<RestaurantBloc>().add(LoadRestaurants());
    } else {
      context.read<RestaurantBloc>().add(SearchRestaurants(value));
    }
  }

  Future<void> _refreshRestaurants() async {
    context.read<RestaurantBloc>().add(LoadRestaurants());
  }

  void _retryLoading() {
    context.read<RestaurantBloc>().add(LoadRestaurants());
  }
}
