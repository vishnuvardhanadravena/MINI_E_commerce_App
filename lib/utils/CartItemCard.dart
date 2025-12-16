import 'package:flutter/material.dart';
import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final dynamic product;

  const CartItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: true);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 80,
              width: 80,
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        product.quantity = -1;
                        provider.removeFromCart(product);
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  product.category,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                        // border: Border.all(),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              provider.removeFromCart(product);
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            product.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () {
                              provider.addToCart(product,"cart");
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Row(
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         provider.removeOne(product);
          //       },
          //       child: Container(
          //         width: 28,
          //         height: 28,
          //         decoration: BoxDecoration(
          //           color: Colors.orange.shade300,
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         child: const Icon(
          //           Icons.remove,
          //           size: 18,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),

          //     const SizedBox(width: 10),

          //     Text(
          //       product.quantity.toString(),
          //       style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16,
          //       ),
          //     ),

          //     const SizedBox(width: 10),

          //     GestureDetector(
          //       onTap: () {
          //         provider.addToCart(product);
          //       },
          //       child: Container(
          //         width: 28,
          //         height: 28,
          //         decoration: BoxDecoration(
          //           color: Colors.orange,
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         child: const Icon(Icons.add, size: 18, color: Colors.white),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
