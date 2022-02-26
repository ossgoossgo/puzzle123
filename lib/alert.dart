import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'def.dart';

class Alert extends StatelessWidget {
  final String? title;
  final String? msg;
  final String? btn1Text;
  final String? btn2Text;
  final Color? btn1Color;
  final Color? btn2Color;
  final Color? btn1TextColor;
  final Color? btn2TextColor;
  final Function()? onBtn1Pressed;
  final Function()? onBtn2Pressed;
  final Function()? onCancel;
  Alert({Key? key, title, msg, btn1Text, btn2Text, btn1TextColor, btn2TextColor, btn1Color, btn2Color, onBtn1Pressed, onBtn2Pressed, onCancel})
      : title = title,
        msg = msg,
        btn1Text = btn1Text,
        btn2Text = btn2Text,
        btn1TextColor = btn1TextColor,
        btn2TextColor = btn2TextColor,
        btn1Color = btn1Color ?? Colors.red.shade200,
        btn2Color = btn2Color ?? Colors.red.shade200,
        onBtn1Pressed = onBtn1Pressed,
        onBtn2Pressed = onBtn2Pressed,
        onCancel = onCancel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          constraints: kIsWeb ? BoxConstraints(maxWidth: Def.webMaxWidth) : null,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              color: const Color(0xFFFDFDFD),
              child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  color: const Color(0xFFECF0F1),
                  child: Stack(
                    children: [
                      //title
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        // width: MediaQuery.of(context).size.width * 0.7,

                        child: Center(
                            child: Text(
                          title ?? "",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff748384)),
                        )),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (onCancel != null) onCancel!();
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close)))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                        backgroundColor: MaterialStateProperty.all(btn1Color),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onBtn1Pressed!();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                        child: FittedBox(
                          child: Baseline(
                            baselineType: TextBaseline.alphabetic,
                            baseline: 1.5 * 25 - 1.5 * 25 / 4, //height * textSize - height * textSize / 4;
                            child: Text(
                              btn1Text ?? "",
                              style: TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2", color: Colors.white),
                            ),
                          ),
                        ),
                      )),
                ),
                if (btn2Text != null)
                  Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                          backgroundColor: MaterialStateProperty.all(btn2Color),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onBtn2Pressed != null) onBtn2Pressed!();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                          child: FittedBox(
                            child: Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: 1.5 * 25 - 1.5 * 25 / 4, //height * textSize - height * textSize / 4;
                              child: Text(
                                btn2Text ?? "",
                                style: const TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2", color: Colors.white),
                              ),
                            ),
                          ),
                        )),
                  ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
