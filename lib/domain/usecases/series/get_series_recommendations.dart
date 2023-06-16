import 'package:dartz/dartz.dart';
import 'package:movie_show/domain/entities/series.dart';
import 'package:movie_show/common/failure.dart';
import 'package:movie_show/domain/repositories/series_repository.dart';

class GetSeriesRecommendations {
  final SeriesRepository repository;

  GetSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Series>>> execute(id) {
    return repository.getSeriesRecommendations(id);
  }
}
