import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike2/data/product.dart';
import 'package:nike2/data/rep/product_repository.dart';
import 'package:nike2/ui/list/bloc/product_list_bloc.dart';
import 'package:nike2/ui/product/product.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  const ProductListScreen({super.key, required this.sort});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;
  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26272C),
      appBar: AppBar(
        backgroundColor: const Color(0xff262a35),
        title: const Text(' ساعت های ضد آب '),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(sort: widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.4),
                              width: 1),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20)
                        ]),
                    height: 56,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(32))),
                            context: context,
                            builder: (context) {
                              return Container(
                                color: const Color(0xff262a35),
                                height: 270,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                                  child: Column(
                                    children: [
                                      Text(
                                        ' مرتب سازی',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: state.sortNames.length,
                                            itemBuilder: (context, index) {
                                              final selectedSortIndex =
                                                  state.sort;
                                              return InkWell(
                                                onTap: () {
                                                  bloc!.add(ProductListStarted(
                                                      sort: index));
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 16, 8),
                                                  child: SizedBox(
                                                    height: 32,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          state
                                                              .sortNames[index],
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        if (selectedSortIndex ==
                                                            index)
                                                          Icon(
                                                            CupertinoIcons
                                                                .check_mark_circled_solid,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(CupertinoIcons.sort_down),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('مرتب سازی'),
                                      Text(
                                        ProductSort.names[state.sort],
                                        style:
                                            Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.4),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.grid
                                      ? ViewType.list
                                      : ViewType.grid;
                                });
                              },
                              icon: const Icon(CupertinoIcons.square_grid_2x2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.65,
                          crossAxisCount: viewType == ViewType.grid ? 2 : 1),
                      itemBuilder: (BuildContext context, int index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
    );
  }
}
