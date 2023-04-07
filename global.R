# 1. SETUP

## A. Load Libraries

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinythemes)
library(shinydashboard)
library(hexbin)

## B. Load Processed Dataset ===

blitz <- readRDS(file = "./data/blitzgames_processed.rds")

# ------------------------------------------------------------------------------------------------------

# 2. ANALYSIS: BAD MOVES

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
         Total_moves) %>%
  mutate(player_moves = ceiling(Total_moves / 2))

### 2. Set up error Dataframes

blunders <- bad_move_data %>%
  select(game_id, WhiteElo, BlackElo, player_moves, White_blunders, Black_blunders) %>%
  pivot_longer(cols = c("WhiteElo", "BlackElo"),
               names_to = "player",
               values_to = "elo"
               ) %>%
  mutate(player = ifelse(player == "WhiteElo", "White", "Black")) %>%
  mutate(errors = ifelse(player == "White", White_blunders, Black_blunders)) %>%
  mutate(error_type = "blunders") %>%
  select(game_id, player, elo, error_type, errors, player_moves)

all_bad_moves <- blunders

  