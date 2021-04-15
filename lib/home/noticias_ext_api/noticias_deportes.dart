import 'package:flutter/material.dart';
import 'package:google_login/utils/news_repository.dart';

import 'item_noticia.dart';

class NoticiasDeportes extends StatefulWidget {
  const NoticiasDeportes({Key key}) : super(key: key);

  @override
  _NoticiasDeportesState createState() => _NoticiasDeportesState();
}

class _NoticiasDeportesState extends State<NoticiasDeportes> {
  TextEditingController ctrl = TextEditingController();
  List data;

  Future<List> refresh() async {
    print(ctrl == null);
    if (ctrl == null) return search("");
    return (search(ctrl.text));
  }

  Future<List> search(String txt) async {
    data = await NewsRepository().getAvailableNoticias(query: txt);
    print(data);
    setState(() {});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: TextField(
              onChanged: search,
              controller: ctrl,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: RefreshIndicator(
            onRefresh: refresh,
            child: FutureBuilder(
              future: refresh(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child:
                        Text("Algo salio mal", style: TextStyle(fontSize: 32)),
                  );
                }
                if (snapshot.hasData) {
                  data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ItemNoticia(
                        noticia: data[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
