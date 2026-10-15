import 'package:flutter/material.dart';
import '../models/document_request.dart';
import '../widgets/request_tile.dart';
import 'request_details_page.dart';

class MyRequestsPage extends StatelessWidget {
  final List<DocumentRequest> requests;
  final ValueChanged<DocumentRequest> onDelete;

  const MyRequestsPage({
    super.key,
    required this.requests,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: requests.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 72, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No document requests yet.',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 6),
                    Text('Your submitted requests will appear here.'),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return RequestTile(
                  request: request,
                  onDelete: () => onDelete(request),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RequestDetailsPage(request: request),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
