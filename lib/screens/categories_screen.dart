import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/category_card.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productProvider.categories.length,
            itemBuilder: (context, index) {
              final category = productProvider.categories[index];
              return CategoryCard(category: category);
            },
          );
        },
      ),
    );
  }
}