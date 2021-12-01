import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:loading_indicator/loading_indicator.dart';

class CustomButton extends StatelessWidget {
  final bool enabled;
  final void Function() onPressed;
  final String title;

  const CustomButton({Key? key, this.enabled = true, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: enabled ? onPressed : null,
      child: enabled
          ? Text(title,textAlign: TextAlign.center,)
          : kIsWeb ? LoadingIndicator(indicatorType: Indicator.ballPulse, color: Colors.blue,) :  CircularProgressIndicator(
              // valueColor: new AlwaysStoppedAnimation<Color>(
              //   Theme.of(context).primaryColor,
              // ),
            ),
    );
  }
}
