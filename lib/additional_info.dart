import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdditionalInfoItem  extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem ({super.key, required this.icon, required this.label,
  required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,
    size: 65),
     const SizedBox(height: 10,),
    Text(label,
    style: GoogleFonts.dmSans(
      fontSize: 16,
       fontWeight: FontWeight.bold,
       ),
       ),
        const SizedBox(height:5,),
        Text(value,
        style: GoogleFonts.dmSans
        (fontSize: 16,fontWeight: FontWeight.bold,),),
    ],
    );
  }
}