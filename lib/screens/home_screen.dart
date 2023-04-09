import 'package:appnotes/screens/note_editor.dart';
import 'package:appnotes/screens/note_reader.dart';
import 'package:appnotes/style/app_style.dart';
import 'package:appnotes/widgets/note_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("NOTLAR"),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text (
            "Kişisel Notlarım",
            style: GoogleFonts.roboto(
              color:Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Notes").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              //checking the connection state, if we still load the data we can display a progress bar
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );

              }
              if(snapshot.hasData) {
                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: snapshot.data!.docs
                      .map((note) => noteCard((){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteReaderScreen(note),
                            ));
                  }, note) )
                      .toList(),
                );
              }
              return Text("Henüz bir not yok", style: GoogleFonts.nunito(color: Colors.white),
              );
            },
          )
          )
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> NoteEditorScreen()));
          },
          label: Text("NOT EKLE"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
