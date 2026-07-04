import 'package:barcode_scanner/models/cart_item_model.dart';
import 'package:barcode_scanner/models/product_model.dart';
import 'package:barcode_scanner/models/sales_model.dart';
import 'package:barcode_scanner/screens/auth/forgot_view.dart';
import 'package:barcode_scanner/screens/auth/login_view.dart';
import 'package:barcode_scanner/screens/auth/register_view.dart';
import 'package:barcode_scanner/screens/home/home_view.dart';
import 'package:barcode_scanner/screens/multi_scan/multi_scan_view.dart';
import 'package:barcode_scanner/screens/profile/profile_view.dart';
import 'package:barcode_scanner/screens/single_scan/single_scan_view.dart';
import 'package:barcode_scanner/screens/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(SalesModelAdapter());

  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<CartItemModel>('cart');
  await Hive.openBox<SalesModel>('sales');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Barcode Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashView()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(name: '/register', page: () => ForgotView()),
        GetPage(name: '/register', page: () => ProfileView()),
        GetPage(name: '/home', page: () => HomeView()),

        GetPage(name: '/single scan', page: () => SingleScanView()),
        GetPage(name: '/multi scan', page: () => MultiScanView()),
      ],
    );
  }
}
