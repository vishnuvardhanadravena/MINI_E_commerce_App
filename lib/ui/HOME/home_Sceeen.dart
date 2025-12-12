import 'package:flutter/material.dart';
import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:mini_e_commerce/ui/HOME/ProductCardWidget.dart';
import 'package:mini_e_commerce/ui/productSereenDetaies.dart';
import 'package:mini_e_commerce/utils/catagireyTabBar.dart';
import 'package:mini_e_commerce/utils/search_bar.dart';
import 'package:mini_e_commerce/utils/slider_bar.dart';
import 'package:provider/provider.dart';

class HomeSceeen extends StatefulWidget {
  const HomeSceeen({super.key});

  @override
  State<HomeSceeen> createState() => _HomeSceeenState();
}

class _HomeSceeenState extends State<HomeSceeen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final logs = [
      "https://cdn-icons-png.flaticon.com/128/281/281764.png",
      "https://cdn-icons-png.flaticon.com/128/731/731985.png",
      "https://cdn-icons-png.flaticon.com/128/145/145802.png",
      "https://cdn-icons-png.flaticon.com/128/4055/4055978.png",
      "https://cdn-icons-png.flaticon.com/128/10087/10087824.png",
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_sharp, color: Colors.grey, size: 22),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications, color: Colors.grey, size: 22),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prov, child) {
          if (prov.isLoading && prov.categories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SearchBarWidget(
                  controller: TextEditingController(),
                  onFilterTap: () {},
                ),
                const SizedBox(height: 30),

                BannerSliderWidget(banners: logs),

                const SizedBox(height: 30),

                CategoryTabBarWidget(
                  categories: prov.categories,
                  selectedIndex: selectedIndex,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });

                    final cat = prov.categories[index]["label"];
                    prov.fetchProductsByCategory(cat);
                  },
                ),

                const SizedBox(height: 10),

                prov.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: prov.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                        itemBuilder: (context, index) {
                          final product = prov.products[index];
                          return ProductCardWidget(
                            product: product,
                            onTap: (p) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsScreen(productId: p.id),
                                ),
                              );
                            },
                            onFavorite: () {},
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
