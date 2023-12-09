class Audio {
  String path;

  Audio({
    required this.path,
  });

  factory Audio.fromPath(String path) {
    return Audio(path: path);
  }

  factory Audio.fromUrl(String url) {
    return Audio(path: url);
  }

  get name => path.split('/').last.split('.').first;
  get extension => path.split('.').last;
}
