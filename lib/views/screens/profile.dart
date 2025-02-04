import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/profile_controller.dart';
import '../components/notification_popup.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Function to open image picker (camera or gallery)
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final profileController = Provider.of<ProfileController>(context, listen: false);
    await profileController.pickImage(source); // Call the correct method
  }

  // Function to show a bottom sheet for image source selection
  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar and User Details
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceBottomSheet(context),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: profileController.avatar != null
                        ? FileImage(profileController.avatar!)
                        : null,
                    child: profileController.avatar == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileController.name ?? 'John Doe',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      profileController.email ?? 'johndoe@example.com',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Geo Location Toggle
            ListTile(
              title: const Text('Turn on Geo Location'),
              trailing: Switch(
                value: profileController.geoLocationEnabled,
                onChanged: (value) async {
                  if (value) {
                    // Request location permission
                    bool serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                    if (!serviceEnabled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Location services are disabled.'),
                        ),
                      );
                      return;
                    }

                    LocationPermission permission =
                    await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location permissions are denied.'),
                          ),
                        );
                        return;
                      }
                    }

                    if (permission == LocationPermission.deniedForever) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Location permissions are permanently denied.'),
                        ),
                      );
                      return;
                    }

                    // Get current position
                    Position position = await Geolocator.getCurrentPosition();
                    print(
                        'Location: ${position.latitude}, ${position.longitude}');
                    profileController.setGeoLocation(position);
                  } else {
                    profileController.setGeoLocation(null);
                  }
                },
              ),
            ),
            if (profileController.geoLocationEnabled &&
                profileController.position != null)
              ListTile(
                title: const Text('Location'),
                subtitle: Text(
                  'Lat: ${profileController.position!.latitude}, Long: ${profileController.position!.longitude}',
                ),
              ),

            // Notifications Toggle
            ListTile(
              title: const Text('Enable Notifications'),
              trailing: Switch(
                value: profileController.notificationsEnabled,
                onChanged: (value) {
                  profileController.toggleNotifications(value);
                  if (value) {
                    showNotificationPopup(context);
                  }
                },
              ),
              leading: Icon(
                profileController.notificationsEnabled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_sharp,
                color: Theme.of(context).iconTheme.color,
              ),
            ),

            // Theme Toggle
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeController.isDarkMode,
                onChanged: (value) => themeController.toggleTheme(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}