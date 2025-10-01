import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/expedientes/presentation/pages/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/expedientes/presentation/pages/expedientes_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hcxvglblspdiewfgzpgh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjeHZnbGJsc3BkaWV3Zmd6cGdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1ODkyMzAsImV4cCI6MjA3MDE2NTIzMH0.N3_Rz630JtmXrTmiOZ2xMWGq0SP6mvo3Z68OkoAZ24M',
    debug: true,
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mercosur App',
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/expedientes': (_) => const ExpedientesPage(),
      },
    );
  }
}
