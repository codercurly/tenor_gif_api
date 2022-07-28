import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tenor gif'),
    );
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
TextEditingController _controller = TextEditingController();
List<String> gifUrls=[];

void getGifUrls(String word) async{

 var link= await http.get(Uri.parse('https://g.tenor.com/v1/search?q=$word&key=LIVDSRZULELA&limit=8'));
  var dataParsed = jsonDecode(link.body);

 setState(() {  gifUrls.clear();
 for(var i=0; i<8;i++){
   gifUrls.add(dataParsed['results'][i]['media'][0]['tinygif']['url']);

 }});
}


final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

@override
  void initState() {
  getGifUrls('hacı');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Gif arayın"),backgroundColor: Colors.orange,),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextField(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  controller: _controller,
                  ),
                ),
              FlatButton(onPressed:(){
                getGifUrls(_controller.text);
              }, child: Text("çağır"),
              ),
              gifUrls.isEmpty?
              spinkit:
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.separated(
                  separatorBuilder: (_, __) {
                    return Divider(
                      color: Colors.orangeAccent,
                      thickness: 5,
                      height: 5,
                    );
                  },
                  itemCount: 8, itemBuilder: (BuildContext context, int index) {

    return GifCard(gifUrls[index]);
    }

              ),
              )
            ],

          ),
        ),
      ),
    );
  }
}
class GifCard extends StatelessWidget {


  final String gifUrl;

  GifCard(this.gifUrl);


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(gifUrl),
        )
    );
  }
}


