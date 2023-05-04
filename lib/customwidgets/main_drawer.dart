import 'package:flutter/material.dart';

import '../auth/authservice.dart';
import '../pages/launcher_page.dart';
import '../pages/login_page.dart';
import '../pages/order_page.dart';
import '../pages/user_profile_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: 150,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, OrderPage.routeName);
            },
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          /*ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('Login/Register'),
          ),*/
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
