import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/give_process/searchFood.dart';

class ScanFood extends StatefulWidget {
  const ScanFood({Key? key}) : super(key: key);

  @override
  State<ScanFood> createState() => _ScanFoodState();
}

class _ScanFoodState extends State<ScanFood> {
  String barcodeScanRes = "";
  String? ingredientsT;
  List<Ingredient>? ingredients;
  double? energy_100g;
  double? fat_100g;
  double? saltServing;
  double? fatServing;
  String? firstAdditiveName;
  Level? sugarsLevel;
  ProductResult? result;
  Uri? insightsResult;
  List<ProductImage>? assets;

  startBarcodeScanner() async {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    setState(() {});
    ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcodeScanRes,
      version: ProductQueryVersion.v2,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [ProductField.ALL],
    );
    result = await OpenFoodAPIClient.getProduct(configuration);
    insightsResult =
        await OpenFoodAPIClient.getCrowdinUri(OpenFoodFactsLanguage.ENGLISH);
    assets = result!.product!.images;
    setState(() {});
  }

  @override
  void initState() {
    startBarcodeScanner();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      body: SafeArea(
        child: result != null
            ? Column(
                children: [
                  Expanded(
                    flex: 11,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 30,
                          right: 50,
                        ),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result!.product!.productName
                                  .toString()
                                  .split(" ")
                                  .map((str) => str.toCapitalized())
                                  .join(" "),
                              style: const TextStyle(
                                fontFamily: "Recoleta",
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(color: CustomColors.textColor),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Scores",
                              style: TextStyle(
                                fontFamily: "Recoleta",
                                fontSize: 25,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Eco Score: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!
                                                      .product!.ecoscoreGrade !=
                                                  null
                                              ? result!.product!
                                                          .ecoscoreGrade !=
                                                      "not-applicable"
                                                  ? result!.product!
                                                              .ecoscoreGrade !=
                                                          "unknown"
                                                      ? result!.product!
                                                          .ecoscoreGrade!
                                                          .toUpperCase()
                                                      : "Not Available"
                                                  : "Not Available"
                                              : "Not Available",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Nutri Score: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!.product!.nutriscore !=
                                                  null
                                              ? result!.product!.nutriscore!
                                                  .toUpperCase()
                                              : "Not Available",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: CustomColors.textColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "General",
                              style: TextStyle(
                                fontFamily: "Recoleta",
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Serving Size: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              result!.product!.servingSize !=
                                                      null
                                                  ? result!
                                                      .product!.servingSize!
                                                      .replaceAll('en:', '')
                                                      .replaceAll(
                                                          'pp', 'Polypropylene')
                                                      .replaceAll('-', ' ')
                                                      .capitalizeFirstofEach
                                                  : "Not Specified",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Serving Quantity: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!.product!
                                                      .servingQuantity !=
                                                  null
                                              ? result!
                                                  .product!.servingQuantity!
                                                  .toStringAsFixed(0)
                                                  .replaceAll('en:', '')
                                                  .replaceAll(
                                                      'pp', 'Polypropylene')
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstofEach
                                              : "Not Specified",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Brand: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!.product!.brandsTags!
                                              .join(', ')
                                              .capitalizeFirstofEach,
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Allergens: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (result!.product!.allergens!.names
                                            .isNotEmpty)
                                          TextSpan(
                                            text: result!
                                                .product!.allergens!.names
                                                .join(', ')
                                                .capitalizeFirstofEach,
                                            style: GoogleFonts.poppins(
                                              color: CustomColors.textColor,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 20,
                                            ),
                                          )
                                        else
                                          (TextSpan(
                                            text: "None",
                                            style: GoogleFonts.poppins(
                                              color: CustomColors.textColor,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 20,
                                            ),
                                          ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Ingredients: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!.product!
                                                      .ingredientsText !=
                                                  null
                                              ? result!.product!.ingredientsText
                                                  .toString()
                                                  .capitalizeFirstofEach
                                              : 'None',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Labels: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!.product!.labels != null
                                              ? result!.product!.labels!
                                                  .replaceAll('en:', '')
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstofEach
                                              : 'None',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Additives: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!
                                                      .product!.additives!.names
                                                      .join(', ')
                                                      .replaceAll('en:', '')
                                                      .replaceAll('-', ' ')
                                                      .capitalizeFirstofEach !=
                                                  ""
                                              ? result!
                                                  .product!.additives!.names
                                                  .join(', ')
                                                  .replaceAll('en:', '')
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstofEach
                                              : "None",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Sold: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!
                                                      .product!.countriesTags !=
                                                  null
                                              ? result!.product!.countriesTags!
                                                  .join(', ')
                                                  .replaceAll('en:', '')
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstofEach
                                              : "None",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Tags: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!.product!
                                                      .categoriesTags !=
                                                  null
                                              ? result!.product!.categoriesTags!
                                                  .join(', ')
                                                  .replaceAll('en:', '')
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstofEach
                                              : "None",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: CustomColors.textColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Environment",
                              style: TextStyle(
                                fontFamily: "Recoleta",
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Packaging: ',
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result!
                                                      .product!.packagingTags !=
                                                  null
                                              ? result!.product!.packagingTags!
                                                  .join(', ')
                                                  .replaceAll('en:', '')
                                                  .replaceAll(
                                                      'pp', 'Polypropylene')
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstofEach
                                              : "Not Specified",
                                          style: GoogleFonts.poppins(
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: CustomColors.textColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Gallery",
                              style: TextStyle(
                                fontFamily: "Recoleta",
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 160,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  result!.product!.imageFrontSmallUrl != null
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              result!
                                                  .product!.imageFrontSmallUrl
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  result!.product!.imageIngredientsSmallUrl !=
                                          null
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              result!.product!
                                                  .imageIngredientsSmallUrl
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  result!.product!.imageNutritionSmallUrl !=
                                          null
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              result!.product!
                                                  .imageNutritionSmallUrl
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  result!.product!.imagePackagingSmallUrl !=
                                          null
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              result!.product!
                                                  .imagePackagingSmallUrl
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CustomColors.textColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  child: ButtonTheme(
                                    height: 100.0,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      // onPressed: () async {
                                      //   print(selectedAllergies);
                                      //   List<String> wordsFound =
                                      //       filter.getAllProfanity(foodCategory.text);
                                      //   if (foodCategory.text == "") {
                                      //     Fluttertoast.showToast(
                                      //         msg: "Food category can not be left blank.");
                                      //   } else if (ageNum.text == "") {
                                      //     Fluttertoast.showToast(
                                      //         msg: "Age number can not be left blank.");
                                      //   } else if (ageValue == null) {
                                      //     Fluttertoast.showToast(
                                      //         msg: "Age type can not be left blank.");
                                      //   } else if (photo == null) {
                                      //     Fluttertoast.showToast(
                                      //         msg: "You must upload a photo");
                                      //   } else if (wordsFound.isNotEmpty) {
                                      //     Fluttertoast.showToast(
                                      //         msg: "Food category contains profanity.");
                                      //   } else {
                                      //     Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //         builder: (context) => AddLocation(),
                                      //       ),
                                      //     );
                                      //   }
                                      // },
                                      style: ElevatedButton.styleFrom(
                                        primary: CustomColors.primary,
                                        onPrimary: CustomColors.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        minimumSize: const Size(240, 60),
                                      ),
                                      child: Text(
                                        'Next >',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  child: ButtonTheme(
                                    height: 100.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          result = null;
                                          barcodeScanRes = "";
                                        });
                                        startBarcodeScanner();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: CustomColors.primary,
                                        onPrimary: CustomColors.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        minimumSize: const Size(60, 60),
                                      ),
                                      child: const Icon(
                                        FontAwesomeIcons.barcode,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    barcodeScanRes != ""
                        ? Column(
                            children: [
                              const Text(
                                'Error',
                                style: TextStyle(
                                  fontFamily: "Recoleta",
                                  fontSize: 40,
                                ),
                              ),
                              Text(
                                'Barcode $barcodeScanRes did not return any results',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          result = null;
                                          barcodeScanRes = "";
                                        });
                                        startBarcodeScanner();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: CustomColors.primary,
                                        onPrimary: CustomColors.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Scan Again',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchFood(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: CustomColors.primary,
                                        onPrimary: CustomColors.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Search Product',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : CircularProgressIndicator(
                            color: CustomColors.textColor,
                          )
                  ],
                ),
              )),
      ),
    );
  }
}
