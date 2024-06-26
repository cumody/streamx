import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:streamx/core/networking/api_constants.dart';
import 'package:streamx/core/networking/api_result.dart';
import 'package:streamx/core/networking/dio_factory.dart';
import 'package:streamx/core/networking/network_info.dart';
import 'package:streamx/features/home/data/media_item_response.dart';

class TrendingMoviesRepo {
  final NetworkInfo networkInfo;
  TrendingMoviesRepo(this.networkInfo);
  Future<ApiResult<MovieItem>> getMediaModel() async {
    if (await networkInfo.isConnected) {
      try {
        final dio = DioFactory.getDio();
        final response = await dio.get(ApiConstants.trendingEndPoint);

        if (response.statusCode == 200) {
          final responseData = response.data;

          if (responseData != null) {
            dynamic decodedJson;
            if (responseData is String) {
              decodedJson = jsonDecode(responseData);
            } else {
              decodedJson = responseData;
            }

            debugPrint(decodedJson.toString());
            return ApiResult.success(MovieItem.fromJson(decodedJson));
          } else {
            return const ApiResult.failure('Response data is null.');
          }
        } else {
          return ApiResult.failure(
              'Failed to fetch data: ${response.statusCode}');
        }
      } on DioException catch (e) {
        return ApiResult.failure('DioError: ${e.message}');
      } catch (e) {
        return ApiResult.failure('Unexpected error: $e');
      }
    } else {
      return const ApiResult.failure('No internet connection');
    }
  }
}
