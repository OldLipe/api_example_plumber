library(plumber)

pr <- pr("api_kohonen.R")
pr$run(port = 9173)

# ver esse codigo q ele especifica como q cria o swagger
# https://github.com/sol-eng/plumber-model/blob/master/R/model-api/entrypoint.R
