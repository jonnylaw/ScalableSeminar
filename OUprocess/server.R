#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
packages <- c("dplyr", "tidyr", "ggplot2", "shiny")
newPackages <- packages[!(packages %in% as.character(installed.packages()[,"Package"]))]
if(length(newPackages)) install.packages(newPackages)
lapply(packages,require,character.only=T)

theme_set(theme_minimal())

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ## Plot the OU process
  output$ou = renderPlot({
    ou_sims = function(theta, alpha, sigma) {
      x = numeric(100)
      x[1] = rnorm(1, 0, 1)
      for (i in 2:100) {
        mean = theta + (x[i-1] - theta) * exp(- alpha)
        variance = (sigma**2/2*alpha)*(1-exp(-2*alpha))
        x[i] = rnorm(1, mean, sqrt(variance))
      }
      
      data_frame(Time = 1:100, Value = x)  %>%
        mutate(upper = qnorm(0.975, mean = Value, sd = sigma), 
               lower = qnorm(0.025, mean = Value, sd = sigma))
    }
    
    ou_sims(input$theta, input$alpha, input$sigma) %>%
      ggplot(aes(x = Time, y = Value)) + 
      geom_line() +
      geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.3) +
      ggtitle("Ornstein-Uhlenbeck Process Simulation")
  })
})
