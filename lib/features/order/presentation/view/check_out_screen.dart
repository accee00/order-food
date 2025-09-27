import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:order_food/core/extension/build_extension.dart';
import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/features/order/bloc/order_bloc.dart';
import 'package:order_food/features/order/presentation/view/order_track_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _promoController = TextEditingController();

  String? _selectedPaymentMethod;
  String? _selectedDeliveryTime;
  bool _isLoadingLocation = false;
  bool _promoApplied = false;
  double _promoDiscount = 0.0;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'icon': Icons.credit_card,
      'title': 'Credit Card',
      'subtitle': '**** 1234',
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Debit Card',
      'subtitle': '**** 5678',
    },
    {
      'icon': Icons.paypal_outlined,
      'title': 'PayPal',
      'subtitle': 'user@example.com',
    },
    {'icon': Icons.apple, 'title': 'Apple Pay', 'subtitle': 'Touch ID'},
    {
      'icon': Icons.local_atm,
      'title': 'Cash on Delivery',
      'subtitle': 'Pay when delivered',
    },
  ];

  final List<Map<String, dynamic>> _deliveryTimes = [
    {'title': 'ASAP', 'subtitle': '35-45 min', 'icon': Icons.flash_on},
    {'title': 'Schedule', 'subtitle': 'Choose time', 'icon': Icons.schedule},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod =
        '${_paymentMethods[0]['title']} (${_paymentMethods[0]['subtitle']})';
    _selectedDeliveryTime =
        '${_deliveryTimes[0]['title']} (${_deliveryTimes[0]['subtitle']})';

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideController.forward();
    _fadeController.forward();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _promoController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.street}, ${place.locality}, ${place.country}';
        _addressController.text = address;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
            backgroundColor: context.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      _addressController.text = '123 Main Street, Anytown, USA';
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Widget _buildModernCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color ?? context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: context.colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalWithDiscount = widget.total - _promoDiscount;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            context.read<CartBloc>().add(ClearCart());
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    OrderTrackingScreen(order: state.order),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                        child: child,
                      );
                    },
              ),
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: context.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: context.colorScheme.background,
                  foregroundColor: context.colorScheme.onBackground,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Checkout',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onBackground,
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Delivery Address
                              _buildModernCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'Delivery Address',
                                      Icons.location_on,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _addressController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your delivery address',
                                        hintStyle: TextStyle(
                                          color: context.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.colorScheme.outline,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.colorScheme.outline
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        suffixIcon: _isLoadingLocation
                                            ? Container(
                                                width: 20,
                                                height: 20,
                                                margin: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: context
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.my_location,
                                                  color: context
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                onPressed: _getCurrentLocation,
                                              ),
                                      ),
                                      maxLines: 2,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a delivery address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Delivery Time
                              _buildModernCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'Delivery Time',
                                      Icons.access_time,
                                    ),
                                    const SizedBox(height: 16),
                                    ...(_deliveryTimes.asMap().entries.map((
                                      entry,
                                    ) {
                                      int index = entry.key;
                                      Map<String, dynamic> time = entry.value;
                                      String value =
                                          '${time['title']} (${time['subtitle']})';

                                      return Container(
                                        margin: EdgeInsets.only(
                                          bottom:
                                              index < _deliveryTimes.length - 1
                                              ? 12
                                              : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                _selectedDeliveryTime == value
                                                ? context.colorScheme.primary
                                                : context.colorScheme.outline
                                                      .withValues(alpha: 0.3),
                                            width:
                                                _selectedDeliveryTime == value
                                                ? 2
                                                : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: RadioListTile<String>(
                                          title: Row(
                                            children: [
                                              Icon(
                                                time['icon'],
                                                color:
                                                    _selectedDeliveryTime ==
                                                        value
                                                    ? context
                                                          .colorScheme
                                                          .primary
                                                    : context
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    time['title'],
                                                    style: context
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              _selectedDeliveryTime ==
                                                                  value
                                                              ? context
                                                                    .colorScheme
                                                                    .primary
                                                              : context
                                                                    .colorScheme
                                                                    .onSurface,
                                                        ),
                                                  ),
                                                  Text(
                                                    time['subtitle'],
                                                    style: context
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: context
                                                              .colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          value: value,
                                          groupValue: _selectedDeliveryTime,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedDeliveryTime = newValue;
                                            });
                                          },
                                          activeColor:
                                              context.colorScheme.primary,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                        ),
                                      );
                                    }).toList()),
                                  ],
                                ),
                              ),

                              // Payment Method
                              _buildModernCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'Payment Method',
                                      Icons.payment,
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: context.colorScheme.outline
                                              .withValues(alpha: 0.5),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedPaymentMethod,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        items: _paymentMethods.map((method) {
                                          String value =
                                              '${method['title']} (${method['subtitle']})';
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  method['icon'],
                                                  color: context
                                                      .colorScheme
                                                      .primary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      method['title'],
                                                      style: context
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                    Text(
                                                      method['subtitle'],
                                                      style: context
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: context
                                                                .colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                  alpha: 0.6,
                                                                ),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedPaymentMethod = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a payment method';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Promo Code
                              _buildModernCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'Promo Code',
                                      Icons.local_offer,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _promoController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter promo code',
                                              hintStyle: TextStyle(
                                                color: context
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: context
                                                      .colorScheme
                                                      .outline,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: context
                                                      .colorScheme
                                                      .outline
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: context
                                                      .colorScheme
                                                      .primary,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: _promoApplied
                                              ? null
                                              : () {
                                                  if (_promoController
                                                      .text
                                                      .isNotEmpty) {
                                                    setState(() {
                                                      _promoApplied = true;
                                                      _promoDiscount =
                                                          widget.total *
                                                          0.1; // 10% discount
                                                    });
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              'Promo code applied! 10% off',
                                                            ),
                                                          ],
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _promoApplied
                                                ? Colors.green
                                                : context.colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                          ),
                                          child: _promoApplied
                                              ? Icon(Icons.check, size: 20)
                                              : Text('Apply'),
                                        ),
                                      ],
                                    ),
                                    if (_promoApplied) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'You saved \$${_promoDiscount.toStringAsFixed(2)}!',
                                              style: context
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Order Summary
                              _buildModernCard(
                                color: context.colorScheme.primaryContainer
                                    .withValues(alpha: 0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'Order Summary',
                                      Icons.receipt_long,
                                    ),
                                    const SizedBox(height: 16),
                                    ...widget.cartItems
                                        .map(
                                          (item) => Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color:
                                                  context.colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: context
                                                        .colorScheme
                                                        .primary
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${item.quantity}x',
                                                      style: context
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                            color: context
                                                                .colorScheme
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    item.menuItem.name,
                                                    style: context
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                                  style: context
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: context
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),

                                    const SizedBox(height: 16),
                                    Container(
                                      height: 1,
                                      color: context.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                                    const SizedBox(height: 16),

                                    _buildPriceRow('Subtotal', widget.subtotal),
                                    _buildPriceRow(
                                      'Delivery Fee',
                                      widget.deliveryFee,
                                    ),
                                    _buildPriceRow('Tax', widget.tax),
                                    if (_promoApplied)
                                      _buildPriceRow(
                                        'Discount',
                                        -_promoDiscount,
                                        color: Colors.green,
                                      ),

                                    const SizedBox(height: 16),
                                    Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            context.colorScheme.primary
                                                .withValues(alpha: 0.3),
                                            context.colorScheme.secondary
                                                .withValues(alpha: 0.3),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: context.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: context
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                        ),
                                        Text(
                                          '\$${totalWithDiscount.toStringAsFixed(2)}',
                                          style: context.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    context.colorScheme.primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 100,
                              ), // Bottom padding for floating button
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // Floating Action Button
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FloatingActionButton.extended(
          onPressed: context.watch<OrderBloc>().state is OrderPlacing
              ? null
              : _placeOrder,
          backgroundColor: context.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          label: context.watch<OrderBloc>().state is OrderPlacing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Placing Order...'),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_checkout),
                    const SizedBox(width: 8),
                    Text(
                      'Place Order • \$${(widget.total - _promoDiscount).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPriceRow(String label, double amount, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyLarge?.copyWith(
              color: color ?? context.colorScheme.onSurface,
            ),
          ),
          Text(
            '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color ?? context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      final restaurantId = widget.cartItems.first.restaurantId;
      const restaurantName = 'Restaurant';

      context.read<OrderBloc>().add(
        PlaceOrder(
          items: widget.cartItems,
          restaurantId: restaurantId,
          restaurantName: restaurantName,
          deliveryAddress: _addressController.text,
          subtotal: widget.subtotal,
          deliveryFee: widget.deliveryFee,
          tax: widget.tax,
        ),
      );
    }
  }
}
