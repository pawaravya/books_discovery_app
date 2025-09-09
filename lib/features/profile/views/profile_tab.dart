import 'dart:io';
import 'package:books_discovery_app/features/authentication/models/user_model.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _newProfileImage;
  UserModel? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// Load user from SharedPreferences
  void _loadUser() async {
    final savedUser = await AppSharedPreferences.customSharedPreferences
        .getUser();
    if (savedUser != null) {
      setState(() {
        _user = savedUser;
      });
    }
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _newProfileImage = File(picked.path);
        });

        await _uploadProfilePicture(_newProfileImage!);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      AppViewUtils.showTopSnackbar(context, "Failed to pick image");
    }
  }

  /// Upload profile picture to Firebase Storage and update Firebase Auth
  Future<void> _uploadProfilePicture(File image) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final storageRef = FirebaseStorage.instance.ref().child(
        "profile_pics/${currentUser.uid}.jpg",
      );

      // Upload file
      final uploadTask = await storageRef.putFile(image);

      // ✅ Ensure upload completed successfully
      if (uploadTask.state == TaskState.success) {
        // Now get download URL
        final downloadUrl = await storageRef.getDownloadURL();

        // Update Firebase Auth
        await currentUser.updatePhotoURL(downloadUrl);
        await currentUser.reload();

        // Update local user model
        if (_user != null) {
          final updatedUser = _user!.copyWith(photoUrl: downloadUrl);
          await AppSharedPreferences.customSharedPreferences.saveUser(
            updatedUser,
          );
          setState(() {
            _user = updatedUser;
          });
        }

        AppViewUtils.showTopSnackbar(context, "Profile picture updated");
      } else {
        AppViewUtils.showTopSnackbar(context, "Upload failed");
      }
    } catch (e) {
      debugPrint("Error uploading profile picture: $e");
      AppViewUtils.showTopSnackbar(
        context,
        "Failed to upload profile picture",
        isError: true,
      );
    }
  }

  /// Logout function
  Future<void> _logout() async {
    AppViewUtils.showLogoutConfirmation(context, () async {
      await FirebaseAuth.instance.signOut();
      await AppSharedPreferences.customSharedPreferences
          .clearSharedPreference();

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return AppText("User not found");

    return BaseWidget(
      screen: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _newProfileImage != null
                        ? FileImage(_newProfileImage!) as ImageProvider
                        : (_user?.photoUrl != null
                              ? NetworkImage(_user!.photoUrl!)
                              : null),
                    child: (_newProfileImage == null && _user?.photoUrl == null)
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppText(
              _user?.name ?? "No Name",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            AppText(
              _user?.email ?? "No Email",
              fontSize: 16,
              color: Colors.grey,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const AppText("Logout", color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
