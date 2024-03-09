import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/album.dart'; // Your PodcastEpisode model path
import 'package:firebase_auth/firebase_auth.dart';

class DetailsPage extends StatefulWidget {
  final PodcastEpisode episode;

  const DetailsPage({Key? key, required this.episode}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isPlaying = false;
  bool isFavorited = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    // Optionally, load initial favorite state from Firestore
  }

  Future<void> _checkFavoriteStatus() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.episode.title)
          .get();
      setState(() {
        isFavorited = doc.exists ? doc['isFavorited'] : false;
      });
    }
  }

  Future<void> _toggleFavoriteStatus() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && isFavorited != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.episode.title);

      if (isFavorited!) {
        // Remove from favorites
        await docRef.delete();
      } else {
        // Add to favorites
        await docRef.set({
          'title': widget.episode.title,
          'imageUrl': widget.episode.imageUrl['url'],
          'isFavorited': true,
        });
      }
      setState(() {
        isFavorited = !isFavorited!;
      });
    }
  }

  void togglePlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.episode.audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.episode.title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'episodeImage${widget.episode.title}',
              child: Image.network(widget.episode.imageUrl['url'],
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.episode.title,
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 8),
                  Text(widget.episode.description.substring(0, 29),
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 30),
                        color: Colors.red,
                        onPressed: _toggleFavoriteStatus,
                      ),
                      ElevatedButton.icon(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(isPlaying ? 'Pause' : 'Play'),
                        onPressed: togglePlay,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose(); // Properly dispose the audio player
  }
}
