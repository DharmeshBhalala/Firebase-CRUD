import 'package:flutter/material.dart';

class TextFieldWrapper extends StatefulWidget {
  final String? label;
  final TextFormField child;
  final FocusNode? focusNode;

  const TextFieldWrapper({
    Key? key,
    this.label,
    required this.child,
    this.focusNode,
  })  : assert(focusNode != null, "FocusNode can not be null"),
        super(key: key);

  @override
  _TextFieldWrapperState createState() => _TextFieldWrapperState();
}

class _TextFieldWrapperState extends State<TextFieldWrapper> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var decorationTheme = Theme.of(context).inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          elevation: widget.focusNode!.hasFocus ? 10 : 0,
          shadowColor: widget.focusNode!.hasFocus
              ? Theme.of(context).accentColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: widget.focusNode!.hasFocus
                  ? decorationTheme.copyWith(
                      errorStyle: TextStyle(
                        fontSize: 0,
                        height: 0,
                      ),
                    )
                  : decorationTheme,
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
