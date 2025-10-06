import 'package:flutter/material.dart';

class RechargeWalletScreen extends StatefulWidget {
  final double currentBalance;
  final List<Map<String, dynamic>> transactions;

  const RechargeWalletScreen({
    super.key,
    required this.currentBalance,
    required this.transactions,
  });

  @override
  State<RechargeWalletScreen> createState() => _RechargeWalletScreenState();
}

class _RechargeWalletScreenState extends State<RechargeWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  String selectedPaymentMethod = '';
  String selectedAmount = '';

  final List<String> quickAmounts = ['500', '1000', '2000', '5000'];
  final List<Map<String, dynamic>> paymentMethods = [
    {'id': 'upi', 'name': 'UPI', 'icon': Icons.smartphone},
    {'id': 'card', 'name': 'Debit/Credit Card', 'icon': Icons.credit_card},
    {'id': 'netbanking', 'name': 'NetBanking', 'icon': Icons.account_balance},
  ];

  void _handleRecharge() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0 && selectedPaymentMethod.isNotEmpty) {
      final newBalance = widget.currentBalance + amount;
      final newTransactions = List<Map<String, dynamic>>.from(widget.transactions);
      
      newTransactions.insert(0, {
        'id': newTransactions.length + 1,
        'amount': '+₹${amount.toStringAsFixed(0)}',
        'type': 'Recharge',
        'date': DateTime.now().toString().split(' ')[0],
      });

      Navigator.pop(context, {
        'balance': newBalance,
        'transactions': newTransactions,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recharged ₹$amount successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount and select payment method')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recharge Wallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Quick amount buttons
              Wrap(
                spacing: 12,
                children: quickAmounts.map((amount) {
                  final isSelected = selectedAmount == amount;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmount = amount;
                        _amountController.text = amount;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF293038),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Text(
                        '₹ $amount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Custom amount input
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3b4754)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3b4754)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedAmount = '';
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              // Payment Options
              const Text(
                'Payment Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              ...paymentMethods.map((method) {
                final isSelected = selectedPaymentMethod == method['id'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = method['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF293038).withOpacity(0.3)
                          : const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF293038),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(method['icon'], color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            method['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _handleRecharge,
            style: ElevatedButton.styleFrom(
              backgroundColor: _amountController.text.isNotEmpty && selectedPaymentMethod.isNotEmpty
                  ? Colors.blue
                  : const Color(0xFF293038),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Recharge',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
