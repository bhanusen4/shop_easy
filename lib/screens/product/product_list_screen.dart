import 'package:ecommerce/core/widgets/product_card.dart';
import 'package:ecommerce/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/category_short_name.dart';
import '../../providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  final String category;
  const ProductListScreen({super.key, required this.category, });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:   Text(capitalizeFirstLetter(widget.category))),
      body: Consumer<ProductProvider>(
        builder: (_, p, __) {
          if (p.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15

            ),
            itemCount: p.products.length,
            itemBuilder: (_, i) {
              final product = p.products[i];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailsScreen(product: product),
                    ),
                  );
                },
                child:ProductCard(product: product),

              );
            },
          );
        },
      ),
    );
  }
}
