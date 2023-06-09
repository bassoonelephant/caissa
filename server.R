
shinyServer(function(input, output) {

  # ----------------------------------------------------------------------------
  # FAQ
  # ----------------------------------------------------------------------------
  
  output$elo_dist_plot <- renderPlotly({
    elo_dist_ggplot <- ggplot(elo_summary, aes(x = elo_bin, y = count_players)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = count_players), nudge_y = max(elo_summary$count_players) * 0.02, size = 2.3) +
      labs(x = "Elo Bin", y = "Number of Players", title = "Distribution of Elo Ratings") +
      scale_y_continuous(labels = scales::comma) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_text(margin = margin(t = 30)),
            plot.title = element_text(hjust = 0.5))
  
    ggplotly(elo_dist_ggplot)
  })
  
  
  
  # ----------------------------------------------------------------------------
  # Bad Moves
  # ----------------------------------------------------------------------------
  
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
        title = "Bad Moves by Elo",
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
  
  # ----------------------------------------------------------------------------
  # Time >> Time Management Analysis
  # ----------------------------------------------------------------------------
  
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
      title = "Irregular Timed Moves by Elo Bin",
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
  
  # ----------------------------------------------------------------------------
  # Time >> Number of Moves Analysis
  # ----------------------------------------------------------------------------
  
  output$num_moves_plot <- renderPlotly({
    sampled_timed_moves <- all_timed_moves[sample(nrow(all_timed_moves), 1e5),] # sample the data for faster rendering
    
    ggplot_obj <- sampled_timed_moves %>%
      ggplot(aes(x = elo, y = player_moves)) +
      geom_hex(bins = 30) +
      geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "solid") +
      labs(title = "Moves Per Game by Player Strength", x = "Player Elo", y = "Moves per Game")
    
    ggplotly(ggplot_obj) %>%
      layout(
        title = list(text = "Moves Per Game by Player Strength", x=0.5, xanchor = "center")
      )
  })
  
  # ----------------------------------------------------------------------------
  # Time >> Time Trouble Analysis
  # ----------------------------------------------------------------------------  
  
  output$ts_sum_plot <- renderPlotly({
    ggplot_obj2 <- ggplot(summary_ts, aes(x = blunder_type, y = blunder_rate * 100, fill = blunder_type)) +
      geom_bar(stat="identity",position="dodge") +
      facet_grid(~ rating_category) +
      scale_fill_brewer(palette = "Set2") +
      scale_x_discrete(labels = c("reg_blunder_rate" = "regular", "all_blunder_rate" = "all moves", "ts_blunder_rate" = "time scramble")) +
      labs(x = "Move Type", y = "Blunders Per 100 Moves", title = "Summary of Blunder Rates by Time Condition and Player Strength") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_text(margin = margin(t=30)),
            plot.title = element_text(hjust = 0.5),
            legend.position = "none")
    
    ggplotly(ggplot_obj2, tooltip = c('x', 'y'))
  })
  
  output$ts_dist_plot <- renderPlotly({
    sampled_ts <- dist_ts[sample(nrow(dist_ts), 100000), ]
    
    ggplot_obj3 = ggplot(sampled_ts, aes(x = blunder_type , y = blunder_rate * 100, fill = blunder_type)) +
      geom_boxplot() +
      facet_grid(~ rating_category) +
      scale_fill_brewer(palette = "Set2") +
      scale_x_discrete(labels = c("all_blunder_rate" = "all moves", "ts_blunder_rate" = "time scramble")) +
      labs(x = "Move Type", y = "Blunders Per Game Per 100 Moves", title = "Distribution of Blunder Rates by Time Condition and Player Strength") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_text(margin = margin(t=30)),
            plot.title = element_text(hjust = 0.5),
            legend.position = "none")
    
    ggplotly(ggplot_obj3, tooltip = c('x', 'y'))
  })
  
    # ----------------------------------------------------------------------------
    # Time >> Long Move Analysis
    # ----------------------------------------------------------------------------
  
    output$lm_sum_plot <- renderPlotly({
    summary_lm <- summary_lm %>%
      mutate(inferior_move_type = factor(inferior_move_type, levels = c("all_inf_move_rate", "inf_reg_move_rate", "inf_long_move_rate")))
    
    ggplot_obj4 <- ggplot(summary_lm, aes(x = inferior_move_type, y = inferior_move_rate * 100, fill = inferior_move_type)) +
      geom_bar(stat="identity", position="dodge") +
      facet_grid(~ rating_category) +
      scale_fill_brewer(palette = "Set2") +
      scale_x_discrete(labels = c("all_inf_move_rate" = "all moves", "inf_reg_move_rate" = "regular moves", "inf_long_move_rate" = "long moves")) +
      labs(x = "Move Type", y = "Inferior Moves Per 100 Moves", title = "Summary of Inferior Move Rates by Long Moves and Player Strength") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_text(margin = margin(t=30)),
            plot.title = element_text(hjust = 0.5),
            legend.position = "none")
    
    ggplotly(ggplot_obj4, tooltip = c('x', 'y'))
    })
  
    output$lm_dist_plot <- renderPlotly({
      sampled_lm <- dist_lm[sample(nrow(dist_lm), 1e5), ] # sample the data for faster rendering
    
    ggplot_obj5 <- ggplot(sampled_lm, aes(x = inferior_move_type, y = inferior_move_rate * 100, fill = inferior_move_type)) +
      geom_boxplot() +
      facet_grid(~ rating_category) +
      scale_fill_brewer(palette = "Set2") +
      scale_x_discrete(labels = c("all_inf_move_rate" = "all moves", "inf_long_move_rate" = "long moves")) +
      labs(x = "Move Type", y = "Inferior Moves Per Game Per 100 Moves", title = "Distribution of Inferior Move Rates by Long Moves and Player Strength") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_text(margin = margin(t=30)),
            plot.title = element_text(hjust = 0.5),
            legend.position = "none")
    
    ggplotly(ggplot_obj5, tooltip = c('x', 'y'))
    })
  
    # ----------------------------------------------------------------------------
    # Openings >> Ranking
    # ----------------------------------------------------------------------------
  
    filtered_openings <- reactive({
      req(input$min_games)
      openings_data_agg %>% filter(`Total Games` >= input$min_games)
    })  
    
    output$openings_table <- renderDT({
      table <- datatable(filtered_openings(),
                options = list(
                  pageLength = 20,
                  autoWidth = TRUE,
                  order = list(list(3, 'desc'))
                  )
      )
    
    ## Format columns as percentages
    table <- table %>% formatPercentage(c("White Win Rate", "Black Win Rate", "Draw Rate", "Frequency %"), 2)

    # Increase the width of the Opening column
    table <- table %>% formatStyle(columns = "Opening", width = "250px")
    
    table
    })
  
    # ----------------------------------------------------------------------------
    # Openings >> ECO Word Cloud
    # ----------------------------------------------------------------------------
  
    top_eco_codes <- reactive({
      eco_count %>% 
        arrange(desc(freq)) %>%
        head(input$n)
    })
  
    output$eco_wordcloud <- renderWordcloud2({
      req(top_eco_codes())
      wc_data <- data.frame(word = top_eco_codes()$ECO, freq = top_eco_codes()$freq)
      wordcloud2(data = wc_data, size = 0.5)
    })
  
    output$eco_table <- renderTable({
      req(input$search_eco)
    
      selected_eco <- input$search_eco
      associated_openings <- openings_data %>% filter(ECO == selected_eco) %>%
        distinct(Opening)
    
      associated_openings
    })
  
})

