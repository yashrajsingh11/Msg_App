class ModelPredict {
  ModelPredict({
    required this.prediction,
  });
  late final List<Prediction> prediction;

  ModelPredict.fromJson(Map<String, dynamic> json) {
    prediction = List.from(json['prediction'])
        .map((e) => Prediction.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['prediction'] = prediction.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Prediction {
  Prediction({
    this.result,
    this.url,
    this.dateTime,
    this.sendername,
  });
  double? result;
  String? sendername;
  DateTime? dateTime;
  String? url;

  Prediction.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['url'] = url;
    return _data;
  }
}
