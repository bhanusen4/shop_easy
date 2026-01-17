import 'package:ecommerce/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/category_short_name.dart';
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

         suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "|",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
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
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  final Map<String, IconData> categoryIcons = {
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
                        categoryIcons[category] ?? Icons.category,
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

                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'See All Products',
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Fav"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
