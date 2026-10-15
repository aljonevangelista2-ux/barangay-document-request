import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/document_request.dart';

class NewRequestPage extends StatefulWidget {
  final List<String> documentTypes;
  final ValueChanged<DocumentRequest> onSubmit;

  const NewRequestPage({
    super.key,
    required this.documentTypes,
    required this.onSubmit,
  });

  @override
  State<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final purposeController = TextEditingController();

  String? selectedDocument;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documents =
        widget.documentTypes.isEmpty ? defaultDocuments : widget.documentTypes;

    // The list can change after the API responds, so make sure the selected
    // value is always one of the dropdown items (otherwise Flutter asserts).
    if (selectedDocument == null || !documents.contains(selectedDocument)) {
      selectedDocument = documents.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Document Request')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.post_add,
              size: 55,
              color: primaryBlue,
            ),
            const SizedBox(height: 10),
            const Text(
              'Request a Document',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            const Text('Document Type'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDocument,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              items: documents
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedDocument = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your full name.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Complete Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your address.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: purposeController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Purpose of Request',
                hintText: 'Explain why you need this document',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter the purpose.'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final request = DocumentRequest(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  documentType: selectedDocument!,
                  fullName: nameController.text.trim(),
                  address: addressController.text.trim(),
                  purpose: purposeController.text.trim(),
                  date: DateTime.now(),
                );

                // MainPage shows the success message and switches tabs.
                widget.onSubmit(request);

                nameController.clear();
                addressController.clear();
                purposeController.clear();
                setState(() => selectedDocument = documents.first);
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit Request'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
