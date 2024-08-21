import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedMedia;
  String? extractedText;
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Text Recognition'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedMedia != null) _buildImagePreview(),
            const SizedBox(height: 16),
            _buildExtractTextView(),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16, // Add margin from the left
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0), // Additional margin
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    selectedMedia = null;
                    extractedText = null;
                  });
                },
                child: const Icon(Icons.clear),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _pickImage,
              child: const Icon(Icons.add_a_photo),
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () async {
              final pickedFile = await picker.pickImage(source: ImageSource.camera);
              Navigator.of(context).pop(pickedFile);
            },
            child: const Text('Take Photo'),
          ),
          TextButton(
            onPressed: () async {
              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
              Navigator.of(context).pop(pickedFile);
            },
            child: const Text('Choose from Gallery'),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (await file.exists()) {
        setState(() {
          selectedMedia = file;
          extractedText = null; // Reset extracted text when a new image is picked
          _isLoading = true; // Start loading animation
        });
        await _extractText(file); // Extract text as soon as the image is picked
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file does not exist')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.file(
          selectedMedia!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildExtractTextView() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (extractedText == null) {
      return const Center(
        child: Text("Take/Choose image"),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isExpanded
                ? extractedText!
                : (extractedText!.length > 100
                    ? extractedText!.substring(0, (extractedText!.length * 0.24).toInt()) + '...'
                    : extractedText!),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.teal,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          if (extractedText!.length > 100)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Show Less' : 'Show More',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        extractedText = recognizedText.text;
        _isLoading = false; // Stop loading animation
      });
    } catch (e) {
      print('Error extracting text: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to extract text')),
      );
      setState(() {
        _isLoading = false; // Stop loading animation on error
      });
    } finally {
      textRecognizer.close();
    }
  }
}
