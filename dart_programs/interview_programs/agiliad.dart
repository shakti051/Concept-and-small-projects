// void main() {
//   final list1 = [1, 2, 3];
//   list1.add(4);
//   list1 = [5, 6];
//   print(list1);
// }

// void main() {
//   const list2 = [1, 2, 3];
//   list2.add(4);
//   print(list2);
// const currentTime = DateTime.now();
// }

// void main() {
//   print("A");
//   Future(() => print("B"));
//   Future.microtask(() => print("C"));
//   print("D");
// }

// class User {
//   final String name;
//   User(this.name);
// }

// void main() {
//   var u1 = User('Alice');
//   var u2 = User('Alice');
//   print(u1 == u2);
// }

// class User {
//   final String name;
//  const User(this.name);
// }

// void main() {
//   const u1 = User('Alice');
//   const u2 = User('Alice');
//   print(u1 == u2);
// }

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse('https://video.mp4'),
//     );

//     _controller.initialize().then((_) {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: VideoPlayer(_controller),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// complete video player code 

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const VideoScreen(),
//     );
//   }
// }

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({super.key});

//   @override
//   State<VideoScreen> createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//       ),
//     )..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Network Video'),
//       ),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : const CircularProgressIndicator(),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               _controller.play();
//             }
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying
//               ? Icons.pause
//               : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }