#* @apiTitle Clustering API example
#* @apiDescription Creating kmeans clustering and some
#*  plots.

# Importing packages
library(plumber)
library(jsonlite)
library(dplyr)
library(tidyselect)


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

#* Creating a kmeans object, working as controller operation
#* @filter clustering/kmeans
#*
#* @param centers:integer either the number of clusters, say k,
#*  or a set of initial (distinct) cluster centres. If a number,
#*  a random set of (distinct) rows in x is chosen as the
#*  initial centres. If not provided, by default will be
#*  setted 3 centers.
#* @param iter.max:integer the maximum number of iterations
#*  allowed.
#* @param nstart:integer if centers is a number, how many
#*  random sets should be chosen?
#* @param algorithm:character	character: may be abbreviated.
#*  Note that "Lloyd" and "Forgy" are alternative names for
#*   one algorithm.
function(req, res) {

  # only parse response body if final endpoint is/predict/
  if (grepl("clustering/kmeans", req$PATH_INFO)) {
    # verify the specified args
    if (is.null(req$args$centers)) {
      res$status <- 400

      return(list(error = paste0("You must specify the number of clusters, ",
                                 "please provide the parameter 'centers'.")))
    }

    if (is.null(req$args$iter.max))
      req$args$iter.max <- 10

    if (is.null(req$args$nstart))
      req$args$nstart <- 1

    if (is.null(req$args$algorithm))
      req$args$algorithm <- "Lloyd"

    # Select only numerical attributes
    req$dataset <-
      dplyr::select(req$dataset, where(is.numeric))

    # Creating a clustering with the provided parameters
    kmeans_clustering <- kmeans(x           = req$dataset,
                                centers     = req$args$centers,
                                iter.max    = req$args$iter.max,
                                nstart      = req$args$nstart,
                                algorithm   = req$args$algorithm)

    req$kmeans_obj <- kmeans_clustering

    # Calling the predict function
    plumber::forward()
  }
}

#* Return a dataset with an additional column called "group_id", that
#* corresponding to each group created by the kmeans
#*
#* @post /clustering/kmeans/groups
#*
#* @serializer json
#*
function(req, res) {

  # Add groups attributes
  req$dataset$group_id <- req$kmeans_obj$cluster
  req$dataset
}

#* Return an object from kmeans base method in R
#*
#* @post /clustering/kmeans/obj
#*
#* @serializer rds
#*
function(req, res) {
  req$dataset$kmeans_obj
}
