if Meteor.isClient
  Meteor.subscribe("locations")
  Meteor.subscribe("courses")
  
  Template.locations.styleIs = (style) -> Session.get("locationViewStyle") == style

  Template.locations_carousel.events = 
    "click .location-link": (e) ->
      e.preventDefault()
      $( "a.location-link" ).removeClass("selected")
      $( e.target ).parent("a").addClass("selected")
      $(" #selected-location ").html( Template.location @ )
      $(".location-image-container img").css "top", (i, old) ->
        $(@).css "top", (Math.min( 0, (200 - $(@).height())/2 ) + "px")
  
  Template.locations_carousel.locations = ->
    Locations.find({}, sort: { name: 1 })
    
  Template.locations.locations = ->
    Locations.find({}, sort: { name: 1 })
    
  Template.locations_carousel.courses = ->
    Courses.find { location_id: @id }, sort: { starts: 1 }

  Template.location.courses = ->
    Courses.find { location_id: @id }, sort: { starts: 1 }
    
  Template.location.anyCourses = ->
    Courses.find({ location_id: @id }).count() > 0

  Template.locations_carousel.rendered = ->
    $("#locations-carousel").carouFredSel(
      auto: false
      circular: false
      infinite: false
      item:
        filter: ".carousel-item"
      prev:
        button: "#locations-prev"
        key: "left"
      next:
        button: "#locations-next"
        key: "right"
      onCreate: (data) ->
        leftMargin = ( $("#nearest-locations").width() - 46 - data.width )/2
        if leftMargin > 0 then $(@).parent().css( "margin-left", leftMargin )
    )

  Template.location.rendered = ->
    $("#dhamma-name").tooltip()
