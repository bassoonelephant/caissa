
shinyServer(function(input, output) {
  
  # Overview tab
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
  
  # Bad Moves tab
  select_bad_moves <- reactive({
    all_bad_moves %>%
        filter(elo >= input$elo_range[1] & 
                 elo < input$elo_range[2] & 
                 error_type == input$bad_move_types)
  })
  
  output$badmoves <- renderPlot(
    select_bad_moves() %>%
      mutate(elo_bin = cut(elo, 
                           breaks = seq(0, 4000, by = 100), 
                           include.lowest = TRUE, 
                           right = FALSE,
                           labels = paste0(seq(0, 3900, by = 100), "-", seq(100, 4000, by = 100))
      )) %>%
      group_by(player, elo_bin) %>%
      summarize(
        sum_num_errors = sum(errors, na.rm = TRUE),
        sum_player_moves = sum(player_moves, na.rm = TRUE)
      ) %>%
      mutate(error_rate = 100 * sum_num_errors / sum_player_moves) %>%
      ggplot(aes(x = elo_bin, y = error_rate, fill = player)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(
        title = "Error Rate by ELO Bin",
        x = "Elo Bin",
        y = "Error Rate per 100 Moves"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        axis.title.x = element_text(size = 14, face = "bold"),
        axis.title.y = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.title = element_text(size = 14, face = "bold"),
        legend.text = element_text(size = 12)
      )
  )
  
  # Time tab
  output$time_content <- renderUI({
    req(input$time_sidebar)
    if (input$time_sidebar == "time_mgmt_tab") {
      tagList(
        h2("Time Management"),
        tags$div("Here, you can find an analysis of time management by ELO.")
      )
    } else if (input$time_sidebar == "time_trouble_tab") {
      tagList(
        h2("Time Trouble"),
        tags$div("Here is an analysis of time trouble.")
      )
    }
  })
  
})



# if (input$time_sidebar == "time_mgmt_tab") {
#   tagList(
#     h2("Time Management"),
#     tags$div("Here, you can find an analysis of time management by ELO."),
#     sliderInput("elo_range",
#                 label = "ELO Range",
#                 min = 500, 
#                 max = 3500, 
#                 value = c(1500, 2500),
#                 step = 100),
#     radioButtons("bad_move_types",
#                  label = "Bad Move Types",
#                  choices = c("Inaccuracies" = "inaccuracies",
#                              "Mistakes" = "mistakes",
#                              "Blunders" = "blunders",
#                              "All" = "all bad"),
#                  selected = "all bad"),
#     plotOutput("badmoves")
#   )
# }
