# importing packages
library(httr)
library(jsonlite)
library(magrittr)
library(dplyr)
library(kohonen)

# importing mtcars to enviroment
data("mtcars")

# sending a POST to kmeans API
res_kmeans <- httr::POST(
                url = "http://127.0.0.1:9173/clustering/kmeans/groups?centers=3",
                body = mtcars,
                encode = "json")

# converting to a tibble data frame
mtcars_df <- lapply(httr::content(res_kmeans), tibble::as_tibble) %>%
    dplyr::bind_rows()

################################################################################
# sending a POST to som API
res_som <- httr::POST(
  url = "http://127.0.0.1:9173/clustering/som/obj?xdim=5&ydim=5",
  body = mtcars,
  encode = "json")

# kohonen object from kohonen package
k_obj <- unserialize(httr::content(res_som, as = "raw"))



