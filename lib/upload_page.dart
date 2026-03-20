import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    //automatically open gallery when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) => _openGallery());
  }

  Future<void> _openGallery() async {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1C1C1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined, color: Colors.white, size: 22),
            title: const Text(
              'Choose Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              final file = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 90,
              );
              if (file != null) {
                setState(() {
                  _selectedFile = file;
                  _isVideo = false;
                });
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam_outlined, color: Colors.white, size: 22),
            title: const Text(
              'Choose Video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              final file = await _picker.pickVideo(
                source: ImageSource.gallery,
              );
              if (file != null) {
                setState(() {
                  _selectedFile = file;
                  _isVideo = true;
                });
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                  const Text(
                    'New Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Upload coming soon',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
