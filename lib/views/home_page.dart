import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/would_you_rather_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Would You Rather - Food Edition'),
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
