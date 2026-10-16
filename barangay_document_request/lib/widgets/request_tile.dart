import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/document_request.dart';

class RequestTile extends StatelessWidget {
  final DocumentRequest request;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const RequestTile({
    super.key,
    required this.request,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (request.status) {
      'Approved' => Colors.green,
      'Released' => Colors.blue,
      'Processing' => Colors.orange,
      _ => Colors.deepOrange,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          backgroundColor: lightBlue,
          child: Icon(Icons.description, color: primaryBlue),
        ),
        title: Text(
          request.documentType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${request.date.toLocal().toString().split(' ').first}'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          tooltip: 'Cancel request',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ),
    );
  }
}
