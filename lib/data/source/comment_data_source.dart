import 'package:dio/dio.dart';
import 'package:nike2/data/comment.dart';
import 'package:nike2/data/common/response_validator.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required String productId});
}

class CommentRemoteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required String productId}) async {
    final comments = <CommentEntity>[];
    final ParseObject commentsOnServer = ParseObject("Comment");
    final query = QueryBuilder<ParseObject>(commentsOnServer);
    query.whereContains('productId', productId);
    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      for (var object in response.result) {
        comments.add(CommentEntity.fromObject(object));
      }
    }
    return comments;
  }
}
