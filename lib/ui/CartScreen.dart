import 'package:flutter/material.dart';

import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:mini_e_commerce/utils/CartBottomSection.dart';
import 'package:mini_e_commerce/utils/CartItemCard.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.cartproducts.length,
              itemBuilder: (context, index) {
                final product = provider.cartproducts[index];
                return CartItemCard(product: product);
              },
            ),
          ),

          CartBottomSection(),
        ],
      ),
    );
  }
}
