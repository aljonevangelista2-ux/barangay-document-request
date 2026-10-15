import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/document_request.dart';
import '../widgets/detail_row.dart';

class RequestDetailsPage extends StatelessWidget {
  final DocumentRequest request;

  const RequestDetailsPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.description, size: 70, color: primaryBlue),
          const SizedBox(height: 18),
          Text(
            request.documentType,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DetailRow(label: 'Request ID', value: request.id),
          DetailRow(label: 'Resident', value: request.fullName),
          DetailRow(label: 'Address', value: request.address),
          DetailRow(label: 'Purpose', value: request.purpose),
          DetailRow(
            label: 'Date Submitted',
            value: request.date.toLocal().toString().split('.').first,
          ),
          DetailRow(label: 'Current Status', value: request.status),
        ],
      ),
    );
  }
}
