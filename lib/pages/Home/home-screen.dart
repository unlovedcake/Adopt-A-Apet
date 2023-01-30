import 'dart:convert';
import 'package:adopt_a_pet/pages/Factorial/factorial-screen.dart';
import 'package:adopt_a_pet/utilities/Extenstion-String.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:adopt_a_pet/model/animal-model.dart';
import 'package:adopt_a_pet/pages/SignIn-SignUp/signin-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../router/Navigate-Route.dart';
import '../../widgets/RichText-HightTermText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AnimalModel>? _data = []; //List.generate(20, (i) => AnimalModel());
  List<AnimalModel>? searchData = []; //List.generate(20, (i) => AnimalModel());

  final ScrollController _controller = ScrollController();
  var isLoading = ValueNotifier<bool>(false);
  var dataLenght = ValueNotifier<int>(10);

  TextEditingController searchController = TextEditingController();

  String highLightSearchtTerm = "";

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://api.publicapis.org/entries'));
    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body)['entries'];

        // List<AnimalModel>? searchDatas = [];
        //
        // for (var jsonItem in jsonData) {
        //   searchDatas.add(AnimalModel.fromMap(jsonItem));
        // }

        List<AnimalModel> decodedData =
            (jsonData as List).map((value) => AnimalModel.fromMap(value)).toList();

        // searchData = decodedData;
        //
        // _data = searchData;

        _data = decodedData
            .sublist(0, dataLenght.value + 1)
            .map((e) => AnimalModel(
                API: e.API,
                Category: e.Category,
                Link: e.Link,
                Auth: e.Auth,
                Description: e.Description,
                Cors: e.Cors,
                HTTPS: e.HTTPS))
            .toList();

        searchData = _data;

        isLoading.value = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _searchFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _fetchData();
    } else {
      _data = searchData!
          .where((studentName) =>
              studentName.Category!.toUpperCase().contains(enteredKeyword.toUpperCase()))
          .toList();
    }
  }

  @override
  void initState() {
    _fetchData();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          _controller.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {});
        _fetchData();
        dataLenght.value += 20;

        print("ADD");
        isLoading.value = true;
      } else if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
      // else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      //   // setState(() {});
      //   isLoading.value = false;
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [Colors.white, Colors.blue],
        //     ),
        //   ),
        // ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Data Management',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.blue],
                ),
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Data Management'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Factorial'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => FactorialScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).push(pageRouteAnimate(const SignInScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * .02),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: searchTextField(),
          ),
          SizedBox(height: size.height * .02),
          Expanded(
            child: RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1)).then((value) => _fetchData());
              },
              child: ValueListenableBuilder(
                valueListenable: dataLenght,
                builder: (BuildContext context, _, Widget? child) {
                  if (_data!.isEmpty && searchController.text.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_data!.isEmpty && searchController.text.isNotEmpty) {
                    return const Center(child: Text('No Search Found...'));
                  }
                  return ListView.builder(
                    controller: _controller,
                    itemCount: _data?.length,
                    itemBuilder: (context, index) {
                      String suggestion = _data?[index].Category.toString().toUpperCase() ?? "";
                      int startIndex = suggestion.indexOf(highLightSearchtTerm);
                      return Slidable(
                        // Specify a key if the Slidable is dismissible.
                        key: ValueKey(index),

                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          // dismissible: DismissiblePane(onDismissed: () {
                          //
                          // }),
                          children: [
                            SlidableAction(
                              onPressed: (val) {},
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            const SlidableAction(
                              onPressed: null,
                              backgroundColor: Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: 'Share',
                            ),
                          ],
                        ),

                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (val) {},
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Hide',
                            ),
                            const SlidableAction(
                              onPressed: null,
                              backgroundColor: Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.save,
                              label: 'Save',
                            ),
                          ],
                        ),

                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child: ListTile(
                          subtitle: Text(_data?[index].Description ?? ""),
                          leading: Image.asset('asset/images/app-logo.png'),
                          // leading: (_data?[index].Link ?? "").isURLValid()
                          //     ? CachedNetworkImage(
                          //         imageUrl: _data?[index].Link ?? "",
                          //         progressIndicatorBuilder: (context, url, downloadProgress) =>
                          //             CircularProgressIndicator(value: downloadProgress.progress),
                          //         errorWidget: (context, url, error) => Icon(Icons.error),
                          //       )
                          //     : Image.asset('asset/images/app-logo.png'),
                          //trailing: Image.network(_data?[index].Link ?? ""),

                          title: startIndex != -1
                              ? searchHiglightTermText(suggestion, highLightSearchtTerm)
                              : const SizedBox.shrink(),
                          // title: Text(_data?[index].Category ?? "")
                        ),
                      );
                      // return ListTile(
                      //   title: Text(_data?[index].Category ?? ""),
                      //   subtitle: Text(_data?[index].Description ?? ""),
                      // );
                    },
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (BuildContext context, _, Widget? child) {
                return isLoading.value
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ))
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  TextField searchTextField() {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: searchController,
      decoration: InputDecoration(
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        hintText: 'Search...',
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (value) {
        setState(() {
          highLightSearchtTerm = value.toUpperCase();
          _searchFilter(value.toUpperCase());
        });
      },
    );
  }
}
