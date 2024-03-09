import 'package:nymble_music/album.dart';

abstract class EpisodeState {}

class EpisodesInitial extends EpisodeState {}

class EpisodesLoadInProgress extends EpisodeState {}

class EpisodesLoadSuccess extends EpisodeState {
  final List<PodcastEpisode> episodes;

  EpisodesLoadSuccess({required this.episodes});
}

class EpisodesLoadFailure extends EpisodeState {
  final String error;

  EpisodesLoadFailure({required this.error});
}
