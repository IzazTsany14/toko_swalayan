import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_swalayan/services/database_service.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'constants/app_colors.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Toko Swalayan',
            debugShowCheckedModeBanner: false,
            theme: AppColors.getLightTheme(),
            darkTheme: AppColors.getDarkTheme(),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const SplashScreen(),
            routes: {
              '/main': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}