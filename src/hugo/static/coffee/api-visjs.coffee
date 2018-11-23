
class Api_VisJs
  constructor: () ->
    @.answer = 42

  add_node: (node)->
    network.body.data.nodes.add(node)

  add_edge: (edge)->
    network.body.data.edges.add(edge)

  edges: ()->
    return network.body.data.edges._data

  nodes: ()->
    return network.body.data.nodes._data

  remove_node: (id)->
    network.body.data.nodes.remove(id)

console.log 'in api_visjs coffee....'
window.api_visjs = new Api_VisJs()

