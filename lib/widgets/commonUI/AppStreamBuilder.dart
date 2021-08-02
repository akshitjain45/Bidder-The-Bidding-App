import 'package:flutter/material.dart';
// import 'package:bidding_app/constants/assetImages.dart';

typedef Widget SBui<T>(BuildContext context, T value);
typedef Widget EBui(BuildContext context, Object? error);

class StrmBldr<T> extends StatelessWidget {
  final Stream<T> stream;
  final SBui<T?> builder;

  /// change default Error widget, optional

  final EBui? errorBuilder;
  static final EBui defErrorBuilder = (BuildContext context, Object? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // CachedNetworkImage(
        //   imageUrl: OnlineAssetImages.notFound,
        // ),
        Text('Oops we faced an error,\n $error '),
        TextButton(
          child: Text('Report'),
          onPressed: () {
            // Navigator.pushNamed(context, Routes.contactUs,
            //     arguments:
            //         'Error Report: $error \n ^^^^ Text above helps us to fix error you are facing ^^^^ \n write your any other concern below');
          },
        )
      ],
    );
  };

  /// change default noData widget, optional

  final Widget? noDataWidget;

  /// change default loading widget, optional
  final Widget? loadingWidget;

  /// default widget when stream is loading
  static final Widget defaultLoadingWidget = Center(child: CircularProgressIndicator());

  /// default widget when stream has no data
  static final Widget defaultNoDataWidget = Center(
    child: Text(
      "Can't find anything for you :/",
    ),
  );

  const StrmBldr(
      {Key? key,
      required this.stream,
      required this.builder,
      this.loadingWidget,
      this.errorBuilder,
      this.noDataWidget})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget ?? defaultLoadingWidget;
          }
          if (snapshot.hasError) {
            errorBuilder == null
                ? defErrorBuilder(context, snapshot.error)
                : errorBuilder!(context, snapshot.error);
          }

          if (!snapshot.hasData) {
            return noDataWidget ?? defaultNoDataWidget;
          }
          final t = snapshot.data;
          if (t is List) {
            if (t.isEmpty) {
              return noDataWidget ?? defaultNoDataWidget;
            }
          }
          return builder(context, snapshot.data);
        });
  }
}
