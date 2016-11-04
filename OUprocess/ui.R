#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    sidebarLayout(
      sidebarPanel( sliderInput("theta", "theta, the mean", min = -5.0, max = 5.0, value = 3.0, step = 0.1),
                    sliderInput("alpha", "alpha, mean reverting parameter", min = 0.05, max = 1.0, value = 0.1, step = 0.05),
                    sliderInput("sigma", "sigma, diffusion coefficient", min = 0.0, max = 3.0, value = 0.5, step = 0.1)),
      mainPanel(
        plotOutput("ou")
      )
    )
  )
)
