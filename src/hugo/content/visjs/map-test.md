---
title     : Maps test
menu      : main
---

Test Wardley Maps generation

{{< map-render mode="JavaScript" height="300" >}}

var DOTstring = `dinetwork {
  "user"        [ col = 2 , row = 0]
  "tea"         [ col = 3 ]
  "cup"         [ col = 3  row = 2]
  "water"       [ col = 4 ]
  "electricity" [ col = 4 ]
  "kettle"      [ col = 3 ]

  user  -> tea [label="wants"];
  tea   -> cup
  tea   -> kettle
  tea   -> water;
  water -> electricity
  }`

var parsedData = vis.network.convertDot(DOTstring);
var options    = {}

split_value = 8.2

 render(parsedData, options)

//nodes = new vis.DataSet([
//    {id: 0, x: 500 , y:-300  , label: 'Anchor' , fixed: true        , shape: 'box'},
//    {id: 1, x: 100  ,y:-100  , label: 'Node 1' , fixed: { x: true } , shape: 'box'},
//    {id: 2, x: 100  ,y:0     , label: 'Node 2' , fixed: { x: true } , shape: 'box'},
//    {id: 3, x: 300  ,y:-100  , label: 'Node 3' , fixed: { x: true } , shape: 'box'},
//    {id: 4, x: 500           , label: 'Node 4' , fixed: { x: true } , shape: 'box'},
//    {id: 5, x: 700           , label: 'Node 5' , fixed: { x: true } , shape: 'box'},
//    {id: 6, x: 100  ,y:100   , label: 'Node 6' , fixed: { x: true } , shape: 'box'},
//    //{id: 6, x: 100 , y:200   , label: 'with icon' , fixed: { x: true } , shape: 'image',image :'/img/osa/osa_desktop.png'},
//  ]);
//edges = new vis.DataSet([
//    {from: 0, to: 1, arrows:'to',smooth:false},
//    {from: 1, to: 3, arrows:'to',smooth:false},
//    {from: 1, to: 2, arrows:'to',smooth:false},
//    {from: 2, to: 4, arrows:'to',smooth:false},
//    {from: 2, to: 3, arrows:'to',smooth:false},
//    {from: 4, to: 5, arrows:'to',smooth:false},
//    {from: 5, to: 6, arrows:'to',smooth:false},
//  ]);

//split_value = 5.4

//render({})

{{</ map-render >}}