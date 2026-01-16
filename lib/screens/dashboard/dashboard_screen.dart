import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/banner_carousel.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    context.read<CategoryProvider>().loadCategories();
  }
  String? _selectedCategory;
  bool _initialized = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      appBar: AppBar(
        leading: const Icon(Icons.grid_view_rounded),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 16),
            const BannerCarousel(),
            const SizedBox(height: 16),
            _categories(),
            const SizedBox(height: 16),
            _specialForYou(context),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
          color: Colors.black,
        ),

        hintText: "Search...",
        hintStyle: const TextStyle(color: Colors.grey),

        filled: true,
        fillColor: AppColors.grey,

        /// IMPORTANT: use suffix instead of suffixIcon
        suffix: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "|",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.filter_list,
                size: 20,
                color: Colors.black,
              ),
            ],
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 14, // key line
          horizontal: 0,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }



  Widget _categories() {
    return Consumer<CategoryProvider>(
      builder: (_, p, __) {
        if (p.loading) {
          return const SizedBox(
            height: 90,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (p.categories.isEmpty) {
          return const Text("No categories found");
        }

        /// 🔥 AUTO SELECT FIRST CATEGORY (only once)
        if (!_initialized) {
          _initialized = true;
          _selectedCategory = p.categories.first;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context
                .read<ProductProvider>()
                .loadProducts(_selectedCategory!);
          });
        }

        return SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: p.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final category = p.categories[i];
              final isSelected = category == _selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });

                  context
                      .read<ProductProvider>()
                      .loadProducts(category);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                      isSelected ? AppColors.primary : AppColors.grey,
                      child: Text(
                        category[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category,
                      style: TextStyle(
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }



  Widget _specialForYou(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (_, p, __) {
        if (_selectedCategory == null) {
          return const Text(
            "Select a category",
            style: TextStyle(color: Colors.grey),
          );
        }

        if (p.loading) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (p.products.isEmpty) {
          return const Text("No products found");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedCategory!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: p.products.length,
              itemBuilder: (_, i) {
                final product = p.products[i];


                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetails,
                      arguments: product,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100, // Light grey background like in image aa.png
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // 1. Favorite Badge (Top Right)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF7A00), // Your brand orange
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: const Icon(Icons.favorite_border, color: Colors.white, size: 18),
                          ),
                        ),

                        // 2. Card Content
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: Center(
                                  child: Hero(
                                    tag: product.id,
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Title
                              Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),

                              // Price and Color Dots Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${product.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // Color selection dots
                                  Row(
                                    children: [
                                      _colorDot(Colors.black87),
                                      _colorDot(Colors.redAccent),
                                      _colorDot(const Color(0xFFFF7A00)),
                                      _colorDot(Colors.blue),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  Widget _colorDot(Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
  int _currentIndex = 0;

// List of screens to navigate between
  final List<Widget> _screens = [
    const DashboardScreen(),
    const CartScreen(),
   ];

  Widget _bottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Tells Flutter which icon to highlight
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed, // Keeps labels from shifting
      selectedItemColor: const Color(0xFFFF7A00), // Your brand orange
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Fav"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
