import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/features/restaurant/model/resturant.dart';
import 'package:order_food/repository/cart_repo.dart';

@GenerateMocks([CartRepository])
import 'cart_bloc_test.mocks.dart';

void main() {
  late MockCartRepository mockRepository;
  late CartBloc cartBloc;

  setUp(() {
    mockRepository = MockCartRepository();
    cartBloc = CartBloc(mockRepository);
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    final mockMenuItem = MenuItem(
      id: '1',
      name: 'Margherita Pizza',
      description: 'Classic pizza with tomato sauce, mozzarella, and basil',
      price: 14.99,
      imageUrl: 'https://example.com/pizza.jpg',
      category: 'Pizza',
      allergens: ['Gluten', 'Dairy'],
    );

    final mockCartItem = CartItem(
      menuItem: mockMenuItem,
      quantity: 2,
      restaurantId: 'restaurant-1',
    );

    final mockCartItems = [mockCartItem];

    test('initial state is CartInitial', () {
      expect(cartBloc.state, equals(CartInitial()));
    });

    group('LoadCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] when LoadCart is added and succeeds',
        build: () {
          when(
            mockRepository.getCartItems(),
          ).thenAnswer((_) async => mockCartItems);
          when(mockRepository.subtotal).thenReturn(29.98);
          when(mockRepository.deliveryFee).thenReturn(2.99);
          when(mockRepository.tax).thenReturn(2.40);
          when(mockRepository.total).thenReturn(35.37);
          return cartBloc;
        },
        act: (bloc) => bloc.add(LoadCart()),
        expect: () => [
          CartLoading(),
          CartLoaded(
            items: mockCartItems,
            subtotal: 29.98,
            deliveryFee: 2.99,
            tax: 2.40,
            total: 35.37,
          ),
        ],
        verify: (_) {
          verify(mockRepository.getCartItems()).called(1);
          verify(mockRepository.subtotal).called(1);
          verify(mockRepository.deliveryFee).called(1);
          verify(mockRepository.tax).called(1);
          verify(mockRepository.total).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartError] when LoadCart is added and fails',
        build: () {
          when(
            mockRepository.getCartItems(),
          ).thenThrow(Exception('Network error'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(LoadCart()),
        expect: () => [
          CartLoading(),
          CartError('Failed to load cart: Exception: Network error'),
        ],
        verify: (_) {
          verify(mockRepository.getCartItems()).called(1);
        },
      );
    });

    group('AddToCart', () {
      blocTest<CartBloc, CartState>(
        'adds LoadCart event when AddToCart succeeds',
        build: () {
          when(mockRepository.addItem(any)).thenAnswer((_) async {});
          when(
            mockRepository.getCartItems(),
          ).thenAnswer((_) async => mockCartItems);
          when(mockRepository.subtotal).thenReturn(29.98);
          when(mockRepository.deliveryFee).thenReturn(2.99);
          when(mockRepository.tax).thenReturn(2.40);
          when(mockRepository.total).thenReturn(35.37);
          return cartBloc;
        },
        act: (bloc) => bloc.add(AddToCart(mockCartItem)),
        expect: () => [
          CartLoading(),
          CartLoaded(
            items: mockCartItems,
            subtotal: 29.98,
            deliveryFee: 2.99,
            tax: 2.40,
            total: 35.37,
          ),
        ],
        verify: (_) {
          verify(mockRepository.addItem(mockCartItem)).called(1);
          verify(mockRepository.getCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when AddToCart fails',
        build: () {
          when(mockRepository.addItem(any)).thenThrow(Exception('Add failed'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(AddToCart(mockCartItem)),
        expect: () => [
          CartError('Failed to add item to cart: Exception: Add failed'),
        ],
        verify: (_) {
          verify(mockRepository.addItem(mockCartItem)).called(1);
        },
      );
    });

    group('UpdateCartItem', () {
      blocTest<CartBloc, CartState>(
        'updates cart item when UpdateCartItem succeeds and state is CartLoaded',
        build: () {
          when(mockRepository.updateItem(any)).thenAnswer((_) async {});
          when(mockRepository.subtotal).thenReturn(44.97);
          when(mockRepository.deliveryFee).thenReturn(2.99);
          when(mockRepository.tax).thenReturn(2.40);
          when(mockRepository.total).thenReturn(50.36);
          return cartBloc;
        },
        seed: () => CartLoaded(
          items: mockCartItems,
          subtotal: 29.98,
          deliveryFee: 2.99,
          tax: 2.40,
          total: 35.37,
        ),
        act: (bloc) {
          final updatedCartItem = CartItem(
            menuItem: mockMenuItem,
            quantity: 3,
            restaurantId: 'restaurant-1',
          );
          bloc.add(UpdateCartItem(updatedCartItem));
        },
        expect: () => [
          CartLoaded(
            items: [
              CartItem(
                menuItem: mockMenuItem,
                quantity: 3,
                restaurantId: 'restaurant-1',
              ),
            ],
            subtotal: 44.97,
            deliveryFee: 2.99,
            tax: 2.40,
            total: 50.36,
          ),
        ],
        verify: (_) {
          verify(mockRepository.updateItem(any)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when UpdateCartItem fails',
        build: () {
          when(
            mockRepository.updateItem(any),
          ).thenThrow(Exception('Update failed'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(UpdateCartItem(mockCartItem)),
        expect: () => [
          CartError('Failed to update cart item: Exception: Update failed'),
        ],
        verify: (_) {
          verify(mockRepository.updateItem(mockCartItem)).called(1);
        },
      );
    });

    group('RemoveFromCart', () {
      blocTest<CartBloc, CartState>(
        'removes item from cart when RemoveFromCart succeeds and state is CartLoaded',
        build: () {
          when(mockRepository.removeItem(any, any)).thenAnswer((_) async {});
          // Mock the repository to return updated calculations for empty cart
          when(mockRepository.subtotal).thenReturn(0.0);
          when(mockRepository.deliveryFee).thenReturn(2.99);
          when(mockRepository.tax).thenReturn(2.40);
          when(mockRepository.total).thenReturn(5.39);
          return cartBloc;
        },
        seed: () => CartLoaded(
          items: mockCartItems,
          subtotal: 29.98,
          deliveryFee: 2.99,
          tax: 2.40,
          total: 35.37,
        ),
        act: (bloc) => bloc.add(RemoveFromCart('1', 'restaurant-1')),
        expect: () => [
          CartLoaded(
            items: [],
            subtotal: 0.0,
            deliveryFee: 2.99,
            tax: 2.40,
            total: 5.39,
          ),
        ],
        verify: (_) {
          verify(mockRepository.removeItem('1', 'restaurant-1')).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when RemoveFromCart fails',
        build: () {
          when(
            mockRepository.removeItem(any, any),
          ).thenThrow(Exception('Remove failed'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(RemoveFromCart('1', 'restaurant-1')),
        expect: () => [
          CartError(
            'Failed to remove item from cart: Exception: Remove failed',
          ),
        ],
        verify: (_) {
          verify(mockRepository.removeItem('1', 'restaurant-1')).called(1);
        },
      );
    });

    group('ClearCart', () {
      blocTest<CartBloc, CartState>(
        'adds LoadCart event when ClearCart succeeds',
        build: () {
          when(mockRepository.clearCart()).thenAnswer((_) async {});
          when(mockRepository.getCartItems()).thenAnswer((_) async => []);
          when(mockRepository.subtotal).thenReturn(0.0);
          when(mockRepository.deliveryFee).thenReturn(0.0);
          when(mockRepository.tax).thenReturn(0.0);
          when(mockRepository.total).thenReturn(0.0);
          return cartBloc;
        },
        act: (bloc) => bloc.add(ClearCart()),
        expect: () => [
          CartLoading(),
          CartLoaded(
            items: [],
            subtotal: 0.0,
            deliveryFee: 0.0,
            tax: 0.0,
            total: 0.0,
          ),
        ],
        verify: (_) {
          verify(mockRepository.clearCart()).called(1);
          verify(mockRepository.getCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when ClearCart fails',
        build: () {
          when(mockRepository.clearCart()).thenThrow(Exception('Clear failed'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(ClearCart()),
        expect: () => [
          CartError('Failed to clear cart: Exception: Clear failed'),
        ],
        verify: (_) {
          verify(mockRepository.clearCart()).called(1);
        },
      );
    });

    group('Multiple items scenario', () {
      blocTest<CartBloc, CartState>(
        'correctly updates specific item in cart with multiple items',
        build: () {
          when(mockRepository.updateItem(any)).thenAnswer((_) async {});
          when(mockRepository.subtotal).thenReturn(99.0);
          when(mockRepository.deliveryFee).thenReturn(3.0);
          when(mockRepository.tax).thenReturn(3.12);
          when(mockRepository.total).thenReturn(105.12);
          return cartBloc;
        },
        seed: () {
          final item1 = CartItem(
            menuItem: MenuItem(
              id: '1',
              name: 'Pizza',
              description: 'Delicious pizza',
              price: 15.0,
              imageUrl: 'pizza.jpg',
              category: 'Main',
            ),
            quantity: 1,
            restaurantId: 'restaurant-1',
          );
          final item2 = CartItem(
            menuItem: MenuItem(
              id: '2',
              name: 'Burger',
              description: 'Tasty burger',
              price: 12.0,
              imageUrl: 'burger.jpg',
              category: 'Main',
            ),
            quantity: 2,
            restaurantId: 'restaurant-1',
          );
          return CartLoaded(
            items: [item1, item2],
            subtotal: 39.0,
            deliveryFee: 3.0,
            tax: 3.12,
            total: 45.12,
          );
        },
        act: (bloc) {
          final updatedItem = CartItem(
            menuItem: MenuItem(
              id: '1',
              name: 'Pizza',
              description: 'Delicious pizza',
              price: 15.0,
              imageUrl: 'pizza.jpg',
              category: 'Main',
            ),
            quantity: 5,
            restaurantId: 'restaurant-1',
          );
          bloc.add(UpdateCartItem(updatedItem));
        },
        expect: () => [
          CartLoaded(
            items: [
              CartItem(
                menuItem: MenuItem(
                  id: '1',
                  name: 'Pizza',
                  description: 'Delicious pizza',
                  price: 15.0,
                  imageUrl: 'pizza.jpg',
                  category: 'Main',
                ),
                quantity: 5,
                restaurantId: 'restaurant-1',
              ),
              CartItem(
                menuItem: MenuItem(
                  id: '2',
                  name: 'Burger',
                  description: 'Tasty burger',
                  price: 12.0,
                  imageUrl: 'burger.jpg',
                  category: 'Main',
                ),
                quantity: 2,
                restaurantId: 'restaurant-1',
              ),
            ],
            subtotal: 99.0,
            deliveryFee: 3.0,
            tax: 3.12,
            total: 105.12,
          ),
        ],
        verify: (_) {
          verify(mockRepository.updateItem(any)).called(1);
        },
      );
    });
  });
}
