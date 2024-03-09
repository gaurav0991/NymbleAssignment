import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/album.dart';
import 'package:nymble_music/album_api_service.dart';
import 'package:nymble_music/album_event.dart';
import 'package:nymble_music/album_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final EpisodeApiService episodeApiService;

  EpisodeBloc({required this.episodeApiService}) : super(EpisodesInitial()) {
    on<EpisodeRequested>((event, emit) async {
      emit(EpisodesLoadInProgress());
      try {
        print("here");
        final List<PodcastEpisode> episodes =
            await episodeApiService.fetchEpisodes();
        print(episodes);
        print("here2");

        emit(EpisodesLoadSuccess(episodes: episodes));
      } catch (e) {
        emit(EpisodesLoadFailure(error: e.toString()));
      }
    });
  }
}
