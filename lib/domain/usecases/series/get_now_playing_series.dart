import 'package:dartz/dartz.dart';
import 'package:movie_show/domain/entities/series.dart';
import 'package:movie_show/common/failure.dart';
import 'package:movie_show/domain/repositories/series_repository.dart';

class GetNowPlayingSeries {
  final SeriesRepository repository;

  GetNowPlayingSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getNowPlayingSeries();
  }
}
