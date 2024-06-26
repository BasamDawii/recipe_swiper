import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/l10n/l10n.dart';
import 'package:recipe_swiper/providers/localization_provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/providers/user_provider.dart';
import 'package:recipe_swiper/services/supabase_service.dart';
import 'package:recipe_swiper/views/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().initialize();
  await L10n.load('en');
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, child) {
          return MaterialApp(
            title: 'Food Recipe',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.white,
              textTheme: TextTheme(
                titleMedium: TextStyle(color: Colors.white),
              ),
            ),
            home: LoginPage(),
          );
        },
      ),
    );
  }
}

