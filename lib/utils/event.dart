import 'package:audioplayers/audioplayers.dart';
import 'package:event_bus/event_bus.dart';
import 'package:lizhi_music_flutter/provider/global_provider.dart';

EventBus eventBus = EventBus();

class SongPlayingStateChange {
  SongState state;

  SongPlayingStateChange(this.state);
}