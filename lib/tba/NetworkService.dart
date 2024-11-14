import 'dart:convert';
import 'dart:io';
import 'package:every_month_account_books_fly/ad/CCCllok.dart';
import 'package:http/http.dart' as http;
import 'result.dart';

class NetworkService {


 static Future<Result<String>> postNetwork(dynamic body) async {
    final url = Uri.parse(CCCllok.TBA_URL);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == HttpStatus.ok) {
        return Result.success(response.body);
      } else {
        return Result.failure(
          'Request failed with code ${response.statusCode}: ${response.body}' as String?,
        );
      }
    } on SocketException catch (e) {
      return Result.failure('Network error: ${e.message}' as String?);
    } on HttpException catch (e) {
      return Result.failure('HTTP error: ${e.message}' as String?);
    } catch (e) {
      return Result.failure('Unexpected error: $e' as String?);
    }
  }
}
