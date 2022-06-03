import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:openfoodfacts/model/parameter/Page.dart' as page;

class SearchFood extends StatefulWidget {
  const SearchFood({Key? key}) : super(key: key);

  @override
  State<SearchFood> createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
  String? nutriscore_first_product;
  SearchResult? result;
  var parameters = <Parameter>[
    const PageNumber(page: 5),
    const PageSize(size: 10),
    const SortBy(option: SortOption.PRODUCT_NAME),
    TagFilter.fromType(
        tagFilterType: TagFilterType.CATEGORIES,
        contains: true,
        tagName: "breakfast_cereals"),
    TagFilter.fromType(
        tagFilterType: TagFilterType.NUTRITION_GRADES,
        contains: true,
        tagName: "A")
  ];
  getSearch() async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
            parametersList: parameters,
            fields: [ProductField.NUTRISCORE],
            language: OpenFoodFactsLanguage.ENGLISH);
    result = await OpenFoodAPIClient.searchProducts(
      const User(userId: "r", password: "ee"),
      configuration,
    );
    nutriscore_first_product = result!.products![0].nutriscore.toString();
    print(result);
    setState(() {});
  }

  @override
  void initState() {
    getSearch();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 30, right: 50),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [],
          ),
        ),
      ),
    );
  }
}
