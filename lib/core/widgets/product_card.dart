import 'package:ecommerce/data/models/product_model.dart';
import 'package:flutter/material.dart';

import 'color_dots.dart';
class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return  Container(
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
                        colorDot(Colors.black87),
                        colorDot(Colors.redAccent),
                        colorDot(const Color(0xFFFF7A00)),
                        colorDot(Colors.blue),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
