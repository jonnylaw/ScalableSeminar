packages <- c("dplyr", "tidyr", "ggplot2", "gridExtra", "magrittr", "shiny", "readr", "gganimate")
newPackages <- packages[!(packages %in% as.character(installed.packages()[,"Package"]))]
if(length(newPackages)) install.packages(newPackages)
lapply(packages,require,character.only=T)

n = 100
sims = read_csv("~/Desktop/ComposableModels/LinearModelSims.csv", col_names = c("Time", "Observation", "Eta", "Gamma", "State"))
pfData = read_csv("~/Desktop/ComposableModels/LinearModelFilter.csv", col_names = c("Time", "Particles", "Weights"))
theme_set(theme_minimal())

p1 = pfData %>%
  ggplot() + 
  geom_point(aes(x = Time, y = Particles, alpha = Weights, frame = Time)) +
  geom_line(data = sims, aes(x = Time, y = State)) +
  theme(legend.position = "none")
  
gg_animate(p1)
