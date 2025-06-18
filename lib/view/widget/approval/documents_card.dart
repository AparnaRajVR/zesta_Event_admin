import 'package:flutter/material.dart';

class DocumentsCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  const DocumentsCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final docs = userData['documentImage'];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: docs != null
            ? (docs is List
                ? Column(
                    children: docs.map<Widget>((url) => _buildImage(url)).toList(),
                  )
                : _buildImage(docs))
            : Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text("No documents uploaded", style: TextStyle(color: Colors.grey)),
              ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          height: 150,
          errorBuilder: (_, __, ___) => const Text(
            "Failed to load image",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
