import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/entities/entrance.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntrancesList {
  static List<Entrance> entrances = [];

  static Future<void> generateList(BuildContext context) async {
    if (entrances.isEmpty) {
      try {
        Response response =
            await ApiClient().dio.get("/entrance/get_all_entrances");
        List data = response.data['data'] ?? [];
        entrances = data.map<Entrance>((item) {
          return Entrance(id: item['id'], name: item['name']);
        }).toList();
        entrances.sort((a, b) => a.id.compareTo(b.id));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("entrance", entrances.first.id);
      } on DioException catch (e) {
        String errorMessage = e.toString();
        if (e.response != null &&
            e.response?.data != null &&
            e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
