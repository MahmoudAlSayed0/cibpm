import 'package:cibpm/models/response_model.dart';
import 'package:cibpm/services/dio_helper.dart';

class ApiCreds {
  final RequestStatus status;
  final ApiResponse? response;

  ApiCreds({required this.status, this.response});
}
