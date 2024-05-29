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
        Provider.of<RecipeProvider>(context, listen: false).searchRecipes(query);
      } else {
        Provider.of<RecipeProvider>(context, listen: false).clearSearchResults();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
        backgroundColor: Colors.red.shade400,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: recipeProvider.isSearchLoading
                ? Center(child: CircularProgressIndicator())
                : recipeProvider.searchResults.isEmpty
                ? Center(
              child: Text(
                'No recipes found. Try a different search.',
                style: TextStyle(fontSize: 18),
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

