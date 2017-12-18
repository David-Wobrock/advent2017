data = list()
data[[1]] <- 0
data[[2]] <- 1
len <- 2
currentI <- 2

spin <- 345

for (i in 2:2017) {
    nextI <- ((currentI + spin) %% len)+1
    data <- c(data[1:nextI-1], i, data[nextI:len])
    len <- len + 1
    currentI <- nextI
}
pos2017 <- which(data == 2017)
print(data[[pos2017+1]])
