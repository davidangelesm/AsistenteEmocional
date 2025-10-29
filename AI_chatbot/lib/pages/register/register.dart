import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController controller = Get.put(RegisterController());

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

                // Logo circular (igual que en Login)
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // Asegúrate que esté en assets
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 24),

                // Título de bienvenida
                Text(
                  'BIENVENIDO A Asistente Emocional',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo Email
                TextField(
                  controller: controller.txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo Nombre
                TextField(
                  controller: controller.txtName,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
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

                // Botón Registrar + mensaje reactivo
                Obx(() {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
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
                            : const Text('Registrar'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.message.value,
                        style: TextStyle(
                          color: controller.messageColor.value,
                          fontSize: 14,
                        ),
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

                // Botones “Google” y “Apple” (placeholder)
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
                    const Text('¿Ya tienes cuenta? '),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Inicia sesión',
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
