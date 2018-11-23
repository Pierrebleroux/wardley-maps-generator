
class Api_VisJs
  constructor: () ->
    @.answer = 42

  hello: ()->
    "hello #{@.answer}"

window.api_visjs = new Api_VisJs()

