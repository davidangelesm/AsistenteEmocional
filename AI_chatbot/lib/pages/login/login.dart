import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    // Asegurarse de que tengamos una instancia fresca del controlador
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>();
    }
    controller = Get.put(LoginController());
  }

  @override
  void dispose() {
    // Limpiar el controlador al salir de la página
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Text(
                  'Asistente Emocional',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 24),

                // Imagen circular debajo del título (sin sombra)
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // <-- Asegúrate que esté en tu carpeta assets
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 32),

                // Campo Email
                TextField(
                  controller: controller.txtUser,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo Contraseña
                TextField(
                  controller: controller.txtPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botón Ingresar + Mensaje reactivo
                Obx(() {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Ingresar'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.message.value,
                        style: TextStyle(
                          color: controller.messageColor.value,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'o continúa con',
                  style: TextStyle(
                    color: colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 12),

                // Botones “Google” y “Apple”
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.email),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_iphone),
                      label: const Text('Apple'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? '),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: Text(
                        'Regístrate',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
