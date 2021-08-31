class Device {
  String token;
  String platform;
  String version;
  String appVersion;

  Device({this.token, this.platform, this.version, this.appVersion});

  Device.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    platform = json['platform'];
    version = json['version'];
    appVersion = json['app_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['platform'] = this.platform;
    data['version'] = this.version;
    data['app_version'] = this.appVersion;
    return data;
  }
}