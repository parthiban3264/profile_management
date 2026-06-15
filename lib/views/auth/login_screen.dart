import 'package:flutter/material.dart';
import 'package:profile_management/views/auth/register_screen.dart';

import '../../color/colors.dart';
import '../../model/auth_model.dart';
import '../../services/session_service.dart';
import '../../viewmodels/auth_vms.dart';
import '../../widgets/appbar.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/snackBar_messages.dart';
import '../home/home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthVms authVms = AuthVms();
  final session = SessionService();
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();

  bool _isObscure = true;
  bool isNotEmpty = false;
  bool isLoading = false;
  bool userExist = false;

  void checkIsEmpty() {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        isNotEmpty = false;
      });
    } else {
      setState(() {
        isNotEmpty = true;
      });
    }
  }

  Future<dynamic> handleLogin() async {
    setState(() => isLoading = true);

    try {
      final data = await authVms.checkUserData(userNameController.text);
      session.saveSession(userNameController.text);
      await Future.delayed(const Duration(seconds: 2));
      // Adjust this logic based on your API response meaning
      final userExists = data == null || data.isEmpty;
      if (userExists) {
        userExist = true;
        //isLoading = false;
        snackBarMessenger.showSnackBar(
          context,
          'Invalid Credentials',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      } else if (data['password'] != passwordController.text) {
        session.saveSession(userNameController.text);
        userExist = true;
        //isLoading = false;
        snackBarMessenger.showSnackBar(
          context,
          'Invalid Password',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      } else {
        snackBarMessenger.showSnackBar(
          context,
          'User Login Successfully',
          Icons.check_circle,
          Colors.green,
          Colors.green[100]!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }

      userNameController.clear();
      passwordController.clear();
    } catch (e) {
      snackBarMessenger.showSnackBar(
        context,
        e.toString(),
        Icons.error,
        Colors.red,
        Colors.red[100]!,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: CustomAppbar(
          title: 'USER LOGIN',
          pop: false,
          setting: false,
          drawer: false,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 30),
              child: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                constraints: BoxConstraints(maxWidth: 450, maxHeight: 450),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 24),

                    buildTextField(
                      controller: userNameController,
                      hint: 'User Name',
                      icon: Icons.person,
                      isPassword: false,
                      onChanged: (value) {
                        setState(() {
                          userNameController.text = value;
                          userExist = false;
                        });
                        checkIsEmpty();
                      },
                    ),

                    SizedBox(height: 16),
                    buildTextField(
                      controller: passwordController,
                      hint: 'password',
                      icon: Icons.person,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          passwordController.text = value;
                          userExist = false;
                        });
                        checkIsEmpty();
                      },
                    ),

                    SizedBox(height: 18),

                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: isNotEmpty && !userExist && !isLoading
                            ? () async {
                                await handleLogin();
                              }
                            : null,
                        child: isLoading
                            ? const CircleLoading()
                            : Text(
                                'LOGIN',
                                style: TextStyle(color: background),
                              ),
                      ),
                    ),

                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create an account? ',
                            style: TextStyle(color: text, fontSize: 16),
                          ),
                          Text(
                            'Register',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isPassword = false,
    void Function()? onTap,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 16),
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon: suffixIcon,

        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      obscureText: isPassword ? _isObscure : false,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
