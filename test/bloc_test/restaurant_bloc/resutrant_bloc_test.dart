import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:order_food/features/restaurant/bloc/restaurant_bloc.dart';
import 'package:order_food/features/restaurant/model/resturant.dart';
import 'package:order_food/repository/resturant_repo.dart';
import 'widget_test.mocks.dart';

@GenerateMocks([RestaurantRepository])
void main() {
  late MockRestaurantRepository mockRepository;
  late RestaurantBloc restaurantBloc;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    restaurantBloc = RestaurantBloc(mockRepository);
  });

  tearDown(() {
    restaurantBloc.close();
  });

  group('RestaurantBloc', () {
    final mockRestaurants = [
      Restaurant(
        id: '1',
        name: 'Pizza Palace',
        description: 'Authentic Italian pizzas made with fresh ingredients',
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
        rating: 4.5,
        deliveryTime: 30,
        deliveryFee: 2.99,
        categories: ['Italian', 'Pizza'],
        menu: [
          const MenuItem(
            id: '1',
            name: 'Margherita Pizza',
            description:
                'Classic pizza with tomato sauce, mozzarella, and basil',
            price: 14.99,
            imageUrl:
                'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
            category: 'Pizza',
            allergens: ['Gluten', 'Dairy'],
          ),
          const MenuItem(
            id: '2',
            name: 'Pepperoni Pizza',
            description: 'Traditional pizza topped with pepperoni and cheese',
            price: 16.99,
            imageUrl:
                'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
            category: 'Pizza',
            allergens: ['Gluten', 'Dairy'],
          ),
          const MenuItem(
            id: '3',
            name: 'Caesar Salad',
            description:
                'Fresh romaine lettuce with Caesar dressing and croutons',
            price: 8.99,
            imageUrl:
                'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
            category: 'Salads',
            allergens: ['Gluten', 'Dairy'],
          ),
        ],
      ),
      Restaurant(
        id: '2',
        name: 'Burger Haven',
        description: 'Gourmet burgers with premium ingredients',
        imageUrl:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800',
        rating: 4.3,
        deliveryTime: 25,
        deliveryFee: 1.99,
        categories: ['American', 'Burgers'],
        menu: [
          const MenuItem(
            id: '4',
            name: 'Classic Cheeseburger',
            description:
                'Juicy beef patty with cheese, lettuce, tomato, and pickles',
            price: 12.99,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
            category: 'Burgers',
            allergens: ['Gluten', 'Dairy'],
          ),
          const MenuItem(
            id: '5',
            name: 'Bacon BBQ Burger',
            description: 'Beef patty with bacon, BBQ sauce, and onion rings',
            price: 15.99,
            imageUrl:
                'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=400',
            category: 'Burgers',
            allergens: ['Gluten', 'Dairy'],
          ),
          const MenuItem(
            id: '6',
            name: 'Sweet Potato Fries',
            description: 'Crispy sweet potato fries with aioli dip',
            price: 6.99,
            imageUrl:
                'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
            category: 'Sides',
          ),
        ],
      ),
      Restaurant(
        id: '3',
        name: 'Sushi Zen',
        description: 'Fresh sushi and Japanese cuisine',
        imageUrl:
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
        rating: 4.7,
        deliveryTime: 40,
        deliveryFee: 3.99,
        categories: ['Japanese', 'Sushi'],
        menu: [
          const MenuItem(
            id: '7',
            name: 'Salmon Nigiri Set',
            description: 'Fresh salmon nigiri sushi (6 pieces)',
            price: 18.99,
            imageUrl:
                'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
            category: 'Sushi',
            allergens: ['Fish'],
          ),
          const MenuItem(
            id: '8',
            name: 'California Roll',
            description: 'Crab, avocado, and cucumber roll with sesame seeds',
            price: 10.99,
            imageUrl:
                'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=400',
            category: 'Rolls',
            allergens: ['Fish', 'Sesame'],
          ),
          const MenuItem(
            id: '9',
            name: 'Miso Soup',
            description: 'Traditional Japanese soup with tofu and seaweed',
            price: 4.99,
            imageUrl:
                'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400',
            category: 'Soup',
            allergens: ['Soy'],
          ),
        ],
      ),
    ];

    test('initial state is RestaurantInitial', () {
      expect(restaurantBloc.state, equals(RestaurantInitial([])));
    });

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantLoaded] when LoadRestaurants is added and succeeds',
      build: () {
        when(
          mockRepository.getRestaurants(),
        ).thenAnswer((_) async => mockRestaurants);
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurants()),
      expect: () => [RestaurantLoading([]), RestaurantLoaded(mockRestaurants)],
      verify: (_) {
        verify(mockRepository.getRestaurants()).called(1);
      },
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantError] when LoadRestaurants is added and fails',
      build: () {
        when(mockRepository.getRestaurants()).thenThrow(Exception('Error'));
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurants()),
      expect: () => [
        RestaurantLoading([]),
        RestaurantError('Failed to load restaurants: Exception: Error', []),
      ],
      verify: (_) {
        verify(mockRepository.getRestaurants()).called(1);
      },
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantLoaded] when SearchRestaurants is added and succeeds',
      build: () {
        when(
          mockRepository.searchRestaurants('query'),
        ).thenAnswer((_) async => mockRestaurants);
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(SearchRestaurants('query')),
      expect: () => [RestaurantLoading([]), RestaurantLoaded(mockRestaurants)],
      verify: (_) {
        verify(mockRepository.searchRestaurants('query')).called(1);
      },
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantError] when SearchRestaurants is added and fails',
      build: () {
        when(
          mockRepository.searchRestaurants('query'),
        ).thenThrow(Exception('Error'));
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(SearchRestaurants('query')),
      expect: () => [
        RestaurantLoading([]),
        RestaurantError('Failed to search restaurants: Exception: Error', []),
      ],
      verify: (_) {
        verify(mockRepository.searchRestaurants('query')).called(1);
      },
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantDetailLoaded] when LoadRestaurantById is added and succeeds',
      build: () {
        final restaurant = Restaurant(
          id: '3',
          name: 'Sushi Zen',
          description: 'Fresh sushi and Japanese cuisine',
          imageUrl:
              'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
          rating: 4.7,
          deliveryTime: 40,
          deliveryFee: 3.99,
          categories: ['Japanese', 'Sushi'],
          menu: [
            const MenuItem(
              id: '7',
              name: 'Salmon Nigiri Set',
              description: 'Fresh salmon nigiri sushi (6 pieces)',
              price: 18.99,
              imageUrl:
                  'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
              category: 'Sushi',
              allergens: ['Fish'],
            ),
            const MenuItem(
              id: '8',
              name: 'California Roll',
              description: 'Crab, avocado, and cucumber roll with sesame seeds',
              price: 10.99,
              imageUrl:
                  'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=400',
              category: 'Rolls',
              allergens: ['Fish', 'Sesame'],
            ),
            const MenuItem(
              id: '9',
              name: 'Miso Soup',
              description: 'Traditional Japanese soup with tofu and seaweed',
              price: 4.99,
              imageUrl:
                  'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400',
              category: 'Soup',
              allergens: ['Soy'],
            ),
          ],
        );
        when(
          mockRepository.getRestaurantById('3'),
        ).thenAnswer((_) async => restaurant);
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurantById('3')),
      expect: () => [
        RestaurantLoading([]),
        RestaurantDetailLoaded(
          Restaurant(
            id: '3',
            name: 'Sushi Zen',
            description: 'Fresh sushi and Japanese cuisine',
            imageUrl:
                'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
            rating: 4.7,
            deliveryTime: 40,
            deliveryFee: 3.99,
            categories: ['Japanese', 'Sushi'],
            menu: [
              const MenuItem(
                id: '7',
                name: 'Salmon Nigiri Set',
                description: 'Fresh salmon nigiri sushi (6 pieces)',
                price: 18.99,
                imageUrl:
                    'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
                category: 'Sushi',
                allergens: ['Fish'],
              ),
              const MenuItem(
                id: '8',
                name: 'California Roll',
                description:
                    'Crab, avocado, and cucumber roll with sesame seeds',
                price: 10.99,
                imageUrl:
                    'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=400',
                category: 'Rolls',
                allergens: ['Fish', 'Sesame'],
              ),
              const MenuItem(
                id: '9',
                name: 'Miso Soup',
                description: 'Traditional Japanese soup with tofu and seaweed',
                price: 4.99,
                imageUrl:
                    'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400',
                category: 'Soup',
                allergens: ['Soy'],
              ),
            ],
          ),
          [],
        ),
      ],
      verify: (_) {
        verify(mockRepository.getRestaurantById('3')).called(1);
      },
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantError] when LoadRestaurantById is added and fails',
      build: () {
        when(
          mockRepository.getRestaurantById('1'),
        ).thenThrow(Exception('Error'));
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurantById('1')),
      expect: () => [
        RestaurantLoading([]),
        RestaurantError('Failed to load restaurant: Exception: Error', []),
      ],
      verify: (_) {
        verify(mockRepository.getRestaurantById('1')).called(1);
      },
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantError] when LoadRestaurantById is added and restaurant is not found',
      build: () {
        when(
          mockRepository.getRestaurantById('1'),
        ).thenAnswer((_) async => null);
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurantById('1')),
      expect: () => [
        RestaurantLoading([]),
        const RestaurantError('Restaurant not found', []),
      ],
      verify: (_) {
        verify(mockRepository.getRestaurantById('1')).called(1);
      },
    );
  });
}
