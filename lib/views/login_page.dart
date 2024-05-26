import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/user_provider.dart';
import 'package:recipe_swiper/views/register_page.dart';
import 'package:recipe_swiper/views/home_page.dart';
import 'package:recipe_swiper/views/widgets/carousel_slider_widget.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);


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
                        labelText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                        await userProvider.signIn(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (userProvider.errorMessage == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    userProvider.errorMessage != null
                        ? Text(userProvider.errorMessage!, style: TextStyle(color: Colors.red))
                        : Container(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text('Register'),
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

