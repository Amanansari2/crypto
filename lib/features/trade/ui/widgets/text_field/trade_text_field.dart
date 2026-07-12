import 'package:flutter/material.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

class TradeTextField extends StatefulWidget {

  final bool dark;
  final String? hintText;
  final String? labelText;

  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  final Widget? prefix;
  final Widget? suffix;

  final VoidCallback? onPrefixTap;
  final VoidCallback? onSuffixTap;

  final bool hideAffixesWhenTyping;
  final bool readOnly;
  final bool showAffixesUntilFocused;

  const TradeTextField({
    super.key,
    required this.dark,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.onPrefixTap,
    this.onSuffixTap,
    this.hideAffixesWhenTyping = false,
    this.readOnly = false,
    this.showAffixesUntilFocused = false,
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
      height: 40,
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
            readOnly: widget.readOnly,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType:
            TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: widget.dark
                    ? AppColors.white
                    : AppColors.black,
                fontSize: 16,
                height: 1.0
            ),

            decoration:  InputDecoration(
              labelText: widget.showAffixesUntilFocused
                  ? (isEditing ? widget.labelText : null)
                  : widget.labelText,
              labelStyle: TextStyle(
                color: widget.dark ? AppColors.white : AppColors.black
              ),
              hintText: widget.hintText ,
                hintStyle:  TextStyle(
                    color: widget.dark ? AppColors.white : AppColors.black
                ),
                fillColor: Colors.transparent,
                filled: false,
              border: border,

              enabledBorder: border,

              focusedBorder: border,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 6,
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

              suffixIcon: hideAffixes
                  ? null
                  : widget.suffix == null
                  ? null
                  : GestureDetector(
                onTap: widget.onSuffixTap,
                child: widget.suffix,
              ),

            ),

            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}