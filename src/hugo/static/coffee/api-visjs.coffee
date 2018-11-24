
class Api_VisJs
  constructor: () ->
    @.answer = 42

  add_node: (node)-> network.body.data.nodes.add(node)
  add_edge: (edge)-> network.body.data.edges.add(edge)
  context : ()     -> network.canvas.getContext()
  edges   : ()     -> return network.body.data.edges._data
  nodes   : ()     -> return network.body.data.nodes._data

  node_set_x_y: (id, x, y)-> network.body.data.nodes.update({'id':id, x:x , y:y})

  remove_node: (id)->
    network.body.data.nodes.remove(id)


  draw_circle: (x, y, r)=>
    context = @.context()
    ctx = context
    ctx.strokeStyle = '#294475';
    ctx.lineWidth   = 4;
    ctx.fillStyle   = '#A6D5F7';
    ctx.circle(x,y,r)
    ctx.fill();
    ctx.stroke();

  move_to: (x,y)=>
    network.moveTo({  position: {x: x, y: y}, offset  : { x: -300, y: -200 }, scale   : 1.0 } )



  after_drawing: ()=>
      @.move_to(0,0)
      #@.node_set_x_y('1', 0,0)
      #@.node_set_x_y('2', 100,0)
      @.draw_circle(0   ,0   ,2)
      @.draw_circle(0 ,400   ,5)
      @.draw_circle(600   ,0   ,10)
      @.draw_circle(600   ,400   ,15)

  set_up_on_after_drawing: ()=>
    network.on "afterDrawing",  (ctx) =>
      @.after_drawing()
      #@.move_to(0,0)
      #@.draw_circle(0   ,0   ,10)
      #@.draw_circle(100 ,100   ,10)
      #@.draw_circle(0   ,100   ,10)
    api_visjs.add_node( {id: '1', label: '1', shape: 'box'  , fixed: true , x:100, y:0 , _mass: 5})
    api_visjs.add_node( {id: '2', label: '2', shape: 'box'  , fixed: true , x:300, y:0 })
    api_visjs.add_node( {id: '3', label: '3', shape: 'box'  , fixed: true , x:100, y:400 })
    api_visjs.add_node( {id: '4', label: '4', shape: 'box'  , fixed: true , x:300, y:400 })

    api_visjs.add_node( {id: 'a', label: 'A', shape: 'box' , x:100, y:100 ,color: '#F9F0F0'})
    api_visjs.add_edge( { from: 'a', to: '1', smooth:false , length:200   , _hidden: true, dashes: true, color: {color: '#F0C0C0', _inherit : false} } )
    api_visjs.add_edge( { from: '3', to: 'a', smooth:false , length:100   , _hidden: true, dashes: true, color: {color: '#F0C0C0'} })

    api_visjs.add_node( {id: 'b', label: 'B', shape: 'box' , x:100, y:100 , color: '#F9F0F0'})
    api_visjs.add_edge( { from: 'b', to: '1', smooth:false , length:100  , hidden: true})
    api_visjs.add_edge( { from: '3', to: 'b', smooth:false , length:200  , hidden: true})

    api_visjs.add_node( {id: 'c', label: 'C', shape: 'box' , x:100, y:100 ,color: '#F9F0F0'})
    api_visjs.add_edge( { from: 'c', to: '2', smooth:false , length:0   , hidden: true})
    api_visjs.add_edge( { from: '4', to: 'c', smooth:false , length:350 , hidden: true})

    api_visjs.add_node( {id: 'd', label: 'D', shape: 'box' , x:300, y:100 ,color: '#F9F0F0'})
    api_visjs.add_edge( { from: 'd', to: '2', smooth:false , length:100   , hidden: true})
    api_visjs.add_edge( { from: '4', to: 'd', smooth:false , length:200 , hidden: true})


    api_visjs.add_edge( { from: 'c', to: 'b', smooth:false , arrows: 'to' , color: {color : 'red'}})
    api_visjs.add_edge( { from: 'b', to: 'a', smooth:false , arrows: 'to' })
    api_visjs.add_edge( { from: 'c', to: 'd', smooth:false , arrows: 'to' })



    console.log('------ here----')

  set_physics_Off:()=>
    options =
      {
        #nodes: { physics: false }
        #edges: { physics: false }
        physics: {
                    forceAtlas2Based: {
                        gravitationalConstant: -26,
                        centralGravity: 0.005,
                        springLength: 130,
                        springConstant: 0.18
                    },
                    maxVelocity: 146,
                    solver: 'forceAtlas2Based',
                    timestep: 0.35,
                    stabilization: {
                        enabled:true,
                        iterations:2000,
                        updateInterval:25
                    }

        }
      #physics: true,
        interaction: {
            dragNodes: true
            zoomView : false
            dragView : false
        }
      }
    network.setOptions(options)

window.api_visjs = new Api_VisJs()

api_visjs.set_up_on_after_drawing()
#api_visjs.after_drawing()

api_visjs.set_physics_Off()
