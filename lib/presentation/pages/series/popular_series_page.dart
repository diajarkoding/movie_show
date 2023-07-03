// ignore_for_file: constant_identifier_names

import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/presentation/provider/series/series_list_notifier.dart';
import 'package:movie_show/presentation/widgets/series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  const PopularSeriesPage({super.key});

  @override
  PopularSeriesPageState createState() => PopularSeriesPageState();
}

class PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SeriesListNotifier>(context, listen: false)
            .fetchPopularSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SeriesListNotifier>(
          builder: (context, data, child) {
            if (data.popularSeriesState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.popularSeriesState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = data.popularSeries[index];
                  return SeriesCard(series);
                },
                itemCount: data.popularSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
