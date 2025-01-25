import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:todo_netzlech/model/beer_model/beer.dart';
import 'package:todo_netzlech/model/people_model/people.dart';
import 'package:injectable/injectable.dart' as i;

part 'api_service.g.dart';

@RestApi(parser: Parser.FlutterCompute)
@i.lazySingleton
@i.injectable
abstract class RestClient {
  @i.factoryMethod
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/peoples")
  Future<List<PeopleModel>> getPeoples();

  @GET("https://api.punkapi.com/v2/beers?Page={page_no}?per_page={limit}")
  Future<List<BeerSummary>> getBeer(
    @Path('page_no') int page,
    @Path('limit') int limit,
  );
}
