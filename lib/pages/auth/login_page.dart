import 'package:flutter/material.dart';
import 'package:rosantibike_mobile/api/auth_api,dart';
import 'package:rosantibike_mobile/screen/main_screen.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final AuthApi _authApi = AuthApi();

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authApi.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response['success'] == true) {
        print('Login successful!');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        print('Login failed: ${response['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response['message']}')),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16.0),
                _CustomTextField(
                  controller: _usernameController,
                  label: 'Username',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 1) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _CustomButton(
                        onPressed: () => _login(context),
                        text: 'Login',
                      ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Don’t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const _CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
    );
  }
}
