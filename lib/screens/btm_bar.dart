import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:user_groceryapp/screens/categories.dart';
import 'package:user_groceryapp/screens/home_screen.dart';
import 'package:user_groceryapp/screens/user.dart';
import 'package:user_groceryapp/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/dark_theme_provider.dart';
import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'page': const HomeScreen(),
      'title': 'Home Screen',
    },
    {
      'page': CategoriesScreen(),
      'title': 'Categories Screen',
    },
    {
      'page': const CartScreen(),
      'title': 'Cart Screen',
    },
    {
      'page': const UserScreen(),
      'title': 'user Screen',
    },
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text( _pages[_selectedIndex]['title']),
      // ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark
            ? Theme.of(context).cardColor
            : const Color.fromARGB(187, 145, 145, 145),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: _isDark
            ? const Color.fromARGB(236, 195, 195, 195)
            : const Color.fromARGB(232, 27, 27, 27),
        selectedItemColor: _isDark
            ? Colors.lightBlue.shade200
            : const Color.fromARGB(180, 35, 29, 29),
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
              return badges.Badge(
                // toAnimate: true,
                // shape: BadgeShape.circle,
                // badgeColor: Colors.blue,
                // borderRadius: BorderRadius.circular(8),
                position: BadgePosition.topEnd(top: -7, end: -7),
                badgeContent: FittedBox(
                    child: TextWidget(
                        text: myCart.getCartItems.length.toString(),
                        color: Colors.white,
                        textSize: 15)),
                child: Icon(
                    _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
              );
            }),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
