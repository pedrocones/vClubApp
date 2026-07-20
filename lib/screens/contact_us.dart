import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../api/abstracts/abstract_contact_service.dart';
import '../api/abstracts/mock_services_registry.dart';

class ContactUsPage extends StatefulWidget {
  final AbstractContactService contactService;

  ContactUsPage({super.key, AbstractContactService? service})
    : contactService = service ?? testContactAPI;

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  String _userName = '';
  // ignore: prefer_final_fields
  String _selectedCategory = 'General Inquiry';
  String? _localAttachmentPath;
  String? _displayedFileName;
  //will do lenght validation to avoid exploits
  // ignore: unused_field
  int _currentTextLength = 0;
  bool _isSending = false;

  final List<String> _categories = [
    'General Inquiry',
    'Technical Support',
    'Donation Question',
    'Volunteer Coordination',
    'Membership Operations',
  ];

  @override
  void initState() {
    super.initState();
    // Listen to input mutations to dynamically update character countdown widgets
    _messageController.addListener(() {
      setState(() {
        _currentTextLength = _messageController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Triggers a secure platform picker restricted to safe documents and images
  Future<void> _pickSecureFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _localAttachmentPath = result.files.single.path;
          _displayedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      // Check if the widget is still on the screen otherwise silently crash
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File access denied or unverified: $e')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Enforce the 4,000 character upper limit validation constraint
      if (_messageController.text.length > 4000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Submission blocked: Message exceeds 4,000 character limit.',
            ),
          ),
        );
        return;
      }

      setState(() => _isSending = true);

      bool success = await widget.contactService.sendContactInquiry(
        name: _userName,
        category: _selectedCategory,
        message: _messageController.text,
        attachmentPath: _localAttachmentPath,
      );

      setState(() => _isSending = false);

      if (mounted && success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Inquiry Dispatched'),
            content: const Text(
              'The request has passed local mock validations and is logged to the console track.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _formKey.currentState?.reset();
                  _messageController.clear();
                  setState(() {
                    _localAttachmentPath = null;
                    _displayedFileName = null;
                  });
                },
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
              Text(
                'Contact Vicinum Club',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Name Entry
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.indigo),
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? 'Please enter your name'
                    : null,
                onSaved: (val) => _userName = val ?? '',
              ),
              const SizedBox(height: 16),

              // 2. Dynamic Inquiry Tracker Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Inquiry Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category, color: Colors.indigo),
                ),
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) => setState(
                  () => _selectedCategory = val ?? _categories.first,
                ),
              ),
              const SizedBox(height: 16),

              // 3. Clamped Message Input Box with Character Count Indicator
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                maxLength: 4000,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) {
                      int remaining = 4000 - currentLength;
                      return Text(
                        '$currentLength / 4000 characters ($remaining remaining)',
                        style: TextStyle(
                          fontSize: 12,
                          color: remaining < 200
                              ? Colors.red.shade700
                              : Colors.grey.shade600,
                          fontWeight: remaining < 200
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    },
                decoration: const InputDecoration(
                  labelText: 'Message Body',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  hintText: 'Describe your request details here...',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Message field cannot be left blank';
                  }
                  if (val.length > 4000) {
                    return 'Cannot exceed strict 4,000 parameter limits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 4. File Upload Module
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: _pickSecureFile,
                      icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                      label: const Text(
                        'Upload File',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _displayedFileName ??
                            'Allowed secure extensions: PDF, PNG, JPG',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: _displayedFileName == null
                              ? Colors.grey
                              : Colors.black87,
                          fontWeight: _displayedFileName == null
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_displayedFileName != null)
                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setState(() {
                          _localAttachmentPath = null;
                          _displayedFileName = null;
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Submit Execution Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSending ? null : _submitForm,
                child: _isSending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.indigo,
                        ),
                      )
                    : const Text(
                        'Dispatch Inquiry Form',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
