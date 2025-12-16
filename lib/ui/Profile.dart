import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ✅ Simulating API / DB call
  Future<Map<String, dynamic>> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      "name": "John Doe",
      "email": "john.doe@gmail.com",
      "items": [
        {"icon": Icons.person_outline, "title": "My Account"},
        {"icon": Icons.shopping_bag_outlined, "title": "My Orders"},
        {"icon": Icons.location_on_outlined, "title": "Shipping Address"},
        {"icon": Icons.payment_outlined, "title": "Payment Methods"},
        {"icon": Icons.settings_outlined, "title": "Settings"},
        {"icon": Icons.logout, "title": "Logout"},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),

      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfile(),
        builder: (context, snapshot) {
          // ✅ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ ERROR
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load profile"));
          }

          // ✅ DATA READY
          final data = snapshot.data!;

          return Column(
            children: [
              // PROFILE HEADER
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 45, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data["email"],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // PROFILE OPTIONS USING BUILDER
              Expanded(
                child: ListView.builder(
                  itemCount: data["items"].length,
                  itemBuilder: (context, index) {
                    final item = data["items"][index];

                    return ListTile(
                      leading: Icon(item["icon"]),
                      title: Text(item["title"]),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // handle navigation
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
