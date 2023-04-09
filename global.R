# 1. SETUP

## A. Load Libraries

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinythemes)
library(shinydashboard)
library(hexbin)
library(plotly)

## B. Load Processed Dataset ===

blitz <- readRDS(file = "./data/blitzgames_processed.rds")

# ------------------------------------------------------------------------------------------------------

# 2. BAD MOVES

## A. Data Manipulation for Bad Moves Analysis

### 1. Select needed columns
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

### 2. Set up error dataframes

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

# 3. TIME

## A. Timed Moves

### 1. Select needed columns

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

### 2. Set up time scramble and long move dataframes

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

## B. Time Trouble

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
  mutate(tot_blunder_rate = tot_blunders / tot_all_moves,         
         ts_blunder_rate = tot_ts_blunders / tot_ts_moves,
         reg_blunder_rate = tot_reg_blunders / tot_reg_moves) %>%
  select(rating_category, tot_blunder_rate, ts_blunder_rate, reg_blunder_rate) %>%
  pivot_longer(cols = -rating_category,
               names_to = "blunder_type",
               values_to = "blunder_rate")

