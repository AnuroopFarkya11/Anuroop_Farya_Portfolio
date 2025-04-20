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
  // List<ProjectModel> list = await fetchReadme2(dioClient);
  _logger.log("Projects" + list.toString());
  return list;
});

Future<List<ProjectModel>> fetchReadme(DioClient dioClient) async {
  List<ProjectModel> projects = [];
  const url =
      'https://raw.githubusercontent.com/AnuroopFarkya11/Anuroop_Farya_Portfolio/refs/heads/main/projects_details.json';
  //https://raw.githubusercontent.com/AnuroopFarkya11/Anuroop_Farya_Portfolio/refs/heads/main/projects_details.json

  final response = await dioClient.get(url);
  if (response.isSuccess) {
    try {
      List<dynamic> data = jsonDecode(response.data);
      List<ProjectModel> projects =
          data.map((e) => ProjectModel.fromJson(e)).toList();
      return projects;
    } catch (e, s) {
      _logger.log(e.toString() + s.toString());
    }
  } else {
    _logger.log("Failed to retrieve");
  }
  return projects;
}

Future<List<ProjectModel>> fetchReadme2(DioClient dioClient) async {
  List<ProjectModel> projects = [];
  const url =
      'https://api.github.com/repos/AnuroopFarkya11/Anuroop_Farya_Portfolio/contents/projects_details.json';
  //https://raw.githubusercontent.com/AnuroopFarkya11/Anuroop_Farya_Portfolio/refs/heads/main/projects_details.json

  Options options = Options(headers: {
    'Authorization': 'Bearer '
  });
  final response = await dioClient.get(url,option: options);
  if (response.isSuccess) {
    try {
      final String base64Content = response.data['content'];
      final sanitizedContent =
          base64Content.replaceAll('\n', '').replaceAll('\r', '');

      final String decodedContent =
          utf8.decode(base64.decode(sanitizedContent));

      final List<dynamic> projectsJson = json.decode(decodedContent);
      projects = projectsJson
          .map((project) => ProjectModel.fromJson(project))
          .toList();
    } catch (e, s) {
      _logger.log(e.toString() + s.toString());
    }
  } else {
    _logger.log("Failed to retrieve");
  }
  return projects;
}


Future<void> updateFile()async{}