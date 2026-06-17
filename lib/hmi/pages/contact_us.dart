import 'package:flutter/material.dart';
import '../../api/abstract_contact_service.dart';
import '../../api/mock_services_registry.dart';

class ContactUsPage extends StatefulWidget {
  // Injecting the abstract contract directly inside the constructor signature
  final AbstractContactService contactService;

  const ContactUsPage({super.key, AbstractContactService? service})
    : contactService =
          service ?? testContactAPI; // Fallback to our local mock instance

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _selectedCategory = 'General Inquiry';
  String _messageText = '';
  bool _isSending = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isSending = true);

      // UI talks to the abstract blueprint method directly without knowing it's a mock!
      bool success = await widget.contactService.sendContactInquiry(
        name: _userName,
        category: _selectedCategory,
        message: _messageText,
      );

      setState(() => _isSending = false);

      if (mounted && success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Interface Verified'),
            content: const Text(
              'Check your IDE console logs! The Abstract class parameters successfully channeled into the mock gateway.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Required' : null,
                onSaved: (val) => _userName = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message Content',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Required' : null,
                onSaved: (val) => _messageText = val ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.indigo,
                ),
                onPressed: _isSending ? null : _submitForm,
                child: _isSending
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Test Abstract Service Call'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
