import 'package:flutter/material.dart';
import 'package:mini_e_commerce/ui/CartScreen.dart';
import 'package:mini_e_commerce/ui/HOME/home_Sceeen.dart';
import 'package:mini_e_commerce/ui/productSereenDetaies.dart';

class Dashborad extends StatefulWidget {
  const Dashborad({super.key});

  @override
  State<Dashborad> createState() => _DashboradState();
}

class _DashboradState extends State<Dashborad> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    Center(child: Text("Home")),
    Center(child: Text("Cart")),
    Center(child: Text("WishList")),
    Center(child: Text("Profile")),
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    HomeSceeen(),
    CartScreen(),
    ProductDetailsScreen(productId: 14),

    Text('Settings Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: List.generate(_widgetOptions.length, (index) {
          IconData iconData;
          switch (index) {
            case 0:
              iconData = Icons.home_outlined;
              break;
            case 1:
              iconData = Icons.shopping_cart;
              break;
            case 2:
              iconData = Icons.favorite_border;
              break;
            case 3:
              iconData = Icons.settings;
              break;
            default:
              iconData = Icons.home_outlined;
          }

          bool isSelected = _selectedIndex == index;
          return BottomNavigationBarItem(
            label: '.',
            icon: Container(
              padding: EdgeInsets.all(isSelected ? 8 : 0),
              child: Icon(
                iconData,
                size: 28,
                color: isSelected ? Colors.orangeAccent : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }
}
