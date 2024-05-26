import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../views/widgets/message_banner.dart';


class UserProvider with ChangeNotifier {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  bool _isLoading = false;
  String? _errorMessage;
  String? _message;
  MessageType? _messageType;




  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get message => _message;
  MessageType? get messageType => _messageType;


  void _setMessage(String message, MessageType type) {
    _message = message;
    _messageType = type;
    notifyListeners();
  }


  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();


    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );


      if (response.user == null) {
        _errorMessage = 'Login failed';
        _setMessage('Login failed', MessageType.error);
      } else {
        _errorMessage = null;
        _setMessage('Login successful', MessageType.success);
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _setMessage('An error occurred. Please try again.', MessageType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();


    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );


      if (response.user == null) {
        _errorMessage = 'Registration failed';
        _setMessage('Registration failed', MessageType.error);
      } else {
        _errorMessage = null;
        _setMessage('Registration successful, please check your inbox to verify your mail', MessageType.success);
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _setMessage('An error occurred. Please try again.', MessageType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await supabaseClient.auth.signOut();
      _setMessage('Signed out successfully', MessageType.success);
    } catch (e) {
      _setMessage('Error signing out: $e', MessageType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clearMessage() {
    _message = null;
    _messageType = null;
    notifyListeners();
  }
}

