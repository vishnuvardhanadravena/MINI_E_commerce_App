import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:mini_e_commerce/ui/HOME/ProductCardWidget.dart';
import 'package:mini_e_commerce/ui/productSereenDetaies.dart';
import 'package:mini_e_commerce/model/Product.dart';

class SearchResultScreen extends StatelessWidget {
  final Product? selectedProduct;
  final String title;

  const SearchResultScreen({
    super.key,
    required this.title,
    this.selectedProduct,
  });

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);

    /// prepare final list
    final List<Product> resultProducts = selectedProduct == null
        ? prov.products
        : [
            selectedProduct!,
            ...prov.products.where((p) => p.id != selectedProduct!.id).toList(),
          ];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: resultProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final product = resultProducts[index];

                return ProductCardWidget(
                  product: product,
                  colors: const [
                    Colors.pink,
                    Colors.blue,
                    Colors.orange,
                    Colors.grey,
                  ],
                  selectedColor: 0,
                  onTapcolors: (_) {},
                  onFavorite: () {},
                  onTap: (p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(productId: p.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
