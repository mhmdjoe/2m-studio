import 'package:flutter/material.dart';
import 'package:anosh/widgets/navbar.dart';
import 'package:anosh/theme/app_theme.dart';
import 'package:anosh/widgets/magnetic_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isMobile ? 120 : 180),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'RESERVE A SESSION',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: isMobile ? 32 : 64,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Provide details about your project to reserve your commercial session.',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: isMobile ? 14 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 40 : 80),
                      const BookingForm(),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Floating NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(scrollOffset: _scrollOffset),
          ),
        ],
      ),
    );
  }
}

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  
  String? selectedSessionType;
  bool _hasAttemptedSubmit = false;

  final List<String> sessionTypes = [
    'Commercial',
    'Product',
    'Flatlay',
    'Indoor Location',
    'Lifestyle',
  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateController.dispose();
    timeController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  bool _isPhoneValid(String phone) {
    final cleanPhone = phone.trim();
    return cleanPhone.length == 11 && cleanPhone.startsWith('01');
  }

  Color _getValidationColor(String text, {bool isPhone = false}) {
    if (!_hasAttemptedSubmit) return Colors.white12;
    if (text.trim().isEmpty) return Colors.redAccent;
    if (isPhone && !_isPhoneValid(text)) return Colors.redAccent;
    return Colors.greenAccent;
  }

  Future<void> _sendToWhatsApp() async {
    setState(() {
      _hasAttemptedSubmit = true;
    });

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final details = detailsController.text.trim();
    
    if (name.isEmpty || phone.isEmpty || details.isEmpty) {
      _showSnackBar('PLEASE FILL IN ALL REQUIRED FIELDS (RED BORDERS).');
      return;
    }

    if (!_isPhoneValid(phone)) {
      _showSnackBar('PHONE NUMBER MUST START WITH 01 AND BE 11 DIGITS.');
      return;
    }

    final email = emailController.text.trim();
    final sessionType = selectedSessionType ?? 'Not specified';
    final date = dateController.text.trim();
    final time = timeController.text.trim();

    final String message = 
        '*NEW BOOKING REQUEST (2M STUDIO)*\n\n'
        '👤 *Name:* $name\n'
        '📞 *Phone:* $phone\n'
        '✉️ *Email:* ${email.isEmpty ? 'N/A' : email}\n'
        '📸 *Session Type:* $sessionType\n'
        '📅 *Date:* ${date.isEmpty ? 'N/A' : date}\n'
        '🕒 *Time:* ${time.isEmpty ? 'N/A' : time}\n\n'
        '📝 *Details:* $details';

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/201033397672?text=${Uri.encodeComponent(message)}'
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      if (mounted) {
        _showSnackBar('COULD NOT OPEN WHATSAPP.');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  InputDecoration _buildEliteDecoration(String label, String text, {bool isOptional = false, bool isPhone = false}) {
    final validationColor = isOptional ? Colors.white12 : _getValidationColor(text, isPhone: isPhone);
    final hasStatus = validationColor != Colors.white12;
    
    return InputDecoration(
      labelText: label,
      labelStyle: hasStatus ? TextStyle(color: validationColor) : null,
      floatingLabelStyle: hasStatus ? TextStyle(color: validationColor) : null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: validationColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: validationColor == Colors.white12 ? AppTheme.accentColor : validationColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70, fontSize: isMobile ? 10 : 12, letterSpacing: 2),
          floatingLabelStyle: const TextStyle(color: AppTheme.accentColor),
          hintStyle: const TextStyle(color: Colors.white24),
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              TextField(
                controller: nameController, 
                onChanged: (v) => setState(() {}),
                decoration: _buildEliteDecoration('FULL NAME', nameController.text),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController, 
                decoration: _buildEliteDecoration('EMAIL ADDRESS (OPTIONAL)', '', isOptional: true),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController, 
                      onChanged: (v) => setState(() {}),
                      decoration: _buildEliteDecoration('FULL NAME', nameController.text),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      controller: emailController, 
                      decoration: _buildEliteDecoration('EMAIL ADDRESS (OPTIONAL)', '', isOptional: true),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),
            TextField(
              controller: phoneController,
              onChanged: (v) => setState(() {}),
              keyboardType: TextInputType.phone,
              decoration: _buildEliteDecoration('PHONE NUMBER (E.G. 01XXXXXXXXX)', phoneController.text, isPhone: true),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              decoration: _buildEliteDecoration('SESSION TYPE (OPTIONAL)', '', isOptional: true),
              dropdownColor: AppTheme.cardColor,
              initialValue: selectedSessionType,
              style: const TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
              items: sessionTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedSessionType = value),
            ),
            const SizedBox(height: 30),
            if (isMobile) ...[
              TextField(
                controller: dateController,
                decoration: _buildEliteDecoration('PREFERRED DATE (OPTIONAL)', '', isOptional: true).copyWith(
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.white24),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: timeController,
                decoration: _buildEliteDecoration('PREFERRED TIME (OPTIONAL)', '', isOptional: true).copyWith(
                  hintText: 'HH:MM',
                  suffixIcon: const Icon(Icons.access_time, size: 18, color: Colors.white24),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      decoration: _buildEliteDecoration('PREFERRED DATE (OPTIONAL)', '', isOptional: true).copyWith(
                        hintText: 'YYYY-MM-DD',
                        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.white24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      decoration: _buildEliteDecoration('PREFERRED TIME (OPTIONAL)', '', isOptional: true).copyWith(
                        hintText: 'HH:MM',
                        suffixIcon: const Icon(Icons.access_time, size: 18, color: Colors.white24),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),
            TextField(
              controller: detailsController,
              onChanged: (v) => setState(() {}),
              maxLines: 5,
              decoration: _buildEliteDecoration('PROJECT DETAILS', detailsController.text).copyWith(
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 60),
            MagneticWrapper(
              cursorHint: 'SEND',
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendToWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 20 : 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Matching the 8px rounded edges
                    ),
                  ),
                  child: Text(
                    'SUBMIT BOOKING REQUEST',
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: isMobile ? 2 : 4),
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
