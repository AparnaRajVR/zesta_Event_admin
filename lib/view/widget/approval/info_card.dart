import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  const InfoCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text('User Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            _buildTile(Icons.email, "Email", userData['email'] ?? "Not provided"),
            _buildTile(Icons.phone, "Phone", userData['phone'] ?? "Not provided"),
            _buildTile(Icons.category, "Type", userData['organizerType'] ?? "Not provided"),
            _buildTile(Icons.location_on, "Address", userData['address'] ?? "Not provided"),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle: Text(value, style: TextStyle(fontSize: 16)),
    );
  }
}
