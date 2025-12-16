// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:mini_e_commerce/model/Product.dart';
// import 'package:mini_e_commerce/provider/prodctprovider.dart';
// import 'package:mini_e_commerce/utils/ColorSelector.dart';
// import 'package:provider/provider.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   final int productId;

//   const ProductDetailsScreen({super.key, required this.productId});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   Product? product;
//   bool isLoading = true;

//   int quantity = 1;
//   int selectedColor = 0;
//   final List<Color> colors = [
//     Colors.black,
//     Colors.pink,
//     Colors.blue,
//     Colors.orange,
//     Colors.grey,
//   ];

//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 3, vsync: this);
//     fetchProductDetails();
//   }

//   Future<void> fetchProductDetails() async {
//     final url = "https://fakestoreapi.com/products/${widget.productId}";
//     try {
//       final response = await Dio().get(url);

//       if (response.statusCode == 200) {
//         setState(() {
//           product = Product.fromJson(response.data);
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (product == null) {
//       return const Scaffold(body: Center(child: Text("Error loading product")));
//     }

//     final provider = Provider.of<ProductProvider>(context);

//     return Scaffold(
//       extendBody: true,

//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 330,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(color: Color(0xfff5f5f5)),
//                   child: Center(
//                     child: Image.network(product!.image, height: 220),
//                   ),
//                 ),

//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   right: 10,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _circleIcon(Icons.arrow_back_ios_new, () {
//                         Navigator.pop(context);
//                       }),
//                       Row(
//                         children: [
//                           _circleIcon(Icons.favorite_border, () {}),
//                           const SizedBox(width: 10),
//                           _circleIcon(Icons.share, () {}),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               product!.title,
//                               maxLines: 2,
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 5),
//                       Text(
//                         "\$${product!.price}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           "Seller: ${product!.category}",
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.star,
//                                 color: Colors.orange,
//                                 size: 22,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "${product!.rate} ",
//                                 style: const TextStyle(fontSize: 15),
//                               ),
//                               Text(
//                                 "(${product!.count} Reviews)",
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 15),

//                       const Text(
//                         "Color",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       ColorSelector1(
//                         colors: colors,
//                         selectedIndex: selectedColor,
//                         onColorSelected: (index) {
//                           setState(() {
//                             selectedColor = index;
//                           });
//                         },
//                       ),

//                       const SizedBox(height: 20),

//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xfff6f6f6),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: TabBar(
//                           controller: tabController,
//                           indicator: BoxDecoration(
//                             color: Colors.orange,
//                             // borderRadius: BorderRadius.circular(30),
//                           ),
//                           labelStyle: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           unselectedLabelStyle: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           labelColor: Colors.white,
//                           unselectedLabelColor: Colors.black87,
//                           dividerColor: Colors.transparent,
//                           tabs: const [
//                             Tab(child: Text("Description")),
//                             Tab(child: Text("Specifications")),
//                             Tab(child: Text("Reviews")),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       SizedBox(
//                         height: 200,
//                         child: TabBarView(
//                           controller: tabController,
//                           children: [
//                             Text(
//                               product!.description,
//                               style: const TextStyle(fontSize: 15, height: 1.6),
//                             ),
//                             const Text(
//                               "• 40 Hours Battery\n• Noise Cancelling\n• Wireless Bluetooth\n• 1 Year Warranty",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "⭐ ${product!.rate} based on ${product!.count} reviews",
//                               style: const TextStyle(fontSize: 15),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Container(
//             height: 70,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(40),
//               // boxShadow: const [
//               //   BoxShadow(
//               //     color: Colors.black26,
//               //     blurRadius: 10,
//               //     offset: Offset(0, 5),
//               //   ),
//               // ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   height: 45,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         icon: const Icon(Icons.remove, color: Colors.white),
//                         onPressed: () {
//                           if (quantity > 1) {
//                             setState(() => quantity--);
//                           }
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         quantity.toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         icon: const Icon(Icons.add, color: Colors.white),
//                         onPressed: () {
//                           setState(() => quantity++);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: () {
//                       provider.addToCart(
//                         Product(
//                           id: product!.id,
//                           title: product!.title,
//                           price: product!.price,
//                           description: product!.description,
//                           category: product!.category,
//                           image: product!.image,
//                           rate: product!.rate,
//                           count: product!.count,
//                           quantity: quantity,
//                         ),
//                       );

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: const Text("Added to cart"),
//                           backgroundColor: Colors.green,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Add to Cart",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _circleIcon(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, size: 20, color: Colors.black),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mini_e_commerce/model/Product.dart';
import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:mini_e_commerce/utils/ColorSelector.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  Product? product;
  bool isLoading = true;

  int quantity = 1;
  int selectedColor = 0;
  final List<Color> colors = [
    Colors.black,
    Colors.pink,
    Colors.blue,
    Colors.orange,
    Colors.grey,
  ];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final url = "https://fakestoreapi.com/products/${widget.productId}";
    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        setState(() {
          product = Product.fromJson(response.data);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");

      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return const Scaffold(body: Center(child: Text("Error loading product")));
    }

    final provider = Provider.of<ProductProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfff5f5f5),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _circleIcon(Icons.arrow_back_ios_new, () {
            Navigator.pop(context);
          }),
        ),
        leadingWidth: 56,
        actions: [
          Row(
            children: [
              _circleIcon(Icons.favorite_border, () {}),
              const SizedBox(width: 10),
              _circleIcon(Icons.share, () {}),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 330,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xfff5f5f5),
                        ),
                        child: Center(
                          child: Image.network(product!.image, height: 220),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product!.title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "\$${product!.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Seller: ${product!.category}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 22,
                            ),
                            const SizedBox(width: 4),
                            Text("${product!.rate}"),
                            const SizedBox(width: 5),
                            Text(
                              "(${product!.count} Reviews)",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Color",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ColorSelector1(
                          colors: colors,
                          selectedIndex: selectedColor,
                          onColorSelected: (index) {
                            setState(() {
                              selectedColor = index;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xfff6f6f6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TabBar(
                            controller: tabController,
                            indicator: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),

                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(child: Text("Description")),
                              Tab(child: Text("Specifications")),
                              Tab(child: Text("Reviews")),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  product!.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  "• 40 Hours Battery\n• Noise Cancelling\n• Wireless Bluetooth\n• 1 Year Warranty",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "⭐ ${product!.rate} based on ${product!.count} reviews",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 10,
              left: 16,
              right: 16,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              setState(() => quantity++);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          provider.addToCart(
                            Product(
                              id: product!.id,
                              title: product!.title,
                              price: product!.price,
                              description: product!.description,
                              category: product!.category,
                              image: product!.image,
                              rate: product!.rate,
                              count: product!.count,
                              quantity: quantity,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Added to cart"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}
