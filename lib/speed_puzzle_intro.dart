import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:puzzle123/def.dart';

class SpeedPuzzleIntro extends StatefulWidget {
  SpeedPuzzleIntro({Key? key}) : super(key: key);

  @override
  State<SpeedPuzzleIntro> createState() => _SpeedPuzzleIntroState();
}

class _SpeedPuzzleIntroState extends State<SpeedPuzzleIntro> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Material(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
            constraints: kIsWeb ? BoxConstraints(maxWidth: Def.webMaxWidth) : null,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: const Color(0xFFFDFDFD),
                  child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    //title
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      width: MediaQuery.of(context).size.width * 0.7,
                      color: const Color(0xFFECF0F1),
                      child: const Center(
                          child: Text(
                        "How to play",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff748384)),
                      )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 200,
                      child: Image.asset("assets/images/speed_puzzle_intro.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Pass all the levels within the time limit.",
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                            backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                            child: FittedBox(
                              child: Baseline(
                                baselineType: TextBaseline.alphabetic,
                                baseline: 1.5 * 25 - 1.5 * 25 / 4, //height * textSize - height * textSize / 4;
                                child: Text(
                                  "Ready",
                                  style: TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2", color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
