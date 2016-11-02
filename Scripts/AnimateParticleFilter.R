packages <- c("dplyr", "tidyr", "ggplot2", "gridExtra", "magrittr", "shiny", "readr", "gganimate")
newPackages <- packages[!(packages %in% as.character(installed.packages()[,"Package"]))]
if(length(newPackages)) install.packages(newPackages)
lapply(packages,require,character.only=T)

n = 100
sims = read_csv("~/Desktop/ComposableModels/LinearModelSims.csv", col_names = c("Time", "Observation", "Eta", "Gamma", "State"))
pfData = read_csv("~/Desktop/ComposableModels/LinearModelFilter.csv", col_names = c("Time", "Particles", "Weights"))
theme_set(theme_minimal())

time = sims$Time[5,]

p1 = pfData %>% filter(Time == time) %>%
  ggplot() + 
    geom_point(aes(x = Time, y = Particles, alpha = Weights)) +
    geom_line(data = sims, aes(x = Time, y = State)) +
    theme(legend.position = "none")

p2 = pfData %>% filter(Time == time) %>%
  inner_join(sims, by = "Time") %>%
  ggplot() + geom_histogram(aes(x = Particles)) + geom_vline(aes(xintercept = State)) +
  ggtitle("Initial Particle Positions")
  
p3 = pfData %>% inner_join(sims, by = "Time") %>% 
  filter(Time == time) %>%
  group_by(Time) %>%
  mutate(distribution = sample(Particles, size = n, replace = T, prob = Weights)) %>%
  ggplot() + geom_histogram(aes(x = distribution)) + geom_vline(aes(xintercept = State)) +
  ggtitle("Re-weighted Particles")
 
grid.arrange(p1, p2, p3, layout_matrix = rbind(c(1,1), c(2,3)))

## There might be a way to animate all three together using facet and subset
## https://stackoverflow.com/questions/16614860/stacke-different-plots-in-a-facet-manner

p1 = pfData %>%
  ggplot() + 
  geom_point(aes(x = Time, y = Particles, alpha = Weights, frame = Time)) +
  geom_line(data = sims, aes(x = Time, y = State)) +
  theme(legend.position = "none") + 
  
gg_animate(p1, "../Figures/animatedParticleFilter.gif")
