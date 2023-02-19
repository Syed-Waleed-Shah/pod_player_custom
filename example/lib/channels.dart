class Channel {
  final String url;
  final String name;

  Channel(this.url, this.name);
}

List<Channel> channels = [
  Channel("https://sc.id-tv.kz/Kinohit_hd.m3u8", 'Channel1'),
  Channel("https://sc.id-tv.kz/Kinohit_hd.m3u8", 'Channel2'),
  Channel("https://tv-trthaber.medya.trt.com.tr/master.m3u8", 'Channel3'),
  Channel(
      "https://cdn1.skygo.mn/live/disk1/TV8HD/HLS-FTA/TV8HD.m3u8", 'Channel4'),
  Channel(
      "https://api.trtworld.com/livestream/v1/WcM3Oa2LHD9iUjWDSRUI335NkMWVTUV351H56dqC/master.m3u8",
      'Channel5'),
  Channel(
      "https://tscstreaming-lh.akamaihd.net/i/TSCLiveStreaming_1@91031/master.m3u8",
      'Channel6'),
  Channel("https://ythls.onrender.com/channel/UC8ROUUjHzEQm-ndb69CX8Ww.m3u8",
      'Channel7'),
  Channel("https://tastemadetravel-vizio.amagi.tv/playlist.m3u8", 'Channel8'),
  Channel("https://dns2.rtvbn.com:8080/live/index.m3u8", 'Channel9'),
  Channel("https://jukin-weatherspy-2-in.samsung.wurl.tv/playlist.m3u8",
      'Channel10'),
  Channel("https://30a-tv.com/feeds/xodglobal/30atv.m3u8", 'Channel11'),
  Channel("https://30a-tv.com/sidewalks.m3u8", 'Channel12')
];
