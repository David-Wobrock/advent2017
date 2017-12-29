a = 1
b = 0
c = 0
d = 0
e = 0
f = 0
g = 0
h = 0

b = 99
c = b
if a != 0
    b = 100*b
    b = b+100000
    c = b + 17000

loop
    f = 1
    d = 2
    loop
        if (b%d) == 0
            f = 0
        e = b
        d = d + 1
        g = d - b
        break if g == 0

    if f == 0
        h = h + 1
        console.log h
    g = b - c
    break if g == 0
    b = b + 17
