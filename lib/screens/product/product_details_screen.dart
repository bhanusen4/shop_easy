import 'package:ecommerce/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import '../../data/models/seller_model.dart';
import '../../providers/cart_provider.dart';
import '../../routes/app_routes.dart';


class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {


    final Map<int, SellerModel> sellerInfoMap = {
      1: SellerModel(name: "Syed Noman", rating: 4.8, reviews: 320),
      2: SellerModel(name: "Rahul Store", rating: 4.5, reviews: 210),
      3: SellerModel(name: "Tech World", rating: 4.7, reviews: 540),
      4: SellerModel(name: "Fashion Hub", rating: 4.3, reviews: 180),
    };
    final seller = sellerInfoMap[product.id] ??
        SellerModel(name: "Verified Seller", rating: 4.5, reviews: 100);

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Background for the image area
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. App Bar & Image Section
              SliverAppBar(
                expandedHeight: 350,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: _circularButton(context, Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                actions: [
                  _circularButton(context, Icons.share_outlined, () {}),
                  const SizedBox(width: 8),
                  _circularButton(context, Icons.favorite_border, () {}),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Hero(
                      tag: product.id,
                      child: Image.network(product.image, height: 250, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),

              // 2. Details Content
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("\$${product.price}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),

                      // Seller/Review Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(radius: 12, backgroundColor: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                "Seller: ${seller.name}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 20),
                              Text(
                                " ${seller.rating} (${seller.reviews} Reviews)",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(product.description, style: const TextStyle(color: Colors.grey, height: 1.5)),
                      const SizedBox(height: 100), // Extra space for the floating bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Floating Bottom Action Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _circularButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(icon, color: Colors.black, size: 18),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: () {}),
                const Text("1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A00),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                context.read<CartProvider>().addToCart(product);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
