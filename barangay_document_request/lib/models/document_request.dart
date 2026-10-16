class DocumentRequest {
  final String id;
  final String documentType;
  final String fullName;
  final String address;
  final String purpose;
  final DateTime date;
  String status;

  DocumentRequest({
    required this.id,
    required this.documentType,
    required this.fullName,
    required this.address,
    required this.purpose,
    required this.date,
    this.status = 'Pending',
  });
}