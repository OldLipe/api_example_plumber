#* @apiTitle Clustering API example
#* @apiDescription Creating kmeans clustering and some
#*  plots.

# Importing packages
library(plumber)
library(jsonlite)
library(dplyr)
library(tidyselect)
library(kohonen)

#* Log system time, request method and HTTP user agent of the incoming request
#* @filter logger
function(req){
  cat("System time:", as.character(Sys.time()), "\n",
      "Request method:", req$REQUEST_METHOD, req$PATH_INFO, "\n",
      "HTTP user agent:", req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  plumber::forward()
}

#* Parse the input dataset
#* @filter clustering
function(req, res) {

  # only parse response body if final endpoint is/predict/
  if (grepl("clustering", req$PATH_INFO)) {
    # parse postBody into data.frame and store in req
    req$dataset <- tryCatch(jsonlite::fromJSON(req$postBody),
                            error = function(e) NULL)

    if (is.null(req$dataset)) {
      res$status <- 400

      return(
        list(
          error = "NO JSON data included in request body."
        )
      )
    }
    # Calling the predict function
    plumber::forward()
  }
}


#* Creating a kohonen object, working as controller operation
#* @filter clustering/som
#*
#* @param xdim:integer dimensions of the grid.
#* @param ydim:integer dimensions of the grid.
#* @param rlen:integer the number of times the complete data set will be
#*  presented to the network.
#* @param alpha:double earning rate, a vector of two numbers indicating the
#*  amount of change. Default is to decline linearly from 0.05 to 0.01 over rlen
#*  updates. Not used for the batch algorithm.
function(req, res) {

  # only parse response body if final endpoint is/predict/
  if (grepl("clustering/som", req$PATH_INFO)) {
    # verify the specified args
    if (any(is.null(req$args$xdim), is.null(req$args$ydim))) {
      res$status <- 400

      return(list(error = paste0("You must specify the number of grids, ",
                                 "please provide the parameter 'xgrid', and",
                                 " 'ygrid'. ")))
    }

    if (is.null(req$args$rlen))
      req$args$rlen <- 1

    if (is.null(req$args$alpha))
      req$args$alpha <- 0.5

    # Select only numerical attributes
    req$dataset <-
      dplyr::select(req$dataset, where(is.numeric))

    # Creating a clustering with the provided parameters
    som_clustering <- kohonen::som(as.matrix(req$dataset),
                                   grid        = kohonen::somgrid(
                                     xdim = req$args$xdim,
                                     ydim = req$args$ydim),
                                   rlen        = req$args$rlen,
                                   alpha       = req$args$alpha)

    req$som_obj <- som_clustering

    # Calling the predict function
    plumber::forward()
  }
}



#* Return an object from kohonen package in R
#*
#* @post /clustering/som/obj
#*
#* @serializer rds
#*
function(req, res) {
  req$som_obj
}
