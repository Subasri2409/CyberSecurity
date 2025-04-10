import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportIncident extends StatefulWidget {
  const ReportIncident({super.key});

  @override
  _ReportIncidentState createState() => _ReportIncidentState();
}

class _ReportIncidentState extends State<ReportIncident> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  File? _imageFile; // Selected image for mobile
  Uint8List? _webImage; // Selected image for web
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false; // Track upload state

  // PICK IMAGE FROM CAMERA OR GALLERY
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      if (kIsWeb) {
        // Convert file to Uint8List for Web
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null; // Ensure only one source is used
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null; // Ensure only one source is used
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  // MANUALLY CONFIRM INCIDENT SUBMISSION
  void _confirmSubmission() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty || (_imageFile == null && _webImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Simulate a delay for UX improvement
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isUploading = false;
      });

      // Show manual success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incident reported successfully! ✅")),
      );

      // Clear form fields and image after submission
      titleController.clear();
      descriptionController.clear();
      setState(() {
        _imageFile = null;
        _webImage = null;
      });

      // Optionally navigate back after submission
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report an Incident"), backgroundColor: Colors.red),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Incident Title", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter incident title",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(height: 10),
              
              Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Describe the incident...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
              SizedBox(height: 20),

              Text("Attach Evidence", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.image),
                    label: Text("Gallery"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text("Camera"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _buildImagePreview(), // Display the selected image

              SizedBox(height: 20),

              _isUploading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _confirmSubmission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Center(child: Text("Submit Incident", style: TextStyle(fontSize: 16))),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to display image preview
  Widget _buildImagePreview() {
    if (_webImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(_webImage!, height: 150, fit: BoxFit.cover),
      );
    } else if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No image selected", style: TextStyle(color: Colors.grey)),
      );
    }
  }
}
