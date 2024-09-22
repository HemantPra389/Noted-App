import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("General",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          ListTile(
            title: Text("Security"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.security),
          ),
          ListTile(
            title: Text("Reminders"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.browse_gallery_outlined),
          ),
          ListTile(
            title: Text("History"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.collections_bookmark_rounded),
          ),
          SizedBox(height: 12),
          Text("Help & Support",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          ListTile(
            title: Text("About"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.info_outline_rounded),
          ),
          SizedBox(height: 12),
          Text("Privacy",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          ListTile(
            title: Text("Terms of Service"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.electrical_services_rounded),
          ),
          ListTile(
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.privacy_tip_rounded),
          ),
          ListTile(
            title: Text("Security Policy"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.policy),
          ),
        ]);
  }
}
