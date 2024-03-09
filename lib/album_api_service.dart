import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nymble_music/album.dart';

class EpisodeApiService {
  Future<List<PodcastEpisode>> fetchEpisodes() async {
    const String url =
        'https://player.fm/featured/true-crime.json?episode_detail=full';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> episodesJson = jsonDecode(response.body)['episodes'];
      print("Episodes");
      print(episodesJson.sublist(0, 1).length);
      List<PodcastEpisode> episodes = episodesJson.map((episodeJson) {
        return PodcastEpisode.fromJson(episodeJson);
      }).toList();
      return episodes;
    } else {
      throw Exception('Failed to load episodes');
    }
  }
}
