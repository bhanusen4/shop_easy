import 'package:ecommerce/core/constants/app_colors.dart';
import 'package:ecommerce/core/widgets/color_dots.dart';
import 'package:ecommerce/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/seller_model.dart';
import '../../providers/cart_provider.dart';
import '../../routes/app_routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selected=0;

  @override
  Widget build(BuildContext context) {
    final Map<int, SellerModel> sellerInfoMap = {
      1: SellerModel(name: "Syed Noman", rating: 4.8, reviews: 320),
      2: SellerModel(name: "Rahul Store", rating: 4.5, reviews: 210),
      3: SellerModel(name: "Tech World", rating: 4.7, reviews: 540),
      4: SellerModel(name: "Fashion Hub", rating: 4.3, reviews: 180),
    };
    final seller = sellerInfoMap[widget.product.id] ??
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
                leading: _circularButton(context, Icons.arrow_back_ios_new,
                    () => Navigator.pop(context)),
                actions: [
                  _circularButton(context, Icons.share_outlined, () {}),
                  const SizedBox(width: 8),
                  _circularButton(context, Icons.favorite_border, () {}),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Hero(
                      tag: widget.product.id,
                      child: Image.network(widget.product.image,
                          height: 250, fit: BoxFit.contain),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(35)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("\$${widget.product.price}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),

                      // Seller/Review Row
                      Align(
                        alignment: Alignment.topRight,
                         child:  Text(
                            "Seller: ${seller.name}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700),
                          ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 3,right: 5),
                            decoration: BoxDecoration(
                                                color:AppColors.primary,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.white, size: 12),
                            Text(
                              " ${seller.rating}",
                              style: const TextStyle(color: Colors.white,fontSize: 13),

                            ),
                         ] )),
                          Text(
                            " (${seller.reviews} Reviews)",
                            style: const TextStyle(color: Colors.grey,fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const Text('Color',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          AppColors.productColors.length,
                              (index) => selectedColorDot(
                            AppColors.productColors[index],
                            index,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDescription("Description", 0),
                          ),
                          Expanded(
                            child: _buildDescription("Specification", 1),
                          ),
                          Expanded(
                            child: _buildDescription("Reviews", 2),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Text(widget.product.description,
                          style:
                              const TextStyle(color: Colors.grey, height: 1.5)),
                      const SizedBox(height: 100),
                      // Extra space for the floating bottom bar
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

  int selectedColorIndex=0;

  Widget selectedColorDot(Color color, int index) {
    final isSelected = selectedColorIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Container(
          height: 23,
          width: 23,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }


  Widget _buildDescription(String title, int index) {
    final isSelected = selected == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = index;
        });
      },
      child: Container(
       margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circularButton(
      BuildContext context, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              final qty = cart.getQty(widget.product.id);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed:
                          qty > 0 ? () => cart.decrement(widget.product.id) : null,
                    ),
                    Text(
                      qty.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => cart.increment(widget.product.id),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                context.read<CartProvider>().addToCart(widget.product);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              child: const Text("Add to Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
