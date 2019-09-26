easylayout <- function(graph){
  graph_json <- jsonlite::toJSON(list(
     nodes = igraph::as_data_frame(graph, "vertices")
    ,links = igraph::as_data_frame(graph, "edges"))
  )

  server <- function(input, output, session) {
    session$sendCustomMessage(type = "dataTransferredFromServer", graph_json)

    shiny::observeEvent(input$coordinates, {
      if(!is.null(input$coordinates)) shiny::stopApp(input$coordinates)
    })
  }

  shiny::addResourcePath('vivagraph.min.js', 'inst/www/vivagraph.min.js')
  shiny::addResourcePath('multiselect.js', 'inst/www/multiselect.js')
  shiny::addResourcePath('index.js', 'inst/www/index.js')

  layout <- shiny::runGadget(shiny::shinyApp(ui = shiny::htmlTemplate("inst/www/index.html"), server))

  matrix(layout, ncol=2,byrow=T)
}