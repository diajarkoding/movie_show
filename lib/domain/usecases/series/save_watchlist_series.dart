import 'package:dartz/dartz.dart';
import 'package:movie_show/common/failure.dart';
import 'package:movie_show/domain/entities/series_detail.dart';
import 'package:movie_show/domain/repositories/series_repository.dart';

class SaveWatchlistSeries {
  final SeriesRepository repository;

  SaveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlistSeries(series);
  }
}
