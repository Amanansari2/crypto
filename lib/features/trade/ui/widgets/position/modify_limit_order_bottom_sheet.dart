
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/limit_order/limit_open_order.dart';
import '../../../data/providers/limit_open_order_provider.dart';
import '../text_field/trade_text_field.dart';

class ModifyLimitOrderBottomSheet extends ConsumerStatefulWidget {
  const ModifyLimitOrderBottomSheet({
    super.key,
    required this.order,
    required this.accountId,
  });

  final LimitOpenOrder order;
  final String accountId;

  @override
  ConsumerState<ModifyLimitOrderBottomSheet> createState() =>
      _ModifyLimitOrderBottomSheetState();
}

class _ModifyLimitOrderBottomSheetState
    extends ConsumerState<ModifyLimitOrderBottomSheet> {
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _takeProfitController;
  late final TextEditingController _stopLossController;
  String? _errorMessage;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _priceController =
        TextEditingController(text: widget.order.price.toString());
    _quantityController =
        TextEditingController(text: widget.order.quantity.toString());
    _takeProfitController = TextEditingController(
      text: widget.order.takeProfit?.toString() ?? '',
    );
    _stopLossController = TextEditingController(
      text: widget.order.stopLoss?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    _takeProfitController.dispose();
    _stopLossController.dispose();
    super.dispose();
  }

  double? _parse(String value) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }

  Future<void> _submit() async {
    final price = _parse(_priceController.text);
    final quantity = _parse(_quantityController.text);
    final takeProfit = _parse(_takeProfitController.text);
    final stopLoss = _parse(_stopLossController.text);

    if (price == null ||
        price <= 0 ||
        quantity == null ||
        quantity <= 0) {
      _showMessage('Enter a valid price and quantity.');
      return;
    }

    if (_takeProfitController.text.trim().isNotEmpty &&
        (takeProfit == null || takeProfit <= 0)) {
      _showMessage('Enter a valid Take Profit price.');
      return;
    }

    if (_stopLossController.text.trim().isNotEmpty &&
        (stopLoss == null || stopLoss <= 0)) {
      _showMessage('Enter a valid Stop Loss price.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await ref
          .read(limitOpenOrderProvider.notifier)
          .modifyLimitOrder(
        tradeId: widget.order.tradeId,
        accountId: widget.accountId,
        data: {
          'accountId' : widget.accountId,
          'price': price,
          'quantity': quantity,
          'takeProfit': takeProfit,
          'stopLoss': stopLoss,
        },
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Modify Limit Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.order.symbol} • ${widget.order.side}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              _buildField(
                dark: dark,
                label: 'Limit Price',
                controller: _priceController,
              ),
              const SizedBox(height: 14),

              _buildField(
                dark: dark,
                label: 'Quantity',
                controller: _quantityController,
              ),
              const SizedBox(height: 14),

              _buildField(
                dark: dark,
                label: 'Take Profit (optional)',
                controller: _takeProfitController,
                optional: true,
              ),
              const SizedBox(height: 14),

              _buildField(
                dark: dark,
                label: 'Stop Loss (optional)',
                controller: _stopLossController,
                optional: true,
              ),
              const SizedBox(height: 12),

              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Update Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required bool dark,
    required String label,
    required TextEditingController controller,
    bool optional = false,
  }) {
    return TradeTextField(
      dark: dark,
      controller: controller,
      labelText: label,
      hintText: optional ? 'Leave empty to clear' : 'Enter $label',
      onChanged: (_) {},
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d*$'),
        ),
      ],
    );
  }
}
