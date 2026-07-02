import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController placeController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  Future<void> addReview() async {

    if(placeController.text.trim().isEmpty ||
        reviewController.text.trim().isEmpty){
      return;
    }

    await firestore.collection("reviews").add({

      "placeName": placeController.text.trim(),
      "review": reviewController.text.trim(),
      "createdAt": FieldValue.serverTimestamp(),

    });

    placeController.clear();
    reviewController.clear();

    Navigator.pop(context);
  }

  void openBottomSheet(){

    showModalBottomSheet(

      context: context,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),

      ),

      builder: (context){

        return Padding(

          padding: EdgeInsets.only(

            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,

          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              const Text(

                "Add Review",

                style: TextStyle(

                  fontSize: 22,
                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(height: 20),

              TextField(

                controller: placeController,

                decoration: InputDecoration(

                  labelText: "Place Name",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                ),

              ),

              const SizedBox(height: 15),

              TextField(

                controller: reviewController,

                maxLines: 4,

                decoration: InputDecoration(

                  labelText: "Write Review",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                ),

              ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: addReview,

                  style: ElevatedButton.styleFrom(

                    padding: const EdgeInsets.symmetric(vertical: 15),

                  ),

                  child: const Text("Submit"),

                ),

              ),

            ],

          ),

        );

      },

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Community Reviews"),

        centerTitle: true,

      ),

      floatingActionButton: FloatingActionButton(

        onPressed: openBottomSheet,

        child: const Icon(Icons.add),

      ),

      body: StreamBuilder(

        stream: firestore
            .collection("reviews")
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context,snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){

            return const Center(
              child: CircularProgressIndicator(),
            );

          }

          if(!snapshot.hasData ||
              snapshot.data!.docs.isEmpty){

            return const Center(

              child: Text(
                "No Reviews Yet",
                style: TextStyle(fontSize: 18),
              ),

            );

          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(

            padding: const EdgeInsets.all(15),

            itemCount: reviews.length,

            itemBuilder: (context,index){

              final data = reviews[index];

              return Card(

                elevation: 3,

                margin: const EdgeInsets.only(bottom: 15),

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(18),

                ),

                child: Padding(

                  padding: const EdgeInsets.all(15),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Row(

                        children: [

                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),

                          const SizedBox(width: 5),

                          Expanded(

                            child: Text(

                              data["placeName"],

                              style: const TextStyle(

                                fontSize: 18,
                                fontWeight: FontWeight.bold,

                              ),

                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 12),

                      Text(

                        data["review"],

                        style: const TextStyle(

                          fontSize: 15,

                        ),

                      ),

                    ],

                  ),

                ),

              );

            },

          );

        },

      ),

    );

  }

}