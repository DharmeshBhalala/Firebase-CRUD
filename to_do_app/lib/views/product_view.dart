import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/product_model.dart';
import 'package:to_do_app/utils/utils.dart';
import 'package:to_do_app/views/product_bloc.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/text_field_wrapper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductView extends StatefulWidget {
  bool? isEditingProduct;
  ProductModel? productModel;
  ProductView({Key? key, this.isEditingProduct = false, this.productModel})
      : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _productBloc = ProductBloc();
  final GlobalKey<FormState> _formkey = GlobalKey();
  final _productNameController = TextEditingController();
  final _productNameFocusNode = FocusNode();
  final _launchedAtController = TextEditingController();
  final _launchedAtFocusNode = FocusNode();
  final _launchSiteController = TextEditingController();
  final _launchSiteFocusNode = FocusNode();
  double productRating = 0.0;
  bool inProgress = false;
  bool isOperationCompleted = true;

  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    if (widget.isEditingProduct != null &&
        widget.productModel != null &&
        widget.isEditingProduct!) {
      _productNameController.text = widget.productModel!.productName!;
      _launchSiteController.text = widget.productModel!.launchSite!;
      _launchedAtController.text =
          Utils.formatDate(widget.productModel!.launchedAt!);
      _pickedDate = widget.productModel!.launchedAt!;
      productRating = widget.productModel!.popularity!;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditingProduct != null && widget.isEditingProduct!
            ? 'Edit Product'
            : 'Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  height: 30,
                ),
                CustomButton(
                    enabled: !inProgress,
                    onPressed: inProgress ? () {} : () => saveProduct(),
                    title: widget.isEditingProduct != null &&
                            widget.isEditingProduct!
                        ? 'Update Product'
                        : 'Add New Product'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> saveProduct() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        inProgress = true;
      });
      if (widget.isEditingProduct!) {
        await _productBloc.updateProduct(ProductModel(
            productId: widget.productModel!.productId,
            productName: _productNameController.text,
            launchedAt: _pickedDate,
            launchSite: _launchSiteController.text,
            popularity: productRating)).then((msg) {
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

      setState(() {
        inProgress = false;
      });

      if (isOperationCompleted) {
        AutoRouter.of(context).pop();
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
}
