import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/models/position/position_model.dart';
import '../text_field/trade_text_field.dart';

class PartialCloseBottomSheet extends StatefulWidget {
  const PartialCloseBottomSheet({
    super.key,
    required this.position,
  });

  final PositionModel position;

  @override
  State<PartialCloseBottomSheet> createState() =>
      _PartialCloseBottomSheetState();
}

class _PartialCloseBottomSheetState
    extends State<PartialCloseBottomSheet> {
  late final TextEditingController _quantityController;

  String? _quantityError;

  @override
  void initState() {
    super.initState();

    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark =
        Theme.of(context).brightness == Brightness.dark;

    final position = widget.position;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? AppColors.darkBg : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Center(
                    child: Text(
                      'Partial Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text(
                        'Position Size',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        position.quantity.toStringAsFixed(5),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Close Quantity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  TradeTextField(
                    dark: dark,
                    controller: _quantityController,
                    hintText: 'Enter quantity',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,5}'),
                      ),
                    ],
                    errorText: _quantityError,
                    onChanged: (value) {
                      if (_quantityError != null) {
                        setState(() {
                          _quantityError = null;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Maximum: ${position.quantity.toStringAsFixed(5)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        dark ? Colors.blue : Colors.grey.shade400,
                        foregroundColor:
                        dark
                            ? AppColors.white
                            : AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final text = _quantityController.text.trim();

                        if (text.isEmpty) {
                          setState(() {
                            _quantityError = 'Please enter quantity';
                          });
                          return;
                        }

                        final quantity = double.tryParse(text);

                        if (quantity == null) {
                          setState(() {
                            _quantityError = 'Enter a valid quantity';
                          });
                          return;
                        }

                        if (quantity <= 0) {
                          setState(() {
                            _quantityError = 'Quantity must be greater than 0';
                          });
                          return;
                        }

                        if (quantity > position.quantity) {
                          setState(() {
                            _quantityError =
                            'Quantity cannot be greater than ${position.quantity.toStringAsFixed(5)}';
                          });
                          return;
                        }

                        setState(() {
                          _quantityError = null;
                        });

                        Navigator.pop(
                          context,
                          quantity,
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}