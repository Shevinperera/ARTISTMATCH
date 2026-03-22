import 'package:flutter/material.dart';

import 'gig_post_page.dart';
// import 'gig_post_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GigPostPage(),
    );
  }
}

// ─── Color palette (matches your gig feed) ───────────────────────────────────
const kBg = Color.fromARGB(255, 0, 0, 0);
const kCard = Color(0xFF1A1A2E);
const kCardDeep = Color(0xFF16213E);
const kBorder = Color(0xFF2A2A3A);
const kBlue = Color(0xFF1E90FF);
const kBlueDark = Color(0xFF0066CC);
const kTextPri = Color(0xFFFFFFFF);
const kTextSec = Color(0xFF888888);
const kTextMuted = Color(0xFF555555);

// ─── Entry point screen ───────────────────────────────────────────────────────
class ApplyPage extends StatefulWidget {
  final String gigTitle;
  final String gigDate;
  final String gigLocation;
  final String price;
  const ApplyPage({
    super.key,
    required this.gigTitle,
    required this.gigDate,
    required this.gigLocation,
    required this.price,
  });
  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  int _step = 1; // 1 = Your Info, 2 = Cover Note
  bool _submitted = false;

  // Step-1 state
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final Set<String> _genres = {'Acoustic'};
  String? _experience;

  // Step-2 state
  final _coverCtrl = TextEditingController();
  final _portfolioCtrl = TextEditingController();
  final _socialCtrl = TextEditingController();
  String? _availability;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _coverCtrl.dispose();
    _portfolioCtrl.dispose();
    _socialCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  // ── SUCCESS SCREEN ─────────────────────────────────────────────────────────
  Widget _buildSuccess() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kBlue, width: 3),
                  boxShadow: [
                    BoxShadow(color: kBlue.withOpacity(.3), blurRadius: 30),
                  ],
                ),
                child: const Icon(Icons.check, color: kBlue, size: 42),
              ),
              const SizedBox(height: 24),
              const Text(
                'Application Sent!',
                style: TextStyle(
                  color: kTextPri,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hilton, Colombo will review your profile\nand get back to you.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kTextSec, fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBlue.withOpacity(.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎵  ${widget.gigTitle}',
                      style: TextStyle(
                        color: kTextPri,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      widget.gigDate,
                      style: TextStyle(color: kTextSec, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: _GradientButton(
                  label: 'Back to Gigs',
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── MAIN FORM ──────────────────────────────────────────────────────────────
  Widget _buildForm() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildGigCard(),
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _step == 1 ? _buildStep1() : _buildStep2(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left, color: kBlue, size: 26),
            ),
          ),
          const Expanded(
            child: Text(
              'Apply for Gig',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kTextPri,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: .3,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ── GIG SUMMARY CARD ───────────────────────────────────────────────────────
  Widget _buildGigCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('🎸', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.gigTitle,
                  style: TextStyle(
                    color: kTextPri,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '📍 ${widget.gigLocation}  •  ${widget.gigDate}',
                  style: TextStyle(color: kTextSec, fontSize: 11),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.price,
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: '/night',
                  style: TextStyle(color: kTextMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP INDICATOR ─────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          _StepDot(
            number: 1,
            label: 'Your Info',
            active: _step >= 1,
            done: _step > 1,
          ),
          Expanded(
            child: Container(height: 1, color: _step >= 2 ? kBlue : kBorder),
          ),
          _StepDot(
            number: 2,
            label: 'Cover Note',
            active: _step >= 2,
            done: false,
          ),
        ],
      ),
    );
  }

  // ── STEP 1 ─────────────────────────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Artist / Band Name'),
        _AppInput(controller: _nameCtrl, hint: 'e.g. Luna & The Echo'),
        _FieldLabel('Contact Number'),
        _AppInput(
          controller: _phoneCtrl,
          hint: '+94 77 000 0000',
          keyboardType: TextInputType.phone,
        ),

        _FieldLabel('Years of Experience'),
        _SegmentPicker(
          options: const ['< 1 yr', '1–3 yrs', '3–5 yrs', '5+ yrs'],
          selected: _experience,
          onSelect: (v) => setState(() => _experience = v),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // ── STEP 2 ─────────────────────────────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Cover Note'),
        Container(
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: TextField(
            controller: _coverCtrl,
            maxLines: 6,
            style: const TextStyle(color: kTextPri, fontSize: 14, height: 1.6),
            decoration: const InputDecoration(
              hintText:
              'Tell the venue why you\'re the perfect fit for this gig. Mention your style, past experience, and any relevant performances…',
              hintStyle: TextStyle(color: kTextSec, fontSize: 13),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14),
            ),
          ),
        ),
        _FieldLabel('Portfolio / Demo Link'),
        _AppInput(
          controller: _portfolioCtrl,
          hint: 'https://soundcloud.com/yourname',
          keyboardType: TextInputType.url,
        ),
        _FieldLabel('Social Media'),
        _AppInput(controller: _socialCtrl, hint: '@yourinsta or Facebook page'),
        _FieldLabel('Availability Confirmed?'),
        _SegmentPicker(
          options: const ['Yes', 'Tentative', 'Need to Check'],
          selected: _availability,
          onSelect: (v) => setState(() => _availability = v),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── BOTTOM BAR ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: kBg,
      child: Row(
        children: [
          if (_step == 2) ...[
            GestureDetector(
              onTap: () => setState(() => _step = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorder),
                ),
                child: const Text(
                  '← Back',
                  style: TextStyle(
                    color: kTextSec,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: _GradientButton(
              label: _step == 1 ? 'Next  →' : 'Submit Application',
              onTap: () {
                if (_step == 1) {
                  setState(() => _step = 2);
                } else {
                  setState(() => _submitted = true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: kTextSec,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: .8,
      ),
    ),
  );
}

class _AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  const _AppInput({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: kTextPri, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kTextSec, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      ),
    );
  }
}

class _SegmentPicker extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  const _SegmentPicker({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
            child: Text(
              o,
              style: TextStyle(
                color: sel ? kTextPri : kTextSec,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final bool active;
  final bool done;
  const _StepDot({
    required this.number,
    required this.label,
    required this.active,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? kBlue : kCard,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, size: 14, color: kTextPri)
                : Text(
              '$number',
              style: const TextStyle(
                color: kTextPri,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? kBlue : kTextMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kBlue, kBlueDark]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kBlue.withOpacity(.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: kTextPri,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
            ),
          ),
        ),
      ),
    );
  }
}
