import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseService {
  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://cidnfgzxyepantcvghmx.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNpZG5mZ3p4eWVwYW50Y3ZnaG14Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY1NDczMzksImV4cCI6MjAzMjEyMzMzOX0.Ot1e2Q9DjtRetEKuqE1Ke17jCnfPmMIFkEtkqhk-BZk',
    );
  }
}

