import 'dart:isolate';

import 'package:example/channels.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void changeVideo(List<dynamic> data) {
  SendPort sendPort = data[0];
  ChangeVideoParams params = data[1];
  params.controller.changeVideo(playVideoFrom: params.playVideoFrom);
}

class ChangeVideoParams {
  final PodPlayerController controller;
  final PlayVideoFrom playVideoFrom;

  ChangeVideoParams(this.controller, this.playVideoFrom);
}

class PlayVideoFromNetwork extends StatefulWidget {
  const PlayVideoFromNetwork({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<PlayVideoFromNetwork> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();

  late Channel current;

  @override
  void initState() {
    current = channels[0];
    initPlayer();
    super.initState();
  }

  PlayVideoFrom get playFrom {
    return PlayVideoFrom.network(
      current.url,
      formatHint: VideoFormat.hls,
    );
  }

  void initPlayer() {
    controller = PodPlayerController(
      playVideoFrom: playFrom,
    )..initialise();
  }

  Future<void> change() async {
    ReceivePort port = ReceivePort();
    Isolate isolate = await Isolate.spawn<List<dynamic>>(
        changeVideo, [port.sendPort, ChangeVideoParams(controller, playFrom)]);
    isolate.kill();
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play video from Netwok')),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              PodVideoPlayer(
                controller: controller,
                podProgressBarConfig: const PodProgressBarConfig(
                  padding: kIsWeb
                      ? EdgeInsets.zero
                      : EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                  playingBarColor: Colors.blue,
                  circleHandlerColor: Colors.blue,
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  children: List.generate(
                    channels.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          current = channels[index];
                          change();
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          color: Colors.red,
                          child: Text(channels[index].name)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _loadVideoFromUrl() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: videoTextFieldCtr,
            decoration: const InputDecoration(
              labelText: 'Enter video url',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FocusScope(
          canRequestFocus: false,
          child: ElevatedButton(
            onPressed: () async {
              if (videoTextFieldCtr.text.isEmpty) {
                snackBar('Please enter the url');
                return;
              }
              try {
                snackBar('Loading....');
                FocusScope.of(context).unfocus();
                await controller.changeVideo(
                  playVideoFrom: PlayVideoFrom.network(videoTextFieldCtr.text),
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } catch (e) {
                snackBar('Unable to load,\n $e');
              }
            },
            child: const Text('Load Video'),
          ),
        ),
      ],
    );
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
  }
}
