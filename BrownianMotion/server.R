packages <- c("dplyr", "tidyr", "ggplot2", "gridExtra", "magrittr", "scales", "ggfortify", "leaflet", "readr")
newPackages <- packages[!(packages %in% as.character(installed.packages()[,"Package"]))]
if(length(newPackages)) install.packages(newPackages)
lapply(packages,require,character.only=T)

theme_set(theme_minimal())

shinyServer(function(input, output) {
  output$brownian = renderPlot({
    ## Can this be replaced with inline scala, lol no
    brownian_sims = function(mu, sigma) {
      x = numeric(100)
      x[1] = rnorm(1, 0, 1)
      for (i in 2:100) {
        x[i] = rnorm(1, mean = x[i-1] + mu, sd = sigma)
      }
      data_frame(Time = 1:100, Value = x) %>%
        mutate(upper = qnorm(p = 0.975, mean = Value, sd = sigma), 
               lower = qnorm(p = 0.025, mean = Value, sd = sigma))
    }
    
    brownianSims = brownian_sims(input$mu, input$sigma)
    
    brownianSims %>%
      ggplot(aes(x = Time, y = Value)) + 
      geom_line() +
      geom_ribbon(aes(ymax = upper, ymin = lower), alpha = 0.5) +
      ggtitle("Generalised Brownian Motion Simulation")
  })
})