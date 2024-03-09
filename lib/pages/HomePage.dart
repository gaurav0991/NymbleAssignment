import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/pages/DetailsPage.dart';
import 'package:nymble_music/album_api_service.dart';
import 'package:nymble_music/bloc/album_bloc.dart';
import 'package:nymble_music/events/album_event.dart';
import 'package:nymble_music/States/album_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpisodeBloc(episodeApiService: EpisodeApiService())
        ..add(EpisodeRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Episodes'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
              },
            ),
          ],
        ),
        body: BlocBuilder<EpisodeBloc, EpisodeState>(
          builder: (context, state) {
            if (state is EpisodesLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EpisodesLoadSuccess) {
              return ListView.builder(
                itemCount: state.episodes.length,
                itemBuilder: (context, index) {
                  final episode = state.episodes[index];
                  return ListTile(
                    title: Text(episode.title),
                    subtitle: Text(episode.description.length > 50
                        ? '${episode.description.substring(0, 50)}...'
                        : episode.description),
                    leading: episode.imageUrl.containsKey("url")
                        ? Hero(
                            tag:
                                'episodeImage${episode.title}', // Ensure unique tag; use episode id or equivalent
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(episode.imageUrl['url']),
                            ),
                          )
                        : Icon(Icons.music_off),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailsPage(episode: episode)),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('Failed to fetch episodes'));
            }
          },
        ),
      ),
    );
  }
}
