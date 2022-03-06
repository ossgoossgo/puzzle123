import 'package:flutter/material.dart';
import 'package:puzzle123/def.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:audioplayers/audioplayers.dart';
import 'package:puzzle123/utility/sound_helper.dart';

class HowToPlay extends StatefulWidget {
  HowToPlay({Key? key}) : super(key: key);

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  int _pageIndex = 0;
  late PageController _pageController;
  // AudioCache _player = AudioCache(prefix: 'assets/audios/');

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );
  }

  @override
  void dispose() {
    // _player.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Material(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: SafeArea(
                child: Container(
                  constraints: kIsWeb ? BoxConstraints(maxWidth: Def.webMaxWidth) : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.66,
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
                                  "How to play",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff748384)),
                                )),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        SoundHelper.playClickSound();
                                        // _player.play("click.mp3", volume: 0.3);
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close)))
                            ],
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            itemCount: 3,
                            pageSnapping: true,
                            controller: _pageController,
                            onPageChanged: (int index) {
                              setState(() {
                                _pageIndex = index;
                              });
                            },
                            itemBuilder: (BuildContext ctx, int index) {
                              switch (index) {
                                case 0:
                                  return _buildPage(
                                    "Drag and swipe to select the blocks from the starting point.",
                                    "assets/images/intro1.png",
                                  );

                                case 1:
                                  return _buildPage(
                                    "Blocks that have been swiped will change color.\n\nBlocks that have changed color can no longer be entered.",
                                    "assets/images/intro2.png",
                                  );

                                case 2:
                                  return _buildPage(
                                    "Select the blocks in the order of 1~3, when all the blocks change color, you will win the game.",
                                    "assets/images/intro3.png",
                                  );

                                default:
                                  return _buildPage(
                                    "",
                                    "",
                                  );
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _pageIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  _buildPage(String text, String imagePath) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 10,
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
