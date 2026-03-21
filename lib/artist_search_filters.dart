import 'package:flutter/material.dart';

class SearchFiltersPage extends StatefulWidget {
  final List<String> initialRoles;
  final List<String> initialGenres;
  final List<String> initialTrackTypes;
  final String? initialGender;
  final List<String> initialLanguages;
  final String? initialExp;
  final String? initialLocation;

  const SearchFiltersPage({
    super.key,
    this.initialRoles = const [],
    this.initialGenres = const [],
    this.initialTrackTypes = const [],
    this.initialGender,
    this.initialLanguages = const [],
    this.initialExp,
    this.initialLocation,
  });
  @override
  State<SearchFiltersPage> createState() => _SearchFiltersPageState();
}

class _SearchFiltersPageState extends State<SearchFiltersPage> {
  List<String> _selectedRoles = [];
  List<String> _selectedGenres = [];
  List<String> _selectedTrackTypes = [];
  List<String> _selectedLanguages = [];
  String? _selectedGender;
  String? _selectedExp;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedRoles = List.from(widget.initialRoles);
    _selectedGenres = List.from(widget.initialGenres);
    _selectedTrackTypes = List.from(widget.initialTrackTypes);
    _selectedGender = widget.initialGender;
    _selectedLanguages = List.from(widget.initialLanguages);
    _selectedExp = widget.initialExp;
    _selectedLocation = widget.initialLocation;
  }
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
                  _buildMultiSelectChips(
                    label: 'Roles',
                    options: _roles,
                    selected: _selectedRoles,
                    onChanged: (val) => setState(() => _selectedRoles = val),
                  ),
                  const SizedBox(height: 16),
                  _buildMultiSelectChips(
                    label: 'Genre',
                    options: _genres,
                    selected: _selectedGenres,
                    onChanged: (val) => setState(() => _selectedGenres = val),
                  ),
                  const SizedBox(height: 16),
                  _buildMultiSelectChips(
                    label: 'Track Types',
                    options: _trackTypes,
                    selected: _selectedTrackTypes,
                    onChanged: (val) => setState(() => _selectedTrackTypes = val),
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
                  _buildMultiSelectChips(
                    label: 'Preferred Languages',
                    options: _languages,
                    selected: _selectedLanguages,
                    onChanged: (val) => setState(() => _selectedLanguages = val),
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
                      onPressed: () => Navigator.pop(context, {
                        'roles': _selectedRoles,
                        'genres': _selectedGenres,
                        'trackTypes': _selectedTrackTypes,
                        'gender': _selectedGender,
                        'languages': _selectedLanguages,
                        'exp': _selectedExp,
                        'location': _selectedLocation,
                      }),
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
                          _selectedRoles = [];
                          _selectedGenres = [];
                          _selectedTrackTypes = [];
                          _selectedGender = null;
                          _selectedLanguages = [];
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
  Widget _buildMultiSelectChips({
    required String label,
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
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
        Wrap(
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
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}