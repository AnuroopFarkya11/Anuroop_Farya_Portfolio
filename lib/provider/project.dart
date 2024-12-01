import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/logger/logger.dart';
import 'package:my_portfolio/core/service/api_service/api_service.dart';
import 'package:my_portfolio/models/project.dart';

final projectProvider = FutureProvider<List<ProjectModel>>((ref) async {
  var dioClient = ref.watch(dioClientProvider);
  List<ProjectModel> list = await fetchReadme(dioClient);
  return list;
});

Future<List<ProjectModel>> fetchReadme(DioClient dioClient) async {
  List<String> repos = ["KuChat_ChatApp"];
  List<ProjectModel> projects = [];
  for (String repo in repos) {
    Logger _logger = Logger("Project : $repo fetching");

    final url = 'https://raw.githubusercontent.com/AnuroopFarkya11/' +
        repo +
        '/refs/heads/master/details.json';
    final response = await dioClient.get(url);
    if (response.isSuccess) {
      final data = response.data;
      _logger.log(data);
      try {
        ProjectModel model = ProjectModel.fromJson(jsonDecode(data));
        projects.add(model);
      } catch (e, s) {
        _logger.log(e.toString() + s.toString());
      }
    } else {
      _logger.log("Failed to retrieve");
    }
  }
  return projects;
}
