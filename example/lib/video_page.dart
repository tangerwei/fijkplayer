import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';
// import 'custom_ui.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  final int? audioTrack; // 0.立体声 1.左声道 2.右声道

  VideoScreen({required this.url, this.audioTrack});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    startPlay();
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);

    // 设置声道
    switch(widget.audioTrack) {
      case 1:
        print("setAudioTrack is left");
        await player.setOption(FijkOption.playerCategory, "af", "pan=stereo|c1=c0");
        break;
      case 2:
        print("setAudioTrack is right");
        await player.setOption(FijkOption.playerCategory, "af", "pan=stereo|c0=c1");
        break;
      default:
        print("ignore setAudioTrack");
    }
    await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
      print("setDataSource error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FijkAppBar.defaultSetting(title: "Video"),
      body: Container(
        child: Center(
          child: FijkView(
            player: player,
            panelBuilder: fijkPanel2Builder(snapShot: true),
            fsFit: FijkFit.fill,
            // panelBuilder: simplestUI,
            // panelBuilder: (FijkPlayer player, BuildContext context,
            //     Size viewSize, Rect texturePos) {
            //   return CustomFijkPanel(
            //       player: player,
            //       buildContext: context,
            //       viewSize: viewSize,
            //       texturePos: texturePos);
            // },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
