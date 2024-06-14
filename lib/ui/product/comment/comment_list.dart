import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike2/data/comment.dart';
import 'package:nike2/data/rep/comment_repository.dart';
import 'package:nike2/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nike2/ui/widgets/errors.dart';


class CommentList extends StatelessWidget {
  final String productId;

  const CommentList({super.key, required this.productId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
            repository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return CommentItem(
              data: state.comments[index],
            );
          }, childCount: state.comments.length));
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
              exception: state.exception,
              onPressed: () {
                BlocProvider.of<CommentListBloc>(context)
                    .add(CommentListStarted());
              },
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      }),
    );
  }
}

class CommentItem extends StatelessWidget {
  final CommentEntity data;
  const CommentItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: themeData.dividerColor,width: 1,),borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.email,
                    style: themeData.textTheme.bodySmall,
                  )
                ],
              ),
              Text(
                data.date,
                style: themeData.textTheme.bodySmall,
              )
            ],
          ),
          const SizedBox(height: 16,),
          Text(data.content,style: const TextStyle(height: 1.4),),
        ],
      ),
    );
  }
}
