import 'package:flutter/material.dart';

import '../../color/colors.dart';
import '../../model/auth_model.dart';
import '../../viewmodels/auth_vms.dart';
import '../../widgets/appbar.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/snackBar_messages.dart';
import '../../widgets/textField.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController luckyNoController = TextEditingController();
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();
  final AuthVms authVms = AuthVms();

  bool isNotEmpty = false;
  bool isLoading = false;
  bool userExist = false;
  bool _isObscure = true;

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

  Future<void> handleReset() async {
    setState(() => isLoading = true);

    try {
      final user = await authVms.checkUserData(userNameController.text.trim());

      if (user == null) {
        snackBarMessenger.showSnackBar(
          context,
          'User not found',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      }
      print('lukky : ${user['luckyNo']}');
      if (user['luckyNo'] != int.parse(luckyNoController.text)) {
        snackBarMessenger.showSnackBar(
          context,
          'Lucky number is incorrect',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      }

      await authVms.updateProfile(
        AuthModel(
          userName: user['userName'],
          password: passwordController.text.trim(),
          luckyNo: user['luckyNo'],
        ),
      );

      snackBarMessenger.showSnackBar(
        context,
        'Password reset successfully',
        Icons.check_circle,
        Colors.green,
        Colors.green[100]!,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
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
          title: 'Forgot Password',
          pop: true,
          setting: false,
          drawer: false,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                constraints: BoxConstraints(maxWidth: 450, maxHeight: 500),
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
                      'Reset Password',
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
                      keyboardType: TextInputType.text,
                      isPassword: false,
                      onChanged: (value) {},
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
                              //checkIsEmpty();
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    buildTextField(
                      controller: passwordController,
                      hint: 'New Password',
                      icon: Icons.person,
                      isPassword: true,
                      isObscure: _isObscure,
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
                    const SizedBox(height: 20),

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
                                await handleReset();
                              }
                            : null,
                        child: isLoading
                            ? const CircleLoading()
                            : Text(
                                'RESET',
                                style: TextStyle(color: background),
                              ),
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
}
