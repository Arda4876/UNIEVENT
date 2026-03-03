import 'package:flutter/material.dart';
import '../models/event.dart';

class PaymentScreen extends StatefulWidget {
  final Event event;

  const PaymentScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _quantity = 1;
  String _paymentMethod = 'credit_card';
  bool _agreeToTerms = false;
  bool _isProcessing = false;

  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpireController = TextEditingController();
  final _cardCvvController = TextEditingController();

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpireController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  double get _totalPrice => (widget.event.price ?? 0) * _quantity;

  void _processPayment() async {
    if (!_validateForm()) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Simulated payment processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ödeme işlemi başarısız: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  bool _validateForm() {
    if (_quantity < 1) {
      _showError('Lütfen en az 1 bilet seçin');
      return false;
    }

    if (!_agreeToTerms) {
      _showError('Lütfen şart ve koşulları kabul edin');
      return false;
    }

    if (_cardNameController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _cardExpireController.text.isEmpty ||
        _cardCvvController.text.isEmpty) {
      _showError('Lütfen tüm kart bilgilerini girin');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Ödeme Başarılı!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              '${_quantity} adet bilet satın aldınız',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Biletleriniz e-postanıza gönderilmiştir.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6366F1),
            ),
            child: Text(
              'Ana Sayfaya Dön',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bilet Satın Al'),
        backgroundColor: Color(0xFF6366F1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Summary
            Container(
              padding: EdgeInsets.all(16),
              color: Color(0xFF6366F1).withOpacity(0.05),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.event.imageUrl ??
                            'https://via.placeholder.com/80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.event,
                            color: Color(0xFF6366F1),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fiyat: ₺${widget.event.price?.toStringAsFixed(2) ?? "0.00"}',
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quantity Selection
                  Text(
                    'Bilet Adedi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey[300] ?? Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$_quantity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Payment Method
                  Text(
                    'Ödeme Yöntemi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey[300] ?? Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildPaymentOption('credit_card', 'Kredi Kartı'),
                        Divider(height: 0),
                        _buildPaymentOption('debit_card', 'Banka Kartı'),
                        Divider(height: 0),
                        _buildPaymentOption('wallet', 'E-Cüzdan'),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Card Details (if credit card selected)
                  if (_paymentMethod.contains('card'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kart Bilgileri',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _cardNameController,
                          decoration: InputDecoration(
                            hintText: 'Kart Sahibinin Adı',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            hintText: 'Kart Numarası',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _cardExpireController,
                                decoration: InputDecoration(
                                  hintText: 'AA/YY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _cardCvvController,
                                decoration: InputDecoration(
                                  hintText: 'CVV',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                      ],
                    ),

                  // Terms and Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() => _agreeToTerms = value ?? false);
                        },
                        activeColor: Color(0xFF6366F1),
                      ),
                      Expanded(
                        child: Text(
                          'Şart ve koşulları kabul ediyorum',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Price Summary
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFF6366F1).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Birim Fiyat:'),
                            Text(
                              '₺${widget.event.price?.toStringAsFixed(2) ?? "0.00"}',
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Adet:'),
                            Text('$_quantity'),
                          ],
                        ),
                        Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Toplam:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₺${_totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Ödemeyi Tamamla',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _buildPaymentOption(String value, String label) {
    return RadioListTile<String>(
      value: value,
      groupValue: _paymentMethod,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() => _paymentMethod = newValue);
        }
      },
      title: Text(label),
      activeColor: Color(0xFF6366F1),
    );
  }
}
