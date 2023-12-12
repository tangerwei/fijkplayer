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
    startPlay();
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setOption(FijkOption.playerCategory, "reconnect", 20);
    await player.setOption(FijkOption.playerCategory, "framedrop", 20);
    await player.setOption(
        FijkOption.playerCategory, "enable-accurate-seek", 1);
    await player.setOption(FijkOption.playerCategory, "mediacodec", 1);
    await player.setOption(FijkOption.playerCategory, "packet-buffering", 0);
    await player.setOption(FijkOption.playerCategory, "soundtouch", 1);

    // 设置声道
    switch (widget.audioTrack) {
      case 1:
        print("setAudioTrack is left");
        await player.setOption(
            FijkOption.playerCategory, "af", "pan=stereo|c0=c0|c1=c0");
        break;
      case 2:
        print("setAudioTrack is right");
        await player.setOption(
            FijkOption.playerCategory, "af", "pan=stereo|c0=c1|c1=c1");
        break;
      default:
        print("ignore setAudioTrack");
    }
    setVideoUrl(widget.url);
  }

  Future<void> setVideoUrl(String url) async {
    try {
      await player.setDataSource(url, autoPlay: true, showCover: true);
    } catch (error) {
      print("播放-异常: $error");
      return;
    }
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
