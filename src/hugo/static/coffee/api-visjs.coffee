class Canvas_Draw
  constructor: (context) ->
    @.ctx = context

  arrow: (x1, y1, x2, y2)=>
    rot = -Math.atan2(x1 - x2, y1 - y2);
    @.ctx.beginPath();
    @.ctx.moveTo(x1, y1);
    @.ctx.lineTo(x2, y2);
    @.ctx.stroke();         # draw arrow line

    @.ctx.save();             # draw arrow head
    @.ctx.translate(x1, y1);
    @.ctx.rotate(rot);
    @.ctx.beginPath();
    @.ctx.moveTo(0, 0);
    @.ctx.lineTo(-5, -12);
    @.ctx.lineTo(5, -12);
    @.ctx.closePath();
    @.ctx.fill();
    @.ctx.restore();

  circle: (x, y, r)=>
    @.ctx.strokeStyle = '#294475';
    @.ctx.lineWidth   = 40;
    @.ctx.fillStyle   = '#A6D5F7';
    @.ctx.circle(x,y,r)
    @.ctx.fill();
    @.ctx.stroke();

  rectangle: (from_x, from_y, to_x, to_y )=>
    @.ctx.rect(from_x, from_y, to_x, to_y);
    @.ctx.stroke();

  box: (x, y, w, h, r)=>
    if (w < 2 * r)
      r = w / 2
    if (h < 2 * r)
      r = h / 2
    @.ctx.beginPath();
    @.ctx.lineWidth = "3";
    @.ctx.strokeStyle = "darkred";
    @.ctx.moveTo(x+r, y);
    @.ctx.arcTo(x+w, y,   x+w, y+h, r);
    @.ctx.arcTo(x+w, y+h, x,   y+h, r);
    @.ctx.arcTo(x,   y+h, x,   y,   r);
    @.ctx.arcTo(x,   y,   x+w, y,   r);
    @.ctx.closePath();
    @.ctx.stroke();

  text: (value, x, y)=>
    @.ctx.font      = "25px Arial";
    @.ctx.fillStyle = "darkred";
    @.ctx.fillText(value, x, y);

  text_vertical: (value, x, y)=>
    @.ctx.save();
    @.ctx.translate(x, y);
    @.ctx.rotate(-Math.PI/2);
    #@.ctx.textAlign = "center";
    @.ctx.fillText(value, 0, -20);
    @.ctx.restore();

  font: (font_size, font_type)=>
    @.ctx.font   = "#{font_size || 14}px Arial";
    @

class Api_VisJs
  constructor: () ->
    @._canvas_border    = 50
    @.hide_anchor_edges = true
    @.connection_arrows = '' #'to'
    @.row_count         = 4

  add_node       : (node    ) -> network.body.data.nodes.add(node)
  add_edge       : (edge    ) -> network.body.data.edges.add(edge)
  canvas_border  : (        ) -> @._canvas_border
  canvas_height  : (        ) -> network.canvas.frame.clientHeight
  canvas_width   :  (        ) -> network.canvas.frame.clientWidth
  draw           : (        ) => new Canvas_Draw(@.context())
  context        : (        ) => network.canvas.getContext()
  edges          : (        ) -> return network.body.data.edges._data
  nodes          : (        ) -> return network.body.data.nodes._data
  node_set_x_y   : (id, x, y) -> network.body.data.nodes.update({'id':id, x:x , y:y              }) ;  @
  node_fixed_x_y : (id, x, y) -> network.body.data.nodes.update({'id':id, x:x , y:y , fixed: true}) ;  @
  remove_node    : (id      ) -> network.body.data.nodes.remove(id)                                 ;  @
  physics_off    : (        ) -> network.setOptions({ physics: off })                               ;  @
  physics_options: (        ) -> network.physics.options

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
             from   : "#{from}"
             to     : "#{to}"
             smooth : false
             arrows : @.connection_arrows
             color  : {color : 'black' } #4444FF'}
             length : length || 200

    @.add_edge(edge)

  add_component: (label , row = 1, col = 1 ) =>
    node_id       = "#{label}"
    node_label    = "#{label}"
    node_color    = { border: 'black' , background : 'white'} # F9F0F0
    node_shape    = 'dot'
    node_font     = size: 20
    node_size     = 8
    node_mass     = 1
    edge_1_label  = ''
    edge_2_label  = ''
    edge_1_id     = "edge_1_#{label}"
    edge_2_id     = "edge_2_#{label}"
    edge_color    = { color: '#C0C0C0'}
    edge_dashes   = true
    edge_hidden   = @.hide_anchor_edges
    anchor_top    = "anchor_#{row}_0"
    anchor_bottom = "anchor_#{row}_1"
    adjustment    = @.canvas_height() / 3                   # used to center the nodes in the canvas
    area_height   = @.canvas_height() -  adjustment
    area_width    = @.canvas_width() -  @.canvas_width()  / @.row_count


    edge_1_length = area_height * (    col) / 7
    edge_2_length = area_height * (8 - col) / 7

    node_x        = area_width * row / @.row_count           # adjust this so that there is less movement
    node_y        = edge_1_length                            #

    api_visjs.add_node( { id: node_id  , label: node_label  , shape: node_shape     , color: node_color , mass  : node_mass , font  : node_font     , size  : node_size   , x     : node_x      , y     : node_y      })
    api_visjs.add_edge( { id: edge_1_id, label: edge_1_label, from : anchor_top     , to   : node_id    , color: edge_color , length: edge_1_length , hidden: edge_hidden , dashes: edge_dashes })
    api_visjs.add_edge( { id: edge_2_id, label: edge_2_label, from : anchor_bottom  , to   : node_id    , color: edge_color , length: edge_2_length , hidden: edge_hidden , dashes: edge_dashes })

    #api_visjs.add_edge( { from: 'a', to: '1', smooth:false , length:200   , _hidden: true, dashes: true, color: {color: '#F0C0C0', _inherit : false} } )
    #api_visjs.add_edge( { from: '3', to: 'a', smooth:false , length:100   , _hidden: true, dashes: true, color: {color: '#F0C0C0'} })


  add_top_and_bottom_anchor_nodes: () ->
    split_x        = (@.canvas_width() - @.canvas_border() * 2) / @.row_count
    split_x_offset = split_x / 2
    split_y        = @.canvas_height() - @.canvas_border() * 2
    node_color     = 'black'
    node_hidden    = @.hide_anchor_edges
    node_fixed     = true
    node_font      = size: 1
    node_label     = ' '
    node_shape     = 'circle'

    for i in [1..@.row_count]           # number of anchors to add
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
                #mass   : 0.1            # repulsion of the the anchor nodes
        api_visjs.add_node node

  draw_static_elements: ()=>
      #@.draw().rectangle(0 ,0 , @.canvas_width() - @.canvas_border() * 2 , @.canvas_height() - @.canvas_border() * 2)
      @.draw().arrow(0,0,0,@.canvas_height() - @.canvas_border() * 2 )
      @.draw().arrow(@.canvas_width() - @.canvas_border() * 2 , @.canvas_height() - @.canvas_border() * 2, 0,@.canvas_height() - @.canvas_border() * 2)
      @.draw().font(20).text_vertical("Value Chain", 0, @.canvas_height() / 2 )
      @.draw().font(14).text_vertical("Visible"    , 0, @.canvas_height() / 8 )
      @.draw().font(14).text_vertical("Invisible"  , 0, @.canvas_height() / 1.3  )

      @.on_AfterDrawing?()      # callback event to allow the script to add more elements to the canvas (that will be redrawn every time)

  move_canvas: ()=>
    @.move_to(0,0, - @.canvas_width() / 2 + @.canvas_border(), - @.canvas_height() / 2 + @.canvas_border() , 1.0)

  setup: ()=>
    @.move_canvas()
    @.set_Options()
    @.add_top_and_bottom_anchor_nodes()
    network.on "afterDrawing",  () => @.draw_static_elements() # setup hook to add static elements to UI after each drawing event
    #network.on 'startStabilizing', (data)=>
    #network.on 'stabilized', (data)=>


    @

    #api_visjs.add_node( {id: '1', label: '1', shape: 'box'  , fixed: true , x:100, y:0 , _mass: 5})
    #api_visjs.add_node( {id: '2', label: '2', shape: 'box'  , fixed: true , x:300, y:0 })
    #api_visjs.add_node( {id: '3', label: '3', shape: 'box'  , fixed: true , x:100, y:400 })
    #api_visjs.add_node( {id: '4', label: '4', shape: 'box'  , fixed: true , x:300, y:400 })


#    @.add_component('kettle' , 1)
#    @.add_component('user'   , 3)
#    @.add_component('tea'    , 1)
#    @.add_component('water'  , 2)
#
#    @.set_edge_value('edge_1_kettle', 'length',300)
#    @.set_edge_value('edge_2_kettle', 'length',450)
#
#    @.set_edge_value('edge_1_user'  , 'length', 10)
#    @.set_edge_value('edge_2_user'  , 'length', 700)
#
#    @.add_connection('user'         , 'kettle'  )
#    @.add_connection('kettle'       , 'water')
#    @.add_connection('kettle'       , 'tea'  )



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

  set_Options:()=>
    options =
      {
        layout : {
                  randomSeed: 0                             # set this value to remove random placement of nodes (shouldn't have a big impact since most nodes should be placed in a location that is already good for them)
                 }
        physics: {
                    barnesHut: {
                        gravitationalConstant: -700         # (-2000
                        centralGravity       :  0.00        # (0.01) no central gravity since we don't need that
                        springLength         : 50           # (100) this value is also set by the anchor edges
                        springConstant       :  0.0015        # (0.08) this is how hard the spring is
                        damping              :  0.4         # (0.4
                        avoidOverlap         :  0
                    },
                    maxVelocity : 10,                       # (50) keep this low so that the nodes don'y move too far from each other
                    minVelocity : 1,                        # (0.1)
                    solver      : 'barnesHut'               #       other good option is forceAtlas2Based',
                    timestep    : 1.35,                     # (0.5) this value can be used to slow down the animation (for ex 0.015)
                    stabilization: {
                        enabled       : true,
                        iterations    : 2000,
                        updateInterval: 100
                    }

        }
        interaction: {
            dragNodes: true
            zoomView : false
            dragView : false
        }
      }
    network.setOptions(options)


window.Api_VisJs = Api_VisJs

window.api_visjs = new Api_VisJs()
#network.on 'stabilizationProgress',  (data)->
#      console.log('stabilizationProgress',data)
#      network.stopSimulation()





