class Audio {
  String path;
  double volume;
  bool stopAll;
  Audio({
    required this.path,
    this.volume = 1,
    this.stopAll = true,
  });
}
