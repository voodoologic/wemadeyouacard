jQuery ->

  class window.CardView extends Backbone.View

    tagName: "li"

    model: window.Card

    initialize: ->
      _.bindAll @, 'render'
      @model.bind 'change' , @render

    render: ->
      $('ul.cards').append "<a href='cards/#{@model.id}/messages' >#{@model.get('title')}</a>"

  class window.CardsView extends CardView

    template: JST['backbone/templates/cards/cards']

    initialize: ->
      _.bindAll(@, 'render')
      @collection.bind 'reset', @render

    urlRoot: '/cards.json'

    render: ->
      $('#container').replaceWith( @$el.html(@template) )
      @collection.each (card) ->
        view = new CardView model: card
        view.render()
      @

  class window.createCardView extends Backbone.View

    template: JST['backbone/templates/cards/newCard']

    initialize: ->
      _.bindAll(@, 'render')
      alert("whoot")

    urlRoot: '/cards/new'

    render: ->
      $('#container').replaceWith( @$el.html(@template) )
