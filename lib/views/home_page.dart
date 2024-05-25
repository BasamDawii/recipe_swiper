import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/would_you_rather_widget.dart';
import 'package:recipe_swiper/views/favorites_page.dart';


import '../providers/user_provider.dart';
import 'login_page.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Would You Rather - Food Edition'),
        actions: [
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
            icon: Icon(Icons.logout),
            onPressed: () async {
              await userProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }


          if (recipeProvider.currentOptionA == null || recipeProvider.currentOptionB == null) {
            return const Center(child: Text('No more recipes!'));
          }


          return WouldYouRatherWidget(
            optionA: recipeProvider.currentOptionA!,
            optionB: recipeProvider.currentOptionB!,
            onOptionSelected: recipeProvider.handleOptionSelected,
          );
        },
      ),
    );
  }
}



