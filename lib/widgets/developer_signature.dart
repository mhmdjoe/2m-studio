import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class DeveloperSignature extends StatelessWidget {
  const DeveloperSignature({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 1,
            color: Colors.white10,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onLongPress: () => context.push('/admin-login'), // Secret Long Press for Admin
            child: Text(
              'DESIGN & DEVELOPMENT BY JOE',
              style: GoogleFonts.montserrat(
                fontSize: 9,
                fontWeight: FontWeight.w300,
                letterSpacing: 4,
                color: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
