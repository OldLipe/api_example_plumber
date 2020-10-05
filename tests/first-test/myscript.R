#* Application with a note predictor for IMDb films]
#* We will use the "movies" database from the "ggplot2movies" package.
#* For more details on the base, run "?Movies".
#* If you don't have that package, run "install.packages ("ggplot2movies")"

##Import packages:
library(plumber)
library(ggplot2movies)
library(tidyverse)

#* create data base:
data <- ggplot2movies::movies %>%
  filter(!is.na(budget), budget > 0) %>%
  select(title, year, budget, rating) %>%
  arrange(desc(year))

#* # A tibble: 5,183 x 4
#*                           title  year   budget rating
#*                           <chr> <int>    <int>  <dbl>
#*  1                           90  2005     4000    9.1
#*  2              Alien Abduction  2005   600000    1.9
#*  3     All the Stage Is a World  2005    12000    7.0
#*  4            Alone in the Dark  2005 20000000    2.1
#*  5       Amityville Horror, The  2005 18000000    5.8
#*  6                  And I Lived  2005    20000    9.4
#*  7            Are We There Yet?  2005 32000000    3.5
#*  8                Ash Wednesday  2005     4999    8.6
#*  9       Assault on Precinct 13  2005 20000000    6.3
#* 10 Ballad of Jack and Rose, The  2005  1500000    6.2
#* # ... with 5,173 more rows
#* model will attempt to predict rating using the following variables:
#* budget: budget of the film in dollars
#* year: year of the film (considered as a whole number)
#* model:
model <- lm(rating ~ budget + year, data = data)

#* function that predicts the rating of a film based on its budget and year:
#* @post /predict
predict_evaluation <- function(estimate, anno) {
  predict(model, newdata = data.frame(budget = estimate, year = anno))
}

#* function that returns a random sample of ten cases from the database:
#* @get /drop
drop_ten <- function() {
  data %>%
    sample_n(10)
}





