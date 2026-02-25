import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      // 🔹 Cold start
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleUri(uri);
      }

      // 🔹 Background / Foreground
      _sub = _appLinks.uriLinkStream.listen((uri) {
        _handleUri(uri);
      });
    } catch (e) {
      debugPrint("Deep link error: $e");
    }
  }

  void _handleUri(Uri uri) {
    debugPrint("Received URI: $uri");

    if (uri.host != "codecraft.com") return;

    if (uri.pathSegments.isEmpty) return;

    final first = uri.pathSegments.first;

    if (first == "product") {
      final id =
          uri.pathSegments.length > 1 ? uri.pathSegments[1] : "0";

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ProductScreen(id: id),
        ),
      );
    } else if (first == "profile") {
      final username =
          uri.pathSegments.length > 1 ? uri.pathSegments[1] : "guest";

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ProfileScreen(username: username),
        ),
      );
    } else {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

// ------------------ HOME ------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateFromButton(BuildContext context, String url) {
    final uri = Uri.parse(url);
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) {
          if (uri.pathSegments.first == "product") {
            return ProductScreen(id: uri.pathSegments[1]);
          } else if (uri.pathSegments.first == "profile") {
            return ProfileScreen(username: uri.pathSegments[1]);
          } else {
            return const NotFoundScreen();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CodeCraft App")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                navigateFromButton(
                  context,
                  "https://codecraft.com/product/123",
                );
              },
              child: const Text("Go to Product 123"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigateFromButton(
                  context,
                  "https://codecraft.com/profile/shakti",
                );
              },
              child: const Text("Go to Profile Shakti"),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PRODUCT ------------------

class ProductScreen extends StatelessWidget {
  final String id;

  const ProductScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Page")),
      body: Center(
        child: Text(
          "Product ID: $id",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

// ------------------ PROFILE ------------------

class ProfileScreen extends StatelessWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: Center(
        child: Text(
          "Username: $username",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

// ------------------ 404 ------------------

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("404")),
      body: const Center(
        child: Text(
          "Page Not Found",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}