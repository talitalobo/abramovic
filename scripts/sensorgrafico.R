
library(jsonlite)

json <- fromJSON("http://150.165.85.12:41205/get_today_people_count")
counting <- json$data

color <- c("darkmagenta","seagreen4","palevioletred1","red3","burlywood4", "antiquewhite1", 
             "aquamarine2","aquamarine3","cadetblue","cadetblue2", "cadetblue4", "aquamarine4",
             "chartreuse","chartreuse3","chartreuse4", "azure3"," chocolate",
             "chocolate1", "chocolate4", "coral1", "coral4","bisque1","cornflowerblue","blueviolet",
             "blue3", "cyan3","cyan4","brown","brown2","darkgoldenrod", "darkgoldenrod1","burlywood1",
             "deepskyblue2","deepskyblue4","darkolivegreen3", "darkorchid",
             "darkorchid4","darkorange1","darkseagreen","darkslategray", "deeppink",
             "deeppink4","deeppink2","hotpink","hotpink4")

x = sqrt(counting)
y = exp(counting)

op = par(bg = 'white', mar = rep(0.5, 4))

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

lines(x, y, col = sample(color, 1))
lines(0.8 * x, 0.8 * y, col = sample(color, 1))
lines(0.6 * x, 0.6 * y, col = sample(color, 1))
lines(0.4 * x, 0.4 * y, col = sample(color, 1))

legend("topleft", legend = "Hall Lsd", bty = "n", text.col = "gray60")
x = log10(counting)
y = log(counting)

op = par(bg = 'white', mar = rep(0.5, 4))

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

lines(x, y, col = sample(color, 1))
lines(0.8 * x, 0.8 * y, col = sample(color, 1))
lines(0.6 * x, 0.6 * y, col = sample(color, 1))
lines(0.4 * x, 0.4 * y, col = sample(color, 1))

legend("topleft", legend = "Hall Lsd", bty = "n", text.col = "gray60")