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
      menuItem("Documentation", tabName = "documentation", icon = icon("info-circle")),
      menuItem("Bad Moves", tabName = "bad_moves", icon = icon("exclamation-triangle")),
      menuItem("Time", tabName = "time", icon = icon("clock")),
      menuItem("Openings", tabName = "openings", icon = icon("chess-board"))
    )
  ),
    
  # Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "documentation",
              fluidPage(
                tabsetPanel(
                  tabPanel("The Data",
                           h2("The Data"),
                           tags$div(style = "max-width: 800px; word-wrap: break-word;",
                                    h3("Source"),
                                    tags$div(
                                      tags$ul(
                                        tags$li("Link to dataset: ",
                                                tags$a(href="https://www.kaggle.com/datasets/noobiedatascientist/lichess-september-2020-data", "Kaggle dataset")),
                                        tags$li("This data is taken from a sample of Lichess games played during the month of September 2020.  
                                                The games were annotated by Stockfish, which is an open-source chess engine.")
                                    )),
                                    h3("Preprocessing"),
                                    tags$div(
                                      tags$ul(
                                        tags$li("Link to data preprocessing script: ",
                                                tags$a(href="https://github.com/bassoonelephant/caissa/blob/main/caissa_preproc.Rmd", "Preprocessing script")),
                                        tags$li("The original dataset comprised over 3.7m games (observations) and 40 variables.
                                                I took a subset of the data, selecting only blitz games.  Blitz games are defined as games
                                                where each player starts with between 2-10 minutes on their clock.  This new dataset
                                                comprises over 1.8m games and 40 variables."),
                                        tags$li("In addition, a custom game_id variable was created, and date/time variables were converted to appropriate formats.")
                                        )
                                      )
                                    )
                           ),
                  tabPanel("Variables",
                           h2("Variables"),
                           tags$div(style = "max-width: 800px; word-wrap: break-word;",
                                    h3("Glossary"),
                                    tags$div(
                                      tags$ul(
                                        tags$li("game_id: Custom field for Game ID (not from lichess.org or original database)"),
                                        tags$li("BlackElo: Elo rating of the player with the black pieces"),
                                        tags$li("BlackRatingDiff: Rating change (gain/loss) after game conclusion for the player with the black pieces"),
                                        tags$li("WhiteElo: Elo rating of the player with the white pieces"),
                                        tags$li("WhiteRatingDiff: Rating change (gain/loss) after game conclusion for the player with the white pieces"),
                                        tags$li("Date: Date the game was played"),
                                        tags$li("UTCTime: Time the game was played"),
                                        tags$li("Event: Event where the game was played"),
                                        tags$li("Site: URL of the game"),
                                        tags$li("ECO: Game opening (ECO notation)"),
                                        tags$li("Opening: Game opening"),
                                        tags$li("Result: Result of the game ==> 
                                                  1-0 -- White victory || 
                                                  0-1 -- Black victory || 
                                                  1/2-1/2 -- Draw || 
                                                  * -- Undecided"),
                                        tags$li("Termination: Way the game terminated ==> 
                                                  Time forfeit -- One of the players ran out of time || 
                                                  Normal -- Game terminated with check mate || 
                                                  Rules infraction -- Game terminated due to rule breaking || 
                                                  Abandoned -- Game was abandoned"),
                                        tags$li("TimeControl: Timecontrol in seconds that was used for the game (Starting time: Increment) ==>
                                                  Black_elo_category: ELO category of the player with the black pieces ||
                                                  Low rating -- Rating below 1900 ||
                                                  High rating -- Rating above 1900 and below 2400 ||
                                                  GM rating -- Rating above 2400"),
                                        tags$li("starting_time: The time in seconds that the players have available at the start of the game (taken from TimeControl); EMPTY -- Correspondence games"),
                                        tags$li("increment: Time increment in seconds that was used in the game (taken from TimeControl); EMPTY -- Correspondence games "),
                                        tags$li("Game_type: Type of game based on TimeControl ==> 
                                                  Bullet -- Starting time below 2 minutes || 
                                                  Blitz -- Starting time between 2 and 10 minutes ||
                                                  Rapid -- Starting time between 10 and 15 minutes ||
                                                  Classical -- Starting time above 15 minutes or increment 2 minutes or higher ||
                                                  Correspondence -- No time information "),
                                        tags$li("Total_moves: Total number of moves in the game"),
                                        tags$li("player_moves: Custom field for moves per player; calculated as Total_moves/2, rounded up to nearest integer; will be slightly off for odd number of Total_moves"),
                                        tags$li("Black_blunders: Number of blunders by the player with the black pieces (move annotation ?? in the PGN)"),
                                        tags$li("White_blunders: Number of blunders by the player with the white pieces (move annotation ?? in the PGN)"),
                                        tags$li("Black_mistakes: Number of mistakes by the player with the black pieces (move annotation ? in the PGN)"),
                                        tags$li("White_mistakes: Number of mistakes by the player with the white pieces (move annotation ? in the PGN) "),
                                        tags$li("Black_inaccuracies: Number of inaccuracies by the player with the black pieces (move annotation ?! in the PGN)"),
                                        tags$li("White_inaccuracies: Number of inaccuracies by the player with the white pieces (move annotation ?! in the PGN) "),
                                        tags$li("Black_inferior_moves: Black_blunders + Black_mistakes + Black_inaccuracies"),
                                        tags$li("White_inferior_moves: White_blunders + White_mistakes + White_inaccuracies "),
                                        tags$li("Black_ts_moves: Number of moves by the player with the black pieces in time scramble (remaining time less than or equal to 10% of the starting time)"),
                                        tags$li("White_ts_moves: Number of moves by the player with the white pieces in time scramble (remaining time less than or equal to 10% of the starting time)"),
                                        tags$li("Black_ts_blunders: Number of blunders by the player with the black pieces in time scramble (remaining time less than or equal to 10% of the starting time)"),
                                        tags$li("White_ts_blunders: Number of blunders by the player with the white pieces in time scramble (remaining time less than or equal to 10% of the starting time)"),
                                        tags$li("Black_ts_mistakes: Number of mistakes by the player with the black pieces in time scramble (remaining time less than or equal to 10% of the starting time)"),
                                        tags$li("White_ts_mistakes: Number of mistakes by the player with the white pieces in time scramble (remaining time less than or equal to 10% of the starting time)"),
                                        tags$li("Black_long_moves: Number of moves by the player with the black pieces that required more than 10% of the starting time"),
                                        tags$li("White_long_moves: Number of moves by the player with the white pieces that required more than 10% of the starting time"),
                                        tags$li("Black_bad_long_moves: Number of long moves by the player with the black pieces that were inferior"),
                                        tags$li("White_bad_long_moves: Number of long moves by the player with the white pieces that were inferior "),
                                        tags$li("Game_flips: Number of times in the game where the balance of the game changed"),
                                        tags$li("Game_flips_ts: Number of times in the game where the balance of the game changed and the players were in time scramble")
                                      )
                                      )
                                    )
                           ),
                  tabPanel("FAQ",
                           h2("FAQ"),  
                           tags$div(style = "max-width: 800px; word-wrap: break-word;",
                                    h3("What research questions is this data exploration designed to answer?"),
                                    tags$div(
                                      tags$ol(
                                        tags$li('How many errors do stronger players make vs. weaker players?  Does this change depending upon the severity of error?'),
                                        br(),
                                        tags$li('Do stronger players end up in time trouble more often than weaker players?  How does time trouble affect their error rate?'),
                                        br(),
                                        tags$li('Do stronger players have more "long thinks" than weaker players?  Does thinking longer on these moves affect their accuracy?'),
                                        br(),
                                        tags$li('What are the most popular openings that players choose, and how effective are they?')
                                      )
                                    )
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
                             choices = c("Blunders = a very bad move (??)" = "blunders",
                                         "Mistakes = a poor move (?)" = "mistakes",
                                         "Inaccuracies = not the best move (?!)" = "inaccuracies",
                                         "All" = "inferior"),
                             selected = "blunders"),
                sliderInput("elo_range",
                            label = "Elo Range",
                            min = 500,
                            max = 3500,
                            value = c(800, 2800),
                            step = 100),
                fluidRow(column(8, plotOutput("badmoves"))),
                p("Notes:",
                  br(),
                  "Elo is a rating system used to calculate the skill of a chess player.",
                  br(),
                  "For reference, Magnus Carlsen - the world #1 ranked player - had an Elo rating of 2852 in blitz chess as of April 2023"
                  )
                )
              ),
      tabItem(tabName = "time",
              fluidPage(
                tabsetPanel(
                  tabPanel("Time Management",
                           h2("Time Management by Player Strength"),
                           radioButtons("time_type",
                                        label = "Timed Move Types",
                                        choices = c("Time Scramble (<= 10% of starting time left)" = "ts",
                                                    "Long Moves (>= 10% of starting time used)" = "long moves"),
                                        selected = "ts"
                                        ),
                           sliderInput("elo_range_2",
                                       label = "ELO Range",
                                       min = 500,
                                       max = 3500,
                                       value = c(800, 2800),
                                       step = 100),
                           fluidRow(column(8, plotOutput("timed_moves_plot"))),
                           p("Notes:",
                             br(),
                             "Elo is a rating system used to calculate the skill of a chess player.",
                             br(),
                             "For reference, Magnus Carlsen - the world #1 ranked player - had an Elo rating of 2852 in blitz chess as of April 2023"
                             )
                           ),
                  tabPanel("Moves",
                           h2("Number of Moves Per Game by Player Strength"),
                           fluidRow(column(6, plotlyOutput("num_moves_plot"))),
                           p("Notes:",
                             br(),
                             "n = 100,000 sample",
                             br(),
                             "Elo is a rating system used to calculate the skill of a chess player.",
                             br(),
                             "For reference, Magnus Carlsen - the world #1 ranked player - had an Elo rating of 2852 in blitz chess as of April 2023"
                             )
                           ),
                  tabPanel("Time Trouble",
                           h2("Effect of Time Scrambles on Blunders"),
                           tabsetPanel(
                             tabPanel("Summary",
                                      fluidRow(column(8, plotlyOutput("ts_sum_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+ Elo, High = 1900-2400, Low = less than 1900")
                                      ),
                             tabPanel("Sample Dist",
                                      fluidRow(column(8, plotlyOutput("ts_dist_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+ Elo, High = 1900-2400, Low = less than 1900",
                                        br(),
                                        "n = 100,000 sample")
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
                                        "GM = 2400+ Elo, High = 1900-2400, Low = less than 1900")
                                      ),
                             tabPanel("Sample Dist",
                                      fluidRow(column(8, plotlyOutput("lm_dist_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+ Elo, High = 1900-2400, Low = less than 1900",
                                        br(),
                                        "n = 100,000 sample")
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
                  )
#                  ,tabPanel("Adversary")
                )
              )
      )
    )
  )
  
))
    

     