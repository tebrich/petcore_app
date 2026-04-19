import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/widgets/product_grid.dart';

/// A reusable page that displays a list of products in a grid format.  GridView
///
/// This `StatelessWidget` is designed to be a generic container for showing
/// a collection of products. It is used throughout the shopping feature to display
/// products belonging to a specific category (e.g., "Food," "Toys") or to show
/// search results.
///
/// The page features a simple `AppBar` with a dynamic title and a `GridView`
/// that populates its items using the [productGridElementWidget].
class ProductsListPage extends StatelessWidget {
  /// The title to be displayed in the `AppBar`.
  final String title;

  /// The list of [ProductEntity] objects to be displayed in the grid.
  final List<ProductEntity> listOfProducts;

  /// Creates an instance of [ProductsListPage].
  const ProductsListPage({
    required this.title,
    required this.listOfProducts,
    super.key,
  });

  @override
  /// Builds the main UI for the products list page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        scrolledUnderElevation: 3,
        automaticallyImplyLeading: true,

        /// The title of the page, passed in via the constructor.
        title: Text(
          title,
          style: AppTextStyles.playfulTag.copyWith(
            color: AppPalette.primaryText(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// The main content area, which is a responsive grid of products.
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        padding: EdgeInsets.fromLTRB(
          screenSize.width * 0.05,
          24,
          screenSize.width * 0.025,
          16,
        ),
        itemCount: listOfProducts.length,
        itemBuilder: (context, index) {
          /// Each item in the grid is built using the reusable [productGridElementWidget].
          return productGridElementWidget(context, listOfProducts[index]);
        },
      ),
    );
  }
}
