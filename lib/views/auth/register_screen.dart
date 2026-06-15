import 'package:flutter/material.dart';
import 'package:profile_management/color/colors.dart';

import '../../model/auth_model.dart';
import '../../viewmodels/auth_vms.dart';
import '../../widgets/appbar.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/snackBar_messages.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController luckyNoController = TextEditingController();
  final AuthVms authVms = AuthVms();
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();

  bool _isObscure = true;
  bool isNotEmpty = false;
  bool isLoading = false;
  bool userExist = false;

  void checkIsEmpty() {
    if (userNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        luckyNoController.text.isEmpty) {
      setState(() {
        isNotEmpty = false;
      });
    } else {
      setState(() {
        isNotEmpty = true;
      });
    }
  }

  Future<dynamic> handleRegister() async {
    setState(() => isLoading = true);

    try {
      final checkData = await authVms.checkUserData(userNameController.text);

      // Adjust this logic based on your API response meaning
      final userExists = checkData != null;

      if (userExists) {
        userExist = true;
        //isLoading = false;
        snackBarMessenger.showSnackBar(
          context,
          'User Already Registered',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      }
      //await authVms.clearProfiles();
      await authVms.registerUserData(
        AuthModel(
          userName: userNameController.text,
          password: passwordController.text,
          luckyNo: int.parse(luckyNoController.text),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));

      snackBarMessenger.showSnackBar(
        context,
        'User Registered Successfully',
        Icons.check_circle,
        Colors.green,
        Colors.green[100]!,
      );
      userNameController.clear();
      passwordController.clear();
      luckyNoController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e.toString());
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
          title: 'USER REGISTRATION',
          pop: false,
          setting: false,
          drawer: false,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 14, right: 14, bottom: 0),
              child: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                constraints: BoxConstraints(maxWidth: 450, maxHeight: 550),
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
                      'REGISTER',
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
                    SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: primaryColor,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "What is your lucky number",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2),

                              Icon(
                                Icons.question_mark,
                                color: primaryColor,
                                size: 20,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          buildTextField(
                            controller: luckyNoController,
                            hint: 'Enter Lucky Number',
                            icon: Icons.numbers,
                            keyboardType: TextInputType.number,
                            isPassword: false,
                            onChanged: (value) {
                              setState(() {
                                luckyNoController.text = value;
                              });
                              checkIsEmpty();
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

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
                                await handleRegister();
                              }
                            : null,
                        child: isLoading
                            ? const CircleLoading()
                            : Text(
                                'REGISTER',
                                style: TextStyle(color: background),
                              ),
                      ),
                    ),

                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: text, fontSize: 16),
                          ),
                          Text(
                            'Login',
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
      obscureText: isPassword && _isObscure,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
