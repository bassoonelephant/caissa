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
      menuItem("Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("Bad Moves", tabName = "bad_moves", icon = icon("exclamation-triangle")),
      menuItem("Time", tabName = "time", icon = icon("clock")),
      menuItem("Openings", tabName = "openings", icon = icon("chess-board"))
    )
  ),
    
  # Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              fluidPage(
                tabsetPanel(
                  tabPanel("The Data",
                           h2("The Data"),
                           tags$div(style = "max-width: 800px; word-wrap: break-word;",
                                    tags$div(
                                      h3("Source"),
                                      p("This data is taken from a sample of Lichess games played during the month of September 2020.  
                                        The games were annotated by Stockfish, which is an open-source chess engine."),
                                      p("Link to dataset: https://www.kaggle.com/datasets/noobiedatascientist/lichess-september-2020-data")
                                    ),
                                    tags$div(
                                      h3("Dimensions"),
                                      p("The original dataset comprises over 3.7m games (observations) and 40 variables.
                                        I took a subset of the data, selecting only blitz games.  Blitz games are defined as games
                                        where each player starts with between 2-10 minutes on their clock.  This new dataset
                                        comprises over 1.8m games and 40 variables.")
                                    ),
                                    tags$div(
                                      h3("Variables"),
                                      p("GAME: Game ID (not from lichess.org)"),
                                      p("BlackElo: Elo rating of the player with the black pieces"),
                                      p("BlackRatingDiff: Rating change (gain/loss) after game conclusion for the player with the black pieces"),
                                      p("WhiteElo: Elo rating of the player with the white pieces"),
                                      p("WhiteRatingDiff: Rating change (gain/loss) after game conclusion for the player with the white pieces"),
                                      p("Date: Date the game was played"),
                                      p("UTCTime: Time the game was played"),
                                      p("Event: Event where the game was played"),
                                      p("Site: URL of the game "),
                                      p("ECO: Game opening (ECO notation)"),
                                      p("Opening: Game opening"),
                                      p("Result: Result of the game (1-0 -- White victory || 0-1 -- Black victory || 1/2-1/2 -- Draw || * -- Undecided)"),
                                      p("Termination: Way the game terminated (Time forfeit -- One of the players ran out of time || 
                                        Normal -- Game terminated with check mate || 
                                        Rules infraction -- Game terminated due to rule breaking || 
                                        Abandoned -- Game was abandoned"),
                                      p("TimeControl: Timecontrol in seconds that was used for the game (Starting time: Increment)"),
                                      p("           Black_elo_category: ELO category of the player with the black pieces
                                          	Low rating -- Rating below 1900
                                          	High rating -- Rating above 1900 and below 2400
                                          	GM rating -- Rating above 2400"),
                                      p("          starting_time: The time in seconds that the players have available at the start of the game (taken from TimeControl)
                                          	EMPTY -- Correspondence games"),
                                    
                                      p(" increment: Time increment in seconds that was used in the game (taken from TimeControl)
                                          	EMPTY -- Correspondence games ")   ,
                                      
                                      
                                      p("      Game_type: Type of game based on TimeControl
                                          	Bullet -- Starting time below 2 minutes
                                          	Blitz -- Starting time between 2 and 10 minutes
                                          	Rapid -- Starting time between 10 and 15 minutes
                                          	Classical -- Starting time above 15 minutes or increment 2 minutes or higher
                                          	Correspondence -- No time information "),
                                      
                                      
                                      
                                      p("    Total_moves: Total number of moves in the game
                                        "),
                                      
                                      
                                      p("       Black_blunders: Number of blunders by the player with the black pieces (move annotation ?? in the PGN)
                                        "),
                                          
                                         p("

                                   
                                          White_blunders: Number of blunders by the player with the white pieces (move annotation ?? in the PGN)
                                          
                                          Black_mistakes: Number of mistakes by the player with the black pieces (move annotation ? in the PGN)
                                          
                                          White_mistakes: Number of mistakes by the player with the white pieces (move annotation ? in the PGN)
                                          
                                          Black_inaccuracies: Number of inaccuracies by the player with the black pieces (move annotation ?! in the PGN)
                                          
                                          White_inaccuracies: Number of inaccuracies by the player with the white pieces (move annotation ?! in the PGN)
                                          
                                          
                                          
                                          
                                          Black_inferior_moves: Black_blunders + Black_mistakes + Black_inaccuracies 
                                          White_inferior_moves: White_blunders + White_mistakes + White_inaccuracies
                                          Black_ts_moves: Number of moves by the player with the black pieces in time scramble (remaining time less than or equal to 10% of the starting time)
                                          White_ts_moves: Number of moves by the player with the white pieces in time scramble (remaining time less than or equal to 10% of the starting time)
                                          Black_ts_blunders: Number of blunders by the player with the black pieces in time scramble (remaining time less than or equal to 10% of the starting time)
                                          White_ts_blunders: Number of blunders by the player with the white pieces in time scramble (remaining time less than or equal to 10% of the starting time)
                                          Black_ts_mistakes: Number of mistakes by the player with the black pieces in time scramble (remaining time less than or equal to 10% of the starting time)
                                          White_ts_mistakes: Number of mistakes by the player with the white pieces in time scramble (remaining time less than or equal to 10% of the starting time)
                                          Black_long_moves: Number of moves by the player with the black pieces that required more than 10% of the starting time
                                          White_long_moves: Number of moves by the player with the white pieces that required more than 10% of the starting time
                                          Black_bad_long_moves: Number of long moves by the player with the black pieces that were inferior
                                          White_bad_long_moves: Number of long moves by the player with the white pieces that were inferior 
                                          Game_flips: Number of times in the game where the balance of the game changed
                                          Game_flips_ts: Number of times in the game where the balance of the game changed and the players were in time scramble"
                                        )
                                    )
                             )
                           ),
                  tabPanel("FAQ",
                           h2("FAQ")
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
                           fluidRow(column(6, plotlyOutput("num_moves_plot"))),
                           p("Notes:",
                             br(),
                             "n = 10,000 sample")
                           ),
                  tabPanel("Time Trouble",
                           h2("Effect of Time Scrambles on Blunders"),
                           tabsetPanel(
                             tabPanel("Summary",
                                      fluidRow(column(8, plotlyOutput("ts_sum_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+, High = 1900-2400, Low = less than 1900")
                                      ),
                             tabPanel("Distribution",
                                      fluidRow(column(8, plotlyOutput("ts_dist_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+, High = 1900-2400, Low = less than 1900",
                                        br(),
                                        "n = 10,000 sample")
                                      )
                             )
                           ),
                  tabPanel("Long Thinks",
                           h2("Effect of Long Moves on Inferior Moves"),
                           tabsetPanel(
                             tabPanel("Summary",
                                      fluidRow(column(8, plotlyOutput("lm_sum_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+, High = 1900-2400, Low = less than 1900")
                                      ),
                             tabPanel("Distribution",
                                      fluidRow(column(8, plotlyOutput("lm_dist_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+, High = 1900-2400, Low = less than 1900",
                                        br(),
                                        "n = 10,000 sample")
                                      )
                                    )
                           )
                  )
                )
              ),
      tabItem(tabName = "openings",
              fluidPage(
                tabsetPanel(
                  tabPanel("Ranking",
                           h2("Interactive Openings Data Table"),
                           fluidRow(column(8, DTOutput("openings_table")))
                  ),
                  tabPanel("ECO Cloud",
                           h2("ECO Code Popularity"),
                           sliderInput("n", "Top N Eco Codes", min = 1, max = 50, value = 20),
                           fluidRow(column(7, wordcloud2Output("eco_wordcloud"))),
                           br(),
                           textInput("search_eco", "Search for ECO code:"),
                           tableOutput("eco_table")
                  ),
                  tabPanel("Adversary")
                )
              )
      )
    )
  )
  
))
    

     