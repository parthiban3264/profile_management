import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_management/model/profile_model.dart';
import 'package:profile_management/viewmodels/profile_vms.dart';

import '../../color/colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/snackBar_messages.dart';
import '../../widgets/textField.dart';
import '../home/home_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final bool isEdit;
  final ProfileModel? profile;
  const CreateProfileScreen({super.key, required this.isEdit, this.profile});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool isLoggedIn = false;
  bool isNotEmpty = false;
  bool isLoading = false;
  bool userExist = false;

  final ImagePicker picker = ImagePicker();
  final ProfileVms profileVms = ProfileVms();
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();
  File? imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.profile != null) {
      fullNameController.text = widget.profile!.name;
      ageController.text = widget.profile!.age.toString();
      emailController.text = widget.profile!.email;
      phoneController.text = widget.profile!.phone;
      occupationController.text = widget.profile!.occupation;
      locationController.text = widget.profile!.location;
      aboutMeController.text = widget.profile!.aboutMe;
      genderController.text = widget.profile!.gender;
      imageFile = File(widget.profile!.profileImage);
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  Future<void> pickFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        checkIsEmpty();
      });
    }
  }

  void showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: () {
                pickFromGallery();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () {
                pickFromCamera();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pickFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        checkIsEmpty();
      });
    }
  }

  void checkIsEmpty() {
    if (fullNameController.text.isEmpty ||
        ageController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        occupationController.text.isEmpty ||
        locationController.text.isEmpty ||
        aboutMeController.text.isEmpty ||
        genderController.text.isEmpty ||
        imageFile == null) {
      setState(() {
        isNotEmpty = false;
      });
    } else {
      setState(() {
        isNotEmpty = true;
      });
    }
  }

  Future<void> handleCreateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (!isValidPhone(phoneController.text.trim())) {
        snackBarMessenger.showSnackBar(
          context,
          'Enter valid 10-digit phone number',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      }

      if (!isValidEmail(emailController.text.trim())) {
        snackBarMessenger.showSnackBar(
          context,
          'Enter valid email address',
          Icons.error,
          Colors.red,
          Colors.red[100]!,
        );
        return;
      }
      final id = await profileVms.getNextId();
      final profile = ProfileModel(
        id: id,
        name: fullNameController.text.trim(),
        age: int.tryParse(ageController.text) ?? 0,
        gender: genderController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        occupation: occupationController.text.trim(),
        location: locationController.text.trim(),
        aboutMe: aboutMeController.text.trim(),
        profileImage: imageFile?.path ?? '',
      );
      await Future.delayed(const Duration(seconds: 3));
      await profileVms.addProfile(profile);

      snackBarMessenger.showSnackBar(
        context,
        'Profile Created Successfully',
        Icons.check_circle,
        Colors.green,
        Colors.green[100]!,
      );

      fullNameController.clear();
      ageController.clear();
      phoneController.clear();
      emailController.clear();
      occupationController.clear();
      passwordController.clear();
      locationController.clear();
      aboutMeController.clear();
      genderController.clear();
      imageFile = null;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
      setState(() {
        isLoading = false;
        isNotEmpty = false;
      });
    }
  }

  Future<void> handleUpdateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final updatedProfile = ProfileModel(
        id: widget.profile!.id,
        name: fullNameController.text.trim(),
        age: int.parse(ageController.text.trim()),
        gender: genderController.text.trim(),
        email: emailController.text.trim(),
        occupation: occupationController.text.trim(),
        location: locationController.text.trim(),
        aboutMe: aboutMeController.text.trim(),
        phone: phoneController.text.trim(),
        profileImage: imageFile?.path ?? widget.profile!.profileImage,
        favorite: widget.profile!.favorite,
      );

      await profileVms.updateProfile(updatedProfile);

      if (!mounted) return;

      snackBarMessenger.showSnackBar(
        context,
        'Profile Updated Successfully',
        Icons.check_circle,
        Colors.green,
        Colors.green[100]!,
      );
      fullNameController.clear();
      ageController.clear();
      phoneController.clear();
      emailController.clear();
      occupationController.clear();
      passwordController.clear();
      locationController.clear();
      aboutMeController.clear();
      genderController.clear();
      imageFile = null;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
      setState(() {
        isLoading = false;
        isNotEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          title: 'Create Profile',
          pop: true,
          setting: true,
          drawer: false,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 450, minHeight: 600),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showPickerOptions();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.2,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: 50,
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile!)
                                : null,
                            child: imageFile == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: primaryColor,
                                  )
                                : null,
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: buildTextField(
                          controller: fullNameController,
                          hint: 'Full Name',
                          icon: Icons.person,
                          keyboardType: TextInputType.name,
                          isPassword: false,
                          onChanged: (value) {
                            setState(() {
                              fullNameController.text = value;
                            });
                            checkIsEmpty();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          controller: ageController,
                          hint: 'Age',
                          icon: Icons.calendar_month,
                          keyboardType: TextInputType.number,
                          isPassword: false,
                          onChanged: (value) {
                            setState(() {
                              ageController.text = value;
                            });
                            checkIsEmpty();
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: genderController.text.isEmpty
                              ? null
                              : genderController.text,
                          decoration: InputDecoration(
                            hintText: 'Gender',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: const Icon(Icons.male),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              genderController.text = value!;
                            });
                            checkIsEmpty();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  buildTextField(
                    controller: phoneController,
                    hint: 'Phone',
                    icon: Icons.phone,
                    isPassword: false,
                    keyboardType: TextInputType.number,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                      });
                      checkIsEmpty();
                    },
                  ),
                  SizedBox(height: 12),

                  buildTextField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    isPassword: false,
                    onChanged: (value) {
                      setState(() {
                        emailController.text = value;
                      });
                      checkIsEmpty();
                    },
                  ),
                  SizedBox(height: 12),

                  buildTextField(
                    controller: occupationController,
                    hint: 'Occupation',
                    icon: Icons.work,
                    isPassword: false,
                    onChanged: (value) {
                      setState(() {
                        occupationController.text = value;
                      });
                      checkIsEmpty();
                    },
                  ),
                  SizedBox(height: 12),

                  buildTextField(
                    controller: locationController,
                    hint: 'Location',
                    icon: Icons.location_on,
                    isPassword: false,
                    onChanged: (value) {
                      setState(() {
                        locationController.text = value;
                      });
                      checkIsEmpty();
                    },
                  ),
                  SizedBox(height: 12),
                  buildTextField(
                    controller: aboutMeController,
                    hint: 'About Me',
                    icon: Icons.lock,
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    maxLines: 2,
                    onChanged: (value) {
                      setState(() {
                        aboutMeController.text = value;
                      });
                      checkIsEmpty();
                    },
                  ),
                  SizedBox(height: 12),
                  const SizedBox(height: 14),

                  SizedBox(
                    width: 200,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      //onPressed: isNotEmpty ? handleCreateProfile : null,
                      onPressed: isNotEmpty
                          ? (widget.isEdit
                                ? handleUpdateProfile
                                : handleCreateProfile)
                          : null,

                      child: isLoading
                          ? const CircleLoading()
                          : Text(
                              'Create Profile',
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
    );
  }
}
