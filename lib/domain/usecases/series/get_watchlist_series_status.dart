import 'package:movie_show/domain/repositories/series_repository.dart';

class GetWatchListSeriesStatus {
  final SeriesRepository repository;

  GetWatchListSeriesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistSeries(id);
  }
}
