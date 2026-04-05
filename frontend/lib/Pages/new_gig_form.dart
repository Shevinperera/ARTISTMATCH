import 'package:flutter/material.dart';

class CreateGigPage extends StatefulWidget {
  const CreateGigPage({super.key});

  @override
  State<CreateGigPage> createState() => _CreateGigPageState();
}

class _CreateGigPageState extends State<CreateGigPage> {
  // 1. The "buckets" that hold your typed text
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Post a New Gig", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 2. Attach the buckets to the text fields
            _buildTextField("Gig Title", titleController),
            const SizedBox(height: 16),
            _buildTextField("Location", locationController),
            const SizedBox(height: 16),
            _buildTextField("Price (Rs)", priceController),
            const SizedBox(height: 16),
            _buildTextField("Date & Time", dateController),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0091EA),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // 3. Package the typed text into a Map
                  final newGigData = {
                    "title": titleController.text.isEmpty ? "Untitled Gig" : titleController.text,
                    "location": locationController.text.isEmpty ? "Unknown Location" : locationController.text,
                    "price": priceController.text.isEmpty ? "Rs 0" : "Rs ${priceController.text}",
                    "date": dateController.text.isEmpty ? "TBD" : dateController.text,
                    "color": Colors.teal, // Let's make new gigs Teal so they stand out!
                  };

                  // 4. Send the data BACK to the home page
                  Navigator.pop(context, newGigData); 
                },
                child: const Text("POST GIG", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the text fields
  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller, // <-- Connects the UI to the variable
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}