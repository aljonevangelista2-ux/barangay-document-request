import 'package:flutter/material.dart';
import 'constants.dart';
import 'models/document_request.dart';
import 'page/home_page.dart';
import 'page/my_requests_page.dart';
import 'page/new_request_page.dart';
import 'page/profile_page.dart';
import 'services/api_service.dart';

void main() {
  runApp(const BarangayApp());
}

class BarangayApp extends StatelessWidget {
  const BarangayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barangay Document Request',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  bool loadingDocuments = true;
  String? apiMessage;

  List<String> documentTypes = defaultDocuments;
  final List<DocumentRequest> requests = [];

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    if (!loadingDocuments) {
      setState(() => loadingDocuments = true);
    }

    try {
      final result = await ApiService.fetchDocumentTypes();
      if (!mounted) return;

      setState(() {
        documentTypes = result;
        apiMessage = null;
        loadingDocuments = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        documentTypes = defaultDocuments;
        apiMessage = 'Using sample document types. API is unavailable.';
        loadingDocuments = false;
      });
    }
  }

  void addRequest(DocumentRequest request) {
    setState(() {
      requests.insert(0, request);
      selectedIndex = 2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document request submitted successfully.')),
    );
  }

  Future<void> deleteRequest(DocumentRequest request) async {
    if (request.status == 'Released') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Released requests cannot be cancelled.'),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: Text(
          'Do you want to cancel your ${request.documentType} request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Request'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel Request'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => requests.remove(request));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request cancelled successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        requests: requests,
        documentTypes: documentTypes,
        onNewRequest: openRequestForm,
        onViewRequests: () => setState(() => selectedIndex = 2),
        loading: loadingDocuments,
        apiMessage: apiMessage,
        onRetry: loadDocuments,
      ),
      NewRequestPage(
        documentTypes: documentTypes,
        onSubmit: addRequest,
      ),
      MyRequestsPage(
        requests: requests,
        onDelete: deleteRequest,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'New Request',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'My Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> openRequestForm() async {
    setState(() => selectedIndex = 1);
  }
}
