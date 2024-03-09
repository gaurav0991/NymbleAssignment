class PodcastEpisode {
  final String title;
  final String description;
  final imageUrl;
  final String audioUrl;

  PodcastEpisode({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.audioUrl,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    return PodcastEpisode(
      title: json['title'].toString() ?? 'No title',
      description: json['description'] ?? 'No description',
      imageUrl: (json['image'] ?? {}),
      audioUrl: json['url'] ?? '',
    );
  }
}
