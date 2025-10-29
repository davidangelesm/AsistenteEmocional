// lib/middleware/auth_middleware.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = AuthService();

  @override
  RouteSettings? redirect(String? route) {
    // Rutas que no requieren autenticación
    final publicRoutes = ['/login', '/register'];

    if (publicRoutes.contains(route)) {
      return null; // Permitir acceso
    }

    // Verificar autenticación de forma asíncrona
    _checkAuthAsync(route);
    return null; // Permitir temporalmente mientras se verifica
  }

  void _checkAuthAsync(String? route) async {
    final isLoggedIn = await _authService.isLoggedIn();

    if (!isLoggedIn) {
      Get.offAllNamed('/login');
    }
  }
}

class AuthChecker extends GetxController {
  final AuthService _authService = AuthService();
  RxBool isAuthenticated = false.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;

    try {
      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        // Verificar que el token siga siendo válido
        final response = await _authService.verifyToken();
        isAuthenticated.value = response.success;

        if (!response.success) {
          // Token inválido, hacer logout
          await _authService.logout();
        }
      } else {
        isAuthenticated.value = false;
      }
    } catch (e) {
      print('Error verificando autenticación: $e');
      isAuthenticated.value = false;
      await _authService.logout();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }
}
