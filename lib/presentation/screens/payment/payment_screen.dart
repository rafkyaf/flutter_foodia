import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedIndex = -1;
  int selectedCardIndex = 0;

  // Selected country for Wallet (default: India)
  Map<String, String> _selectedCountry = {
    'name': 'India',
    'dial_code': '+91',
    'code': 'IN',
    'flag': '🇮🇳',
  };

  // A list of countries with dial codes and flags (broad coverage). Add more as needed.
  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'dial_code': '+93', 'code': 'AF', 'flag': '🇦🇫'},
    {'name': 'Albania', 'dial_code': '+355', 'code': 'AL', 'flag': '🇦🇱'},
    {'name': 'Algeria', 'dial_code': '+213', 'code': 'DZ', 'flag': '🇩🇿'},
    {'name': 'Andorra', 'dial_code': '+376', 'code': 'AD', 'flag': '🇦🇩'},
    {'name': 'Angola', 'dial_code': '+244', 'code': 'AO', 'flag': '🇦🇴'},
    {'name': 'Argentina', 'dial_code': '+54', 'code': 'AR', 'flag': '🇦🇷'},
    {'name': 'Armenia', 'dial_code': '+374', 'code': 'AM', 'flag': '🇦🇲'},
    {'name': 'Australia', 'dial_code': '+61', 'code': 'AU', 'flag': '🇦🇺'},
    {'name': 'Austria', 'dial_code': '+43', 'code': 'AT', 'flag': '🇦🇹'},
    {'name': 'Azerbaijan', 'dial_code': '+994', 'code': 'AZ', 'flag': '🇦🇿'},
    {'name': 'Bahamas', 'dial_code': '+1-242', 'code': 'BS', 'flag': '🇧🇸'},
    {'name': 'Bahrain', 'dial_code': '+973', 'code': 'BH', 'flag': '🇧🇭'},
    {'name': 'Bangladesh', 'dial_code': '+880', 'code': 'BD', 'flag': '🇧🇩'},
    {'name': 'Belgium', 'dial_code': '+32', 'code': 'BE', 'flag': '🇧🇪'},
    {'name': 'Belize', 'dial_code': '+501', 'code': 'BZ', 'flag': '🇧🇿'},
    {'name': 'Benin', 'dial_code': '+229', 'code': 'BJ', 'flag': '🇧🇯'},
    {'name': 'Bhutan', 'dial_code': '+975', 'code': 'BT', 'flag': '🇧🇹'},
    {'name': 'Bolivia', 'dial_code': '+591', 'code': 'BO', 'flag': '🇧🇴'},
    {'name': 'Bosnia & Herz.', 'dial_code': '+387', 'code': 'BA', 'flag': '🇧🇦'},
    {'name': 'Brazil', 'dial_code': '+55', 'code': 'BR', 'flag': '🇧🇷'},
    {'name': 'Bulgaria', 'dial_code': '+359', 'code': 'BG', 'flag': '🇧🇬'},
    {'name': 'Canada', 'dial_code': '+1', 'code': 'CA', 'flag': '🇨🇦'},
    {'name': 'Chile', 'dial_code': '+56', 'code': 'CL', 'flag': '🇨🇱'},
    {'name': 'China', 'dial_code': '+86', 'code': 'CN', 'flag': '🇨🇳'},
    {'name': 'Colombia', 'dial_code': '+57', 'code': 'CO', 'flag': '🇨🇴'},
    {'name': 'Costa Rica', 'dial_code': '+506', 'code': 'CR', 'flag': '🇨🇷'},
    {'name': 'Croatia', 'dial_code': '+385', 'code': 'HR', 'flag': '🇭🇷'},
    {'name': 'Czechia', 'dial_code': '+420', 'code': 'CZ', 'flag': '🇨🇿'},
    {'name': 'Denmark', 'dial_code': '+45', 'code': 'DK', 'flag': '🇩🇰'},
    {'name': 'Dominican Rep.', 'dial_code': '+1-809', 'code': 'DO', 'flag': '🇩🇴'},
    {'name': 'Ecuador', 'dial_code': '+593', 'code': 'EC', 'flag': '🇪🇨'},
    {'name': 'Egypt', 'dial_code': '+20', 'code': 'EG', 'flag': '🇪🇬'},
    {'name': 'Estonia', 'dial_code': '+372', 'code': 'EE', 'flag': '🇪🇪'},
    {'name': 'Finland', 'dial_code': '+358', 'code': 'FI', 'flag': '🇫🇮'},
    {'name': 'France', 'dial_code': '+33', 'code': 'FR', 'flag': '🇫🇷'},
    {'name': 'Germany', 'dial_code': '+49', 'code': 'DE', 'flag': '🇩🇪'},
    {'name': 'Ghana', 'dial_code': '+233', 'code': 'GH', 'flag': '🇬🇭'},
    {'name': 'Greece', 'dial_code': '+30', 'code': 'GR', 'flag': '🇬🇷'},
    {'name': 'Guatemala', 'dial_code': '+502', 'code': 'GT', 'flag': '🇬🇹'},
    {'name': 'Honduras', 'dial_code': '+504', 'code': 'HN', 'flag': '🇭🇳'},
    {'name': 'Hong Kong', 'dial_code': '+852', 'code': 'HK', 'flag': '🇭🇰'},
    {'name': 'Hungary', 'dial_code': '+36', 'code': 'HU', 'flag': '🇭🇺'},
    {'name': 'Iceland', 'dial_code': '+354', 'code': 'IS', 'flag': '🇮🇸'},
    {'name': 'Indonesia', 'dial_code': '+62', 'code': 'ID', 'flag': '🇮🇩'},
    {'name': 'Ireland', 'dial_code': '+353', 'code': 'IE', 'flag': '🇮🇪'},
    {'name': 'Israel', 'dial_code': '+972', 'code': 'IL', 'flag': '🇮🇱'},
    {'name': 'Italy', 'dial_code': '+39', 'code': 'IT', 'flag': '🇮🇹'},
    {'name': 'Japan', 'dial_code': '+81', 'code': 'JP', 'flag': '🇯🇵'},
    {'name': 'Kazakhstan', 'dial_code': '+7', 'code': 'KZ', 'flag': '🇰🇿'},
    {'name': 'Kenya', 'dial_code': '+254', 'code': 'KE', 'flag': '🇰🇪'},
    {'name': 'Kuwait', 'dial_code': '+965', 'code': 'KW', 'flag': '🇰🇼'},
    {'name': 'Malaysia', 'dial_code': '+60', 'code': 'MY', 'flag': '🇲🇾'},
    {'name': 'Malta', 'dial_code': '+356', 'code': 'MT', 'flag': '🇲🇹'},
    {'name': 'Mexico', 'dial_code': '+52', 'code': 'MX', 'flag': '🇲🇽'},
    {'name': 'Morocco', 'dial_code': '+212', 'code': 'MA', 'flag': '🇲🇦'},
    {'name': 'Netherlands', 'dial_code': '+31', 'code': 'NL', 'flag': '🇳🇱'},
    {'name': 'New Zealand', 'dial_code': '+64', 'code': 'NZ', 'flag': '🇳🇿'},
    {'name': 'Nigeria', 'dial_code': '+234', 'code': 'NG', 'flag': '🇳🇬'},
    {'name': 'Norway', 'dial_code': '+47', 'code': 'NO', 'flag': '🇳🇴'},
    {'name': 'Pakistan', 'dial_code': '+92', 'code': 'PK', 'flag': '🇵🇰'},
    {'name': 'Philippines', 'dial_code': '+63', 'code': 'PH', 'flag': '🇵🇭'},
    {'name': 'Poland', 'dial_code': '+48', 'code': 'PL', 'flag': '🇵🇱'},
    {'name': 'Portugal', 'dial_code': '+351', 'code': 'PT', 'flag': '🇵🇹'},
    {'name': 'Romania', 'dial_code': '+40', 'code': 'RO', 'flag': '🇷🇴'},
    {'name': 'Russia', 'dial_code': '+7', 'code': 'RU', 'flag': '🇷🇺'},
    {'name': 'Saudi Arabia', 'dial_code': '+966', 'code': 'SA', 'flag': '🇸🇦'},
    {'name': 'Singapore', 'dial_code': '+65', 'code': 'SG', 'flag': '🇸🇬'},
    {'name': 'South Africa', 'dial_code': '+27', 'code': 'ZA', 'flag': '🇿🇦'},
    {'name': 'South Korea', 'dial_code': '+82', 'code': 'KR', 'flag': '🇰🇷'},
    {'name': 'Spain', 'dial_code': '+34', 'code': 'ES', 'flag': '🇪🇸'},
    {'name': 'Sweden', 'dial_code': '+46', 'code': 'SE', 'flag': '🇸🇪'},
    {'name': 'Switzerland', 'dial_code': '+41', 'code': 'CH', 'flag': '🇨🇭'},
    {'name': 'Taiwan', 'dial_code': '+886', 'code': 'TW', 'flag': '🇹🇼'},
    {'name': 'Thailand', 'dial_code': '+66', 'code': 'TH', 'flag': '🇹🇭'},
    {'name': 'Turkey', 'dial_code': '+90', 'code': 'TR', 'flag': '🇹🇷'},
    {'name': 'Ukraine', 'dial_code': '+380', 'code': 'UA', 'flag': '🇺🇦'},
    {'name': 'United Arab Emirates', 'dial_code': '+971', 'code': 'AE', 'flag': '🇦🇪'},
    {'name': 'United Kingdom', 'dial_code': '+44', 'code': 'GB', 'flag': '🇬🇧'},
    {'name': 'United States', 'dial_code': '+1', 'code': 'US', 'flag': '🇺🇸'},
    {'name': 'Vietnam', 'dial_code': '+84', 'code': 'VN', 'flag': '🇻🇳'},
  ];
  final List<String> paymentMethods = [
    "Cash on Delivery",
    "Credit/Debit Card",
    "Google Pay/Other",
    "Netbanking",
    "Wallet"
  ];

  final List<Map<String, String>> savedCards = [
    {"brand": "VISA", "number": "4532 **** **** ****"},
    {"brand": "MasterCard", "number": "5142 **** **** ****"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E90FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: selectedIndex == -1
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PaymentSuccessScreen()),
                  );
                },
          child: Text(
            "Make Payment: \$55",
            style: TextStyle(
              color: selectedIndex == -1 ? Colors.white54 : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Payment",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Select Payment mode",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              /// Payment Options
              for (int i = 0; i < paymentMethods.length; i++)
                _buildPaymentTile(
                  index: i,
                  icon: _getIconForIndex(i),
                  title: paymentMethods[i],
                  content: i == 0
                      ? _buildCODSection()
                      : i == 1
                          ? _buildCreditCardSection()
                          : i == 2
                              ? _buildGooglePaySection()
                              : i == 3
                                  ? _buildNetbankingSection()
                                  : i == 4
                                      ? _buildWalletSection()
                                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.money_rounded;
      case 1:
        return Icons.credit_card_rounded;
      case 2:
        return Icons.account_balance_wallet_rounded;
      case 3:
        return Icons.account_balance_rounded;
      case 4:
        return Icons.wallet_rounded;
      default:
        return Icons.payment;
    }
  }

  Widget _buildPaymentTile({
    required int index,
    required IconData icon,
    required String title,
    Widget? content,
  }) {
    final bool isExpanded = selectedIndex == index;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            selectedIndex = expanded ? index : -1;
          });
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: const Color(0xFF1E3D58)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: content != null ? [content] : [],
      ),
    );
  }

  /// 💳 Section Kartu Kredit
  Widget _buildCreditCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Saved Cards",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildAddCardButton(),
              const SizedBox(width: 10),
              for (int i = 0; i < savedCards.length; i++) ...[
                _buildCardBrand(
                  savedCards[i]["brand"]!,
                  selectedCardIndex == i,
                  onTap: () {
                    setState(() => selectedCardIndex = i);
                  },
                ),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCreditCard(savedCards[selectedCardIndex]),
      ],
    );
  }

  /// ➕ Tombol Add Card
  Widget _buildAddCardButton() {
    return GestureDetector(
      onTap: _showAddCardDialog,
      child: Container(
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Add Card +",
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// 🔹 Dialog "ADD CARD" yang mirip gambar
  void _showAddCardDialog() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _numberController = TextEditingController();
    final TextEditingController _expiryController = TextEditingController();
    final TextEditingController _cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "ADD CARD",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Card Holder Name
                const Text("Card holder Name",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration(""),
                ),
                const SizedBox(height: 15),

                // Card Number
                const Text("Card Number",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 6),
                TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("**** **** **** ****"),
                ),
                const SizedBox(height: 15),

                // Expiry + CVV
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Expiry Date",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            decoration: _inputDecoration("MM / YY"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Security Code",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration("•••"),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Tombol Added
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E90FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _numberController.text.isNotEmpty &&
                          _expiryController.text.isNotEmpty &&
                          _cvvController.text.isNotEmpty) {
                        setState(() {
                          savedCards.add({
                            "brand": "Custom",
                            "number":
                                "**** **** **** ${_numberController.text.substring(_numberController.text.length - 4)}",
                          });
                          selectedCardIndex = savedCards.length - 1;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Added",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1E90FF)),
      ),
    );
  }

  Widget _buildCardBrand(String name, bool selected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade400,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------- ADDITIONAL PAYMENT SECTIONS -----------------------
  Widget _buildCODSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Text(
        'Carry on your cash payment..\nThanx!',
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildGooglePaySection() {
    final TextEditingController _upiController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        TextField(
          controller: _upiController,
          decoration: _inputDecoration('Enter your UPI ID').copyWith(labelText: 'Link via UPI'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E90FF)),
            onPressed: () {},
            child: const Text('Continue'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your UPI ID will be encrypted and is 100% safe with us.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildNetbankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1E90FF)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Netbanking', style: TextStyle(color: Color(0xFF1E90FF))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletSection() {
    final TextEditingController _walletController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: Row(children: const [Text('+91'), SizedBox(width: 6), Icon(Icons.arrow_drop_down)]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _walletController,
                decoration: _inputDecoration('Your Wallet'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E90FF)),
            onPressed: () {},
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
  Widget _buildCreditCard(Map<String, String> card) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF2B2B2B), Color(0xFF1E1E1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card["brand"] ?? "CARD",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          const Text("Credit Card",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 5),
          Text(
            card["number"] ?? "**** **** **** ****",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("04 / 25",
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text("KEVIN HARD",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
