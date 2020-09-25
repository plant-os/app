import 'package:flutter/material.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'src/app.dart';

void main() {
  AuthService authService = AuthService();
  runApp(App(authService));
}
