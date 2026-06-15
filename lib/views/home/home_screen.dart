import 'dart:io';

import 'package:flutter/material.dart';
import 'package:profile_management/color/colors.dart';
import 'package:profile_management/viewmodels/profile_vms.dart';
import 'package:profile_management/widgets/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/appbar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/snackBar_messages.dart';
import '../profile/create_profile_screen.dart';
import '../profile/manage_profile_screen.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileVms profileVms = ProfileVms();
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool isFavorite = false;
  late List profiles = [];
  List<dynamic> filteredProfiles = [];
  List<dynamic> favoriteProfiles = [];
  String username = 'user';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
  }

  Future<void> getProfiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      setState(() {
        username = userName!;
      });

      await Future.delayed(const Duration(seconds: 1));
      await profileVms.getProfiles();

      setState(() {
        profiles = profileVms.profiles;
        filteredProfiles = profiles;
        favoriteProfiles.clear(); // ✅ clear old data

        for (var profile in profiles) {
          if (profile.favorite == true) {
            favoriteProfiles.add(profile);
          }
        }
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProfile(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProfiles = profiles;
      });
      return;
    }

    setState(() {
      filteredProfiles = profiles.where((profile) {
        return profile.name.toLowerCase().contains(query.toLowerCase()) ||
            profile.email.toLowerCase().contains(query.toLowerCase()) ||
            profile.phone.toLowerCase().contains(query.toLowerCase()) ||
            profile.gender.toLowerCase().contains(query.toLowerCase()) ||
            profile.location.toLowerCase().contains(query.toLowerCase()) ||
            profile.occupation.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // void filterProfiles(bool query) {
  //   if (query == true) {
  //     setState(() {
  //       filteredProfiles.clear();
  //       filteredProfiles = favoriteProfiles;
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       filteredProfiles.clear();
  //       filteredProfiles = profiles;
  //     });
  //   }
  // }

  Future<String?> showFilterDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              "Filter Profiles",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _filterCard(
                context,
                icon: Icons.favorite,
                color: Colors.red,
                label: "Favorites",
                value: "favorite",
              ),
              _filterCard(
                context,
                icon: Icons.people,
                color: Colors.blue,
                label: "All",
                value: "all",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          title: 'Home',
          pop: false,
          setting: true,
          drawer: true,
          onMenuTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(
        username: username,
        profileCount: profiles.length,
        favoriteCount: favoriteProfiles.length,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: searchProfile,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        hintStyle: const TextStyle(fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
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
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final result = await showFilterDialog(context);

                        setState(() {
                          if (result == "favorite") {
                            filteredProfiles = profiles
                                .where((profile) => profile.favorite == true)
                                .toList();
                          } else {
                            filteredProfiles = List.from(profiles);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Profile List
              Expanded(
                child: isLoading
                    ? Center(child: CircleLoading())
                    : profiles.isEmpty
                    ? const Center(
                        child: Text(
                          "No Profiles Found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = filteredProfiles[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManageProfileScreen(profileData: profile),
                                ),
                              );
                            },
                            child: Card(
                              color: background,
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // Profile Image
                                    CircleAvatar(
                                      radius: 38,
                                      backgroundColor: Colors.grey.shade300,
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            profile.profileImage.isNotEmpty
                                            ? FileImage(
                                                File(profile.profileImage),
                                              )
                                            : null,
                                        child: profile.profileImage.isEmpty
                                            ? const Icon(Icons.person)
                                            : null,
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ' ${profile.name}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Wrap(
                                            spacing: 10,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  profile.gender,
                                                  style: TextStyle(
                                                    color: Colors.blue.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  "${profile.age} Yrs",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.green.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  profile.location,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          profile.favorite = !profile.favorite;
                                        });

                                        await profileVms.updateProfile(profile);
                                        await getProfiles();
                                      },
                                      icon: Icon(
                                        profile.favorite
                                            ? Icons.thumb_up_alt
                                            : Icons.thumb_up_alt_outlined,
                                        color: profile.favorite
                                            ? primaryColor
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          elevation: 10,
          splashColor: primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateProfileScreen(isEdit: false),
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: background, size: 30),
        ),
      ),
    );
  }
}
