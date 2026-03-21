import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'upload_preview_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  bool _isVideo = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    //automatically open gallery when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) => _openGallery());
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
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
                await _initVideo(file.path);
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  }
  Future<void> _initVideo(String path) async {
    _videoController = VideoPlayerController.file(File(path));
    await _videoController!.initialize();
    setState(() {});
  }
  Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.white.withOpacity(0.3),
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          'Select a photo or video',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _openGallery,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0088FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Open Gallery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildPreview() {
  return Stack(
    fit: StackFit.expand,
    children: [
      if (_isVideo && _videoController != null && _videoController!.value.isInitialized)
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        )
      else if (!_isVideo)
        Image.file(
          File(_selectedFile!.path),
          fit: BoxFit.contain,
        ),
      Positioned(
        bottom: 20,
        right: 20,
        child: GestureDetector(
          onTap: _openGallery,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: const Text(
              'Change',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ],
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
                  GestureDetector( //next button only enabled if a file is selected
                    onTap: _selectedFile == null ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailsPage(
                            filePath: _selectedFile!.path,
                            isVideo: _isVideo,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: _selectedFile == null
                            ? Colors.white.withOpacity(0.3)
                            : const Color(0xFF0088FF),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectedFile == null
                  ? _buildEmptyState()
                  : _buildPreview(),
            ),
          ],
        ),
      ),
    );
  }
}