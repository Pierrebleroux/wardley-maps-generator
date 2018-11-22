---
title     : Maps test
menu      : main
---

Test Wardley Maps generation

{{< map-render mode="JavaScript" height="300" >}}
nodes = new vis.DataSet([
    {id: 0, x: 500 , y:-300  , label: 'Anchor' , fixed: true        , shape: 'box'},
    {id: 1, x: 100  ,y:-100  , label: 'Node 1' , fixed: { x: true } , shape: 'box'},
    {id: 2, x: 100  ,y:0     , label: 'Node 2' , fixed: { x: true } , shape: 'box'},
    {id: 3, x: 300  ,y:-100  , label: 'Node 3' , fixed: { x: true } , shape: 'box'},
    {id: 4, x: 500           , label: 'Node 4' , fixed: { x: true } , shape: 'box'},
    {id: 5, x: 700           , label: 'Node 5' , fixed: { x: true } , shape: 'box'},
    {id: 6, x: 100  ,y:100   , label: 'Node 6' , fixed: { x: true } , shape: 'box'},
    //{id: 6, x: 100 , y:200   , label: 'with icon' , fixed: { x: true } , shape: 'image',image :'/img/osa/osa_desktop.png'},
  ]);
edges = new vis.DataSet([
    {from: 0, to: 1, arrows:'to',smooth:false},
    {from: 1, to: 3, arrows:'to',smooth:false},
    {from: 1, to: 2, arrows:'to',smooth:false},
    {from: 2, to: 4, arrows:'to',smooth:false},
    {from: 2, to: 3, arrows:'to',smooth:false},
    {from: 4, to: 5, arrows:'to',smooth:false},
    {from: 5, to: 6, arrows:'to',smooth:false},
  ]);

split_value = 8





 render()

{{</ map-render >}}