import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/l10n/l10n.dart';
import 'package:recipe_swiper/providers/user_provider.dart';
import 'package:recipe_swiper/views/home_page.dart';
import 'package:recipe_swiper/views/widgets/carousel_slider_widget.dart';


import '../providers/localization_provider.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final localizationProvider = Provider.of<LocalizationProvider>(context);


    return Scaffold(
      body: Stack(
        children: [
          CarouselSliderWidget(),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: L10n.translate('email'),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: L10n.translate('password'),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    userProvider.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () async {
                        await userProvider.signUp(
                          context,
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (userProvider.errorMessage == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()),
                          );
                        }
                      },
                      child: Text(L10n.translate('register')!),
                    ),
                    SizedBox(height: 20),
                    userProvider.errorMessage != null
                        ? Text(userProvider.errorMessage!,
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(L10n.translate('back_to_login')!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

