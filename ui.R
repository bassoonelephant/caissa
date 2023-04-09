shinyUI(dashboardPage(
  # Color Scheme
  skin = "purple",
  
  # Header
  dashboardHeader(title = "Lichess Blitz Games"),
  
  # Sidebar
  dashboardSidebar(
    tags$style(
      HTML(
      ".skin-purple .main-sidebar .sidebar .sidebar-menu .active a {
      background-color: #9370DB;
      color: white;
      }
      .skin-purple .sidebar-menu .active > a:hover {
      background-color: #0056b3;
      color: white;
      }")
      ),
    sidebarUserPanel("Data Explorer v1.0",
                     image = "chess_cyber.jpg"),
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("info")),
      menuItem("Bad Moves", tabName = "bad_moves"),
      menuItem("Time", tabName = "time"),
      menuItem("Openings", tabName = "openings")
    )
  ),
    
  # Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              fluidPage(
                tabsetPanel(
                  tabPanel("About",
                           h2("About"),
                           p("Content for About")
                           ),
                  tabPanel("The Data",
                           h2("The Data"),
                           tags$div(
                             p("Link to dataset: https://www.kaggle.com/datasets/noobiedatascientist/lichess-september-2020-data"),
                             p("This data is taken from over 5m games played on www.lichess.org in the month of Sep 2020.")
                             )
                           )
                  )
                )
              ),
      tabItem(tabName = "bad_moves",
              fluidPage(
                h2("Bad Moves by Player Strength"),
                radioButtons("bad_move_types",
                             label = "Bad Move Types",
                             choices = c("Blunders" = "blunders",
                                         "Mistakes" = "mistakes",
                                         "Inaccuracies" = "inaccuracies",
                                         "All" = "inferior"),
                             selected = "blunders"),
                sliderInput("elo_range",
                            label = "ELO Range",
                            min = 500,
                            max = 3500,
                            value = c(800, 2800),
                            step = 100),
                fluidRow(column(8, plotOutput("badmoves")))
                )
              ),
      tabItem(tabName = "time",
              fluidPage(
                tabsetPanel(
                  tabPanel("Time Management",
                           h2("Time Management by Player Strength"),
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
                           fluidRow(column(8, plotOutput("timed_moves_plot")))
                           ),
                  tabPanel("Moves",
                           h2("Number of Moves Per Game by Player Strength"),
                           fluidRow(column(6, plotlyOutput("num_moves_plot")))
                           ),
                  tabPanel("Time Trouble",
                           h2("Effect of Time Scrambles on Blunders"),
                           tabsetPanel(
                             tabPanel("Summary",
                                      h4("Summary"),
                                      fluidRow(column(8, plotlyOutput("ts_sum_plot")))
                                      ),
                             tabPanel("Distribution",
                                      h4("Content")
                                      )
                             )
                           ),
                  tabPanel("Long Thinks")
                  )
                )
              ),
      tabItem(tabName = "openings",
              fluidPage(
                h2("Openings")
                )
              )
      )
  )
  
))
    

                      
      # output$time_content <- renderUI({
      #   req(input$time_sidebar)
      #   if (input$time_sidebar == "time_mgmt_tab") {
      #     tagList(
      #       h2("Time Management by ELO"),
      #       radioButtons("time_type",
      #                    label = "Timed Move Types",
      #                    choices = c("Time Scramble" = "ts",
      #                                "Long Moves" = "long moves"),
      #                    selected = "ts"
      #       ),
      #       sliderInput("elo_range_2",
      #                   label = "ELO Range",
      #                   min = 500, 
      #                   max = 3500, 
      #                   value = c(800, 2800),
      #                   step = 100),
      #       fluidRow(
      #         column(8, plotOutput("timed_moves_plot"))
      #       )
      #     )
      #   } else if (input$time_sidebar == "num_moves_tab") {
      #     tagList(
      #       h2("Number of Moves Per Game by ELO"),
      #       fluidRow(
      #         column(6, plotlyOutput("num_moves_plot"))
      #       )
      #     )
      #   } else if (input$time_sidebar == "time_trouble_tab") {
      #     tagList(
      #       h2("Time Scramble Trouble"),
      #       tags$div("Here is an analysis of time trouble.")
      #     )
      #   } else if(input$time_sidebar == "long_think_tab") {
      #     tagList(
      #       h2("Long Think = Wrong Think?"),
      #       tags$div("Is the old adage true?")
      #     )
      #   }
      # })      
      # 
      # 
      # 
      
      
      
      
      
      
      
      
  
  
  
  # # Sidebar
  # dashboardSidebar(
  #   tags$style(HTML
  #   ("
  #   .skin-purple .main-sidebar .sidebar .sidebar-menu .active a {
  #   background-color: #9370DB;
  #   color: white;
  #   }
  #   .skin-purple .sidebar-menu .active > a:hover {
  #   background-color: #0056b3;
  #   color: white;
  #   }
  #     ")),
  #   sidebarUserPanel("Data Explorer v1.0",
  #                    image = "chess_cyber.jpg"),
  #   conditionalPanel(
  #       condition = "input.tabs == 'overview'",
  #       sidebarMenu(id = "overview_sidebar",
  #                 menuItem("About", tabName = "about_tab"),
  #                 menuItem("Research Questions", tabName = "researchq_tab"),
  #                 menuItem("FAQ", tabName = "faq_tab")
  #                 )
  #     ),
  #   conditionalPanel(
  #     condition = "input.tabs == 'time'",
  #     sidebarMenu(id = "time_sidebar",
  #                 menuItem("Time Management", tabName = "time_mgmt_tab"),
  #                 menuItem("Number of Moves", tabName = "num_moves_tab"),
  #                 menuItem("Time Scramble Trouble", tabName = "time_trouble_tab"),
  #                 menuItem("Long Thinks", tabName = "long_think_tab")
  #                 )
  #   )
  # ),
  
  # Body
#   dashboardBody(
#     tabsetPanel(id = "tabs", 
#                 tabPanel("Overview", 
#                          value = "overview",
#                          uiOutput("overview_content")
#                          ),
#                 tabPanel("Bad Moves", value = "bad_moves",
#                          h2("Bad Moves by Player Strength"),
#                          radioButtons("bad_move_types",
#                                       label = "Bad Move Types",
#                                       choices = c("Blunders" = "blunders",
#                                                   "Mistakes" = "mistakes",
#                                                   "Inaccuracies" = "inaccuracies",
#                                                   "All" = "inferior"),
#                                             selected = "blunders"),
#                          sliderInput("elo_range",
#                                      label = "ELO Range",
#                                      min = 500, 
#                                      max = 3500, 
#                                      value = c(800, 2800),
#                                      step = 100
#                                      ),
#                          fluidRow(
#                            column(8, plotOutput("badmoves"))
#                          )),
#                 tabPanel("Time",
#                          value = "time",
#                          uiOutput("time_content")
#                          ),
#                 tabPanel("Openings",
#                          fluidRow(
#                            column(12, tags$div("Opening Analysis Plot placeholder"))
#                          ))
#     )
#   )
# )



