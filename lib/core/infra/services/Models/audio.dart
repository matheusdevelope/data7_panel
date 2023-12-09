class Audio {
  String path;
  // double volume;
  // bool stopAll;

  Audio({
    required this.path,
    // this.volume = 1,
    // this.stopAll = true,
  });

  factory Audio.fromPath(String path) {
    return Audio(path: path);
  }

  factory Audio.fromUrl(String url) {
    return Audio(path: url);
  }
}
