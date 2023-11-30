class Vgg16 {
  String? meanSbp;
  String? meanDbp;

  Vgg16(this.meanSbp, this.meanDbp);

  Vgg16.fromMap(Map<String, dynamic> mapData) {
    meanSbp = mapData['Mean SBP'].toString();
    meanDbp = mapData['Mean DBP'].toString();
  }
}

class ResNet101 {
  String? meanSbp;
  String? meanDbp;

  ResNet101(this.meanSbp, this.meanDbp);

  ResNet101.fromMap(Map<String, dynamic> mapData) {
    meanSbp = mapData['Mean SBP'].toString();
    meanDbp = mapData['Mean DBP'].toString();
  }
}

class MessageResult {
  late final Vgg16 vgg16;
  late final ResNet101 resNet101;
  MessageResult({required this.vgg16, required this.resNet101});

  MessageResult.fromMap(Map<String, dynamic> mapData) {
    vgg16 = Vgg16.fromMap(mapData['VGG16']);
    resNet101 = ResNet101.fromMap(mapData['ResNet101']);
  }
}
