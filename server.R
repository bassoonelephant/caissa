
shinyServer(function(input, output) {
  
  # Overview tab
  # output$overview_content <- renderUI({
  #   req(input$overview_sidebar)
  #   if (input$overview_sidebar == "about_tab") {
  #     tagList(
  #       h2("About"),
  #       tags$div(
  #         p("Link to dataset: https://www.kaggle.com/datasets/noobiedatascientist/lichess-september-2020-data"),
  #         p("This data is taken from over 5m games played on www.lichess.org in the month of Sep 2020.")
  #       )
  #     )
  #   } else if (input$overview_sidebar == "researchq_tab") {
  #     tagList(
  #       h2("Research Questions"),
  #       tags$div("Here are the major research questions.")
  #     )
  #   } else if (input$overview_sidebar == "faq_tab") {
  #     tagList(
  #       h2("FAQ"),
  #       tags$div("In this section, you can provide answers to frequently asked questions.")
  #     )
  #   }
  # })
  
  
  # Bad Moves Analysis
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
        title = "Bad Moves by ELO",
        x = "Elo Bin",
        y = "Bad Moves per 100 Moves"
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
  
  
  
  # -------------------------------
  
  
  # Time tab
  output$time_content <- renderUI({
    req(input$time_sidebar)
    if (input$time_sidebar == "time_mgmt_tab") {
      tagList(
        h2("Time Management by ELO"),
        radioButtons("time_type",
                     label = "Timed Move Types",
                     choices = c("Time Scramble" = "ts",
                                 "Long Moves" = "long moves"),
                     selected = "ts"
                     ),
        sliderInput("elo_range_2",
                    label = "ELO Range",
                    min = 500, 
                    max = 3500, 
                    value = c(800, 2800),
                    step = 100),
        fluidRow(
          column(8, plotOutput("timed_moves_plot"))
        )
      )
    } else if (input$time_sidebar == "num_moves_tab") {
      tagList(
        h2("Number of Moves Per Game by ELO"),
        fluidRow(
          column(6, plotlyOutput("num_moves_plot"))
        )
      )
    } else if (input$time_sidebar == "time_trouble_tab") {
      tagList(
        h2("Time Scramble Trouble"),
        tags$div("Here is an analysis of time trouble.")
      )
    } else if(input$time_sidebar == "long_think_tab") {
      tagList(
        h2("Long Think = Wrong Think?"),
        tags$div("Is the old adage true?")
      )
    }
  })
  
  
  # Time >> Time Management Analysis
  
  select_timed_moves <- reactive({
    all_timed_moves %>%
      filter(elo >= input$elo_range_2[1] &
               elo < input$elo_range_2[2] &
               time_type == input$time_type)
  })
  
  output$timed_moves_plot <- renderPlot({
    select_timed_moves() %>%
    mutate(elo_bin = cut(elo, 
                         breaks = seq(0, 4000, by = 100), 
                         include.lowest = TRUE, 
                         right = FALSE,
                         labels = paste0(seq(0, 3900, by = 100), "-", seq(100, 4000, by = 100))
    )) %>%
    group_by(player, elo_bin) %>%
    summarize(
      sum_timed_moves = sum(timed_moves, na.rm = TRUE),
      sum_player_moves = sum(player_moves, na.rm = TRUE)
    ) %>%
    mutate(error_rate = 100 * sum_timed_moves / sum_player_moves) %>%
    ggplot(aes(x = elo_bin, y = error_rate, fill = player)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(
      title = "Irregular Timed Moves by ELO Bin",
      x = "Elo Bin",
      y = "Irregular Moves per 100 Moves"
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
    })
  
  # Time >> Number of Moves Analysis
  
  output$num_moves_plot <- renderPlotly({
    sampled_timed_moves <- all_timed_moves[sample(nrow(all_timed_moves), 10000),] # sample the data for faster rendering
    
    ggplot_obj <- sampled_timed_moves %>%
      ggplot(aes(x = elo, y = player_moves)) +
      geom_hex(bins = 30) +
      geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "solid") +
      labs(title = "Moves Per Game by Player Strength - 10k Sample", x = "Player ELO", y = "Moves per Game")
    
    ggplotly(ggplot_obj) %>%
      layout(
        title = list(text = "Moves Per Game by Player Strength - 10k Sample", x=0.5, xanchor = "center")
      )
  })
  
 # Time >> Time Trouble Analysis
  
  output$ts_sum_plot <- renderPlotly({
    ggplot_obj2 <- ggplot(summary_ts, aes(x = blunder_type, y = blunder_rate)) +
      geom_bar(stat="identity",position="dodge") +
      facet_grid(~ rating_category) +
      labs(x = "Move Type", y = "Count", title = "Summary of Blunders") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(ggplot_obj2)
  })
  
})

