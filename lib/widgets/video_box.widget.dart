import 'package:flutter/material.dart';
import 'package:video_box/video_box.dart';

class VideoBoxWidget extends StatefulWidget {
  final String url;
  const VideoBoxWidget({required this.url, super.key});

  @override
  State<VideoBoxWidget> createState() => _VideoBoxWidgetState();
}

class _VideoBoxWidgetState extends State<VideoBoxWidget> {
  late VideoController vc;

  @override
  void initState() {
    vc = VideoController(
        source: VideoPlayerController.networkUrl(Uri.parse(widget.url)))
      ..addInitializeErrorListenner((e) {
        print('[video box init] error: ' + e.message);
      })
      ..initialize().then((e) {
        if (e != null) {
          print('[video box init] error: ' + e.message);
        } else {
          print('[video box init] success');
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    vc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VideoBox(controller: vc),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoBoxWidget extends StatefulWidget {
//   final String url;
//   const VideoBoxWidget({required this.url, super.key});

//   @override
//   State<VideoBoxWidget> createState() => _VideoBoxWidgetState();
// }

// class _VideoBoxWidgetState extends State<VideoBoxWidget> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.url)
//       ..addListener(() {
//         if (_controller.value.hasError) {
//           print('[video player] error: ' + _controller.value.errorDescription!);
//         }
//       })
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : Center(child: CircularProgressIndicator());
//   }
// }
