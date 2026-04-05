import 'package:flutter/material.dart';
import 'dart:io';

class PostDetailsPage extends StatefulWidget {
  final String filePath;
  final bool isVideo;

  const PostDetailsPage({
    super.key,
    required this.filePath,
    required this.isVideo,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _captionController = TextEditingController();
  bool _isSharing = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
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
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
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
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.isVideo
                          ? Container(
                              height: 300,
                              color: const Color(0xFF2A2A2A),
                              child: const Center(
                                child: Icon(Icons.play_circle_outline,
                                    color: Colors.white, size: 64),
                              ),
                            )
                          : Image.file(
                              File(widget.filePath),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _captionController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Add a caption',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSharing ? null : () async {
                          setState(() => _isSharing = true);
                          await Future.delayed(const Duration(seconds: 1));
                          if (mounted) {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088FF),
                          disabledBackgroundColor: const Color(0xFF0088FF).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSharing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Share',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            

          ],
        ),
      ),
    );
  }
}