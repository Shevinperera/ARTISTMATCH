import 'package:flutter/material.dart';
import 'gig_service.dart';

// ─── Color palette
const kBg        = Color(0xFF000000);
const kCard      = Color(0xFF1A1A2E);
const kCardDeep  = Color(0xFF16213E);
const kBorder    = Color(0xFF2A2A3A);
const kBlue      = Color(0xFF1E90FF);
const kBlueDark  = Color(0xFF0066CC);
const kTextPri   = Color(0xFFFFFFFF);
const kTextSec   = Color(0xFF888888);
const kTextMuted = Color(0xFF555555);

class CreateGigPage extends StatefulWidget {
  const CreateGigPage({super.key});

  @override
  State<CreateGigPage> createState() => _CreateGigPageState();
}

class _CreateGigPageState extends State<CreateGigPage> {
  final titleController    = TextEditingController();
  final locationController = TextEditingController();
  final priceController    = TextEditingController();
  final dateController     = TextEditingController();

  // Store the raw date/time for sending to backend
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? _selectedGenre;
  String? _selectedType;
  bool _isLoading = false; // ← loading state for POST request

  final List<String> _genres = ['Acoustic','Jazz','Pop','R&B','Rock','Electronic','Hip-Hop','Classical'];
  final List<String> _types  = ['Solo', 'Duo', 'Band', 'DJ', 'Any'];

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    priceController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // ── SUBMIT: POST to backend, then pop with result ──────────────────────────
  Future<void> _submit() async {
    // Basic validation
    if (titleController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Format date and time separately for the backend
    final dateStr = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2,'0')}-${_selectedDate!.day.toString().padLeft(2,'0')}";
    final timeStr = "${_selectedTime!.hour.toString().padLeft(2,'0')}:${_selectedTime!.minute.toString().padLeft(2,'0')}";

    final gigData = {
      "eventTitle": titleController.text.trim(),
      "venue":      locationController.text.trim(),
      "date":       dateStr,
      "time":       timeStr,
      "genre":      _selectedGenre ?? "Other",
      "pay":        priceController.text.trim(),
    };

    final success = await GigService.postGig(gigData);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      // Return the new gig data to GigPostPage so it can insert it into the list
      Navigator.pop(context, {
        "title":    titleController.text.trim(),
        "location": locationController.text.trim(),
        "price":    "Rs ${priceController.text.trim()}",
        "date":     dateController.text, // human-readable version
        "color":    Colors.teal,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to post gig. Please try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.chevron_left, color: kBlue, size: 26),
                    ),
                  ),
                  const Expanded(
                    child: Text('Post a New Gig',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kTextPri, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: .3),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // ── Scrollable Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kCard, kCardDeep],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBlue.withOpacity(.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kBlue.withOpacity(.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.music_note, color: kBlue, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Post a New Gig',
                                    style: TextStyle(color: kTextPri, fontWeight: FontWeight.w700, fontSize: 15)),
                                SizedBox(height: 3),
                                Text('Fill in the details and find your artist',
                                    style: TextStyle(color: kTextSec, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    _FieldLabel('Gig Title'),
                    _AppInput(controller: titleController, hint: 'e.g. Acoustic Night', icon: Icons.title),

                    _FieldLabel('Location'),
                    _AppInput(controller: locationController, hint: 'e.g. Hilton, Colombo', icon: Icons.location_on_outlined),

                    _FieldLabel('Price (Rs) / night'),
                    Container(
                      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(Icons.payments_outlined, color: kBlue, size: 18),
                          ),
                          const Text('Rs', style: TextStyle(color: kBlue, fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: kTextPri, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: '20,000',
                                hintStyle: TextStyle(color: kTextSec),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _FieldLabel('Date & Time'),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(primary: kBlue, surface: kCard),
                            ),
                            child: child!,
                          ),
                        );
                        if (date != null && context.mounted) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(primary: kBlue, surface: kCard),
                              ),
                              child: child!,
                            ),
                          );
                          if (time != null) {
                            _selectedDate = date;
                            _selectedTime = time;
                            final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                            final formatted = '${months[date.month - 1]} ${date.day}, ${time.format(context)}';
                            setState(() => dateController.text = formatted);
                          }
                        }
                      },
                      child: AbsorbPointer(
                        child: _AppInput(
                          controller: dateController,
                          hint: 'e.g. January 15, 7pm',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ),

                    _FieldLabel('Music Genre'),
                    _DropdownField(
                      hint: 'Select a genre',
                      value: _selectedGenre,
                      items: _genres,
                      icon: Icons.queue_music_outlined,
                      onChanged: (v) => setState(() => _selectedGenre = v),
                    ),

                    _FieldLabel('Artist Type'),
                    _SegmentPicker(
                      options: _types,
                      selected: _selectedType,
                      onSelect: (v) => setState(() => _selectedType = v),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── POST GIG Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: GestureDetector(
                onTap: _isLoading ? null : _submit,
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isLoading
                          ? [Colors.grey, Colors.grey.shade700]
                          : [kBlue, kBlueDark],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _isLoading
                        ? []
                        : [BoxShadow(color: kBlue.withOpacity(.3), blurRadius: 20, offset: const Offset(0, 6))],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                      height: 22, width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('POST GIG',
                        style: TextStyle(color: kTextPri, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(text.toUpperCase(),
        style: const TextStyle(color: kTextSec, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: .8)),
  );
}

class _AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  const _AppInput({required this.controller, required this.hint, required this.icon, this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: kTextPri, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kTextSec, fontSize: 13),
          prefixIcon: Icon(icon, color: kBlue, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  const _DropdownField({required this.hint, required this.value, required this.items, required this.icon, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
      child: Row(
        children: [
          Icon(icon, color: kBlue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(hint, style: const TextStyle(color: kTextSec, fontSize: 13)),
                dropdownColor: kCard,
                style: const TextStyle(color: kTextPri, fontSize: 14),
                icon: const Icon(Icons.keyboard_arrow_down, color: kTextSec),
                items: items.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentPicker extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  const _SegmentPicker({required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: options.map((o) {
        final sel = selected == o;
        return GestureDetector(
          onTap: () => onSelect(o),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: sel ? kBlue : kCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: sel ? kBlue : kBorder),
            ),
            child: Text(o,
                style: TextStyle(color: sel ? kTextPri : kTextSec, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        );
      }).toList(),
    );
  }
}