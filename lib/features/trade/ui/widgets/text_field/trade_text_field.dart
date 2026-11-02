import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

class TradeTextField extends StatefulWidget {
  final bool obscureText;
  final double height;
  final TextAlign textAlign;
  final double textLetterSpacing;
  final double hintLetterSpacing;

  final bool dark;
  final String? hintText;
  final String? labelText;

  final TextEditingController controller;

  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;


  final VoidCallback? onPrefixTap;
  final VoidCallback? onSuffixTap;

  final bool hideAffixesWhenTyping;
  final bool readOnly;
  final bool showAffixesUntilFocused;
  final List<TextInputFormatter>? inputFormatters;

  const TradeTextField({
    this.textLetterSpacing = 0,
    this.hintLetterSpacing = 0,
    this.textAlign = TextAlign.start,
    this.height = 40,
    super.key,
    this.keyboardType =
    const TextInputType.numberWithOptions(decimal: true),
    this.validator,
    required this.dark,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.errorText,
    this.onPrefixTap,
    this.onSuffixTap,
    this.hideAffixesWhenTyping = false,
    this.readOnly = false,
    this.showAffixesUntilFocused = false,
    this.inputFormatters,
    this.obscureText = false,
  });

  @override
  State<TradeTextField> createState() => _TradeTextFieldState();
}

class _TradeTextFieldState extends State<TradeTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });

  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    _focusNode.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant TradeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.readOnly != widget.readOnly ||
        oldWidget.showAffixesUntilFocused != widget.showAffixesUntilFocused) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: widget.dark
            ? AppColors.blue
            : Colors.grey.withOpacity(0.4),
      ),
    );

    final hasText = widget.controller.text.isNotEmpty;
    final isEditing = _focusNode.hasFocus || hasText;

    final hideAffixes =
    widget.showAffixesUntilFocused
        ? isEditing
        : (widget.hideAffixesWhenTyping && hasText);

    return SizedBox(
      // height: 40,
      height: widget.errorText != null ? widget.height + 15 : widget.height,
      // height: widget.errorText != null ? 55 : 40,
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme:
            TextSelectionThemeData(
              cursorColor: widget.dark
                  ? AppColors.white
                  : AppColors.black,

              selectionHandleColor:
              widget.dark
                  ? Colors.white
                  : Colors.black,

              selectionColor:
              (widget.dark
                  ? Colors.white
                  : Colors.black)
                  .withOpacity(0.25),
            ),
          ),
          child: TextFormField(
            obscureText: widget.obscureText,
            inputFormatters: widget.inputFormatters,
            readOnly: widget.readOnly,
            controller: widget.controller,
            focusNode: _focusNode,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textAlign: widget.textAlign,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: widget.dark
                    ? AppColors.white
                    : AppColors.black,
                fontSize: 16,
                height: 1.25,
              letterSpacing: widget.textLetterSpacing,
            ),

            decoration:  InputDecoration(
              labelText: widget.showAffixesUntilFocused
                  ? (isEditing ? widget.labelText : null)
                  : widget.labelText,
              errorText: widget.errorText,
              labelStyle: TextStyle(
                color: widget.dark ? AppColors.white : AppColors.black
              ),
              hintText: widget.hintText ,
                hintStyle:  TextStyle(
                    color: widget.dark ? AppColors.white : AppColors.black,
                  letterSpacing: widget.hintLetterSpacing,
                ),
                fillColor: Colors.transparent,
                filled: false,
              border: border,

              enabledBorder: border,

              focusedBorder: border,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6
              ),

              prefixIcon: hideAffixes
                  ? null
                  : widget.prefix == null
                  ? null
                  : GestureDetector(
                onTap:() {
                  _focusNode.unfocus();
                  widget.onPrefixTap?.call();
                },
                child: widget.prefix,
              ),

              suffixIcon: hideAffixes || widget.suffix == null
                  ? null
                  : IconButton(
                onPressed: widget.onSuffixTap,
                icon: widget.suffix!,
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
              ),

            ),

            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}