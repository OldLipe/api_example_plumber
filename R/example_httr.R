library(httr)
library(jsonlite)
json_mtcars = jsonlite::toJSON(mtcars)
response <- httr::POST(url = "http://127.0.0.1:9173/clustering/kmeans/groups?centers=3",
                       body = mtcars, encode = "json")
mtcars_df <- lapply(httr::content(response), tibble::as_tibble) %>% dplyr::bind_rows()
## ADD in your server.R (shiny)
output$test <- renderPlot(plot(mtcars_df$mpg, mtcars_df$cyl, col= mtcars_df$group_id))
