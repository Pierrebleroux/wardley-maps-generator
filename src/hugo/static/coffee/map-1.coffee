

class Maps extends window.Api_VisJs

  create_map_for_tea: ()->
    @.add_component('Business'   , 3, 1)
    @.add_component('Public'     , 3, 1)
    @.add_component('Cup of Tea' , 3, 2)
    @.add_component('Cup'        , 4, 3)
    @.add_component('Tea'        , 4, 4)
    @.add_component('Hot Water'  , 4, 5)
    @.add_component('Water'      , 4, 6)
    @.add_component('Kettle'     , 1, 6)
    @.add_component('Power'      , 4, 7)

    @.add_connection('Business'   , 'Cup of Tea')
    @.add_connection('Public'     , 'Cup of Tea')
    @.add_connection('Cup of Tea' , 'Cup'       )
    @.add_connection('Cup of Tea' , 'Tea'       )
    @.add_connection('Cup of Tea' , 'Hot Water' )
    @.add_connection('Hot Water'  , 'Water'     )
    @.add_connection('Hot Water'  , 'Kettle'    )
    @.add_connection('Kettle'     , 'Power'     )

    @.node_fixed_x_y('Business', 350,50)
    @.node_fixed_x_y('Public'  , 450,50)

    @.on_AfterDrawing = ()=>
      @.draw().box(300,30,200,70,20)
      @.draw().text("Anchor", 190,50)








  create_map_test_nodes: ()->
    @.add_component('A (1,1)' , 1 ,1)
    @.add_component('B (1,2)' , 4, 8)
    @.add_component('C (2,3)' )
    @.add_component('D (2,4)' )
    @.add_component('E (3,5)' )
    @.add_component('F (3,6)' )
    @.add_component('G (4,7)' )
    @.add_component('H (4,8)' )

    @.add_connection('A (1,1)', 'B (1,2)')
    @.add_connection('A (1,1)', 'C (2,3)')
    @.add_connection('A (1,1)', 'D (2,4)')
    @.add_connection('A (1,1)', 'E (3,5)')
    @.add_connection('A (1,1)', 'F (3,6)')
    @.add_connection('A (1,1)', 'G (4,7)')
    @.add_connection('A (1,1)', 'H (4,8)')
    @.node_fixed_x_y('A (1,1)', 300,50)

#    @.add_connection('A (1,1)', 'B (1,2)')
#    @.add_connection('B (1,2)', 'C (2,3)')
#    @.add_connection('C (2,3)', 'D (2,4)')
#    @.add_connection('D (2,4)', 'E (3,5)')
#    @.add_connection('E (3,5)', 'F (3,6)')
#    @.add_connection('F (3,6)', 'G (4,7)')
#    @.add_connection('G (4,7)', 'H (4,8)')
#    @.node_fixed_x_y('A (1,1)', 300,20)
#    @.node_fixed_x_y('H (4,8)', 540,670)






new Maps().setup()
          #.physics_off()
          .create_map_for_tea()
          #.create_map_test_nodes()

#new Maps().setup().create_map_1()
