import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/screens/chat_app_screen.dart';
import 'package:inference/screens/sign_up_screen.dart';
import 'package:inference/services/supabase_services.dart';
import 'package:inference/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/widgets/custom_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        fontFamily: 'Poppins',
      ),
      home: AuthApp(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}

class AuthApp extends ConsumerStatefulWidget {
  const AuthApp({super.key});

  @override
  ConsumerState<AuthApp> createState() => _AuthApp();
}

class _AuthApp extends ConsumerState<AuthApp> {
  Map<String, dynamic>? _authUserData;
  String? routeName;
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    supabase.auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      final newUserData = data.session?.user.userMetadata;
      setState(() {
        _authUserData = newUserData;
      });

      if (data.event == AuthChangeEvent.signedIn && user != null) {
        final localUsername = ref.read(userNameProvider);

        await insertData(
          user.id,
          newUserData?['email'],
          newUserData?['name'] ?? localUsername,
          newUserData?['avatar_url'],
        );
        ref.read(authUserProvider.notifier).state = {
          'username': newUserData?['name'] ?? localUsername,
          'email': newUserData?['email'],
          'dp': newUserData?['avatar_url'],
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(title: "Ozone"),
      body: Center(
        child: _authUserData == null
            // ? HomeScreen(authUserData: _authUserData)
            ? SignUpScreen()
            : ChatArea(),
      ),
    );
  }
}
