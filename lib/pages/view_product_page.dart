import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/cart_bubble_view.dart';
import '../customwidgets/main_drawer.dart';
import '../customwidgets/product_grid_item_view.dart';
import '../main.dart';
import '../models/category_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import 'promo_code_page.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';

  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<OrderProvider>(context, listen: false).getAllOrders();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      /*appBar: AppBar(
        title: const Text('Products'),
      ),*/
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  const CartBubbleView(),
                ],
                expandedHeight: MediaQuery.of(context).size.height / 2,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Products', style: TextStyle(color: Colors.black),),
                  background: ListView(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<CategoryModel>(
                          hint: const Text('Select Category'),
                          value: categoryModel,
                          isExpanded: true,
                          items: provider
                              .getCategoryListForFiltering()
                              .map((catModel) => DropdownMenuItem(
                                  value: catModel,
                                  child: Text(catModel.categoryName)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              categoryModel = value;
                            });
                            if(categoryModel!.categoryName == 'All') {
                              provider.getAllProducts();
                            } else {
                              provider.getAllProductsByCategory(categoryModel!);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: provider.productList.length,
                  (context, index) {
                    final product = provider.productList[index];
                    return ProductGridItemView(productModel: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /*Column buildColumn(ProductProvider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<CategoryModel>(
            hint: const Text('Select Category'),
            value: categoryModel,
            isExpanded: true,
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
            items: provider
                .getCategoryListForFiltering()
                .map((catModel) => DropdownMenuItem(
                    value: catModel, child: Text(catModel.categoryName)))
                .toList(),
            onChanged: (value) {
              setState(() {
                categoryModel = value;
              });
              provider.getAllProductsByCategory(categoryModel!);
            },
          ),
        ),
        provider.productList.isEmpty
            ? const Expanded(
                child: Center(
                child: Text('No item found'),
              ))
            : Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: provider.productList.length,
                  itemBuilder: (context, index) {
                    final product = provider.productList[index];
                    return ProductGridItemView(productModel: product);
                  },
                ),
              ),
      ],
    );
  }*/
}

