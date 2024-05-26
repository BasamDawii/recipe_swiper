import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:url_launcher/url_launcher.dart';


class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;


  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);


  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(recipe.imageUrl),
            SizedBox(height: 16),
            Text(
              recipe.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Rating: ${recipe.rating}'),
            SizedBox(height: 8),
            Text('Total Time: ${recipe.totalTime}'),
            SizedBox(height: 16),
            Text(
              'Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(recipe.instructions),
            SizedBox(height: 16),
            if (recipe.youtubeUrl.isNotEmpty)
              TextButton(
                onPressed: () {
                  _launchURL(recipe.youtubeUrl);
                },
                child: Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}

