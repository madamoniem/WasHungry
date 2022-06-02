import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/give_process/add_location.dart';
import 'package:washungrystable/storage.dart';
import 'package:washungrystable/userdashboard.dart';
import 'package:profanity_filter/profanity_filter.dart';

class AddInfo extends StatefulWidget {
  AddInfo({Key? key}) : super(key: key);

  @override
  State<AddInfo> createState() => _AddInfoState();
}

TextEditingController foodCategory = TextEditingController();
XFile? photo;
String fileID = "";
String? selectedValue;
String? ageValue;
TextEditingController ageNum = TextEditingController();
List selectedAllergies = [];

class _AddInfoState extends State<AddInfo> {
  List<String> ageType = [
    'minutes old',
    'hours old',
    'days old',
  ];
  @override
  void initState() {
    print(selectedAllergies);
    super.initState();
  }

  static List<String> foodTags = <String>[
    "Anchovies",
    "Asparagus",
    "Avocados",
    "Alfredo sauce",
    "Arugula",
    "Almonds",
    "Amaranth",
    "Apples",
    "Bacon",
    "Bagels",
    "Bananas",
    "Barbecue",
    "Barley",
    "Basil",
    "Beans",
    "Beef",
    "Beets",
    "Blackberries",
    "Blueberries",
    "Bread",
    "Broccoli",
    "Burgers",
    "Cabbage",
    "Cake",
    "Calzones",
    "Cheese",
    "Chicken",
    "Chili",
    "Coconut",
    "Cod",
    "Coffee",
    "Collards",
    "Cookies",
    "Crepes",
    "Curry",
    "Daikon",
    "Dairy",
    "Dal",
    "Danishes",
    "Dates",
    "Dill",
    "Dosa",
    "Doubles",
    "Doughnuts",
    "Duck",
    "Duff",
    "Dumplings",
    "Durian",
    "Eclairs",
    "Edamame",
    "Eel",
    "Eggnog",
    "Eggplant",
    "Eggrolls",
    "Eggs",
    "Emmenthaler",
    "Empanadas",
    "Enchiladas",
    "Escargot",
    "Escarole",
    "Espresso",
    "Falafel",
    "Fennel",
    "Figs",
    "Fish",
    "Frankfurters",
    "French Fries",
    "Frittatas",
    "Fritters",
    "Frogs",
    "Fruit",
    "Fruitcakes",
    "Fungi",
    "Gazpacho",
    "Goose",
    "Gooseberries",
    "Graham Crackers",
    "Granola",
    "Grapes",
    "Gravy",
    "Guacamole",
    "Guava",
    "Gumbo",
    "Gyoza",
    "Gyros",
    "Ham",
    "Hamburger",
    "Hash Browns",
    "Herring",
    "Hoisin Sauce",
    "Honey",
    "Honeydew",
    "Horseradish",
    "Hot Dogs",
    "Hot Sauce",
    "Huckleberries",
    "Hummus",
    "Icaco",
    "Ice",
    "Ice Cream",
    "Iceberg Lettuce",
    "Idli",
    "Ikizukuri",
    "Inarizushi",
    "Injera",
    "Isaw",
    "Ital",
    "Italian Sausage",
    "Jackfruit",
    "Jalapeno",
    "Jam",
    "Jambalaya",
    "Jambon",
    "Jelly",
    "Jerk Chicken",
    "Jiaozi",
    "Johnnycake",
    "Jollof",
    "Jordan Almonds",
    "Kaiser Roll",
    "Kale",
    "Kasha",
    "Kelp",
    "Kimchi",
    "Knockwurst",
    "Kohlrabi",
    "Kombucha",
    "Kuchen",
    "Kugel",
    "Kumquats",
    "Lard",
    "Lasagna",
    "Lemon",
    "Lima Beans",
    "Limes",
    "Lingonberries",
    "Linzer Torte",
    "Liver",
    "Lo Mein",
    "Lollipop",
    "Lutefisk",
    "Macaroon",
    "Mango",
    "Mangosteen",
    "Maple Syrup",
    "Margarine",
    "Mayonnaise",
    "Melon",
    "Millet",
    "Mochi",
    "Mulberries",
    "Mustard",
    "Naan",
    "Nachos",
    "Natto",
    "Navy Beans",
    "Nectarines",
    "Neufchatel Cheese",
    "Noodles",
    "Nori",
    "Nougat",
    "Nuts",
    "Oatmeal",
    "Octopus",
    "Oil",
    "Okra",
    "Olives",
    "Onion",
    "Opossum",
    "Oranges",
    "Oregano",
    "Oysters",
    "Pad Thai",
    "Pears",
    "Peas",
    "Pecans",
    "Pepperoni",
    "Peppers",
    "Pie",
    "Poi",
    "Pork",
    "Pumpkins",
    "Qeema",
    "Quahog",
    "Quail",
    "Quenelle",
    "Quesadillas",
    "Queso",
    "Quetsch",
    "Quiche",
    "Quinces",
    "Quinoa",
    "Radishes",
    "Raisins",
    "Ramen",
    "Raspberries",
    "Ravioli",
    "Relish",
    "Rhubarb",
    "Rice",
    "Rigatoni",
    "Romaine",
    "Roquefort",
    "Rye Bread",
    "Salami",
    "Sesame Seeds",
    "Sorbet",
    "Sorghum",
    "Soybeans",
    "Spaghetti",
    "Spanakopita",
    "Spinach",
    "Squash",
    "Sugar",
    "Sukiyaki",
    "Tacos",
    "Tagliatelle",
    "Tempeh",
    "Tempura",
    "Tiramisu",
    "Tofu",
    "Tomatoes",
    "Tortellini",
    "Truffles",
    "Tuna",
    "Turnips",
    "Ube",
    "Udon",
    "Ugba",
    "Ukoy",
    "Umbrella Fruit",
    "Unagi",
    "Upma",
    "Uszka",
    "Utazi",
    "Utthappam",
    "Vanilla",
    "Vatapa",
    "Vatrushka",
    "Veal",
    "Vegetables",
    "Venison",
    "Vermicelli",
    "Vindaloo",
    "Vinegar",
    "Vori Vori",
    "Wafers",
    "Waffles",
    "Walnuts",
    "Wasabi",
    "Waterblommetjie Bredie",
    "Watermelon",
    "Wheat",
    "Whelk",
    "Whiting",
    "Wine",
    "Wontons",
    "Xacuti",
    "Xanthia",
    "Xavier Steak",
    "Xia Mi",
    "Xiao Long Bao",
    "Xigua",
    "Ximenia",
    "Xnipec",
    "Xocoatl",
    "Xouba",
    "Yabby",
    "Yahni",
    "Yakitori",
    "Yams",
    "Yautia",
    "Yeast",
    "Yogurt",
    "Yorkshire Pudding",
    "Yucca",
    "Yuzu",
    "Zander",
    "Zapiekanka",
    "Zarzuela",
    "Zeppole",
    "Zerde",
    "Ziti",
    "Zongzi",
    "Zoni",
    "Zucchini",
    "Zuccotto",
    "Abalone",
    "Açaí berries",
    "Açaí juice",
    "Acorn squash",
    "Adzuki bean paste",
    "Adzuki beans",
    "Aged Japanese kurozu",
    "Albacore tuna",
    "Alcohol",
    "Ale",
    "Alfalfa sprouts",
    "Algae",
    "Almond milk",
    "Almond paste",
    "Ancho chili powder",
    "Anchovy paste",
    "Angus beef",
    "Apple juice",
    "Apricots",
    "Apricots, Japanese",
    "Arborio rice",
    "Arctic char",
    "Artichoke, Jerusalem",
    "Artichokes",
    "Asian greens",
    "Asparagus, Chinese",
    "Autumn crocus",
    "Avocado oil",
    "Balsamic vinegar",
    "Barbecued meat",
    "Bean curd",
    "Beer",
    "Bell peppers",
    "Bitter almond oil",
    "Bitter cucumber",
    "Bitter melon",
    "Black beans",
    "Black cumin",
    "Black currants",
    "Black or purple rice",
    "Black pepper",
    "Black tea",
    "Bok choy",
    "Boysenberries",
    "Brazil nuts",
    "Broccoli sprouts",
    "Brown mustard",
    "Brown rice",
    "Brown rice syrup",
    "Brussels sprouts",
    "Buckwheat",
    "Butter",
    "Butternut squash",
    "Canola oil",
    "Cantaloupe",
    "Carrots",
    "Cashews",
    "Cauliflower",
    "Caviar",
    "Celeriac",
    "Celery",
    "Celery seed",
    "Chamomile",
    "Cherries",
    "Chickpeas",
    "Chilli peppers",
    "Chives",
    "Chocolate",
    "Cilantro",
    "Cinnamon",
    "Clams",
    "Coconut oil",
    "Collard greens",
    "Corn",
    "Corn oil",
    "Crab",
    "Cranberries",
    "Cream",
    "Cucumbers",
    "Cumin",
    "Curcumin",
    "Currants",
    "Daidzein",
    "Dried herring",
    "Dried mackerel",
    "Dry beans",
    "Fennel seed",
    "Fermented bean paste",
    "Fermented milk",
    "Flaxseed",
    "Flaxseed oil",
    "Fried potatoes",
    "Garbanzo beans",
    "Garden cress",
    "Garlic",
    "Genistein",
    "Ghee",
    "Ginger",
    "Grape seed oil",
    "Grapefruit",
    "Green beans",
    "Green onions",
    "Green papaya",
    "Green peas",
    "Green tea",
    "Greens",
    "Halibut",
    "Holy basil",
    "Honeydew melon",
    "Hot peppers",
    "Indian mustard",
    "Kefir",
    "Kidney beans",
    "King mackerel",
    "Kiwifruit",
    "Lake trout",
    "Lamb",
    "Lavender",
    "Leeks",
    "Lemons",
    "Lentils",
    "Lettuce",
    "Lobster",
    "Loganberries",
    "Long pepper",
    "Low-fat yogurt",
    "Macadamia nut oil",
    "Macadamia nuts",
    "Mackerel",
    "Maitake mushrooms",
    "Mangoes",
    "Marionberrries",
    "Maté",
    "Melons",
    "Mexican oregano",
    "Milk",
    "Mint",
    "Mint tea",
    "Mung beans",
    "Mushrooms",
    "Muskmelon",
    "Mussels",
    "Mustard greens",
    "Mustard oil",
    "Mutton",
    "Oats",
    "Ohyo",
    "Olive oil",
    "Onions",
    "Papaya",
    "Papaya seeds",
    "Paprika",
    "Parsley",
    "Parsnips",
    "Partially-hydrogen. oil",
    "Passion fruit",
    "Pâtés",
    "Paw paw",
    "Peaches",
    "Peanut oil",
    "Peanuts",
    "Peppermint",
    "Persipan",
    "Pesto sauce",
    "Pickled papaya",
    "Pickled watermel. rind",
    "Pickles",
    "Pineapple",
    "Pinto beans",
    "Pistachio nuts",
    "Plantago",
    "Plantains",
    "Plums",
    "Pomegranate juice",
    "Pomegranates",
    "Portobello mushrooms",
    "Potatoes",
    "Prunes",
    "Pumpkin seeds",
    "Radicchio",
    "Radish",
    "Rapeseed oil",
    "Rapini",
    "Red bean paste",
    "Red beans",
    "Red cabbage",
    "Red currants",
    "Red onions",
    "Red pepper flakes",
    "Red pepper paste",
    "Red rice",
    "Red spinach",
    "Red wine vinegar",
    "Reishi mushrooms",
    "Ribs",
    "Rice bran",
    "Rice bran oil",
    "Rice wine vinegar",
    "Risotto",
    "Roast beef",
    "Roasted almonds",
    "Roasted pork",
    "Roe",
    "Rolled oats",
    "Romaine lettuce",
    "Rosemary",
    "Rutabagas",
    "Rye",
    "Safflower oil",
    "Saffron",
    "Sage",
    "Sage tea",
    "Salmon, wild",
    "Salt",
    "Sardines",
    "Sauerkraut",
    "Sausages",
    "Scallions",
    "Scallops",
    "Seaweed",
    "Sesame oil",
    "Shallots",
    "Shellfish",
    "Shiitake mushrooms",
    "Shrimp",
    "Smoked mackerel",
    "Snails",
    "Snow peas",
    "Soba noodles",
    "Soy infant formula",
    "Soy milk",
    "Soy protein bars",
    "Soy protein isolate",
    "Soybean curd",
    "Soybean oil",
    "Soybean paste",
    "Spaghetti squash",
    "Spearmint",
    "Split peas",
    "Steak",
    "Strawberries",
    "String beans",
    "Subtropical ginger",
    "Sugar beets",
    "Sugar snap peas",
    "Summer squash",
    "Sunflower oil",
    "Sunflower seeds",
    "Sweet peas",
    "Sweet potatoes",
    "Tabasco sauce",
    "Tahini",
    "Tallow",
    "Tangerines",
    "Tartary buckwheat",
    "Tea",
    "Thyme",
    "Tomato paste",
    "Tropical ginger",
    "Turkey",
    "Turkey bacon",
    "Turmeric",
    "Turnip greens",
    "Wakame",
    "Walnut oil",
    "Watercress",
    "Watermelon seeds",
    "Well-done meat",
    "Wheat bran",
    "Wheat germ",
    "Wheat grass",
    "White beans",
    "White bread",
    "White button mush.",
    "White pepper",
    "White tea",
    "White vinegar",
    "Whole wheat bread",
    "Wild ginger",
    "Wild rice",
    "Winter squash",
    "Yerba maté",
  ];
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    void _cameraImage() async {
      final ImagePicker _picker = ImagePicker();
      photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      setState(() {});
      if (photo == null) return;
    }

    void _pickImage() async {
      final ImagePicker _picker = ImagePicker();
      photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 20,
      );
      setState(() {});
      if (photo == null) return;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserDashboard(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                color: CustomColors.textColor,
              ),
            ),
          ),
        ),
        backgroundColor: CustomColors.secondary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                AutoSizeText(
                  'Info',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: "RecoletaB",
                    color: CustomColors.textColor,
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                AutoSizeText(
                  'Add A Brief Description',
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    color: CustomColors.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RawAutocomplete<String>(
                  key: _autocompleteKey,
                  focusNode: _focusNode,
                  textEditingController: foodCategory,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return foodTags.where(
                      (String option) {
                        return option.contains(
                          textEditingValue.text.toLowerCase(),
                        );
                      },
                    );
                  },
                  onSelected: (String selection) {
                    setState(() {});
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-z A-Z 0-9413]")),
                      ],
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: CustomColors.textColor,
                      ),
                      controller: foodCategory,
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      validator: (String? value) {
                        if (!foodTags.contains(value)) {
                          return 'Nothing selected.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        labelText: "Food Category",
                        labelStyle:
                            GoogleFonts.poppins(color: CustomColors.textColor),
                        focusColor: CustomColors.textColor,
                        fillColor: CustomColors.textColor,
                        hoverColor: CustomColors.textColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 3,
                            color: CustomColors.textColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: CustomColors.textColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 30.0,
                          child: SizedBox(
                            height: 300.0,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: ListTile(
                                    title: Text(
                                      option,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                MultiSelectContainer(
                  itemsPadding: const EdgeInsets.only(
                      left: 10, right: 10, top: 7, bottom: 7),
                  itemsDecoration: MultiSelectDecorations(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CustomColors.textColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(2000),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: CustomColors.textColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20000),
                    ),
                  ),
                  textStyles: MultiSelectTextStyles(
                    selectedTextStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      color: CustomColors.textColor,
                    ),
                  ),
                  items: [
                    MultiSelectCard(value: 'Milk', label: 'Milk'),
                    MultiSelectCard(value: 'Peanuts', label: 'Peanuts'),
                    MultiSelectCard(value: 'Tree Nuts', label: 'Tree Nuts'),
                    MultiSelectCard(value: 'Soy', label: 'Soy'),
                    MultiSelectCard(value: 'Wheat', label: 'Wheat'),
                    MultiSelectCard(value: 'Shellfish', label: 'Shellfish'),
                    MultiSelectCard(value: 'Snake', label: 'Snake'),
                    MultiSelectCard(value: 'Fish', label: 'Fish'),
                    MultiSelectCard(value: 'Sesame', label: 'Sesame'),
                    MultiSelectCard(value: 'Gelatin', label: 'Gelatin'),
                    MultiSelectCard(value: 'Pork', label: 'Pork'),
                    MultiSelectCard(value: 'Mushrooms', label: 'Mushroom'),
                    MultiSelectCard(value: 'Bananas', label: 'Bananas'),
                  ],
                  onChange: (allSelectedItems, selectedItem) {
                    setState(() {
                      selectedAllergies = allSelectedItems;
                    });
                  },
                ),
                if (selectedAllergies.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "None selected",
                      style: TextStyle(
                        color: CustomColors.textColor,
                      ),
                    ),
                  )
                else
                  Container(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: CustomColors.textColor,
                          ),
                          controller: ageNum,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            labelText: "Age",
                            labelStyle: GoogleFonts.poppins(
                              color: CustomColors.textColor,
                            ),
                            focusColor: CustomColors.textColor,
                            fillColor: CustomColors.textColor,
                            hoverColor: CustomColors.textColor,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                width: 3,
                                color: CustomColors.textColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: CustomColors.textColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            dropdownFullScreen: true,
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                FontAwesomeIcons.chevronDown,
                                color: CustomColors.textColor,
                              ),
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Select Item',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: CustomColors.textColor,
                                ),
                              ),
                            ),
                            items: ageType
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        item,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: CustomColors.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            value: ageValue,
                            onChanged: (value) {
                              setState(
                                () {
                                  ageValue = value as String;
                                },
                              );
                            },
                            dropdownDecoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  // setState(
                  //     () {
                  //       _pickImage();
                  //     },
                  //   );

                  onTap: () async {
                    showMaterialModalBottomSheet(
                      bounce: true,
                      backgroundColor: CustomColors.secondary,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 40,
                            left: 30,
                            right: 50,
                            bottom: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AutoSizeText(
                                'Upload an Image',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: "RecoletaB",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _cameraImage();
                                },
                                child: Text(
                                  'From Camera >',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: Text(
                                  'From Gallery >',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: photo != null
                      ? Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.file(
                              File(
                                photo!.path.toString(),
                              ),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: CustomColors.secondary,
                          ),
                          height: 200,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Camera.png',
                                  width: 120,
                                ),
                                Text(
                                  'Upload Image',
                                  style: GoogleFonts.poppins(
                                    color: CustomColors.textColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: SizedBox(
                    child: ButtonTheme(
                      height: 100.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          final filter = ProfanityFilter();
                          print(selectedAllergies);
                          List<String> wordsFound =
                              filter.getAllProfanity(foodCategory.text);
                          if (foodCategory.text == "") {
                            Fluttertoast.showToast(
                                msg: "Food category can not be left blank.");
                          } else if (ageNum.text == "") {
                            Fluttertoast.showToast(
                                msg: "Age number can not be left blank.");
                          } else if (ageValue == null) {
                            Fluttertoast.showToast(
                                msg: "Age type can not be left blank.");
                          } else if (photo == null) {
                            Fluttertoast.showToast(
                                msg: "You must upload a photo");
                          } else if (wordsFound.isNotEmpty) {
                            Fluttertoast.showToast(
                                msg: "Food category contains profanity.");
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddLocation(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: CustomColors.textColor,
                          onPrimary: CustomColors.textColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          minimumSize: const Size(double.infinity, 60),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Allergies {
  final int id;
  final String name;

  Allergies({
    required this.id,
    required this.name,
  });
}

class FoodTags {
  final int id;
  final String name;

  FoodTags({
    required this.id,
    required this.name,
  });
}
