import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/document_request.dart';
import '../widgets/document_card.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatelessWidget {
  final List<DocumentRequest> requests;
  final List<String> documentTypes;
  final VoidCallback onNewRequest;
  final VoidCallback onViewRequests;
  final bool loading;
  final String? apiMessage;
  final Future<void> Function() onRetry;

  const HomePage({
    super.key,
    required this.requests,
    required this.documentTypes,
    required this.onNewRequest,
    required this.onViewRequests,
    required this.loading,
    required this.apiMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barangay Services'),
        actions: [
          IconButton(
            tooltip: 'Refresh documents',
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRetry,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_balance, color: Colors.white, size: 38),
                  SizedBox(height: 14),
                  Text(
                    'Welcome, Resident!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Request your barangay documents conveniently.',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Requests',
                    value: '${requests.length}',
                    icon: Icons.description_outlined,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Pending',
                    value: '${requests.where((r) => r.status == 'Pending').length}',
                    icon: Icons.hourglass_empty,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onNewRequest,
                  child: const Text('Request'),
                ),
              ],
            ),
            if (loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (documentTypes.isEmpty)
              const Text('No document types are available.')
            else
              ...documentTypes.map(
                (document) => DocumentCard(
                  title: document,
                  onTap: onNewRequest,
                ),
              ),
            if (apiMessage != null)
              Card(
                color: Colors.amber.shade50,
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(apiMessage!),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: onRetry,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onViewRequests,
              icon: const Icon(Icons.list_alt),
              label: const Text('View My Requests'),
            ),
          ],
        ),
      ),
    );
  }
}
