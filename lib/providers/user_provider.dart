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


  void _setMessage(BuildContext context, String message, MessageType type) {
    final color = _getMessageColor(type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }


  Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.success:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }


  Future<void> signIn(BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();


    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );


      if (response.user == null) {
        _errorMessage = 'Login failed';
        _setMessage(context, 'Login failed', MessageType.error);
      } else {
        _errorMessage = null;
        _setMessage(context, 'Login successful', MessageType.success);
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _setMessage(context, 'An error occurred. Please try again.', MessageType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> signUp(BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();


    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );


      if (response.user == null) {
        _errorMessage = 'Registration failed';
        _setMessage(context, 'Registration failed', MessageType.error);
      } else {
        _errorMessage = null;
        _setMessage(context, 'Registration successful, please check your inbox to verify your mail', MessageType.success);
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _setMessage(context, 'An error occurred. Please try again.', MessageType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> signOut(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await supabaseClient.auth.signOut();
      _setMessage(context, 'Signed out successfully', MessageType.success);
    } catch (e) {
      _setMessage(context, 'Error signing out: $e', MessageType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

