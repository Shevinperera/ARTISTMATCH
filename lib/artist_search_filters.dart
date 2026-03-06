import 'package:flutter/material.dart';

class SearchFiltersPage extends StatefulWidget {
  const SearchFiltersPage({super.key});

  @override
  State<SearchFiltersPage> createState() => _SearchFiltersPageState();
}

class _SearchFiltersPageState extends State<SearchFiltersPage> {
  String? _selectedRole;
  String? _selectedGenre;
  String? _selectedTrackType;
  String? _selectedGender;
  String? _selectedLanguage;
  String? _selectedExp;
  String? _selectedLocation;

  final List<String> _roles = ['Producer', 'Songwriter', 'Vocalist', 'DJ', 'Mixing Engineer', 'Mastering Engineer', 'Composer', 'Instrumentalist', 'Recording Engineer', 'Other'];
  final List<String> _genres = ['Hip Hop', 'House', 'R&B', 'Pop', 'Rock', 'Electronic', 'Jazz', 'Reggae', 'Afrobeats', 'Latin', 'K-Pop', 'Country', 'Amapiano', 'Techno', 'Indie', 'Phonk', 'Metal', 'Dancehall', 'Ambient', 'Drum and Bass'];
  final List<String> _trackTypes = ['Single', 'EP', 'Album'];
  final List<String> _genders = ['Male', 'Female'];
  final List<String> _languages = ['Sinhala', 'Tamil', 'Hindi', 'English', 'German', 'French', 'Portuguese', 'Japanese', 'Spanish', 'Mandarin', 'Korean', 'Arabic'];
  final List<String> _expLevels = ['Beginner', 'Intermediate', 'Professional', 'Veteran'];
  final List<String> _locations = ['Sri Lanka', 'India', 'United States', 'United Kingdom', 'Germany', 'France', 'Brazil', 'Nigeria', 'South Africa', 'Australia', 'Japan', 'Mexico', 'Canada', 'China', 'South Korea', 'Indonesia', 'Sweden', 'Italy', 'Egypt', 'Turkey'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF595959),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Color(0xFFE6E6E6)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Add Search Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // Filter list
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterDropdown(
                    label: 'Roles',
                    hint: 'Select Artist Roles',
                    value: _selectedRole,
                    items: _roles,
                    onChanged: (val) => setState(() => _selectedRole = val),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDropdown(
                    label: 'Genre',
                    hint: 'Select Genres',
                    value: _selectedGenre,
                    items: _genres,
                    onChanged: (val) => setState(() => _selectedGenre = val),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDropdown(
                    label: 'Track Types',
                    hint: 'Select Type',
                    value: _selectedTrackType,
                    items: _trackTypes,
                    onChanged: (val) => setState(() => _selectedTrackType = val),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDropdown(
                    label: 'Gender',
                    hint: 'Select Gender',
                    value: _selectedGender,
                    items: _genders,
                    onChanged: (val) => setState(() => _selectedGender = val),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDropdown(
                    label: 'Preferred Languages',
                    hint: 'Select Languages',
                    value: _selectedLanguage,
                    items: _languages,
                    onChanged: (val) => setState(() => _selectedLanguage = val),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDropdown(
                    label: 'Artist Exp',
                    hint: 'Select Exp',
                    value: _selectedExp,
                    items: _expLevels,
                    onChanged: (val) => setState(() => _selectedExp = val),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDropdown(
                    label: 'Location',
                    hint: 'Country',
                    value: _selectedLocation,
                    items: _locations,
                    onChanged: (val) => setState(() => _selectedLocation = val),
                  ),
                  const SizedBox(height: 24),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Clear button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedRole = null;
                          _selectedGenre = null;
                          _selectedTrackType = null;
                          _selectedGender = null;
                          _selectedLanguage = null;
                          _selectedExp = null;
                          _selectedLocation = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF595959)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF2F2F2),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.40,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.only(left: 16, right: 12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E1E1E), size: 16),
              dropdownColor: Colors.white,
              isExpanded: true,
              style: const TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}