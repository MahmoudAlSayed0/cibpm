import 'dart:convert';

class ApiResponse {
  final String process_id;
  final String time_stamp;

  ApiResponse({
    required this.process_id,
    required this.time_stamp,
  });

  ApiResponse copyWith({
    String? process_id,
    String? time_stamp,
  }) {
    return ApiResponse(
      process_id: process_id ?? this.process_id,
      time_stamp: time_stamp ?? this.time_stamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'result_id': process_id,
      'time_stamp': time_stamp,
    };
  }

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      process_id: map['process_id'] ?? '',
      time_stamp: map['time_stamp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(String source) =>
      ApiResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'ApiResponse(process_id: $process_id, time_stamp: $time_stamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiResponse &&
        other.process_id == process_id &&
        other.time_stamp == time_stamp;
  }

  @override
  int get hashCode => process_id.hashCode ^ time_stamp.hashCode;
}
