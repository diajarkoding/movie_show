// ignore_for_file: constant_identifier_names

import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/presentation/provider/series/series_list_notifier.dart';
import 'package:movie_show/presentation/widgets/series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-series';

  const TopRatedSeriesPage({super.key});

  @override
  TopRatedSeriesPageState createState() => TopRatedSeriesPageState();
}

class TopRatedSeriesPageState extends State<TopRatedSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SeriesListNotifier>(context, listen: false)
            .fetchTopRatedSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SeriesListNotifier>(
          builder: (context, data, child) {
            if (data.topRatedSeriesState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.topRatedSeriesState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = data.topRatedSeries[index];
                  return SeriesCard(series);
                },
                itemCount: data.topRatedSeries.length,
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
