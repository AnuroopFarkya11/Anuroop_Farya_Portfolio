import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/logger/logger.dart';
import 'package:my_portfolio/core/service/api_service/api_service.dart';
import 'package:my_portfolio/models/project.dart';

Logger _logger = Logger("Project Provider");

final projectProvider = FutureProvider<List<ProjectModel>>((ref) async {
  var dioClient = ref.watch(dioClientProvider);
  List<ProjectModel> list = await fetchReadme(dioClient);
  _logger.log("Projects" + list.toString());
  return list;
});

Future<List<ProjectModel>> fetchReadme(DioClient dioClient) async {
  List<ProjectModel> projects = [];
  const url = 'https://raw.githubusercontent.com/AnuroopFarkya11/Anuroop_Farya_Portfolio/refs/heads/main/projects_details';

  final response = await dioClient.get(url);
  if (response.isSuccess) {

    try {
      List<dynamic> data = jsonDecode(response.data);
      List<ProjectModel> projects = data.map((e)=>ProjectModel.fromJson(e)).toList();
      return projects;
    } catch (e, s) {
      _logger.log(e.toString() + s.toString());
    }
  } else {
    _logger.log("Failed to retrieve");
  }
  return projects;
}
