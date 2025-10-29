// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart'; // Import de GetX

// Importa tu archivo de tema y utilitarios
import './configs/app_theme.dart';
import './services/api_service.dart';
import './services/theme_service.dart';

// Importa todas tus páginas
import './pages/register/register.dart';
import './pages/login/login.dart';
import './pages/preferences/preferences_page.dart';
import './pages/preferences/preferences_binding.dart';
import './pages/theme_settings/theme_settings_binding.dart';
import './pages/ai_config/ai_config_page.dart';
import './pages/ai_config/ai_config_binding.dart';
import './pages/History/HistoryPage.dart';
import './pages/evaluation/evaluation.dart';
import './pages/Chat/chat_page.dart';
import './pages/profile/profile_page.dart';
import './pages/change_password/change_password_page.dart';
import './pages/theme_settings/theme_settings_page.dart';
import './pages/compartir/compartir.dart';
import './pages/privacidad/privacy_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios
  ApiService().initialize();
  await Get.putAsync(() => ThemeService().onInit().then((_) => ThemeService()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Asistente Emocional',

        // ─── Temas ───────────────────────────────────────────────────────────────
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeService.themeMode,

        // ─── Localización ────────────────────────────────────────────────────────
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
        locale: const Locale('es', 'ES'),

        // ─── Ruta inicial ─────────────────────────────────────────────────────────
        initialRoute: '/login',

        // ─── Definición de rutas usando GetPage ─────────────────────────────────
        getPages: [
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/register', page: () => const RegisterPage()),
          GetPage(
            name: '/preferences',
            page: () => const PreferencesPage(),
            binding: PreferencesBinding(),
          ),
          GetPage(name: '/history', page: () => const HistoryPage()),
          GetPage(name: '/chat', page: () => const ChatPage()),
          GetPage(name: '/profile', page: () => const ProfilePage()),
          GetPage(
            name: '/change-password',
            page: () => const ChangePasswordPage(),
          ),
          GetPage(
            name: '/theme-settings',
            page: () => const ThemeSettingsPage(),
            binding: ThemeSettingsBinding(),
          ),
          GetPage(name: '/evaluation', page: () => const EvaluationPage()),
          GetPage(name: '/compartir', page: () => const CompartirPage()),
          GetPage(
            name: '/configuracionAI',
            page: () => const AIConfigPage(),
            binding: AIConfigBinding(),
          ),
          GetPage(name: '/privacidad', page: () => const PrivacyPage()),
        ],
      ),
    );
  }
}
