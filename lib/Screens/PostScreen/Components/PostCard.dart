import 'package:Hooked/models/post.dart';
import 'package:Hooked/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key key, this.post}) : super(key: key);

  final Post post;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  HookedUser user;

  @override
  void initState() {
    super.initState();
    _getPostUser();
  }

  void _getPostUser() async {
    var postUser = await HookedUser.getUserbyId(widget.post.userId);
    setState(() {
      user = postUser;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(6, 4),
            spreadRadius: 0,
            blurRadius: 20,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: user != null ? Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.firstName + " " + user.lastName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    Spacer(),
                    Text(DateFormat.yMMMEd().format(widget.post.createdDate))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(widget.post.textContent)),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    widget.post.imageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                )
                ,Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Fish: ${widget.post.fish}",
                    style: TextStyle(fontSize: 24),
                  ),
                )
              ],
            ),
          ),
        ) : Container(),
      ),
    );
  }
}
