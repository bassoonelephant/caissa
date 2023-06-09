# SETUP

## 1. Load Libraries

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinythemes)
library(shinydashboard)
library(hexbin)
library(plotly)
library(RColorBrewer)
library(DT)
library(wordcloud2)

## 2. Load Processed Dataset ===

blitz <- readRDS(file = "./data/blitzgames_processed.rds")


# ------------------------------------------------------------------------------------------------------

# FAQ

## 1. Elo Distribution Data

### A. Set up Elo dataframe
elo_analysis <- blitz %>% 
  select(game_id, BlackElo, WhiteElo) %>%
  pivot_longer(cols = c("BlackElo", "WhiteElo"),
               names_to = "player_color",
               values_to = "elo") %>%
  mutate(player_color = ifelse(player_color == "BlackElo", "Black", "White")) %>%
  select(game_id, player_color, elo)

### B. Discretize Elo data
elo_summary <- elo_analysis %>%
  mutate(elo_bin = cut(elo,
                       breaks = seq (0, 4000, by = 100),
                       include.lowest = TRUE,
                       right = FALSE,
                       labels = paste0(seq(0, 3900, by = 100), "-", seq(100, 4000, by = 100))
  )
  ) %>%
  group_by(elo_bin) %>%
  summarize(
    count_players = n()
  )


# ------------------------------------------------------------------------------------------------------

# BAD MOVES

## 1. Data Manipulation for Bad Moves Analysis

### A. Select needed columns
bad_move_data <- blitz %>% 
  select(game_id, 
         Result, 
         BlackElo, 
         WhiteElo, 
         Black_blunders, 
         White_blunders, 
         Black_mistakes, 
         White_mistakes, 
         Black_inaccuracies,
         White_inaccuracies, 
         Black_inferior_moves, 
         White_inferior_moves,
         Total_moves,
         player_moves)

### B. Set up error dataframes

all_bad_moves <- bad_move_data %>%  # add blunders
  select(game_id, WhiteElo, BlackElo, player_moves, White_blunders, Black_blunders) %>%
  pivot_longer(cols = c("WhiteElo", "BlackElo"),
               names_to = "player",
               values_to = "elo"
               ) %>%
  mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
  mutate(errors = ifelse(player == "White", White_blunders, Black_blunders)) %>%
  mutate(error_type = "blunders") %>%
  select(game_id, player, elo, error_type, errors, player_moves)

all_bad_moves <- all_bad_moves %>%  # add mistakes
  bind_rows(bad_move_data %>%
              select(game_id, WhiteElo, BlackElo, player_moves, White_mistakes, Black_mistakes) %>%
              pivot_longer(cols = c("WhiteElo", "BlackElo"),
                           names_to = "player",
                           values_to = "elo"
              ) %>%
              mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
              mutate(errors = ifelse(player == "White", White_mistakes, Black_mistakes)) %>%
              mutate(error_type = "mistakes") %>%
              select(game_id, player, elo, error_type, errors, player_moves)
  )

all_bad_moves <- all_bad_moves %>%  # add inaccuracies
  bind_rows(bad_move_data %>%
              select(game_id, WhiteElo, BlackElo, player_moves, White_inaccuracies, Black_inaccuracies) %>%
              pivot_longer(cols = c("WhiteElo", "BlackElo"),
                           names_to = "player",
                           values_to = "elo"
              ) %>%
              mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
              mutate(errors = ifelse(player == "White", White_inaccuracies, Black_inaccuracies)) %>%
              mutate(error_type = "inaccuracies") %>%
              select(game_id, player, elo, error_type, errors, player_moves)
  )

all_bad_moves <- all_bad_moves %>%  # add inferior moves
  bind_rows(bad_move_data %>%
              select(game_id, WhiteElo, BlackElo, player_moves, White_inferior_moves, Black_inferior_moves) %>%
              pivot_longer(cols = c("WhiteElo", "BlackElo"),
                           names_to = "player",
                           values_to = "elo"
              ) %>%
              mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
              mutate(errors = ifelse(player == "White", White_inferior_moves, Black_inferior_moves)) %>%
              mutate(error_type = "inferior") %>%
              select(game_id, player, elo, error_type, errors, player_moves)
  )
  

# ------------------------------------------------------------------------------------------------------

# TIME

## 1. Timed Moves

### A. Select needed columns

time_data <- blitz %>% 
  select(game_id, 
         Result, 
         BlackElo, 
         WhiteElo, 
         Black_ts_moves, 
         White_ts_moves,
         Black_ts_blunders,
         White_ts_blunders,
         Black_ts_mistakes,
         White_ts_mistakes,
         Black_long_moves,
         White_long_moves,
         Black_bad_long_moves,
         White_bad_long_moves,
         Total_moves,
         player_moves)

### B. Set up time scramble and long move dataframes

all_timed_moves <- time_data %>%  # add time scramble moves
  select(game_id, WhiteElo, BlackElo, player_moves, White_ts_moves, Black_ts_moves) %>%
  pivot_longer(cols = c("WhiteElo", "BlackElo"),
               names_to = "player",
               values_to = "elo"
  ) %>%
  mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
  mutate(timed_moves = ifelse(player == "White", White_ts_moves, Black_ts_moves)) %>%
  mutate(time_type = "ts") %>%
  select(game_id, player, elo, time_type, timed_moves, player_moves)

all_timed_moves <- all_timed_moves %>%  # add long moves
  bind_rows(time_data %>%
              select(game_id, WhiteElo, BlackElo, player_moves, White_long_moves, Black_long_moves) %>%
              pivot_longer(cols = c("WhiteElo", "BlackElo"),
                           names_to = "player",
                           values_to = "elo"
              ) %>%
              mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
              mutate(timed_moves = ifelse(player == "White", White_long_moves, Black_long_moves)) %>%
              mutate(time_type = "long moves") %>%
              select(game_id, player, elo, time_type, timed_moves, player_moves)
  )

## 2. Time Scrambles

black_ts <- blitz %>%
  select(rating_category = Black_elo_category, 
         blunders = Black_blunders,
         ts_blunders = Black_ts_blunders,
         all_moves = player_moves, 
         ts_moves = Black_ts_moves) %>%
  mutate(color = "Black")

white_ts <- blitz %>%
  select(rating_category = White_elo_category, 
         blunders = White_blunders,
         ts_blunders = White_ts_blunders,
         all_moves = player_moves, 
         ts_moves = White_ts_moves) %>%
  mutate(color = "White")

combined_ts <- bind_rows(black_ts, white_ts)

summary_ts <- combined_ts %>%
  group_by(rating_category) %>%
  summarize(tot_all_moves = sum(all_moves),
            tot_ts_moves = sum(ts_moves),
            tot_reg_moves = tot_all_moves - tot_ts_moves,
            tot_blunders = sum(blunders),
            tot_ts_blunders = sum(ts_blunders),
            tot_reg_blunders = tot_blunders - tot_ts_blunders) %>%
  mutate(all_blunder_rate = tot_blunders / tot_all_moves,         
         ts_blunder_rate = tot_ts_blunders / tot_ts_moves,
         reg_blunder_rate = tot_reg_blunders / tot_reg_moves) %>%
  select(rating_category, all_blunder_rate, ts_blunder_rate, reg_blunder_rate) %>%
  pivot_longer(cols = -rating_category,
               names_to = "blunder_type",
               values_to = "blunder_rate")

dist_ts <- combined_ts %>%
  mutate(all_blunder_rate = blunders / all_moves,
         ts_blunder_rate = ts_blunders / ts_moves) %>%
  pivot_longer(cols = c("all_blunder_rate", "ts_blunder_rate"),
               names_to = "blunder_type",
               values_to = "blunder_rate") %>%
  drop_na(blunder_rate)

## 3. Long Moves

black_lm <- blitz %>%
  select(rating_category = Black_elo_category, 
         inf_moves = Black_inferior_moves,
         inf_long_moves = Black_bad_long_moves,
         all_moves = player_moves,
         long_moves = Black_long_moves) %>%
  mutate(color = "Black")

white_lm <- blitz %>%
  select(rating_category = White_elo_category, 
         inf_moves = White_inferior_moves,
         inf_long_moves = White_bad_long_moves,
         all_moves = player_moves,
         long_moves = White_long_moves) %>%
  mutate(color = "White")

combined_lm <- bind_rows(black_lm, white_lm)

summary_lm <- combined_lm %>%
  group_by(rating_category) %>%
  summarize(tot_all_moves = sum(all_moves),
            tot_long_moves = sum(long_moves),
            tot_inf_moves = sum(inf_moves),
            tot_inf_long_moves = sum(inf_long_moves),
            tot_inf_reg_moves = tot_inf_moves - tot_inf_long_moves) %>%
  mutate(all_inf_move_rate = tot_inf_moves / tot_all_moves,
         inf_long_move_rate = tot_inf_long_moves / tot_long_moves,
         inf_reg_move_rate = tot_inf_reg_moves / (tot_all_moves - tot_long_moves)) %>%
  select(rating_category, all_inf_move_rate, inf_long_move_rate, inf_reg_move_rate) %>%
  pivot_longer(cols = -rating_category,
               names_to = "inferior_move_type",
               values_to = "inferior_move_rate")

dist_lm <- combined_lm %>%
  mutate(all_inf_move_rate = inf_moves / all_moves,
         inf_long_move_rate = inf_long_moves / long_moves) %>%
  pivot_longer(cols = c("all_inf_move_rate", "inf_long_move_rate"),
               names_to = "inferior_move_type",
               values_to = "inferior_move_rate") %>%
  drop_na(inferior_move_rate)


# ------------------------------------------------------------------------------------------------------

# OPENINGS

## 1. Rankings

### A. Select needed columns

openings_data <- blitz %>% 
  select(game_id, 
         Result,
         ECO,
         Opening,
         Black_elo_category,
         White_elo_category,
         Black_ts_moves,
         White_ts_moves,
         player_moves)

### B. Set up dataframes for datatable

openings_data_agg <- openings_data %>%
  group_by(Opening, ECO) %>%
  summarise(total_games = n(),
            white_wins = sum(Result == "1-0"),
            black_wins = sum(Result == "0-1"),
            draws = sum(Result == "1/2-1/2")) %>%
  ungroup() %>%
  mutate(white_win_rate = white_wins / total_games,
         black_win_rate = black_wins / total_games,
         draw_rate = draws / total_games,
         freq_percentage = (total_games / sum(total_games))) %>%
  select(-white_wins, -black_wins, -draws) %>%
  arrange(desc(total_games))

colnames(openings_data_agg) <- c("Opening", "ECO", "Total Games", "White Win Rate", "Black Win Rate", "Draw Rate", "Frequency %")

eco_count <- openings_data %>%
  group_by(ECO) %>%
  summarise(Opening = paste(unique(Opening), collapse = ", "),
            freq = n()) %>%
  ungroup()


