import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SliderLabel extends StatefulWidget {
  final String label;
  const SliderLabel({super.key, required this.label});

  @override
  State<SliderLabel> createState() => _SliderLabelState();
}

class _SliderLabelState extends State<SliderLabel> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.label,
      style: GoogleFonts.inter(
          color: const Color.fromARGB(255, 217, 217, 217),
          fontWeight: FontWeight.bold),
    );
  }
}
