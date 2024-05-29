import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/recipe_card.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      if (query.isNotEmpty) {
        Provider.of<RecipeProvider>(context, listen: false)
            .searchRecipes(query);
      } else {
        Provider.of<RecipeProvider>(context, listen: false)
            .clearSearchResults();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Recipes',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: Color(0xFF657990),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Color(0xFF34495E)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF34495E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF16A085)),
                ),
                suffixIcon: Icon(Icons.search, color: Color(0xFF34495E)),
              ),
              style: TextStyle(color: Color(0xFF34495E)),
            ),
          ),
          Expanded(
            child: recipeProvider.isSearchLoading
                ? Center(child: CircularProgressIndicator())
                : recipeProvider.searchResults.isEmpty
                ? Center(
              child: Text(
                'No recipes found. Try a different search.',
                style: TextStyle(fontSize: 18, color: Color(0xFF34495E)),
              ),
            )
                : ListView.builder(
              itemCount: recipeProvider.searchResults.length,
              itemBuilder: (context, index) {
                final recipe = recipeProvider.searchResults[index];
                return RecipeCard(
                  title: recipe.name,
                  cookTime: recipe.totalTime,
                  rating: recipe.rating.toString(),
                  thumbnailUrl: recipe.imageUrl,
                  recipe: recipe,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
