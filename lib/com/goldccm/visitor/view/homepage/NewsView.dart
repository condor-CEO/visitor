import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/model/NewsInfo.dart';


class NewsView extends StatelessWidget{
  final NewsInfo newsInfo;
  final String imageServerUrl;
  NewsView(this.newsInfo,this.imageServerUrl);

  @override
  Widget build(BuildContext context) {
    return new Padding(padding: const EdgeInsets.only(
      left: 5.0,
      right: 5.0,
      top: 3.0,
      bottom: 3.0,
    ),
    child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                 flex:2,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Container(
                      child:
                        new Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                            ),
        child: new RichText(text: new TextSpan(text: newsInfo.newsName,style: new TextStyle(fontSize: 15.0,color: Colors.black,fontFamily: '楷体_GB2312' )),maxLines: 1,overflow: TextOverflow.ellipsis,)
                           // child:new Text(newsInfo.newsName,overflow: TextOverflow.ellipsis,style: new TextStyle(fontSize: 15.0,color: Colors.black,fontFamily: '楷体_GB2312' )),
                        ),


                    ),

                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                          ),
                          child: new Text(newsInfo.newsDate,style: new TextStyle(fontSize: 14.0,color: Colors.black,fontFamily: '楷体_GB2312' ))
                        )]),

                     new Container(
                        height: 80,
                        child: (
                            new Padding(
                                padding: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 10.0,
                                ),
                                child: new RichText(text: new TextSpan(text: newsInfo.newsDetail,style: new TextStyle(fontSize: 12.0,color: Colors.black,fontFamily: '楷体_GB2312' )),maxLines: 4,overflow: TextOverflow.ellipsis,)
                            )




                        )
                    )

  ]

                )


            ),
          new Expanded(
          flex: 1,
          child: new Container(
            height: 110,
            child: new Image.network(imageServerUrl+newsInfo.newsImageUrl,fit: BoxFit.cover,),),
          )
          ],
        ),




    );
  }





}


