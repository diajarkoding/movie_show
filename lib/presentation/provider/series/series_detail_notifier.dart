import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/domain/entities/series_detail.dart';
import 'package:movie_show/domain/usecases/series/get_series_detail.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  final GetSeriesDetail getSeriesDetail;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
  });

  late SeriesDetail _seriesDetail;
  SeriesDetail get seriesDetail => _seriesDetail;

  RequestState _seriesDetailState = RequestState.Empty;
  RequestState get seriesDetailState => _seriesDetailState;

  String _message = '';
  String get message => _message;

  Future<void> fetchSeriesDetail(int id) async {
    _seriesDetailState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getSeriesDetail.execute(id);

    detailResult.fold(
      (failure) {
        _seriesDetailState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesDetail) {
        _seriesDetailState = RequestState.Loaded;
        _seriesDetail = seriesDetail;
        notifyListeners();
      },
    );
  }
}
