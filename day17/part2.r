len <- 2
nextI <- 2
pos0 = 1
valAfter0 = 1

spin <- 345

for (i in 2:50000000) {
    nextI <- ((nextI + spin) %% len)+1
    if (nextI <= pos0) {
        pos0 <- pos0 + 1
    }
    if (nextI-1 == pos0) {
        valAfter0 = i
        print(i)
    }
    len <- len + 1
    nextI <- nextI
}

print(valAfter0)
