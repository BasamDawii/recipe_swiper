import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/search_page.dart';
import 'package:recipe_swiper/views/favorites_page.dart';
import 'package:recipe_swiper/views/widgets/swipe_recipe_widget.dart';
import 'package:recipe_swiper/views/login_page.dart';


import '../l10n/l10n.dart';
import '../providers/localization_provider.dart';
import '../providers/user_provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipeProvider>(context, listen: false).init(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Expanded(
              child: Consumer<LocalizationProvider>(
                builder: (context, localizationProvider, child) {
                  return Text(
                    L10n.translate('title')!,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await userProvider.signOut(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SwipeRecipeWidget(),
            ),
          ],
        ),
      ),
    );
  }


  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  Provider.of<LocalizationProvider>(context, listen: false)
                      .setLocale('en')
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text('العربية'),
                onTap: () {
                  Provider.of<LocalizationProvider>(context, listen: false)
                      .setLocale('ar')
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text('Dansk'),
                onTap: () {
                  Provider.of<LocalizationProvider>(context, listen: false)
                      .setLocale('da')
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

