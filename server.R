# server.R

shinyServer(function(input, output) {
  
  output$text1 <- renderText({ 
    paste("You have selected this", input$var)
  })
  
  output$text2 <- renderText({
    paste(input$range[1], "to", input$range[2])
  })
}
)