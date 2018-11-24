
class Api_VisJs
  constructor: () ->
    @._canvas_border = 50

  add_node      : (node    ) -> network.body.data.nodes.add(node)
  add_edge      : (edge    ) -> network.body.data.edges.add(edge)
  canvas_border : (        ) -> @._canvas_border
  canvas_height : (        ) -> network.canvas.frame.clientHeight
  canvas_width :  (        ) -> network.canvas.frame.clientWidth
  context       : (        ) -> network.canvas.getContext()
  edges         : (        ) -> return network.body.data.edges._data
  nodes         : (        ) -> return network.body.data.nodes._data
  node_set_x_y  : (id, x, y) -> network.body.data.nodes.update({'id':id, x:x , y:y})
  remove_node   : (id      ) -> network.body.data.nodes.remove(id)

  move_to: (position_x, position_y, offset_x, offset_y, scale ) =>
    options =
              position:
                x: position_x
                y: position_x
              offset:
                x: offset_x
                y: offset_y
              scale   : scale || 1.0

    network.moveTo(options)

  set_edge_value: (id, key, value) => network.body.data.edges.update({ id: id, "#{key}": value })


  #draw helpers (move to separate class)
  draw_circle: (x, y, r)=>
    ctx = @.context()
    ctx.strokeStyle = '#294475';
    ctx.lineWidth   = 4;
    ctx.fillStyle   = '#A6D5F7';
    ctx.circle(x,y,r)
    ctx.fill();
    ctx.stroke();

  draw_rectangle: (from_x, from_y, to_x, to_y )=>
    ctx = @.context()
    ctx.rect(from_x, from_y, to_x, to_y);
    ctx.stroke();
  # Maps specific methods

  add_connection: (from, to,length)->
    edge =
             from   : "node_#{from}"
             to     : "node_#{to}"
             smooth : false
             arrows : 'to'
             color  : {color : '#4444FF'}
             length : length || 150

    console.log(edge)
    @.add_edge(edge)

  add_component: (label , row)->
    node_id      = "node_#{label}"
    node_x       = 100
    node_y       = 200
    node_color   = '#F9F0F0'
    edge_id_1    = "edge_1_#{label}"
    edge_id_2    = "edge_2_#{label}"
    edge_color   = { color: '#C0C0C0'}
    edge_dashes  = true
    edge_hidden  = false
    edge_physics = false
    anchor_top     = "anchor_#{row || 1}_0"
    anchor_bottom  = "anchor_#{row || 1}_1"

    api_visjs.add_node( { id: node_id  , label: label          , shape: 'box'   , color: node_color , x: node_x   , y: node_y })
    api_visjs.add_edge( { id: edge_id_1, from : anchor_top     , to   : node_id , color: edge_color , hidden: edge_hidden , dashes: edge_dashes})
    api_visjs.add_edge( { id: edge_id_2, from : anchor_bottom  , to   : node_id , color: edge_color , hidden: edge_hidden , dashes: edge_dashes})
    #api_visjs.add_edge( { from: 'a', to: '1', smooth:false , length:200   , _hidden: true, dashes: true, color: {color: '#F0C0C0', _inherit : false} } )
    #api_visjs.add_edge( { from: '3', to: 'a', smooth:false , length:100   , _hidden: true, dashes: true, color: {color: '#F0C0C0'} })


  add_top_and_bottom_anchor_nodes: (count) ->
    console.log ('in add_top_and_bottom_anchor_nodes for #{@.canvas_width()} x #{@.canvas_height() })')

    split_x        = (@.canvas_width() - @.canvas_border() * 2) / count
    split_x_offset = split_x / 2
    split_y        = @.canvas_height() - @.canvas_border() * 2
    node_color     = 'black'
    node_hidden    = false
    node_fixed     = true
    node_font      = size: 1
    node_label     = ' '
    node_shape     = 'circle'

    for i in [1..count]           # number of anchors to add
      for j in [0..1]             # to and bottom
        node_id    = "anchor_#{i}_#{j}"
        node_x     = i * split_x - split_x_offset
        node_y     = j * split_y
        node =
                id     : node_id
                color  : node_color
                label  : node_label
                shape  : node_shape
                fixed  : node_fixed
                hidden : node_hidden
                x      : node_x
                y      : node_y
                font   : node_font
        api_visjs.add_node node
    #api_visjs.add_node( {id: '1', label: '1', shape: 'box'  , fixed: true , x:100, y:0 , })
    #api_visjs.add_node( {id: '2', label: '2', shape: 'box'  , fixed: true , x:300, y:0 })
    #api_visjs.add_node( {id: '3', label: '3', shape: 'box'  , fixed: true , x:100, y:400 })
    #api_visjs.add_node( {id: '4', label: '4', shape: 'box'  , fixed: true , x:300, y:400 })

  after_drawing: ()=>
      @.move_to(0,0, - @.canvas_width() / 2 + @.canvas_border(), - @.canvas_height() / 2 + @.canvas_border() , 1.0)
      @.draw_rectangle(0 ,0 , @.canvas_width() - @.canvas_border() * 2 , @.canvas_height() - @.canvas_border() * 2)

      #@.node_set_x_y('1', 0,0)
      #@.node_set_x_y('2', 100,0)
      #@.draw_circle(0   ,0   ,2)
      #@.draw_circle(0 ,400   ,5)
      #@.draw_circle(600   ,0   ,10)
      #@.draw_circle(600   ,400   ,15)

  set_up_on_after_drawing: ()=>
    network.on "afterDrawing",  (ctx) =>
      @.after_drawing()
      #@.move_to(0,0)
      #@.draw_circle(0   ,0   ,10)
      #@.draw_circle(100 ,100   ,10)
      #@.draw_circle(0   ,100   ,10)

  add_data: ()->
    @.add_top_and_bottom_anchor_nodes(4)
    #api_visjs.add_node( {id: '1', label: '1', shape: 'box'  , fixed: true , x:100, y:0 , _mass: 5})
    #api_visjs.add_node( {id: '2', label: '2', shape: 'box'  , fixed: true , x:300, y:0 })
    #api_visjs.add_node( {id: '3', label: '3', shape: 'box'  , fixed: true , x:100, y:400 })
    #api_visjs.add_node( {id: '4', label: '4', shape: 'box'  , fixed: true , x:300, y:400 })


    @.add_component('kettle' , 1)
    @.add_component('user'   , 3)
    @.add_component('tea'    , 1)
    @.add_component('water'  , 2)

    @.set_edge_value('edge_1_kettle', 'length',300)
    @.set_edge_value('edge_2_kettle', 'length',450)

    @.set_edge_value('edge_1_user'  , 'length', 10)
    @.set_edge_value('edge_2_user'  , 'length', 700)

    @.add_connection('user'         , 'kettle'  )
    @.add_connection('kettle'       , 'water')
    @.add_connection('kettle'       , 'tea'  )



#    api_visjs.add_node( {id: 'b', label: 'B', shape: 'box' , x:100, y:100 , color: '#F9F0F0'})
#    api_visjs.add_edge( { from: 'b', to: '1', smooth:false , length:100  , hidden: true})
#    api_visjs.add_edge( { from: '3', to: 'b', smooth:false , length:200  , hidden: true})
#
#    api_visjs.add_node( {id: 'c', label: 'C', shape: 'box' , x:100, y:100 ,color: '#F9F0F0'})
#    api_visjs.add_edge( { from: 'c', to: '2', smooth:false , length:0   , hidden: true})
#    api_visjs.add_edge( { from: '4', to: 'c', smooth:false , length:350 , hidden: true})
#
#    api_visjs.add_node( {id: 'd', label: 'D', shape: 'box' , x:300, y:100 ,color: '#F9F0F0'})
#    api_visjs.add_edge( { from: 'd', to: '2', smooth:false , length:100   , hidden: true})
#    api_visjs.add_edge( { from: '4', to: 'd', smooth:false , length:200 , hidden: true})
#
#
#    api_visjs.add_edge( { from: 'c', to: 'b', smooth:false , arrows: 'to' , color: {color : 'red'}})
#    api_visjs.add_edge( { from: 'b', to: 'a', smooth:false , arrows: 'to' })
#    api_visjs.add_edge( { from: 'c', to: 'd', smooth:false , arrows: 'to' })



    console.log('------ here----')

  set_Options:()=>
    options =
      {
        #nodes: { physics: false }
        #edges: { physics: false }
        physics: {
                    forceAtlas2Based: {
                        gravitationalConstant: -26,
                        centralGravity: 0.000,          # no central gravity since we don't need that
                        springLength: 100,
                        springConstant: 0.18
                    },
                    maxVelocity: 10,                      # keep this low so that the nodes don'y move too far from each other
                    minVelocity: 1,
                    solver: 'forceAtlas2Based',
                    timestep: 2.35,                       # this value can be used to slow down the animation (for ex 0.015)
                    stabilization: {
                        enabled:true,
                        iterations:2000,
                        updateInterval:100
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
network.on 'stabilizationProgress',  (data)->
      console.log('stabilizationProgress',data)
      network.stopSimulation()



api_visjs.set_Options()
api_visjs.set_up_on_after_drawing()
api_visjs.add_data()
#network.stopSimulation()
