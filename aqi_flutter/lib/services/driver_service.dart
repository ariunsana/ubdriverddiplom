import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DriverService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Map<String, dynamic>>> getDrivers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/drivers/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Холбогдоход хэт удаан байна. Интернэт холболтоо шалгана уу.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((driver) => Map<String, dynamic>.from(driver)).toList();
      } else {
        throw Exception('Жолооч нарын мэдээлэл авахад алдаа гарлаа');
      }
    } on SocketException {
      throw Exception('Сервертэй холбогдох боломжгүй байна. Интернэт холболтоо шалгана уу.');
    } on FormatException {
      throw Exception('Серверээс буруу хариу ирлээ');
    } catch (e) {
      throw Exception('Алдаа гарлаа: $e');
    }
  }
} 