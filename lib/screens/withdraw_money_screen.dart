import 'package:flutter/material.dart';

class WithdrawMoneyScreen extends StatefulWidget {
  final double currentBalance;
  final List<Map<String, dynamic>> transactions;

  const WithdrawMoneyScreen({
    super.key,
    required this.currentBalance,
    required this.transactions,
  });

  @override
  State<WithdrawMoneyScreen> createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  String selectedPayoutMethod = '';

  final List<Map<String, dynamic>> payoutMethods = [
    {'id': 'upi', 'name': 'UPI', 'detail': '@Sampad.d@ptaxis', 'icon': Icons.account_balance},
    {'id': 'pnb', 'name': 'PNB', 'detail': 'A/C: -9858785******', 'icon': Icons.account_balance},
    {'id': 'boa', 'name': 'Checking Account', 'detail': 'Bank of America', 'icon': Icons.account_balance},
  ];

  void _handleWithdraw() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0 && selectedPayoutMethod.isNotEmpty) {
      if (amount <= widget.currentBalance) {
        final newBalance = widget.currentBalance - amount;
        final newTransactions = List<Map<String, dynamic>>.from(widget.transactions);
        
        newTransactions.insert(0, {
          'id': newTransactions.length + 1,
          'amount': '-₹${amount.toStringAsFixed(0)}',
          'type': 'Withdrawal',
          'date': DateTime.now().toString().split(' ')[0],
        });

        Navigator.pop(context, {
          'balance': newBalance,
          'transactions': newTransactions,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Withdrawn ₹$amount successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient balance!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount and select payout method')),
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
          'Withdraw Money',
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
                'Available Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFC084FC), Color(0xFF60A5FA)],
                ).createShader(bounds),
                child: Text(
                  '₹ ${widget.currentBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Amount to Withdraw',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Amount input
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
              ),
              
              const SizedBox(height: 32),
              
              // Payout Method
              const Text(
                'Payout Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              ...payoutMethods.map((method) {
                final isSelected = selectedPayoutMethod == method['id'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPayoutMethod = method['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF293038).withOpacity(0.3)
                          : const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF293038),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(method['icon'], color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                method['detail'],
                                style: const TextStyle(
                                  color: Color(0xFF9eabba),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.blue : const Color(0xFF3b4754),
                              width: 2,
                            ),
                            color: isSelected ? Colors.blue : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              
              // Add Payout Method
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Payout Method - Coming Soon')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF293038).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 16),
                          Text(
                            'Add Payout Method',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ),
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
            onPressed: _handleWithdraw,
            style: ElevatedButton.styleFrom(
              backgroundColor: _amountController.text.isNotEmpty && selectedPayoutMethod.isNotEmpty
                  ? Colors.blue
                  : const Color(0xFF293038),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Withdraw',
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
