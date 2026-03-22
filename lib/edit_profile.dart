import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({
    super.key,
    required this.userData,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  final ImagePicker _picker = ImagePicker();
  String? _newBannerPath;
  String? _newProfilePicPath;
  List<String> _selectedRoles = [];
  List<String> _selectedGenres = [];
  
  final List<String> _roles = ['Producer', 'Songwriter', 'Vocalist', 'DJ', 'Mixing Engineer', 'Mastering Engineer', 'Composer', 'Instrumentalist', 'Recording Engineer', 'Other'];
  final List<String> _genres = ['Hip Hop', 'House', 'R&B', 'Pop', 'Rock', 'Electronic', 'Jazz', 'Reggae', 'Afrobeats', 'Latin', 'K-Pop', 'Country', 'Amapiano', 'Techno', 'Indie', 'Phonk', 'Metal', 'Dancehall', 'Ambient', 'Drum and Bass'];
  String? _selectedGender;
  String? _selectedLocation;
  List<String> _selectedLanguages = [];

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _locations = ['Sri Lanka', 'India', 'United States', 'United Kingdom', 'Germany', 'France', 'Brazil', 'Nigeria', 'South Africa', 'Australia', 'Japan', 'Mexico', 'Canada', 'China', 'South Korea', 'Indonesia', 'Sweden', 'Italy', 'Egypt', 'Turkey'];
  final List<String> _languages = ['Sinhala', 'Tamil', 'Hindi', 'English', 'German', 'French', 'Portuguese', 'Japanese', 'Spanish', 'Mandarin', 'Korean', 'Arabic'];
  final List<Map<String, TextEditingController>> _links = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.userData['name'] ?? '');
    _bioController = TextEditingController(
        text: widget.userData['bio'] ?? '');
    _selectedRoles = List<String>.from(widget.userData['selectedRoles'] ?? []);
    _selectedGenres = List<String>.from(widget.userData['selectedGenres'] ?? []);
    _selectedGender = widget.userData['gender'];
    _selectedLocation = widget.userData['location'];
    _selectedLanguages = List<String>.from(widget.userData['selectedLanguages'] ?? []);
    
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickBanner() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _newBannerPath = file.path);
  }

  Future<void> _pickProfilePic() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _newProfilePicPath = file.path);
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFF2F2F2),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF595959), width: 0.5),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
  Widget _buildChips(List<String> options, List<String> selected,
      ValueChanged<List<String>> onChanged) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return GestureDetector(
          onTap: () {
            final updated = List<String>.from(selected);
            if (isSelected) {
              updated.remove(option);
            } else {
              updated.add(option);
            }
            onChanged(updated);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: ShapeDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: isSelected ? Colors.white : const Color(0xFF595959),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.black : const Color(0xFFF2F2F2),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  Widget _buildDropdown(List<String> items, String? value, String hint,
      ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF595959), width: 0.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                  fontFamily: 'Inter')),
          dropdownColor: const Color(0xFF1A1A1A),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Color(0xFF595959), size: 20),
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontFamily: 'Inter'),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Links'),
        ..._links.asMap().entries.map((entry) {
          final index = entry.key;
          final link = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(link['name']!, 'Link name (e.g. Spotify)'),
                      const SizedBox(height: 6),
                      _buildTextField(link['url']!, 'URL'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _links.removeAt(index)),
                  child: const Icon(Icons.remove_circle_outline,
                      color: Color(0xFFFF383C), size: 22),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _links.add({
                'name': TextEditingController(),
                'url': TextEditingController(),
              })),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline,
                  color: Color(0xFF0088FF), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Add Link',
                style: TextStyle(
                  color: Color(0xFF0088FF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
            // Header
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
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 24),
                  ),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: save to backend
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xFF0088FF),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    GestureDetector(
                      onTap: _pickBanner,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF1A1A1A),
                            ),
                            child: _newBannerPath != null
                                ? Image.file(File(_newBannerPath!), fit: BoxFit.cover)
                                : widget.userData['banner'] != null
                                    ? Image.network(widget.userData['banner'], fit: BoxFit.cover)
                                    : const Center(
                                        child: Icon(Icons.image_outlined,
                                            color: Color(0xFF595959), size: 40)),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.camera_alt_outlined,
                                    color: Colors.white, size: 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Profile picture
                    Center(
                      child: GestureDetector(
                        onTap: _pickProfilePic,
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF1A1A1A),
                              ),
                              child: _newProfilePicPath != null
                                  ? Image.file(File(_newProfilePicPath!), fit: BoxFit.cover)
                                  : widget.userData['image'] != null
                                      ? Image.network(widget.userData['image'], fit: BoxFit.cover)
                                      : const Icon(Icons.person,
                                          color: Color(0xFF595959), size: 40),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.camera_alt_outlined,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Name
                    _buildLabel('Name'),
                    _buildTextField(_nameController, 'Enter your name'),
                    const SizedBox(height: 16),
                    // Bio
                    _buildLabel('Bio'),
                    _buildTextField(_bioController, 'Write something about yourself', maxLines: 3),
                    const SizedBox(height: 16),
                    // Roles
                    _buildLabel('Artist Roles'),
                    _buildChips(_roles, _selectedRoles, (val) => setState(() => _selectedRoles = val)),
                    const SizedBox(height: 16),
                    // Genres
                    _buildLabel('Genres'),
                    _buildChips(_genres, _selectedGenres, (val) => setState(() => _selectedGenres = val)),
                    const SizedBox(height: 16),
                    // Gender
                    _buildLabel('Gender'),
                    _buildDropdown(_genders, _selectedGender, 'Select Gender',
                        (val) => setState(() => _selectedGender = val)),
                    const SizedBox(height: 16),
                    // Location
                    _buildLabel('Location'),
                    _buildDropdown(_locations, _selectedLocation, 'Select Country',
                        (val) => setState(() => _selectedLocation = val)),
                    const SizedBox(height: 16),
                    // Languages
                    _buildLabel('Preferred Languages'),
                    _buildChips(_languages, _selectedLanguages,
                        (val) => setState(() => _selectedLanguages = val)),
                    const SizedBox(height: 16),
                    _buildLinksSection(),
                    const SizedBox(height: 40),
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
