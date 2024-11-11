import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/pages/home/home.dart';
import 'package:lizhi_music_flutter/provider/global_provider.dart';
import 'package:lizhi_music_flutter/utils/song_player.dart';
import 'package:lizhi_music_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MusicSourceUtils.init();
  await SongPlayer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(create: (_) => GlobalProvider())
      ], 
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const Home(),
      ),);
  }
}
