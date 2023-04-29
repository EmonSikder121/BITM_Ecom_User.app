import 'package:ecom_user_pb_bitm/providers/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/order_successful_page.dart';
import 'pages/product_details_page.dart';
import 'pages/promo_code_page.dart';
import 'pages/user_profile_page.dart';
import 'pages/view_product_page.dart';
import 'providers/notification_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18)
        ),
        textTheme: GoogleFonts.josefinSansTextTheme(),
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        CartPage.routeName: (_) => const CartPage(),
        PromoCodePage.routeName: (_) => const PromoCodePage(),
        OrderSuccessfulPage.routeName: (_) => const OrderSuccessfulPage(),
        UserProfilePage.routeName: (_) => const UserProfilePage(),
        CheckoutPage.routeName: (_) => const CheckoutPage(),
      },
    );
  }
}

