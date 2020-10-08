library(plumber)

m <- plumber::plumb('myscript.R')
m$run(port = 5555)
