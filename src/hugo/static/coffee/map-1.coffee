

class Maps extends window.Api_VisJs
  create_map_1: ()->
    @.add_component('user  aaa'       )
    @.add_component('kettle'     , 3 ,1)
    @.add_component('tea'        , 1, 0)
    @.add_component('electricity', 1, 4)
    @.add_component('water'      , 1, 5)
    @.add_component('A'          , 2, 6)
    @.add_component('B'          , 3, 7)
    @.add_component('C'          , 4, 8)
    @.add_component('D'          , 4, 2)

    #@.set_edge_value('edge_1_kettle', 'length',300)
    #@.set_edge_value('edge_2_kettle', 'length',450)

    #@.set_edge_value('edge_1_user'  , 'length', 10)
    #@.set_edge_value('edge_2_user'  , 'length', 700)

    #@.add_connection('user'         , 'kettle'  )
    #@.add_connection('kettle'       , 'water'   )
    #@.add_connection('kettle'       , 'tea'     , 300)

new Maps().setup().create_map_1()
