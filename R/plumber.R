#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#
library(plumber)


model_lm <- function(data, ...) {

  lm(mpg ~ cyl, data)
}


#* @apiTitle Plumber Example API

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
    list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
    rand <- rnorm(100)
    hist(rand)
}


#* mtcars dataset
#* @get /data
function() {
  data(mtcars)
  mtcars
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
    as.numeric(a) + as.numeric(b)
}

#* Parse and predict on model for future endpoints
#* @filter train
function(req, res) {

  # only parse response body if final endpoint is/predict/
  if (grepl("train", req$PATH_INFO)) {
    # parse postBody into data.frame and store in req
    #browser()
    req$train_data <- tryCatch(jsonlite::fromJSON(req$postBody),
                                 error = function(e) NULL)

    if (is.null(req$train_data)) {
      res$status <- 400

      return(
        list(
          error = "NO JSON data included in request body."
        )
      )
    }
    # Calling the predict function
    req$trained_data <- model_lm(req$train_data)
    forward()
  }
}

#* Return a residuals values from a trained value
#* @serializer json
#* @post /train/lm
function(req) {
  as.vector(req$trained_data$residuals)
}

