import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Component screens are defined below in this file (no external imports required)


class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({super.key});

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  final List<Map<String, dynamic>> components = [
    {
      'title': 'Alert',
      'icon': Icons.info_outline,
      'color': Colors.blue,
      'screen': const AlertComponentScreen(),
    },
    {
      'title': 'Avatar',
      'icon': Icons.person_outline,
      'color': Colors.purple,
      'screen': const AvatarComponentScreen(),
    },
    {
      'title': 'Button',
      'icon': Icons.touch_app,
      'color': Colors.green,
      'screen': const ButtonComponentScreen(),
    },
    {
      'title': 'Radio Button',
      'icon': Icons.radio_button_checked,
      'color': Colors.orange,
      'screen': const RadioButtonComponentScreen(),
    },
    {
      'title': 'Badge',
      'icon': Icons.bookmark,
      'color': Colors.red,
      'screen': const BadgeComponentScreen(),
    },
    {
      'title': 'Button Group',
      'icon': Icons.group,
      'color': Colors.teal,
      'screen': const ButtonGroupComponentScreen(),
    },
    {
      'title': 'Card',
      'icon': Icons.credit_card,
      'color': Colors.indigo,
      'screen': const CardComponentScreen(),
    },
    {
      'title': 'Charts',
      'icon': Icons.bar_chart,
      'color': Colors.cyan,
      'screen': const ChartsComponentScreen(),
    },
    {
      'title': 'Dropdown',
      'icon': Icons.arrow_drop_down,
      'color': Colors.lime,
      'screen': const DropdownComponentScreen(),
    },
    {
      'title': 'Input',
      'icon': Icons.text_fields,
      'color': Colors.pink,
      'screen': const InputComponentScreen(),
    },
    {
      'title': 'Timeline',
      'icon': Icons.timeline,
      'color': Colors.amber,
      'screen': const TimelineComponentScreen(),
    },
    {
      'title': 'List Group',
      'icon': Icons.list,
      'color': Colors.deepOrange,
      'screen': const ListGroupComponentScreen(),
    },
    {
      'title': 'Modal',
      'icon': Icons.window_outlined,
      'color': Colors.brown,
      'screen': const ModalComponentScreen(),
    },
    {
      'title': 'Progressbar',
      'icon': Icons.autorenew,
      'color': Colors.blueAccent,
      'screen': const ProgressbarComponentScreen(),
    },
    {
      'title': 'Social',
      'icon': Icons.share_outlined,
      'color': Colors.indigo,
      'screen': const SocialComponentScreen(),
    },
    {
      'title': 'Typography',
      'icon': Icons.text_fields,
      'color': Colors.deepPurple,
      'screen': const TypographyComponentScreen(),
    },
    {
      'title': 'Toast',
      'icon': Icons.notifications,
      'color': Colors.teal,
      'screen': const ToastComponentScreen(),
    },
    {
      'title': 'Treeview',
      'icon': Icons.account_tree_outlined,
      'color': Colors.green,
      'screen': const TreeviewComponentScreen(),
    },
    {
      'title': 'Switch',
      'icon': Icons.toggle_on,
      'color': Colors.orange,
      'screen': const SwitchComponentScreen(),
    },
    {
      'title': 'Stepper',
      'icon': Icons.format_list_numbered,
      'color': Colors.pink,
      'screen': const StepperComponentScreen(),
    },
    {
      'title': 'Spinner',
      'icon': Icons.loop,
      'color': Colors.cyan,
      'screen': const SpinnerComponentScreen(),
    },
    {
      'title': 'RangeSlider',
      'icon': Icons.tune,
      'color': Colors.lime,
      'screen': const RangeSliderComponentScreen(),
    },
    {
      'title': 'LightGallery',
      'icon': Icons.photo_library,
      'color': Colors.purple,
      'screen': const LightGalleryComponentScreen(),
    },
    {
      'title': 'Divider',
      'icon': Icons.horizontal_rule,
      'color': Colors.grey,
      'screen': const DividerComponentScreen(),
    },
    {
      'title': 'Language',
      'icon': Icons.language,
      'color': Colors.deepOrange,
      'screen': const LanguageComponentScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Components'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: components.length,
        itemBuilder: (context, index) {
          final component = components[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => component['screen'] as Widget),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withAlpha(25), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: ListTile(
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: (component['color'] as Color).withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(component['icon'] as IconData, color: component['color'] as Color),
                ),
                title: Text(
                  component['title'] as String,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== ALERT COMPONENT ====================
class AlertComponentScreen extends StatelessWidget {
  const AlertComponentScreen({super.key});

  Widget _buildAlert({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    bool isSquare = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        borderRadius: isSquare ? BorderRadius.zero : BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.close, color: textColor, size: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Alerts
            const Text('Basic Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Bootstrap default style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildAlert(
              title: 'Welcome! Message has been sent.',
              icon: Icons.info,
              bgColor: Colors.blue,
              textColor: Colors.white,
              borderColor: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Danger! Your profile photo updated.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFFF6B6B),
              textColor: Colors.white,
              borderColor: const Color(0xFFFF6B6B),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Success! Message has been sent.',
              icon: Icons.check_circle_outline,
              bgColor: const Color(0xFF51CF66),
              textColor: Colors.white,
              borderColor: const Color(0xFF51CF66),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Info! You have got 5 new email.',
              icon: Icons.info_outline,
              bgColor: const Color(0xFF9B59B6),
              textColor: Colors.white,
              borderColor: const Color(0xFF9B59B6),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Warning! Something went wrong. Please check.',
              icon: Icons.warning_amber,
              bgColor: const Color(0xFFFFC107),
              textColor: Colors.white,
              borderColor: const Color(0xFFFFC107),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! Message sending failed.',
              icon: Icons.cancel,
              bgColor: const Color(0xFFE74C3C),
              textColor: Colors.white,
              borderColor: const Color(0xFFE74C3C),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! You successfully read this important alert message.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFF34495E),
              textColor: Colors.white,
              borderColor: const Color(0xFF34495E),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! You successfully read this message.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFD6EAF8),
              textColor: const Color(0xFF1F618D),
              borderColor: const Color(0xFF85C1E2),
            ),
            const SizedBox(height: 24),

            // Alerts Light
            const Text('Alerts Light', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Bootstrap default style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildAlert(
              title: 'Welcome! Message has been sent.',
              icon: Icons.info,
              bgColor: const Color(0xFFD6EAF8),
              textColor: const Color(0xFF1F618D),
              borderColor: const Color(0xFF85C1E2),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Danger! Your profile photo updated.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFFDEDEC),
              textColor: const Color(0xFF78281F),
              borderColor: const Color(0xFFF5B7B1),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Success! Message has been sent.',
              icon: Icons.check_circle_outline,
              bgColor: const Color(0xFFD5F4E6),
              textColor: const Color(0xFF186A3B),
              borderColor: const Color(0xFFA9DFBF),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Info! You have got 5 new email.',
              icon: Icons.info_outline,
              bgColor: const Color(0xFFEBDEF0),
              textColor: const Color(0xFF5B2C6F),
              borderColor: const Color(0xFFD7BDE2),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Warning! Something went wrong. Please check.',
              icon: Icons.warning_amber,
              bgColor: const Color(0xFFFEF5E7),
              textColor: const Color(0xFF7D6608),
              borderColor: const Color(0xFFF9E79F),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! Message sending failed.',
              icon: Icons.cancel,
              bgColor: const Color(0xFFFDEDEC),
              textColor: const Color(0xFF78281F),
              borderColor: const Color(0xFFF5B7B1),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! You successfully read this important alert message.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFD6EAF8),
              textColor: const Color(0xFF1F618D),
              borderColor: const Color(0xFF85C1E2),
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! You successfully read this message.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFD6EAF8),
              textColor: const Color(0xFF1F618D),
              borderColor: const Color(0xFF85C1E2),
            ),
            const SizedBox(height: 24),

            // Square Alerts
            const Text('Square Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('add .alert-square class to change the solid color.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildAlert(
              title: 'Welcome! Message has been sent.',
              icon: Icons.info,
              bgColor: Colors.blue,
              textColor: Colors.white,
              borderColor: Colors.blue,
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Danger! Your profile photo updated.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFFF6B6B),
              textColor: Colors.white,
              borderColor: const Color(0xFFFF6B6B),
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Success! Message has been sent.',
              icon: Icons.check_circle_outline,
              bgColor: const Color(0xFF51CF66),
              textColor: Colors.white,
              borderColor: const Color(0xFF51CF66),
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Info! You have got 5 new email.',
              icon: Icons.info_outline,
              bgColor: const Color(0xFF9B59B6),
              textColor: Colors.white,
              borderColor: const Color(0xFF9B59B6),
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Warning! Something went wrong. Please check.',
              icon: Icons.warning_amber,
              bgColor: const Color(0xFFFFC107),
              textColor: Colors.white,
              borderColor: const Color(0xFFFFC107),
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! Message sending failed.',
              icon: Icons.cancel,
              bgColor: const Color(0xFFE74C3C),
              textColor: Colors.white,
              borderColor: const Color(0xFFE74C3C),
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! You successfully read this important alert message.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFF34495E),
              textColor: Colors.white,
              borderColor: const Color(0xFF34495E),
              isSquare: true,
            ),
            const SizedBox(height: 8),
            _buildAlert(
              title: 'Error! You successfully read this message.',
              icon: Icons.error_outline,
              bgColor: const Color(0xFFD6EAF8),
              textColor: const Color(0xFF1F618D),
              borderColor: const Color(0xFF85C1E2),
              isSquare: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Moved to `alert_component_screen.dart`

// Moved to `avatar_component_screen.dart`

// ==================== BUTTON COMPONENT ====================
class ButtonComponentScreen extends StatelessWidget {
  const ButtonComponentScreen({super.key});

  Widget _buildSolidButton(String label, Color bgColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSquareButton(String label, Color bgColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLightButton(String label, Color bgColor, Color textColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String label, Color borderColor, Color textColor) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buttons Section
            const Text('Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Default button style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // Row 1
            Row(
              children: [
                _buildSolidButton('Primary', Colors.blue),
                const SizedBox(width: 8),
                _buildSolidButton('Secondary', const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildSolidButton('Success', const Color(0xFF51CF66)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 2
            Row(
              children: [
                _buildSolidButton('Danger', const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildSolidButton('Warning', const Color(0xFFFFC107)),
                const SizedBox(width: 8),
                _buildSolidButton('Info', const Color(0xFF9B59B6)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 3
            Row(
              children: [
                _buildSolidButton('Light', Colors.grey[100]!),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34495E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Dark',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Square Buttons Section
            const Text('Square Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('add .btn-square to change the style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // Row 1
            Row(
              children: [
                _buildSquareButton('Primary', Colors.blue),
                const SizedBox(width: 8),
                _buildSquareButton('Secondary', const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildSquareButton('Success', const Color(0xFF51CF66)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 2
            Row(
              children: [
                _buildSquareButton('Danger', const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildSquareButton('Warning', const Color(0xFFFFC107)),
                const SizedBox(width: 8),
                _buildSquareButton('Info', const Color(0xFF9B59B6)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 3
            Row(
              children: [
                _buildSquareButton('Light', Colors.grey[100]!),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34495E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Dark',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Buttons Light Section
            const Text('Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Button Light style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // Row 1
            Row(
              children: [
                _buildLightButton('Primary', const Color(0xFFD6EAF8), Colors.blue),
                const SizedBox(width: 8),
                _buildLightButton('Secondary', const Color(0xFFFDEDEC), const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildLightButton('Success', const Color(0xFFD5F4E6), const Color(0xFF51CF66)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 2
            Row(
              children: [
                _buildLightButton('Danger', const Color(0xFFFDEDEC), const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildLightButton('Warning', const Color(0xFFFEF5E7), const Color(0xFFFFC107)),
                const SizedBox(width: 8),
                _buildLightButton('Info', const Color(0xFFEBDEF0), const Color(0xFF9B59B6)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 3
            Row(
              children: [
                _buildLightButton('Light', Colors.grey[100]!, Colors.grey[600]!),
                const SizedBox(width: 8),
                _buildLightButton('Dark', const Color(0xFFD6EAF8), Colors.blue),
              ],
            ),
            const SizedBox(height: 32),

            // Outline Buttons Section
            const Text('Outline Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Default outline button style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // Row 1
            Row(
              children: [
                _buildOutlineButton('Primary', Colors.blue, Colors.blue),
                const SizedBox(width: 8),
                _buildOutlineButton('Secondary', const Color(0xFFFF6B6B), const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildOutlineButton('Success', const Color(0xFF51CF66), const Color(0xFF51CF66)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 2
            Row(
              children: [
                _buildOutlineButton('Danger', const Color(0xFFFF6B6B), const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildOutlineButton('Warning', const Color(0xFFFFC107), const Color(0xFFFFC107)),
                const SizedBox(width: 8),
                _buildOutlineButton('Info', const Color(0xFF9B59B6), const Color(0xFF9B59B6)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Row 3
            Row(
              children: [
                _buildOutlineButton('Light', Colors.grey[600]!, Colors.grey[600]!),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF34495E), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Dark',
                      style: TextStyle(color: Color(0xFF34495E), fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Button Sizes Section
            const Text('Button Sizes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('add .btn-lg, .btn-sm to change the style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // Large Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'Large Button',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Default Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'Default Button',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Small Button
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'Small Button',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Moved to `button_component_screen.dart`

// ==================== RADIO BUTTON COMPONENT ====================
class RadioButtonComponentScreen extends StatefulWidget {
  const RadioButtonComponentScreen({super.key});

  @override
  State<RadioButtonComponentScreen> createState() => _RadioButtonComponentScreenState();
}

class _RadioButtonComponentScreenState extends State<RadioButtonComponentScreen> {
  String selectedSquare = 'option1';
  String selectedCircle = 'option1';
  String selectedCircle2 = 'option1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio Button ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Square Radio
            const Text('Square Radio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[
              {'value': 'option1', 'label': 'Radio button 01'},
              {'value': 'option2', 'label': 'Radio button 02'},
              {'value': 'option3', 'label': 'Radio button 03'},
              {'value': 'option4', 'label': 'Radio button 04'},
            ].map((item) {
              final isSelected = selectedSquare == item['value'];
              return GestureDetector(
                onTap: () => setState(() => selectedSquare = item['value'] as String),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),

            // Circle Radio
            const Text('Circle Radio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[
              {'value': 'option1', 'label': 'Radio button 01'},
              {'value': 'option2', 'label': 'Radio button 02'},
              {'value': 'option3', 'label': 'Radio button 03'},
              {'value': 'option4', 'label': 'Radio button 04'},
            ].map((item) {
              final isSelected = selectedCircle == item['value'];
              return GestureDetector(
                onTap: () => setState(() => selectedCircle = item['value'] as String),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),

            // Circle Radio 2
            const Text('Circle Radio 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[
              {'value': 'option1', 'label': 'Radio button 01'},
              {'value': 'option2', 'label': 'Radio button 02'},
              {'value': 'option3', 'label': 'Radio button 03'},
              {'value': 'option4', 'label': 'Radio button 04'},
            ].map((item) {
              final isSelected = selectedCircle2 == item['value'];
              return GestureDetector(
                onTap: () => setState(() => selectedCircle2 = item['value'] as String),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Moved to `radio_button_component_screen.dart`

// ==================== BADGE COMPONENT ====================
class BadgeComponentScreen extends StatelessWidget {
  const BadgeComponentScreen({super.key});

  Widget _buildBadge({required String text, required Color backgroundColor, required Color textColor, bool isOutline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : backgroundColor,
        border: isOutline ? Border.all(color: backgroundColor, width: 1) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: isOutline ? backgroundColor : textColor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge '),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== BADGES SIZE ====================
            Text('Badges Size', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Default Bootstrap Badges', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildBadge(text: 'Primary', backgroundColor: const Color(0xFF3B82F6), textColor: Colors.white),
                _buildBadge(text: 'Secondary', backgroundColor: const Color(0xFFEF4444), textColor: Colors.white),
                _buildBadge(text: 'Success', backgroundColor: const Color(0xFF51CF66), textColor: Colors.white),
              ],
            ),
            const SizedBox(height: 32),

            // ==================== BADGES LIGHT ====================
            Text('Badges Light', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Default Bootstrap Badges', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildBadge(text: 'Primary', backgroundColor: const Color(0xFFD6E5FF), textColor: const Color(0xFF3B82F6)),
                _buildBadge(text: 'Secondary', backgroundColor: const Color(0xFFFFE5E5), textColor: const Color(0xFFEF4444)),
                _buildBadge(text: 'Success', backgroundColor: const Color(0xFFE5FFE5), textColor: const Color(0xFF51CF66)),
                _buildBadge(text: 'Danger', backgroundColor: const Color(0xFFFFE5E5), textColor: const Color(0xFFEF4444)),
                _buildBadge(text: 'Warning', backgroundColor: const Color(0xFFFFF3CD), textColor: const Color(0xFFFFC107)),
                _buildBadge(text: 'Info', backgroundColor: const Color(0xFFD1E7FF), textColor: const Color(0xFF0099FF)),
                _buildBadge(text: 'Light', backgroundColor: const Color(0xFFE9ECEF), textColor: const Color(0xFF6C757D)),
                _buildBadge(text: 'Dark', backgroundColor: const Color(0xFFE9ECEF), textColor: const Color(0xFF343A40)),
              ],
            ),
            const SizedBox(height: 32),

            // ==================== BADGES ====================
            Text('Badges', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Default Bootstrap Badges', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildBadge(text: 'Primary', backgroundColor: const Color(0xFF3B82F6), textColor: Colors.white),
                _buildBadge(text: 'Secondary', backgroundColor: const Color(0xFFEF4444), textColor: Colors.white),
                _buildBadge(text: 'Success', backgroundColor: const Color(0xFF51CF66), textColor: Colors.white),
                _buildBadge(text: 'Danger', backgroundColor: const Color(0xFFEF4444), textColor: Colors.white),
                _buildBadge(text: 'Warning', backgroundColor: const Color(0xFFFFC107), textColor: Colors.white),
                _buildBadge(text: 'Info', backgroundColor: const Color(0xFF0099FF), textColor: Colors.white),
                _buildBadge(text: 'Light', backgroundColor: const Color(0xFFE9ECEF), textColor: const Color(0xFF343A40)),
                _buildBadge(text: 'Dark', backgroundColor: const Color(0xFF343A40), textColor: Colors.white),
              ],
            ),
            const SizedBox(height: 32),

            // ==================== OUTLINE CIRCLE BADGE ====================
            Text('Outline Circle Badge', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('add .badge-circle to change the style', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildCircleBadge(number: 1, color: const Color(0xFFEF4444)),
                _buildCircleBadge(number: 2, color: const Color(0xFFEF4444)),
                _buildCircleBadge(number: 3, color: const Color(0xFFFFC107)),
                _buildCircleBadge(number: 4, color: const Color(0xFFFFC107)),
                _buildCircleBadge(number: 5, color: const Color(0xFF51CF66)),
                _buildCircleBadge(number: 6, color: const Color(0xFF51CF66)),
                _buildCircleBadge(number: 7, color: const Color(0xFF0099FF)),
                _buildCircleBadge(number: 8, color: const Color(0xFF0099FF)),
              ],
            ),
            const SizedBox(height: 32),

            // ==================== EXAMPLE BADGES ====================
            Text('Example Badges', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Primary', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('9', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Secondary', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC107),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('4', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9B59B6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Notification', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC107),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('4', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleBadge({required int number, required Color color}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}

// Moved to `badge_component_screen.dart`

// ==================== BUTTON GROUP COMPONENT ====================
class ButtonGroupComponentScreen extends StatefulWidget {
  const ButtonGroupComponentScreen({super.key});

  @override
  State<ButtonGroupComponentScreen> createState() => _ButtonGroupComponentScreenState();
}

class _ButtonGroupComponentScreenState extends State<ButtonGroupComponentScreen> {
  int selectedIndex = 0;
  String selectedSize = 'medium';
  String selectedDropdown = 'option1';

  Widget _buildButtonGroup({
    required List<String> labels,
    required int selected,
    required Function(int) onTap,
    double? width,
    double? height,
    double fontSize = 14,
  }) {
    return Container(
      width: width,
      height: height ?? 48,
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          ...List.generate(labels.length, (index) {
            final isLast = index == labels.length - 1;
            final isFirst = index == 0;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected == index ? Colors.blueAccent : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isFirst ? 6 : 0),
                      bottomLeft: Radius.circular(isFirst ? 6 : 0),
                      topRight: Radius.circular(isLast ? 6 : 0),
                      bottomRight: Radius.circular(isLast ? 6 : 0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected == index ? Colors.white : Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ].fold<List<Widget>>([], (acc, widget) {
          if (acc.isNotEmpty) {
            acc.add(Container(width: 1, color: Colors.blueAccent));
          }
          acc.add(widget);
          return acc;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Group ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Default Button Group
            const Text('Button Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Default Button group style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildButtonGroup(
              labels: ['Left', 'Middle', 'Right'],
              selected: selectedIndex,
              onTap: (index) => setState(() => selectedIndex = index),
            ),
            const SizedBox(height: 24),

            // Button Toolbar
            const Text('Button Toolbar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Default Button toolbar style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildButtonGroup(
                  labels: ['1', '2', '3', '4'],
                  selected: 0,
                  onTap: (_) {},
                  width: 160,
                ),
                _buildButtonGroup(
                  labels: ['5', '6', '7'],
                  selected: 0,
                  onTap: (_) {},
                  width: 130,
                ),
                _buildButtonGroup(
                  labels: ['8'],
                  selected: 0,
                  onTap: (_) {},
                  width: 60,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Button Sizing
            const Text('Button Sizing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Default Button sizing style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildButtonGroup(
                  labels: ['Left', 'Middle', 'Right'],
                  selected: 0,
                  onTap: (_) {},
                  height: 36,
                  fontSize: 12,
                ),
                _buildButtonGroup(
                  labels: ['Left', 'Middle', 'Right'],
                  selected: 0,
                  onTap: (_) {},
                  height: 44,
                  fontSize: 13,
                ),
                _buildButtonGroup(
                  labels: ['Left', 'Middle', 'Right'],
                  selected: 0,
                  onTap: (_) {},
                  height: 52,
                  fontSize: 14,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Button Nesting
            const Text('Button Nesting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Default Button nesting style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildButtonGroup(
                    labels: ['1', '2', 'Dropdown ▼'],
                    selected: 0,
                    onTap: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Vertical Variation
            const Text('Vertical Variation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Default Button vertical variation style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  ...List.generate(3, (index) {
                    final isFirst = index == 0;
                    final isLast = index == 2;
                    return GestureDetector(
                      onTap: () => setState(() => selectedSize = 'btn$index'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedSize == 'btn$index' ? Colors.blueAccent : Colors.white,
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isFirst ? 6 : 0),
                            topRight: Radius.circular(isFirst ? 6 : 0),
                            bottomLeft: Radius.circular(isLast ? 6 : 0),
                            bottomRight: Radius.circular(isLast ? 6 : 0),
                          ),
                        ),
                        child: Text(
                          'Button',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedSize == 'btn$index' ? Colors.white : Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ].fold<List<Widget>>([], (acc, widget) {
                  if (acc.isNotEmpty) {
                    acc.add(Container(height: 1, color: Colors.blueAccent));
                  }
                  acc.add(widget);
                  return acc;
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Vertical Dropdown Variation
            const Text('Vertical Dropdown Variation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Default Button vertical variation style', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  ...['Button', 'Button', 'Dropdown ▼', 'Button', 'Button'].asMap().entries.map((e) {
                    final index = e.key;
                    final label = e.value;
                    final isFirst = index == 0;
                    final isLast = index == 4;
                    return GestureDetector(
                      onTap: () => setState(() => selectedDropdown = 'item$index'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedDropdown == 'item$index' ? Colors.blueAccent : Colors.white,
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isFirst ? 6 : 0),
                            topRight: Radius.circular(isFirst ? 6 : 0),
                            bottomLeft: Radius.circular(isLast ? 6 : 0),
                            bottomRight: Radius.circular(isLast ? 6 : 0),
                          ),
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedDropdown == 'item$index' ? Colors.white : Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList().fold<List<Widget>>([], (acc, widget) {
                    if (acc.isNotEmpty) {
                      acc.add(Container(height: 1, color: Colors.blueAccent));
                    }
                    acc.add(widget);
                    return acc;
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Moved to `button_group_component_screen.dart`

// ==================== CARD COMPONENT ====================
class CardComponentScreen extends StatelessWidget {
  const CardComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Card Styles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Special title treatment (white card with tabs)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.grey.withAlpha((0.12 * 255).round()), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)), child: const Text('Active', style: TextStyle(fontWeight: FontWeight.w600))),
                        const SizedBox(width: 8),
                        TextButton(onPressed: () {}, child: const Text('Link')),
                        const SizedBox(width: 8),
                        TextButton(onPressed: null, child: const Text('Disabled')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('With supporting text below as a natural lead-in to additional content.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Go somewhere'),
                    ),
                  ],
                ),
              ),
            ),

            // Moved to `card_component_screen.dart`

          ],
        ),
      ),
    );
  }
}

// Moved to `card_component_screen.dart`

// ==================== CHARTS COMPONENT ====================
class ChartsComponentScreen extends StatelessWidget {
  const ChartsComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charts ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pie Chart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: SfCircularChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.bottom),
                      series: <CircularSeries>[
                        PieSeries<_ChartData, String>(
                          dataSource: _getChartData(),
                          xValueMapper: (d, _) => d.x,
                          yValueMapper: (d, _) => d.y,
                          pointColorMapper: (d, _) => d.color,
                          dataLabelSettings: const DataLabelSettings(isVisible: false),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text('Doughnut Chart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: SfCircularChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.bottom),
                      series: <CircularSeries>[
                        DoughnutSeries<_ChartData, String>(
                          dataSource: _getChartData(),
                          xValueMapper: (d, _) => d.x,
                          yValueMapper: (d, _) => d.y,
                          pointColorMapper: (d, _) => d.color,
                          innerRadius: '60%',
                          dataLabelSettings: const DataLabelSettings(isVisible: false),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text('Polar Chart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(
                children: [
                  SizedBox(
                    height: 320,
                    child: CustomPaint(
                      painter: _PolarChartPainter(_getChartData()),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chart helper data & painter
class _ChartData {
  final String x;
  final double y;
  final Color color;
  _ChartData(this.x, this.y, this.color);
}

List<_ChartData> _getChartData() {
  return [
    _ChartData('Red', 20, const Color(0xFFFF6B81)),
    _ChartData('Blue', 50, const Color(0xFF2F88FF)),
    _ChartData('Yellow', 45, const Color(0xFFFFD16B)),
    _ChartData('grey', 90, const Color(0xFF66C2BF)),
  ];
}

class _PolarChartPainter extends CustomPainter {
  final List<_ChartData> data;
  _PolarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2 - 8;
    final maxValue = data.map((d) => d.y).reduce(math.max);

    // draw concentric circles
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withAlpha((0.12 * 255).round())
      ..strokeWidth = 1;

    final rings = 4;
    for (int i = 1; i <= rings; i++) {
      final r = maxRadius * i / rings;
      canvas.drawCircle(center, r, gridPaint);
    }

    final ringThickness = maxRadius / (data.length + 1);

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final radius = maxRadius - i * (ringThickness + 8);
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = ringThickness
        ..strokeCap = StrokeCap.butt
        ..color = d.color;

      final sweep = (d.y / maxValue) * 2 * math.pi;
      canvas.drawArc(rect, -math.pi / 2, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== DROPDOWN COMPONENT ====================
class DropdownComponentScreen extends StatefulWidget {
  const DropdownComponentScreen({super.key});

  @override
  State<DropdownComponentScreen> createState() => _DropdownComponentScreenState();
}

class _DropdownComponentScreenState extends State<DropdownComponentScreen> {
  String? selectedValue = 'Option 1';

  Widget _buildCard({required String title, required String description, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: child),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dropdown ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dropdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildCard(
              title: 'Basic Dropdown',
              description: 'A dropdown menu is a toggleable menu that allows the user to choose one value from a predefined list',
              child: PopupMenuButton<String>(
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropdown button', style: TextStyle(color: Colors.white)),
                ),
                onSelected: (_) {},
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Action', child: Text('Action')),
                  PopupMenuItem(value: 'Another', child: Text('Another action')),
                  PopupMenuItem(value: 'Something', child: Text('Something else here')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Dropdown Divider',
              description: 'The .dropdown-divider class is used to separate links inside the dropdown menu with a thin horizontal border',
              child: PopupMenuButton<String>(
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropdown button', style: TextStyle(color: Colors.white)),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Action', child: Text('Action')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'Another', child: Text('Another action')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Dropdown Header',
              description: 'The .dropdown-header class is used to add headers inside the dropdown menu',
              child: PopupMenuButton<String>(
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropdown button', style: TextStyle(color: Colors.white)),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(enabled: false, child: Text('Dropdown Header', style: TextStyle(fontWeight: FontWeight.bold))),
                  PopupMenuItem(value: 'Action', child: Text('Action')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Disable And Active Items',
              description: 'The .dropdown-header class is used to add headers inside the dropdown menu',
              child: PopupMenuButton<String>(
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropdown button', style: TextStyle(color: Colors.white)),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Active', child: Row(children: [Icon(Icons.check, color: Colors.green, size: 16), SizedBox(width: 8), Text('Active')],)),
                  PopupMenuItem(enabled: false, child: Text('Disabled')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Align Right',
              description: 'To right-align the dropdown, add the .dropdown-menu-end class to the element with dropdown-menu',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Dropdown button', style: TextStyle(color: Colors.white)),
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Action', child: Text('Action')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Dropup',
              description: 'The .dropup class makes the dropdown menu expand upwards instead of downwards',
              child: PopupMenuButton<String>(
                offset: const Offset(0, -180),
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropup -', style: TextStyle(color: Colors.white)),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Dropup', child: Text('Dropup')),
                  PopupMenuItem(value: 'Split', child: Text('Split dropup')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Dropright',
              description: 'Trigger dropdown menus at the right of the elements by adding .dropright to the parent element',
              child: PopupMenuButton<String>(
                offset: const Offset(120, 0),
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropright', style: TextStyle(color: Colors.white)),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Right', child: Text('Dropright')),
                  PopupMenuItem(value: 'Split', child: Text('Split dropright')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              title: 'Dropstart',
              description: 'Trigger dropdown menus at the left of the elements by adding .dropstart to the parent element',
              child: PopupMenuButton<String>(
                offset: const Offset(-140, 0),
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Dropstart', style: TextStyle(color: Colors.white)),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Start', child: Text('Dropstart')),
                  PopupMenuItem(value: 'Split', child: Text('Split dropstart')),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ==================== INPUT COMPONENT ====================
class InputComponentScreen extends StatefulWidget {
  const InputComponentScreen({super.key});

  @override
  State<InputComponentScreen> createState() => _InputComponentScreenState();
}

class _InputComponentScreenState extends State<InputComponentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController textareaController = TextEditingController();

  bool showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    phoneController.dispose();
    dateController.dispose();
    textareaController.dispose();
    super.dispose();
  }

  Widget _sectionCard({required String title, required Widget child, String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  InputDecoration _modernDecoration({required String hint, IconData? icon, double radius = 8}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey[600]) : null,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.lightBlueAccent)),
    );
  }

  InputDecoration _minimalDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey[600], size: 18) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent)),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() => dateController.text = '${picked.day}/${picked.month}/${picked.year}');
    }
  }

  Widget _fileUploadTile() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: Text('Upload File +', style: TextStyle(color: Colors.grey[700]))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Fields
            _sectionCard(
              title: 'Modern Fields',
              subtitle: null,
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: _modernDecoration(hint: 'Name', icon: Icons.person_outline)),
                  const SizedBox(height: 12),
                  TextField(controller: emailController, decoration: _modernDecoration(hint: 'Email', icon: Icons.email_outlined)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: _modernDecoration(hint: 'Password', icon: Icons.lock).copyWith(suffixIcon: IconButton(onPressed: () => setState(() => showPassword = !showPassword), icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility))),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: websiteController, decoration: _modernDecoration(hint: 'Website', icon: Icons.language)),
                  const SizedBox(height: 12),
                  TextField(controller: phoneController, decoration: _modernDecoration(hint: 'Phone', icon: Icons.phone)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: _modernDecoration(hint: 'dd/mm/yyyy --:--', icon: Icons.calendar_today).copyWith(suffixIcon: IconButton(onPressed: () => _pickDate(context), icon: const Icon(Icons.calendar_today))),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: textareaController, maxLines: 4, decoration: _modernDecoration(hint: 'Textarea')),
                  const SizedBox(height: 12),
                  _fileUploadTile(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            // Modern Fields With Radius
            _sectionCard(
              title: 'Modern Fields With Radius',
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: _modernDecoration(hint: 'Name', icon: Icons.person_outline, radius: 30)),
                  const SizedBox(height: 12),
                  TextField(controller: emailController, decoration: _modernDecoration(hint: 'Email', icon: Icons.email_outlined, radius: 30)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: _modernDecoration(hint: 'Password', icon: Icons.lock, radius: 30).copyWith(suffixIcon: IconButton(onPressed: () => setState(() => showPassword = !showPassword), icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility))),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: websiteController, decoration: _modernDecoration(hint: 'Website', icon: Icons.language, radius: 30)),
                  const SizedBox(height: 12),
                  TextField(controller: phoneController, decoration: _modernDecoration(hint: 'Phone', icon: Icons.phone, radius: 30)),
                  const SizedBox(height: 12),
                  TextField(controller: dateController, readOnly: true, decoration: _modernDecoration(hint: 'dd/mm/yyyy --:--', icon: Icons.calendar_today, radius: 30).copyWith(suffixIcon: IconButton(onPressed: () => _pickDate(context), icon: const Icon(Icons.calendar_today)))),
                  const SizedBox(height: 12),
                  TextField(controller: textareaController, maxLines: 4, decoration: _modernDecoration(hint: 'Textarea', radius: 12)),
                  const SizedBox(height: 12),
                  _fileUploadTile(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            // Minimalist Fields
            _sectionCard(
              title: 'Minimalist Fields',
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: _minimalDecoration(hint: 'Name', icon: Icons.person_outline)),
                  const SizedBox(height: 12),
                  TextField(controller: emailController, decoration: _minimalDecoration(hint: 'Email', icon: Icons.email_outlined)),
                  const SizedBox(height: 12),
                  TextField(controller: passwordController, obscureText: !showPassword, decoration: _minimalDecoration(hint: 'Password', icon: Icons.lock).copyWith(suffixIcon: IconButton(onPressed: () => setState(() => showPassword = !showPassword), icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility)))),
                  const SizedBox(height: 12),
                  TextField(controller: websiteController, decoration: _minimalDecoration(hint: 'Website', icon: Icons.language)),
                  const SizedBox(height: 12),
                  TextField(controller: phoneController, decoration: _minimalDecoration(hint: 'Phone', icon: Icons.phone)),
                  const SizedBox(height: 12),
                  TextField(controller: dateController, readOnly: true, decoration: _minimalDecoration(hint: 'dd/mm/yyyy --:--', icon: Icons.calendar_today).copyWith(suffixIcon: IconButton(onPressed: () => _pickDate(context), icon: const Icon(Icons.calendar_today)))),
                  const SizedBox(height: 12),
                  TextField(controller: textareaController, maxLines: 4, decoration: _minimalDecoration(hint: 'Textarea')),
                  const SizedBox(height: 12),
                  _fileUploadTile(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ==================== TIMELINE COMPONENT ====================
class TimelineComponentScreen extends StatelessWidget {
  const TimelineComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timeline ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Default Timeline
            const Text('Default Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: ['11 March 2020', '11 March 2020', '11 March 2020', '11 March 2020'].map((date) {
                final idx = ['11 March 2020', '11 March 2020', '11 March 2020', '11 March 2020'].indexOf(date);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                        if (idx != 3) Container(width: 2, height: 80, color: Colors.grey.shade300)
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(date, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            const Text('Some text goes here', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit necessitatibus adipisci.', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Timeline Panel (colored cards)
            const Text('Timeline Panel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: [
                _TimelinePanelItem(date: '11 March 2020', title: 'Some text goes here', description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit necessitatibus adipisci.', color: Colors.lightBlue),
                _TimelinePanelItem(date: '11 March 2020', title: 'Some text goes here', description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit necessitatibus adipisci.', color: Colors.redAccent),
                _TimelinePanelItem(date: '11 March 2020', title: 'Some text goes here', description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit necessitatibus adipisci.', color: Colors.green),
                _TimelinePanelItem(date: '11 March 2020', title: 'Some text goes here', description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit necessitatibus adipisci.', color: const Color(0xFF9B59B6)),
                _TimelinePanelItem(date: '11 March 2020', title: 'Some text goes here', description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit necessitatibus adipisci.', color: Colors.amber),
              ],
            ),

            const SizedBox(height: 24),

            // Timeline Number
            const Text('Timeline Number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: [
                _NumberedTimelineItem(number: 1, title: 'Project Analysis', subtitle: 'We at Dream Spa provide various services to the nature of the clients. we can talk.'),
                _NumberedTimelineItem(number: 2, title: 'Project Analysis', subtitle: 'We at Dream Spa provide various services to the nature of the clients. we can talk.'),
                _NumberedTimelineItem(number: 3, title: 'Project Analysis', subtitle: 'We at Dream Spa provide various services to the nature of the clients. we can talk.'),
                _NumberedTimelineItem(number: 4, title: '', subtitle: '', showImageRow: true),
                _NumberedTimelineItem(number: 5, title: 'Project Analysis', subtitle: 'We at Dream Spa provide various services to the nature of the clients. we can talk.'),
              ],
            ),

            const SizedBox(height: 24),

            // Timeline Status
            const Text('Timeline Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.lightBlue, borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Delivered', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Aug 8,per2022-12:20pm', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _TimelineStatusItem(title: 'Order Recived', time: 'Aug 8,2022-12:20pm', done: true),
                    _TimelineStatusItem(title: 'Order Confirmed', time: 'Aug 8,2022-12:20pm'),
                    _TimelineStatusItem(title: 'Order Processed', time: 'Aug 8,2022-12:20pm'),
                    _TimelineStatusItem(title: 'Order Delivered', time: 'Aug 8,2022-12:20pm'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelinePanelItem extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final Color color;

  const _TimelinePanelItem({required this.date, required this.title, required this.description, required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            Container(width: 2, height: 120, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withAlpha(200), borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12)), const SizedBox(height: 6), Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(description, style: const TextStyle(color: Colors.white70, fontSize: 12))]),
            ),
          ),
        ),
      ],
    );
  }
}

class _NumberedTimelineItem extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final bool showImageRow;
  const _NumberedTimelineItem({required this.number, required this.title, required this.subtitle, this.showImageRow = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle), child: Center(child: Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            Container(width: 2, height: 12, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: showImageRow
              ? Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
                  child: Row(children: [
                    Expanded(child: Container(height: 120, margin: const EdgeInsets.all(6), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade300))),
                    Expanded(child: Container(height: 120, margin: const EdgeInsets.all(6), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade300))),
                  ]),
                )
              : Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600]))]),
                ),
        ),
      ],
    );
  }
}

class _TimelineStatusItem extends StatelessWidget {
  final String title;
  final String time;
  final bool done;
  const _TimelineStatusItem({required this.title, required this.time, this.done = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: done ? Colors.blue : Colors.white, shape: BoxShape.circle, border: Border.all(color: done ? Colors.blue : Colors.grey.shade300))),
        Container(width: 2, height: 48, color: Colors.grey.shade200),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: done ? FontWeight.bold : FontWeight.normal, color: done ? Colors.black : Colors.grey[800])), const SizedBox(height: 6), Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12))])),
    ]);
  }
}

// ==================== LIST GROUP COMPONENT ====================
class ListGroupComponentScreen extends StatelessWidget {
  const ListGroupComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final avatarUrls = [
      'https://randomuser.me/api/portraits/men/32.jpg',
      'https://randomuser.me/api/portraits/men/33.jpg',
      'https://randomuser.me/api/portraits/men/34.jpg',
      'https://randomuser.me/api/portraits/women/35.jpg',
      'https://randomuser.me/api/portraits/men/36.jpg',
      'https://randomuser.me/api/portraits/men/37.jpg',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('List Group ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Basic List Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(children: [
                ListTile(leading: const Icon(Icons.view_column_outlined, color: Colors.grey), title: const Text('Accordion'), trailing: const Icon(Icons.chevron_right), onTap: () => _showItemDetail(context, 'Accordion')),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(leading: const Icon(Icons.info_outline, color: Colors.grey), title: const Text('Alert'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertComponentScreen()))),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(leading: const Icon(Icons.input, color: Colors.grey), title: const Text('Input'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InputComponentScreen()))),
              ]),
            ),

            const SizedBox(height: 16),
            const Text('Image List Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(children: [
                for (int i = 0; i < avatarUrls.length; i++) ...[
                  ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrls[i])),
                    title: Text(['James', 'Robert', 'John', 'David', 'Richard', 'Joseph'][i]),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showImageDetail(context, avatarUrls[i], ['James', 'Robert', 'John', 'David', 'Richard', 'Joseph'][i]),
                  ),
                  if (i != avatarUrls.length - 1) Divider(height: 1, color: Colors.grey[200]),
                ]
              ]),
            ),

            const SizedBox(height: 16),
            const Text('Text List Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(children: [
                ListTile(title: const Text('Notification'), trailing: const Icon(Icons.chevron_right), onTap: () => _showItemDetail(context, 'Notification')),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(title: const Text('Settings'), trailing: const Icon(Icons.chevron_right), onTap: () => _showItemDetail(context, 'Settings')),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(title: const Text('Update'), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)), child: const Text('8', style: TextStyle(color: Colors.white, fontSize: 12))), onTap: () => _showItemDetail(context, 'Update')),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(title: const Text('Email'), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)), child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12))), onTap: () => _showItemDetail(context, 'Email')),
              ]),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void _showItemDetail(BuildContext context, String title) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text('Details for $title go here. Add more info or navigation.'),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))),
      ]),
    ),
  );
}

void _showImageDetail(BuildContext context, String url, String name) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: const EdgeInsets.all(16), child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
        Image.network(url, width: 240, height: 240, fit: BoxFit.cover),
        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')))),
        const SizedBox(height: 12),
      ]),
    ),
  );
}

// ==================== MODAL COMPONENT ====================
class ModalComponentScreen extends StatelessWidget {
  const ModalComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modal ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bootstrap Modal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showBasicModal(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('BASIC MODAL', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showLongContentModal(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('LONG CONTENT MODAL', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCenteredModal(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('MODAL CENTERED', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSizedModal(context, large: true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('LARGE MODAL', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSizedModal(context, large: false),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text('SMALL MODAL', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== NEW COMPONENT SCREENS ====================

class ProgressbarComponentScreen extends StatelessWidget {
  const ProgressbarComponentScreen({super.key});

  Widget _card({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _bar({required double value, Color color = Colors.lightBlue, double height = 8.0, bool striped = false}) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(6))),
          FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
          ),
          if (striped)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Row(children: List.generate(30, (i) => Container(width: 12, height: height + 4, margin: const EdgeInsets.symmetric(horizontal: 4), color: Colors.white.withAlpha((0.18 * 255).round())))),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _skillRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text('${(value * 100).round()}%')]),
        const SizedBox(height: 6),
        _bar(value: value, color: color, height: 12),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progressbar ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(title: 'Default Progress Bars', children: [
            const SizedBox(height: 6),
            _bar(value: 0.75),
            const SizedBox(height: 12),
            _bar(value: 0.45),
          ]),

          _card(title: 'Striped Progress Bar', children: [
            const SizedBox(height: 6),
            _bar(value: 0.7, color: Colors.purple, striped: true, height: 12),
          ]),

          _card(title: 'Colored Progress Bar', children: [
            const SizedBox(height: 6),
            _bar(value: 0.72, color: const Color(0xFFFF6B6B)),
            const SizedBox(height: 8),
            _bar(value: 0.55, color: const Color(0xFF8E6CF2)),
            const SizedBox(height: 8),
            _bar(value: 0.35, color: const Color(0xFF66C2BF)),
            const SizedBox(height: 8),
            _bar(value: 0.45, color: const Color(0xFF2F88FF)),
            const SizedBox(height: 8),
            _bar(value: 0.95, color: const Color(0xFFFFB020)),
          ]),

          _card(title: 'Different Bar Sizes', children: [
            const SizedBox(height: 6),
            _bar(value: 0.6, height: 6, color: Colors.redAccent),
            const SizedBox(height: 8),
            _bar(value: 0.5, height: 10, color: Colors.purple),
            const SizedBox(height: 8),
            _bar(value: 0.36, height: 14, color: Colors.green),
            const SizedBox(height: 8),
            _bar(value: 0.82, height: 18, color: Colors.orange),
          ]),

          _card(title: 'Skill Bars', children: [
            const SizedBox(height: 6),
            _skillRow('Photoshop', 0.85, const Color(0xFFFF6B6B)),
            _skillRow('Code editor', 0.9, const Color(0xFF8E6CF2)),
            _skillRow('Illustrator', 0.65, const Color(0xFF66C2BF)),
          ]),
        ]),
      ),
    );
  }
}

class SocialComponentScreen extends StatelessWidget {
  const SocialComponentScreen({super.key});

  Widget _roundedIcon(IconData icon, Color bg) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _circleIcon(IconData icon, Color bg) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _socialButton(BuildContext context, IconData icon, String label, Color color) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double gap = 8;
    final socialButtons = [
      {'icon': Icons.facebook, 'label': 'Facebook', 'color': const Color(0xFF385898)},
      {'icon': Icons.business, 'label': 'LinkedIn', 'color': const Color(0xFF0A66C2)},
      {'icon': Icons.chat_bubble, 'label': 'Twitter', 'color': const Color(0xFF1DA1F2)},
      {'icon': Icons.chat, 'label': 'WhatsApp', 'color': const Color(0xFF25D366)},
      {'icon': Icons.email, 'label': 'Email', 'color': const Color(0xFF00AEEF)},
      {'icon': Icons.phone, 'label': 'Phone', 'color': const Color(0xFFFF5722)},
      {'icon': Icons.g_mobiledata, 'label': 'Google', 'color': const Color(0xFF4285F4)},
      {'icon': Icons.push_pin, 'label': 'Pinterest', 'color': const Color(0xFFC8232C)},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Social Button')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Icons Rounded', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Row(children: [
              _roundedIcon(Icons.facebook, const Color(0xFF385898)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.chat_bubble, const Color(0xFF1DA1F2)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.g_mobiledata, const Color(0xFF4285F4)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.push_pin, const Color(0xFFC8232C)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.business, const Color(0xFF0A66C2)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.chat, const Color(0xFF25D366)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.phone, const Color(0xFFFF5722)),
              const SizedBox(width: 8),
              _roundedIcon(Icons.email, const Color(0xFF00AEEF)),
            ]),
          ),

          const SizedBox(height: 16),
          const Text('Social Buttons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Column(children: [
              for (int i = 0; i < socialButtons.length; i += 2) ...[
                Row(children: [
                  Expanded(child: _socialButton(context, socialButtons[i]['icon'] as IconData, socialButtons[i]['label'] as String, socialButtons[i]['color'] as Color)),
                  SizedBox(width: gap),
                  if (i + 1 < socialButtons.length) Expanded(child: _socialButton(context, socialButtons[i + 1]['icon'] as IconData, socialButtons[i + 1]['label'] as String, socialButtons[i + 1]['color'] as Color)) else const Expanded(child: SizedBox()),
                ]),
                const SizedBox(height: 8),
              ],
            ]),
          ),

          const SizedBox(height: 16),
          const Text('Icons Circle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Row(children: [
              _circleIcon(Icons.facebook, const Color(0xFF385898)),
              const SizedBox(width: 8),
              _circleIcon(Icons.chat_bubble, const Color(0xFF1DA1F2)),
              const SizedBox(width: 8),
              _circleIcon(Icons.g_mobiledata, const Color(0xFF4285F4)),
              const SizedBox(width: 8),
              _circleIcon(Icons.push_pin, const Color(0xFFC8232C)),
              const SizedBox(width: 8),
              _circleIcon(Icons.business, const Color(0xFF0A66C2)),
              const SizedBox(width: 8),
              _circleIcon(Icons.chat, const Color(0xFF25D366)),

              const SizedBox(width: 8),
              _circleIcon(Icons.phone, const Color(0xFFFF5722)),
              const SizedBox(width: 8),
              _circleIcon(Icons.email, const Color(0xFF00AEEF)),
            ]),
          ),

          const SizedBox(height: 16),
          const Text('Icon Sizes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF385898), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.facebook, color: Colors.white, size: 22)),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF1DA1F2), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.chat_bubble, color: Colors.white, size: 18)),

              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF4285F4), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.g_mobiledata, color: Colors.white, size: 16)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class TypographyComponentScreen extends StatelessWidget {
  const TypographyComponentScreen({super.key});

  Widget _card({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lorem = 'Ambitioni dedisse scripsisse iudicaretur. Cras mattis iudicium purus sit amet fermentum. Donec sed odio operae, eu vulputate felis rhoncus.';

    return Scaffold(
      appBar: AppBar(title: const Text('Typography')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(
              title: 'Typography',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('h1. Bootstrap heading', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('h2. Bootstrap heading', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('h3. Bootstrap heading', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('h4. Bootstrap heading', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('h5. Bootstrap heading', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('h6. Bootstrap heading', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text('Paragraph With Justify', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(lorem, textAlign: TextAlign.justify, style: GoogleFonts.poppins(color: Colors.grey[700])),
              ])),

          _card(
              title: 'Alignment Text',
              child: Column(children: [
                Text('Use tags text-start, text-center, text-end', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: Align(alignment: Alignment.centerLeft, child: const Text('Left aligned text on all viewport sizes.'))),
                  Expanded(child: Align(alignment: Alignment.center, child: const Text('Center aligned text on all viewport sizes.'))),
                  Expanded(child: Align(alignment: Alignment.centerRight, child: const Text('Right aligned text on all viewport sizes.'))),
                ])
              ])),

          _card(
              title: 'View Port Text',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Use tags text-sm-start, text-md-start, text-lg-start, text-xl-start for get desire text.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 8),
                const Text('Left aligned text on viewports sized SM (small) or wider.'),
                const SizedBox(height: 6),
                const Text('Left aligned text on viewports sized MD (medium) or wider.'),
                const SizedBox(height: 6),
                const Text('Left aligned text on viewports sized LG (large) or wider.'),
                const SizedBox(height: 6),
                const Text('Left aligned text on viewports sized XL (extra-large) or wider.'),
              ])),

          _card(
              title: 'Font Weight And Italics',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 4),
                Text('Bold text.', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Normal weight text.', style: GoogleFonts.poppins(fontWeight: FontWeight.normal)),
                const SizedBox(height: 6),
                Text('Italic text.', style: GoogleFonts.poppins(fontStyle: FontStyle.italic)),
              ])),

          _card(
              title: 'Text Colors',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('This is an example of muted text. Add classtext-muted', style: GoogleFonts.poppins(color: Colors.grey[500])),
                const SizedBox(height: 6),
                Text('This is an example of primary text. Add classtext-primary', style: GoogleFonts.poppins(color: Theme.of(context).primaryColor)),
                const SizedBox(height: 6),
                Text('This is an example of success text. Add classtext-success', style: GoogleFonts.poppins(color: Colors.green)),
                const SizedBox(height: 6),
                Text('This is an example of info text. Add classtext-info', style: GoogleFonts.poppins(color: Colors.teal)),
                const SizedBox(height: 6),
                Text('This is an example of warning text. Add classtext-warning', style: GoogleFonts.poppins(color: Colors.orange)),
                const SizedBox(height: 6),
                Text('This is an example of danger text. Add classtext-danger', style: GoogleFonts.poppins(color: Colors.red)),
              ])),

          _card(
              title: 'Address',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Twitter, Inc.'),
                const SizedBox(height: 4),
                const Text('795 Folsom Ave, Suite 600'),
                const SizedBox(height: 4),
                const Text('San Francisco, CA 94107'),
                const SizedBox(height: 6),
                const Text('P: (123) 456-7890'),
                const SizedBox(height: 8),
                const Text('George Belly'),
                const SizedBox(height: 4),
                Text('[email protected]', style: TextStyle(color: Theme.of(context).primaryColor)),
              ])),

          _card(
              title: 'Blockquotes',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante.'),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: Text('- Someone famous in Source Title', style: GoogleFonts.poppins(color: Colors.grey[600], fontStyle: FontStyle.italic)))
              ])),

          _card(
              title: 'OL Listing',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('1. Lorem ipsum dolor sit amet'),
                const SizedBox(height: 6),
                const Text('2. Consectetur adipiscing elit'),
                const SizedBox(height: 6),
                const Text('3. Integer molestie lorem at massa'),
              ])),

          _card(
              title: 'UI Listing',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: const [Icon(Icons.brightness_1, size: 8), SizedBox(width: 8), Expanded(child: Text('Lorem ipsum dolor sit amet'))]),
                const SizedBox(height: 6),
                Row(children: const [Icon(Icons.brightness_1, size: 8), SizedBox(width: 8), Expanded(child: Text('Consectetur adipiscing elit'))]),
                const SizedBox(height: 6),
                Row(children: const [Icon(Icons.brightness_1, size: 8), SizedBox(width: 8), Expanded(child: Text('Integer molestie lorem at massa'))]),
              ])),

          _card(
              title: 'Fancy Listing 1',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: const [Icon(Icons.chevron_right, color: Colors.grey, size: 18), SizedBox(width: 8), Expanded(child: Text('Lorem ipsum dolor sit amet'))]),
                const SizedBox(height: 6),
                Row(children: const [Icon(Icons.chevron_right, color: Colors.grey, size: 18), SizedBox(width: 8), Expanded(child: Text('Consectetur adipiscing elit'))]),
                const SizedBox(height: 6),
                Row(children: const [Icon(Icons.chevron_right, color: Colors.grey, size: 18), SizedBox(width: 8), Expanded(child: Text('Integer molestie lorem at massa'))]),
              ])),
        ]),
      ),
    );
  }
}

class ToastComponentScreen extends StatelessWidget {
  const ToastComponentScreen({super.key});

  Widget _toastBox({required String title, required String time, Color? color, bool whiteText = false}) {
    final bool isColored = color != null;
    final textColor = whiteText || isColored ? Colors.white : Colors.black87;
    final subColor = whiteText || isColored ? Colors.white70 : Colors.grey[600];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: isColored ? Colors.white24 : Colors.lightBlue, borderRadius: BorderRadius.circular(6)),
            alignment: Alignment.center,
            child: Text('B', style: TextStyle(color: isColored ? Colors.white : Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(time, style: TextStyle(color: subColor, fontSize: 12))]),
          ),
          GestureDetector(onTap: () {}, child: Icon(Icons.close, color: isColored ? Colors.white70 : Colors.grey[600])),
        ],
      ),
    );
  }

  void _showColoredSnack(BuildContext context, String text, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: background));
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'Default': null,
      'Primary': Colors.lightBlue,
      'Secondary': Colors.redAccent.shade200,
      'Success': Colors.green.shade300,
      'Warning': Colors.orange.shade400,
      'Danger': Colors.red.shade400,
      'Info': Colors.purple.shade300,
      'Dark': Colors.indigo.shade900,
    };

    final liveButtons = [
      Colors.lightBlue,
      Colors.redAccent.shade200,
      Colors.green.shade300,
      Colors.orange.shade400,
      Colors.red.shade400,
      Colors.purple.shade300,
      Colors.indigo.shade900,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Toast ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Toast
          Text('Toast', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _toastBox(title: 'Bootstrap 5', time: '11 min ago'),
          const SizedBox(height: 16),

          // Translucent Toast
          Text('Translucent Toast', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.indigo.shade900, borderRadius: BorderRadius.circular(8)),
            child: _toastBox(title: 'Bootstrap 5', time: '11 min ago'),
          ),
          const SizedBox(height: 16),

          // Different Color Toasts
          Text('Different Color Toast', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            children: colors.entries.map((entry) {
              final name = entry.key;
              final color = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: color == null
                    ? _toastBox(title: 'Toast Default', time: '11 min ago')
                    : _toastBox(title: 'Toast $name', time: '11 min ago', color: color, whiteText: true),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),
          // Live Toast
          Text('Live Toast', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            children: liveButtons.map((c) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: c, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  onPressed: () => _showColoredSnack(context, 'Show live toast', c),
                  child: const Text('Show live toast', style: TextStyle(color: Colors.white)),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
}

class TreeNode {
  final String title;
  final List<TreeNode> children;
  const TreeNode(this.title, [this.children = const []]);
}

class TreeviewComponentScreen extends StatefulWidget {
  const TreeviewComponentScreen({super.key});

  @override
  State<TreeviewComponentScreen> createState() => _TreeviewComponentScreenState();
}

class _TreeviewComponentScreenState extends State<TreeviewComponentScreen> {
  final List<TreeNode> _nodes = [
    const TreeNode('Root node', [
      TreeNode('Child node 1'),
      TreeNode('Child node 2'),
      TreeNode('Custom Icon'),
    ]),
    const TreeNode('Root node', [
      TreeNode('Child node 1'),
      TreeNode('Child node 2'),
      TreeNode('Root node', [TreeNode('Child node 1'), TreeNode('Child node 2')]),
    ]),
  ];

  final Map<String, bool> _checked = {};

  void _setCheckedRecursively(String key, bool value, TreeNode node) {
    _checked[key] = value;
    for (final child in node.children) {
      _setCheckedRecursively('$key/${child.title}', value, child);
    }
  }

  Widget _checkableNodeWidget(TreeNode node, String path) {
    final key = path;
    final checked = _checked[key] ?? false;

    if (node.children.isEmpty) {
      return CheckboxListTile(
        value: checked,
        onChanged: (v) => setState(() => _checked[key] = v ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(children: [const Icon(Icons.folder, color: Colors.orange, size: 16), const SizedBox(width: 8), Text(node.title)]),
        dense: true,
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: checked,
          onChanged: (v) => setState(() => _setCheckedRecursively(key, v ?? false, node)),
          controlAffinity: ListTileControlAffinity.leading,
          title: Row(children: [const Icon(Icons.folder, color: Colors.orange, size: 16), const SizedBox(width: 8), Text(node.title)]),
          dense: true,
          contentPadding: const EdgeInsets.only(left: 8, right: 8),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(children: node.children.map((c) => _checkableNodeWidget(c, '$key/${c.title}')).toList()),
        )
      ],
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treeview ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(
            title: 'Checkable Tree view',
            child: Column(children: _nodes.asMap().entries.map((e) {
              final idx = e.key;
              final node = e.value;
              final key = 'root_$idx/${node.title}';
              return _checkableNodeWidget(node, key);
            }).toList()),
          ),
        ]),
      ),
    );
  }
}

class SwitchComponentScreen extends StatefulWidget {
  const SwitchComponentScreen({super.key});

  @override
  State<SwitchComponentScreen> createState() => _SwitchComponentScreenState();
}

class _SwitchComponentScreenState extends State<SwitchComponentScreen> {
  // Bootstrap switches
  bool _default = false;
  bool _checked = true;
  final bool _disabled = false;
  final bool _disabledChecked = true;

  // Colored switches
  bool _light = true;
  bool _success = true;
  bool _warning = false;
  bool _danger = false;
  bool _info = false;
  bool _dark = false;

  Widget _card({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _switchRow({required Widget switchWidget, required String label, bool disabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          switchWidget,
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: disabled ? Colors.grey[500] : null))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switches')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(
            title: 'Bootstrap Switches',
            child: Column(children: [
              _switchRow(
                switchWidget: Switch(value: _default, onChanged: (v) => setState(() => _default = v)),
                label: 'Default Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _checked, onChanged: (v) => setState(() => _checked = v), activeThumbColor: Colors.lightBlue),
                label: 'Checked Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _disabled, onChanged: null),
                label: 'Disabled Switch',
                disabled: true,
              ),
              _switchRow(
                switchWidget: Switch(value: _disabledChecked, onChanged: null, activeThumbColor: Colors.lightBlue),
                label: 'Disabled Checked Switch',
                disabled: true,
              ),
            ]),
          ),

          _card(
            title: 'Switches Colors',
            child: Column(children: [
              _switchRow(
                switchWidget: Switch(value: _light, onChanged: (v) => setState(() => _light = v), activeThumbColor: const Color(0xFF2AA8E0)),
                label: 'Light Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _success, onChanged: (v) => setState(() => _success = v), activeThumbColor: Colors.green.shade400),
                label: 'Success Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _warning, onChanged: (v) => setState(() => _warning = v), activeThumbColor: Colors.orange.shade400),
                label: 'Warning Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _danger, onChanged: (v) => setState(() => _danger = v), activeThumbColor: Colors.red.shade400),
                label: 'Danger Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _info, onChanged: (v) => setState(() => _info = v), activeThumbColor: Colors.purple.shade300),
                label: 'Info Switch',
              ),
              _switchRow(
                switchWidget: Switch(value: _dark, onChanged: (v) => setState(() => _dark = v), activeThumbColor: Colors.indigo.shade900),
                label: 'Dark Switch',
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class StepperComponentScreen extends StatefulWidget {
  const StepperComponentScreen({super.key});
  @override
  State<StepperComponentScreen> createState() => _StepperComponentScreenState();
}

class _StepperComponentScreenState extends State<StepperComponentScreen> {
  // counters for the demo steppers
  final Map<String, int> _values = {
    'default_a': 0,
    'fill_a': 0,
    'small_a': 0,
    'small_fill_a': 0,
    'large_a': 0,
    'large_fill_a': 0,
    'default_b': 0,
    'fill_b': 0,
    'small_b': 0,
    'small_fill_b': 0,
    'large_b': 0,
    'large_fill_b': 0,
  };

  void _inc(String key) => setState(() => _values[key] = (_values[key] ?? 0) + 1);
  void _dec(String key) => setState(() => _values[key] = (_values[key] ?? 0) - 1);

  Widget _btn({required IconData icon, required VoidCallback? onTap, double size = 36, Color? bg, Color? iconColor, bool filled = false}) {
    final border = Border.all(color: Colors.grey.shade300);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filled ? (bg ?? Theme.of(context).primaryColor) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: filled ? null : border,
          boxShadow: filled ? [BoxShadow(color: Colors.black.withAlpha((0.04 * 255).round()), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Icon(icon, size: size * 0.5, color: filled ? (iconColor ?? Colors.white) : (iconColor ?? Colors.black54)),
      ),
    );
  }

  Widget _numericStepper(String key, {double btnSize = 36, bool fill = false, Color color = const Color(0xFF2AA8E0)}) {
    return Row(children: [
      _btn(icon: Icons.remove, onTap: () => _dec(key), size: btnSize, bg: color, filled: fill),
      const SizedBox(width: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${_values[key]}', style: const TextStyle(fontWeight: FontWeight.bold))),
      const SizedBox(width: 8),
      _btn(icon: Icons.add, onTap: () => _inc(key), size: btnSize, bg: color, filled: fill),
    ]);
  }

  Widget _labeledPair(String title, String keyLeft, String keyRight, {double btnSize = 36, bool fillLeft = false, bool fillRight = false, Color colorLeft = const Color(0xFF2AA8E0), Color colorRight = const Color(0xFF2AA8E0)}) {
    return Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(height: 6), _numericStepper(keyLeft, btnSize: btnSize, fill: fillLeft, color: colorLeft)]),
      ),
      const SizedBox(width: 24),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(height: 6), _numericStepper(keyRight, btnSize: btnSize, fill: fillRight, color: colorRight)]),
      ),
    ]);
  }

  Widget _card({required String title, required Widget child}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]), child: child), const SizedBox(height: 16)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steppers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(
            title: 'Default Steppers',
            child: Column(children: [
              _labeledPair('Default Stepper', 'default_a', 'default_b'),
              const SizedBox(height: 12),
              _labeledPair('Fill Stepper', 'fill_a', 'fill_b', fillLeft: true, fillRight: true),
              const SizedBox(height: 12),
              _labeledPair('Small Stepper', 'small_a', 'small_b', btnSize: 28),
              const SizedBox(height: 12),
              _labeledPair('Small Fill Stepper', 'small_fill_a', 'small_fill_b', btnSize: 28, fillLeft: true, fillRight: true),
              const SizedBox(height: 12),
              _labeledPair('Large Stepper', 'large_a', 'large_b', btnSize: 48),
              const SizedBox(height: 12),
              _labeledPair('Large Fill Stepper', 'large_fill_a', 'large_fill_b', btnSize: 48, fillLeft: true, fillRight: true),
            ]),
          ),

          _card(
            title: 'Different Size Steppers',
            child: Column(children: [
              _labeledPair('Default Stepper', 'default_a', 'default_b'),
              const SizedBox(height: 12),
              _labeledPair('Fill Stepper', 'fill_a', 'fill_b', fillLeft: true, fillRight: true),
              const SizedBox(height: 12),
              _labeledPair('Small Stepper', 'small_a', 'small_b', btnSize: 28),
              const SizedBox(height: 12),
              _labeledPair('Small Fill Stepper', 'small_fill_a', 'small_fill_b', btnSize: 28, fillLeft: true, fillRight: true),
            ]),
          ),

          _card(
            title: 'Different Color Steppers',
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _numericStepper('color_red', btnSize: 40, fill: true, color: Colors.red.shade300),
                _numericStepper('color_purple', btnSize: 40, fill: true, color: Colors.purple.shade300),
                _numericStepper('color_yellow', btnSize: 40, fill: true, color: Colors.amber.shade400),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _numericStepper('color_orange', btnSize: 40, fill: true, color: Colors.orange.shade400),
                _numericStepper('color_green', btnSize: 40, fill: true, color: Colors.green.shade300),
                _numericStepper('color_black', btnSize: 40, fill: true, color: Colors.black),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class SpinnerComponentScreen extends StatelessWidget {
  const SpinnerComponentScreen({super.key});

  Widget _card({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _coloredSpinner({double size = 28, Color color = Colors.lightBlue}) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size * 0.12,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _dot(Color color, {double size = 12}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pastel = [Colors.lightBlue.shade100, Colors.red.shade100, Colors.green.shade100, Colors.orange.shade100, Colors.purple.shade100, Colors.grey.shade300];
    final colors = [Colors.lightBlue, Colors.redAccent, Colors.green, Colors.orange, Colors.purple, Colors.indigo];

    return Scaffold(
      appBar: AppBar(title: const Text('Spinner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(
            title: 'Box Spinner',
            child: Container(
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.lightBlue.shade300, borderRadius: BorderRadius.circular(6)),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Colors.lightBlue.shade100, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
              ),
            ),
          ),

          _card(
            title: 'Color Spinner',
            child: Row(children: colors.map((c) => Padding(padding: const EdgeInsets.only(right: 12), child: _coloredSpinner(size: 36, color: c))).toList()),
          ),

          _card(
            title: 'Growing Size spinner',
            child: Row(children: [
              _coloredSpinner(size: 36, color: Colors.lightBlue),
              const SizedBox(width: 12),
              _coloredSpinner(size: 28, color: Colors.lightBlue.shade200),
              const SizedBox(width: 12),
              _coloredSpinner(size: 20, color: Colors.lightBlue.shade100),
              const SizedBox(width: 12),
              _coloredSpinner(size: 12, color: Colors.lightBlue.shade100),
            ]),
          ),

          _card(
            title: 'Growing Color spinner',
            child: Row(children: pastel.map((c) => Padding(padding: const EdgeInsets.only(right: 10), child: _dot(c, size: 16))).toList()),
          ),

          _card(
            title: 'Buttons spinner',
            child: Row(children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: Row(children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))), const SizedBox(width: 8), const Text('Loading...')]),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: Row(children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.black54))), const SizedBox(width: 8), const Text('Loading...')]),
              ),
              const SizedBox(width: 12),
              TextButton.icon(onPressed: () {}, icon: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.black54))), label: const Text('Loading...')),
            ]),
          ),

          _card(
            title: 'Spinner Small Size',
            child: Row(children: colors.map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: _coloredSpinner(size: 18, color: c))).toList()),
          ),
        ]),
      ),
    );
  }
}

class RangeSliderComponentScreen extends StatefulWidget {
  const RangeSliderComponentScreen({super.key});
  @override
  State<RangeSliderComponentScreen> createState() => _RangeSliderComponentScreenState();
}

class _RangeSliderComponentScreenState extends State<RangeSliderComponentScreen> {
  double _single = 40; // basic slider
  RangeValues _range = const RangeValues(20, 60); // main range
  double _snap = 30; // for snap behavior
  RangeValues _combined = const RangeValues(30, 70);
  bool _disabled = false;
  double _pipValue = 50;
  double _soft = 40; // soft limits slider
  double _dir = 20; // direction slider

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  Widget _card({required String title, required Widget child}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))]), child: child), const SizedBox(height: 16)]);
  }

  Widget _pips(double value, {int steps = 20}) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(children: List.generate(steps + 1, (i) {
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() => _pipValue = (i * (100 / steps)).roundToDouble());
            },
            child: Container(height: 24, alignment: Alignment.topCenter, child: Container(width: 2, height: 8, color: Colors.grey[300])),
          ),
        );
      }));
    });
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // prepare controllers for key-press demo
    _minController.text = _combined.start.toStringAsFixed(0);
    _maxController.text = _combined.end.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Range')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card(
            title: 'Basic Slider',
            child: Column(children: [
              Slider(value: _single, min: 0, max: 100, divisions: 100, onChanged: (v) => setState(() => _single = v)),
            ]),
          ),

          _card(
            title: 'Slider Tooltip',
            child: LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              final left = (_range.start / 100) * width;
              final right = (_range.end / 100) * width;
              const boxW = 56.0;
              return Stack(children: [
                RangeSlider(values: _range, min: 0, max: 100, divisions: 100, labels: RangeLabels('${_range.start.round()}', '${_range.end.round()}'), onChanged: (v) => setState(() => _range = v)),
                Positioned(left: (left - boxW / 2).clamp(0.0, width - boxW), top: -36, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 4)]), child: Text(_range.start.toStringAsFixed(0)))),
                Positioned(left: (right - boxW / 2).clamp(0.0, width - boxW), top: -36, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 4)]), child: Text(_range.end.toStringAsFixed(0)))),
              ]);
            }),
          ),

          _card(
            title: 'Slider Behaviour (Snap)',
            child: Slider(value: _snap, min: 0, max: 100, divisions: 10, onChanged: (v) => setState(() => _snap = v)),
          ),

          _card(
            title: 'Slider Behaviour (Combined)',
            child: RangeSlider(values: _combined, min: 0, max: 100, divisions: 100, labels: RangeLabels('${_combined.start.round()}', '${_combined.end.round()}'), onChanged: (v) => setState(() { _combined = v; _minController.text = v.start.toStringAsFixed(0); _maxController.text = v.end.toStringAsFixed(0); })),
          ),

          _card(
            title: 'Disabling A Slider',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Slider(value: _single, min: 0, max: 100, onChanged: _disabled ? null : (v) => setState(() => _single = v)),
              Row(children: [Checkbox(value: _disabled, onChanged: (v) => setState(() => _disabled = v ?? false)), const SizedBox(width: 8), const Text('Disable slider')]),
            ]),
          ),

          _card(
            title: 'Moving The Slider By Clicking Pips',
            child: Column(children: [
              _pips(_pipValue, steps: 20),
              const SizedBox(height: 8),
              Slider(value: _pipValue, min: 0, max: 100, divisions: 20, onChanged: (v) => setState(() => _pipValue = v)),
            ]),
          ),

          _card(
            title: 'Changing The Slider By Key Press',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RangeSlider(values: _combined, min: 0, max: 100, divisions: 100, labels: RangeLabels('${_combined.start.round()}', '${_combined.end.round()}'), onChanged: (v) => setState(() { _combined = v; _minController.text = v.start.toStringAsFixed(0); _maxController.text = v.end.toStringAsFixed(0); })),
              const SizedBox(height: 8),
              Row(children: [
                SizedBox(width: 80, child: TextField(controller: _minController, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder() ), onSubmitted: (t) { final n = double.tryParse(t) ?? _combined.start; setState(() => _combined = RangeValues(n.clamp(0, _combined.end), _combined.end)); })),
                const SizedBox(width: 12),
                SizedBox(width: 80, child: TextField(controller: _maxController, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder()), onSubmitted: (t) { final n = double.tryParse(t) ?? _combined.end; setState(() => _combined = RangeValues(_combined.start, n.clamp(_combined.start, 100))); })),
              ]),
              const SizedBox(height: 8),
              Text(_combined.end.toStringAsFixed(2)),
              const SizedBox(height: 8),
              Text(_combined.start.toStringAsFixed(2)),
            ]),
          ),

          _card(
            title: 'Soft Limits',
            child: Column(children: [
              _pips(_soft, steps: 20),
              const SizedBox(height: 8),
              Slider(value: _soft, min: 0, max: 100, divisions: 20, onChanged: (v) => setState(() => _soft = v)),
            ]),
          ),

          _card(
            title: 'Slider Direction',
            child: Column(children: [
              Directionality(textDirection: TextDirection.rtl, child: Slider(value: _dir, min: 0, max: 100, onChanged: (v) => setState(() => _dir = v))),
              const SizedBox(height: 8),
              Text(_dir.toStringAsFixed(0)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class LightGalleryComponentScreen extends StatelessWidget {
  const LightGalleryComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      'assets/images/gallery1.jpg',
      'assets/images/gallery2.jpg',
      'assets/images/gallery3.jpg',
      'assets/images/gallery4.jpg',
      'assets/images/gallery5.jpg',
      'assets/images/gallery6.jpg',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('LightGallery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Light Gallery', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(' ', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.4,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(images.length, (i) {
                        final img = images[i];
                        return GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                              insetPadding: const EdgeInsets.all(16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(img, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              color: Colors.grey[200],
                              child: Image.asset(img, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      }),
                    ),
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

class DividerComponentScreen extends StatelessWidget {
  const DividerComponentScreen({super.key});

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
      );

  Widget _iconDividerRow(BuildContext context, Color color, IconData icon, Alignment align) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(height: 2, color: color),
            ),
          ),
          Align(
            alignment: align,
            child: CircleAvatar(radius: 14, backgroundColor: color, child: Icon(icon, size: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _textDividerRow(BuildContext context, String text, Color color, Alignment align) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(height: 2, color: color.withAlpha(153)),
            ),
          ),
          Align(
            alignment: align,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
              child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> get _dividerColors => [
    const Color(0xFF3AA0F3),
    const Color(0xFF51CF66),
    const Color(0xFFFB9678),
    const Color(0xFFF6C94D),
    const Color(0xFF9B59B6),
    Colors.black,
  ];

  Widget _solidDividers() {
    return Column(
      children: _dividerColors.map((c) => Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 2, color: c)).toList(),
    );
  }

  Widget _dashedDivider(Color color, {double height = 8}) => SizedBox(width: double.infinity, height: height, child: CustomPaint(painter: _DashPainter(color: color, dash: true)));
  Widget _dottedDivider(Color color, {double height = 8}) => SizedBox(width: double.infinity, height: height, child: CustomPaint(painter: _DashPainter(color: color, dash: false)));

  @override
  Widget build(BuildContext context) {
    final smallGap = const SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(title: const Text('Divider Component')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Divider
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionTitle('Icon Divider'),
                  const SizedBox(height: 8),
                  _iconDividerRow(context, const Color(0xFF4DB8E8), Icons.home, Alignment.centerLeft),
                  _iconDividerRow(context, const Color(0xFFFFC107), Icons.favorite, Alignment.center),
                  _iconDividerRow(context, const Color(0xFFFF6B6B), Icons.person, Alignment.centerRight),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // Text Divider
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionTitle('Text Divider'),
                  const SizedBox(height: 8),
                  _textDividerRow(context, 'Primary', const Color(0xFF3AA0F3), Alignment.centerLeft),
                  smallGap,
                  _textDividerRow(context, 'Primary', const Color(0xFFFF6B6B), Alignment.center),
                  smallGap,
                  _textDividerRow(context, 'Primary', const Color(0xFFFB9678), Alignment.centerRight),
                  smallGap,
                  Align(alignment: Alignment.centerLeft, child: Text('Primary', style: TextStyle(color: Colors.grey[600], fontSize: 12))),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // Solid Divider
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionTitle('Solid Divider'),
                  const SizedBox(height: 8),
                  _solidDividers(),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // Dashed Divider
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionTitle('Dashed Divider'),
                  const SizedBox(height: 8),
                  ..._dividerColors.map((c) => Padding(padding: const EdgeInsets.only(bottom: 6), child: _dashedDivider(c, height: 10))).toList(),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // Dotted Divider
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionTitle('Dotted Divider'),
                  const SizedBox(height: 8),
                  ..._dividerColors.map((c) => Padding(padding: const EdgeInsets.only(bottom: 6), child: _dottedDivider(c, height: 10))).toList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  final bool dash; // true -> dashed, false -> dotted

  _DashPainter({required this.color, this.dash = true});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (dash) {
      double x = 0;
      const dashWidth = 14.0;
      const dashSpace = 8.0;
      final y = size.height / 2;
      while (x < size.width) {
        final end = (x + dashWidth).clamp(0, size.width).toDouble();
        canvas.drawLine(Offset(x, y), Offset(end, y), strokePaint);
        x += dashWidth + dashSpace;
      }
    } else {
      double x = 0;
      const dotSpace = 10.0;
      const dotRadius = 2.0;
      final y = size.height / 2;
      final fillPaint = Paint()..color = color..style = PaintingStyle.fill;
      while (x < size.width) {
        canvas.drawCircle(Offset(x + dotRadius, y), dotRadius, fillPaint);
        x += dotSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Language component moved to `language_component_screen.dart`

void _showBasicModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Basic Modal'),
      content: const Text('This is a basic modal dialog with short content.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
      ],
    ),
  );
}

void _showLongContentModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: SizedBox(
        height: 360,
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Long Content Modal', style: TextStyle(fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))])),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(12, (i) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Item ${i + 1}'))),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')))])),
          ],
        ),
      ),
    ),
  );
}

class AvatarComponentScreen extends StatelessWidget {
  const AvatarComponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avatar Component')),
      body: const Center(child: Text('Avatar Component (placeholder)')),
    );
  }
}

class LanguageComponentScreen extends StatefulWidget {
  const LanguageComponentScreen({super.key});

  @override
  State<LanguageComponentScreen> createState() => _LanguageComponentScreenState();
}

class _LanguageComponentScreenState extends State<LanguageComponentScreen> {
  final List<String> _languages = [
    'Hindi',
    'English',
    'Afrikaans',
    'Albanian',
    'Arabic',
    'Azerbaijani',
    'Belarusian',
    'Bengali',
    'Bulgarian',
    'Catalan',
    'Cebuano',
    'Chichewa',
    'Dutch',
    'Filipino',
    'French',
    'German',
    'Hebrew',
    'Indonesian',
    'Latvian',
    'Malayalam',
  ];

  final Set<String> _selected = {};

  void _toggle(String lang) {
    setState(() {
      if (_selected.contains(lang)) {
        _selected.remove(lang);
      } else {
        _selected.add(lang);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _languages.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (c, i) {
                      final lang = _languages[i];
                      final checked = _selected.contains(lang);
                      return InkWell(
                        onTap: () => _toggle(lang),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          child: Row(
                            children: [
                              Checkbox(
                                value: checked,
                                onChanged: (_) => _toggle(lang),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(lang, style: const TextStyle(fontSize: 14))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showCenteredModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Centered',
    pageBuilder: (context, a, b) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Modal Centered', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12), const Text('This modal is centered.'), const SizedBox(height: 12), Row(children: [Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')))])]),
        ),
      ),
    ),
  );
}

void _showSizedModal(BuildContext context, {required bool large}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        width: large ? 600 : 260,
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [Text(large ? 'Large Modal' : 'Small Modal', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12), const Text('This modal demonstrates a different size.'), const SizedBox(height: 12), Row(children: [Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')))])]),
      ),
    ),
  );
}
