import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:to_do_app/models/product_model.dart';
import 'package:to_do_app/navigations/router.gr.dart';
import 'package:to_do_app/utils/utils.dart';
import 'package:to_do_app/views/home_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:to_do_app/views/product_bloc.dart';
import 'package:to_do_app/widgets/text_field_wrapper.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _homeBloc = HomeBloc();
  GlobalKey<FormState> _formKey = GlobalKey();
  double productRating = 0;
  bool inProgress = false;
  bool isEditingProduct = false;
  DateTime? _pickedDate;
  final _productBloc = ProductBloc();
  String? selectedProductId;
  int selectedFilterIndex = 1;
  bool isOperationCompleted = true;
  bool isShowingGridView = true;
  

  final _productNameController = TextEditingController();
  final _productNameFocusNode = FocusNode();
  final _launchedAtController = TextEditingController();
  final _launchedAtFocusNode = FocusNode();
  final _launchSiteController = TextEditingController();
  final _launchSiteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // print(screenSize);
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          kIsWeb
              ? IconButton(
                  icon: Icon(
                    Icons.list,
                    color: isShowingGridView ? Colors.blue : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isShowingGridView = !isShowingGridView;
                    });
                  },
                )
              : Container(),
          kIsWeb
              ? IconButton(
                  icon: Icon(
                    Icons.grid_view,
                    color: isShowingGridView ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isShowingGridView = !isShowingGridView;
                    });
                  },
                )
              : Container(),
          PopupMenuButton(
            color: Colors.white,
            elevation: 40,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Sort By Name"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Sort By Site"),
                value: 2,
              ),
              PopupMenuItem(
                child: Text("Sort By Date"),
                value: 3,
              ),
              PopupMenuItem(
                child: Text("Sort By Popularity"),
                value: 4,
              ),
            ],
            onSelected: (val) {
              selectedFilterIndex = int.parse(val.toString());
              setState(() {});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (kIsWeb) {
            setState(() {
              isEditingProduct = false;
              _productNameController.clear();
              _launchedAtController.clear();
              _launchSiteController.clear();
              _pickedDate = null;
              selectedProductId = null;
            });
            showDialog(
              context: context,
              builder: (context) => _showProductDialog(),
            );
          } else {
            AutoRouter.of(context)
                .push(ProductViewRoute(isEditingProduct: false));
          }
        },
      ),
      body: StreamBuilder<List<ProductModel>>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          } else if (snapshot.hasData) {
            final productList = snapshot.data;
            if (productList!.isEmpty) {
              return Center(
                child: Text(
                  'No any product found',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
            }
            return kIsWeb
                ? _buildProductWebView(productList, true, screenSize.width)
                : SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: List.generate(
                            snapshot.data!.length,
                            (index) => _buildProductView(productList[index],
                                productList.length - 1 == index ? true : false,)),
                      ),
                    ),
                );
          }
          return Center(child: kIsWeb ? LoadingIndicator(indicatorType: Indicator.ballPulse, color: Colors.blue,) : CircularProgressIndicator());
        },
        stream: _homeBloc.getAllProducts(selectedFilterIndex),
      ),
    );
  }

  Widget _showProductDialog() {
    return Dialog(
      child: StatefulBuilder(
        builder: (context, dialogSetState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isEditingProduct ? 'Edit Product' : 'Add Product',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWrapper(
                            label: 'Product Name',
                            child: TextFormField(
                              enabled: !inProgress,
                              controller: _productNameController,
                              focusNode: _productNameFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Valid Product Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Product Name',
                                prefixIcon: Icon(
                                  Icons.class_,
                                  color: Colors.blue,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                            ),
                            focusNode: _productNameFocusNode,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _pickDOB();
                            },
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFieldWrapper(
                                label: 'Lunch Date',
                                child: TextFormField(
                                  enabled: true,
                                  controller: _launchedAtController,
                                  focusNode: _launchedAtFocusNode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Valid Lunch Date';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Lunch Date',
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                      )),
                                ),
                                focusNode: _launchedAtFocusNode,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWrapper(
                            label: 'Launch Site',
                            child: TextFormField(
                              enabled: !inProgress,
                              controller: _launchSiteController,
                              focusNode: _launchSiteFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Valid Launch Site';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Launch Site',
                                prefixIcon: Icon(
                                  Icons.web,
                                  color: Colors.blue,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                            ),
                            focusNode: _launchSiteFocusNode,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Product Ratings',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: productRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.green,
                            ),
                            onRatingUpdate: (rating) {
                              productRating = rating;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // CustomButton(
                          //     enabled: !inProgress,
                          //     onPressed: inProgress ? () {} : () => saveProduct(),
                          //     title: widget.isEditingProduct != null &&
                          //             widget.isEditingProduct!
                          //         ? 'Update Product'
                          //         : 'Add New Product'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 18,
                                        color: Color(0xff2270A9),
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: !inProgress
                                ? () => saveProduct(dialogSetState)
                                : null,
                            child: Text(
                              isEditingProduct
                                  ? 'Update Product'
                                  : 'Add Product',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 18,
                                        color: Color(0xff2270A9),
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 10,
    );
  }

  _showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> saveProduct(Function dialogSetState) async {
    if (_formKey.currentState!.validate()) {
      dialogSetState(() {
        inProgress = true;
      });
      if (isEditingProduct) {
        await _productBloc
            .updateProduct(ProductModel(
                productId: selectedProductId,
                productName: _productNameController.text,
                launchedAt: _pickedDate,
                launchSite: _launchSiteController.text,
                popularity: productRating))
            .then((msg) {
          if (msg == 'Already used this product name in database') {
            setState(() {
              isOperationCompleted = false;
            });
            _showInSnackBar(msg);
          } else {
            setState(() {
              isOperationCompleted = true;
            });
          }
        });
      } else {
        await _productBloc
            .addNewProduct(ProductModel(
                productName: _productNameController.text,
                launchedAt: _pickedDate,
                launchSite: _launchSiteController.text,
                popularity: productRating))
            .then((msg) {
          if (msg == 'Already used this product name in database') {
            setState(() {
              isOperationCompleted = false;
            });
            _showInSnackBar(msg);
          } else {
            setState(() {
              isOperationCompleted = true;
            });
          }
        });
      }

      dialogSetState(() {
        inProgress = false;
      });
      if (isOperationCompleted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _pickDOB() async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 120 * 365)),
    );
    if (pickedDateTime != null) {
      setState(() {
        _launchedAtController.text = Utils.formatDate(pickedDateTime);
        _pickedDate = pickedDateTime;
      });
    }
  }

  _buildProductWebView(List<ProductModel> productList, bool isListView, double screenWidth) {
    /* Using a Wrap Widget */
    // return Padding(
    //   padding: const EdgeInsets.all(20),
    //   child: Wrap(
    //     runSpacing: 10,
    //     spacing: 10,
    //     children: List.generate(productList.length, (index) => Card(
    //         child: Container(
    //           decoration: BoxDecoration(
    //               color: Colors.blue.withOpacity(0.1),
    //               borderRadius: BorderRadius.circular(5)),
    //           width: 355,
    //           child: Padding(
    //             padding: const EdgeInsets.all(10.0),
    //             child: Column(
    //               children: [
    //                 SizedBox(
    //                   height: 5,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             'Product Name',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline6!
    //                                 .copyWith(color: Colors.blue),
    //                           ),
    //                           Text(
    //                             '${productList[index].productName}',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .subtitle2!
    //                                 .copyWith(fontSize: 16),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             'Launched At',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline6!
    //                                 .copyWith(color: Colors.blue),
    //                           ),
    //                           Text(
    //                             Utils.formatDate(productList[index].launchedAt!),
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .subtitle2!
    //                                 .copyWith(fontSize: 16),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             'Launch Site',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline6!
    //                                 .copyWith(color: Colors.blue),
    //                           ),
    //                           Text(
    //                             '${productList[index].launchSite}',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .subtitle2!
    //                                 .copyWith(fontSize: 16),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             'Popularity',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline6!
    //                                 .copyWith(color: Colors.blue),
    //                           ),
    //                           Text(
    //                             '${productList[index].popularity}',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .subtitle2!
    //                                 .copyWith(fontSize: 16),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    /* Using a Grid View */

    return isShowingGridView
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              crossAxisCount:  screenWidth == 500 ? 1 : 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
              children: List.generate(
                productList.length,
                (index) => Wrap(
                  children: [
                    Card(
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5)),
                            width: 460,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product Name',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(color: Colors.blue),
                                            ),
                                            Text(
                                              '${productList[index].productName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Launched At',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(color: Colors.blue),
                                            ),
                                            Text(
                                              Utils.formatDate(
                                                  productList[index].launchedAt!),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Launch Site',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(color: Colors.blue),
                                            ),
                                            Text(
                                              '${productList[index].launchSite}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Popularity',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(color: Colors.blue),
                                            ),
                                            Text(
                                              '${productList[index].popularity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 50,
                            top: 25,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEditingProduct = true;
                                      selectedProductId =
                                          productList[index].productId;
                                      _productNameController.text =
                                          productList[index].productName!;
                                      _launchSiteController.text =
                                          productList[index].launchSite!;
                                      _launchedAtController.text = Utils.formatDate(
                                          productList[index].launchedAt!);
                                      _pickedDate = productList[index].launchedAt!;
                                      productRating =
                                          productList[index].popularity!;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) => _showProductDialog(),
                                    );
                                    // AutoRouter.of(context).push(ProductViewRoute(
                                    //     isEditingProduct: true, productModel: productModel));
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    _showDeleteProductDialog(
                                        context, productList[index]);
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Card(
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5)),
                    width: 460,
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(color: Colors.blue),
                                    ),
                                    Text(
                                      '${productList[index].productName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Launched At',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(color: Colors.blue),
                                    ),
                                    Text(
                                      Utils.formatDate(
                                          productList[index].launchedAt!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Launch Site',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(color: Colors.blue),
                                    ),
                                    Text(
                                      '${productList[index].launchSite}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Popularity',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(color: Colors.blue),
                                    ),
                                    Text(
                                      '${productList[index].popularity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isEditingProduct = true;
                              selectedProductId = productList[index].productId;
                              _productNameController.text =
                                  productList[index].productName!;
                              _launchSiteController.text =
                                  productList[index].launchSite!;
                              _launchedAtController.text = Utils.formatDate(
                                  productList[index].launchedAt!);
                              _pickedDate = productList[index].launchedAt!;
                              productRating = productList[index].popularity!;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => _showProductDialog(),
                            );
                            // AutoRouter.of(context).push(ProductViewRoute(
                            //     isEditingProduct: true, productModel: productModel));
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            _showDeleteProductDialog(
                                context, productList[index]);
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(
              width: 15,
            ),
            itemCount: productList.length,
            padding: const EdgeInsets.all(15),
          );
  }

  _buildProductView(ProductModel productModel, bool isLastItem) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 135,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.blue),
                              ),
                              Text(
                                '${productModel.productName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Launched At',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.blue),
                              ),
                              Text(
                                Utils.formatDate(productModel.launchedAt!),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Launch Site',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.blue),
                              ),
                              Text(
                                '${productModel.launchSite}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Popularity',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.blue),
                              ),
                              Text(
                                '${productModel.popularity}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 20,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      AutoRouter.of(context).push(ProductViewRoute(
                          isEditingProduct: true, productModel: productModel));
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      _showDeleteProductDialog(context, productModel);
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: isLastItem ? 0 : 20,
        ),
      ],
    );
  }

  _showDeleteProductDialog(BuildContext context, ProductModel productModel) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () async {
        await _homeBloc.deleteProduct(productModel.productId!);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete Product"),
      content: Text(
          "Are you sure you want to delete product '${productModel.productName}' ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
