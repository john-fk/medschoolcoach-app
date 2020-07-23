import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final bool showObscureTextIcon;
  final List<FormFieldValidator<String>> validators;
  final List<TextInputFormatter> formatterList;
  final int linesCount;
  final String hintText;

  final VoidCallback onEditingComplete;
  final VoidCallback onTap;
  final TextInputAction textInputAction;
  final bool readOnly;

  const MainTextField({
    Key key,
    @required this.controller,
    this.labelText,
    @required this.keyboardType,
    @required this.onEditingComplete,
    this.focusNode,
    this.validators = const [],
    this.formatterList = const [],
    this.showObscureTextIcon = false,
    this.textInputAction = TextInputAction.next,
    // ignore: avoid_init_to_null
    this.onTap = null,
    this.readOnly = false,
    this.linesCount = 1,
    this.hintText,
  }) : super(key: key);

  @override
  _MainTextFieldState createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 2,
            ),
            child: Text(widget.labelText,
                style: smallResponsiveFont(
                  context,
                  fontColor: FontColor.Content3,
                )),
          ),
        TextFormField(
          maxLines: widget.linesCount,
          minLines: widget.linesCount,
          style: normalResponsiveFont(
            context,
          ),
          controller: widget.controller,
          obscureText: widget.showObscureTextIcon ? _obscureText : false,
          keyboardType: widget.keyboardType,
          focusNode: widget.focusNode,
          validator: _validateField,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          inputFormatters: widget.formatterList,
          cursorColor: Style.of(context).colors.accent,
          onEditingComplete: widget.onEditingComplete,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            errorStyle: Style.of(context).font.error.copyWith(
                  fontSize: whenDevice(
                    context,
                    large: 10,
                    tablet: 15,
                  ),
                ),
            hintText: widget.hintText,
            suffixIcon: widget.showObscureTextIcon
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Style.of(context).colors.accent,
                    ),
                    splashColor: Style.of(context).colors.background,
                    onPressed: _toggle,
                  )
                : null,
            errorMaxLines: 10,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(
              whenDevice(context, large: 10, tablet: 20),
            ),
            filled: true,
            fillColor: Color(0xffECF4FA),
          ),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String _validateField(String value) {
    for (final validator in widget.validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
