import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlaying = false;
  double value = 0;

  final player = AudioPlayer();

  Duration? duration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    initPlay();
  }

  void initPlay() async {
    await player.setSource(AssetSource("new_song.mp3"));

    duration = await player.getDuration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/lord_shiva.jpeg"),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              color: Colors.black38,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/lord_shiva.jpeg",
                width: 250,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Summer Vibes",
              style: TextStyle(
                  color: Colors.white, fontSize: 30, letterSpacing: 6),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(value / 60).floor()} : ${(value % 60).floor()}',
                  style: const TextStyle(color: Colors.white),
                ),
                Slider.adaptive(
                  onChanged: ((value) {}),
                  min: 0.0,
                  max: duration!.inSeconds.toDouble(),
                  value: value,
                  onChangeEnd: ((newValue) async {
                    setState(() {
                      value = newValue;
                      print('NewValue : $newValue');
                    });
                    // can move slider in between
                    player.pause();
                    await player.seek(Duration(seconds: newValue.toInt()));
                    player.resume();
                  }),
                  activeColor: Colors.purple[200],
                ),
                Text(
                  "${duration!.inMinutes} : ${duration!.inSeconds % 60}",
                  // "0.00",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: (() async {
                  // to pause
                  if (isPlaying) {
                    // isPlaying - false
                    await player.pause();
                    setState(() {
                      isPlaying = !isPlaying;
                      print('print if block : ${isPlaying}');
                    });
                  } else {
                    setState(() {
                      isPlaying = !isPlaying;
                      print('print else block : ${isPlaying}');
                    });
                    await player.resume();
                    // add tracking for the slider
                    player.onPositionChanged.listen(((positionChange) {
                      // this value will keep track of timestamp
                      setState(() {
                        value = positionChange.inSeconds.toDouble();
                      });
                    }));
                  }
                }),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.purple[200],
                  size: 30,
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
