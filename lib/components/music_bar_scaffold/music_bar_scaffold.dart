import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/components/music_bar/music_bar.dart';
import 'package:lizhi_music_flutter/constants/constants.dart';

class MusicBarScaffold extends StatefulWidget {
  final Widget child;
  final String appBarTitle;
  final bool showBackIcon;
  
  const MusicBarScaffold({
    required this.child,
    this.appBarTitle = '',
    this.showBackIcon = false,
    Key? key
  }) : super(key: key);

  @override
  State<MusicBarScaffold> createState() {
    return _MusicBarScaffold();
  }
}

class _MusicBarScaffold extends State<MusicBarScaffold> {
  PreferredSizeWidget? _buildAppBar() {
    if (widget.appBarTitle.isNotEmpty || widget.showBackIcon) {
      return AppBar(
        title: widget.appBarTitle.isNotEmpty ? Text(widget.appBarTitle) : null,
        leading: widget.showBackIcon ? GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new)
        ) : null,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: LayoutConstants.bottomMusicBarHeight),
          child: SingleChildScrollView(
            child: widget.child
          ),
        )
      ),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverFillRemaining(
      //       hasScrollBody: true,
      //       child: SafeArea(
      //         child: widget.child,
      //       ),
      //     )
      //   ],
      // ),
      floatingActionButton: MusicBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}