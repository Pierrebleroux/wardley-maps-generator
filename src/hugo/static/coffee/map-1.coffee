

class Maps extends window.Api_VisJs
  create_map_1: ()->    
    @.add_component('kettle' , 1)
    @.add_component('user'   , 3)
    @.add_component('tea'    , 1)
    @.add_component('water'  , 2)

    #@.set_edge_value('edge_1_kettle', 'length',300)
    #@.set_edge_value('edge_2_kettle', 'length',450)

    #@.set_edge_value('edge_1_user'  , 'length', 10)
    #@.set_edge_value('edge_2_user'  , 'length', 700)

    @.add_connection('user'         , 'kettle'  )
    @.add_connection('kettle'       , 'water')
    @.add_connection('kettle'       , 'tea'  )


new Maps().create_map_1()
