
shinyServer(function(input, output) {
  
  output$overview_content <- renderUI({
    req(input$overview_sidebar)
    if (input$overview_sidebar == "data_tab") {
      tagList(
        h2("The Data"),
        tags$div("Here, you can write a brief summary of the dataset.")
      )
    } else if (input$overview_sidebar == "researchq_tab") {
      tagList(
        h2("Research Questions"),
        tags$div("Here are the major research questions.")
      )
    } else if (input$overview_sidebar == "faq_tab") {
      tagList(
        h2("FAQ"),
        tags$div("In this section, you can provide answers to frequently asked questions.")
      )
    }
  })
  
  
  
})
