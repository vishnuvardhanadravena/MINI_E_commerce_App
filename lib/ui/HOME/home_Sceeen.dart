import 'package:flutter/material.dart';
import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:mini_e_commerce/ui/CartScreen.dart';
import 'package:mini_e_commerce/ui/HOME/ProductCardWidget.dart';
import 'package:mini_e_commerce/ui/SearchResultScreen.dart';
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
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = [
      "https://cdn-icons-png.flaticon.com/128/281/281764.png",
      "https://cdn-icons-png.flaticon.com/128/731/731985.png",
      "https://cdn-icons-png.flaticon.com/128/145/145802.png",
    ];

    final List<Color> colors = [
      Colors.pink,
      Colors.blue,
      Colors.orange,
      Colors.grey,
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                "Mini E-Commerce",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Cart"),
              onTap: () {
                Navigator.pop(context); // close drawer

                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Wishlist"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.grey),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications, color: Colors.grey),
          ),
        ],
      ),

      body: Consumer<ProductProvider>(
        builder: (context, prov, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarWidget(
                  controller: searchController,
                  onChanged: (value) {
                    prov.search(value);
                  },
                  onFilterTap: () {},
                ),

                if (prov.searchedCategories.isNotEmpty ||
                    prov.searchedProducts.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      children: [
                        ...prov.searchedCategories.map(
                          (cat) => ListTile(
                            leading: const Icon(
                              Icons.category,
                              color: Colors.orange,
                            ),
                            title: Text(cat["label"]),
                            onTap: () async {
                              searchController.clear();
                              prov.clearSearch();

                              // await prov.fetchProductsByCategory(cat["label"]);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => ProductProvider()
                                      ..fetchProductsByCategory(cat["label"]),
                                    child: SearchResultScreen(
                                      title: cat["label"],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        ...prov.searchedProducts.map(
                          (p) => ListTile(
                            leading: const Icon(
                              Icons.shopping_bag,
                              color: Colors.blue,
                            ),
                            title: Text(p.title),
                            onTap: () async {
                              searchController.clear();
                              prov.clearSearch();

                              // await prov.fetchProductsByCategory(p.category);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) =>
                                        ProductProvider()
                                          ..fetchProductsByCategory(p.category),
                                    child: SearchResultScreen(
                                      title: p.category,
                                      selectedProduct: p,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                BannerSliderWidget(banners: banners),

                const SizedBox(height: 20),

                CategoryTabBarWidget(
                  categories: prov.categories,
                  selectedIndex: selectedIndex,
                  onTap: (index) {
                    setState(() => selectedIndex = index);
                    prov.fetchProductsByCategory(
                      prov.categories[index]["label"],
                    );
                  },
                ),

                const SizedBox(height: 10),

                prov.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
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
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                        itemBuilder: (context, index) {
                          final product = prov.products[index];
                          return ProductCardWidget(
                            product: product,
                            colors: colors,
                            selectedColor: 0,
                            onTapcolors: (_) {},
                            onFavorite: () {},
                            onTap: (p) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsScreen(productId: p.id),
                                ),
                              );
                            },
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
