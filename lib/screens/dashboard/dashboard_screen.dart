import 'package:ecommerce/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/category_short_name.dart';
import '../../core/widgets/banner_carousel.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../routes/app_routes.dart';

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
  String _selectedCategory ='All';
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
            _searchBar(context),
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

  Widget _searchBar(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<ProductProvider>().search(value);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, size: 20, color: Colors.black),
        hintText: "Search...",
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.grey,
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("|", style: TextStyle(color: Colors.black)),
              SizedBox(width: 8),
              Icon(Icons.filter_list, size: 20, color: Colors.black),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }



  final Map<String, IconData> categoryIcons = {
    "all": Icons.dashboard,
    "electronics": Icons.electrical_services,
    "jewelery": Icons.diamond,
    "men's clothing": Icons.man,
    "women's clothing": Icons.woman,
  };


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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.darkGrey,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        categoryIcons[category] ?? Icons.dashboard,
                        color: isSelected ? AppColors.primary : AppColors.darkGrey,
                        size: 26,
                      ),
                    )
,

                    const SizedBox(height: 6),
                    Text(
                      categoryShortName(category),

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryShortName(    _selectedCategory!),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                ),    InkWell(
                  onTap: (){
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productList,
                      arguments: _selectedCategory, // Pass the string directly, not a Map


                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
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
                  child: ProductCard(product: product,),
                );
              },
            ),
          ],
        );
      },
    );
  }

  int _currentIndex = 0;


  Widget _bottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
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
      items:   [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),


        BottomNavigationBarItem(
          label: "Cart",
          icon: Consumer<CartProvider>(
            builder: (_, cart, __) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined),

                  if (cart.items.length > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF7A00),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cart .items.length.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          activeIcon: Consumer<CartProvider>(
            builder: (_, cart, __) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart),

                  if ( cart .items.length > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF7A00),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart .items.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Fav"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
