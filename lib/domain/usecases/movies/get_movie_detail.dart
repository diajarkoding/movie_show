import 'package:dartz/dartz.dart';
import 'package:movie_show/domain/entities/movie_detail.dart';
import 'package:movie_show/domain/repositories/movie_repository.dart';
import 'package:movie_show/common/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
