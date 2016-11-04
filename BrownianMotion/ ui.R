shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("mu", "Mu, the drift", min = -5.0, max = 5.0, value = 0.5, step = 0.1),
      sliderInput("sigma", "Sigma, the diffusion", min = 0.0, max = 5.0, value = 1.0, step = 0.1)
    ),
      mainPanel(
        plotOutput("brownian")        
      )
    )
  )
)
