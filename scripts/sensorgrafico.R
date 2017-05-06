
library(jsonlite)
library(ggplot2)

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

funcoes <- c("sin", "cos", "tan", "sqrt", "log", "log10")

x = cos(counting)
y = -tan(counting)

text(x = 5, y = 5, family = "serif")
op = par(bg = 'white', mar = rep(0.5, 4), family = "serif")

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

lines(x*1.6, y*1.6, col = sample(color, 1))
lines(x, y, col = sample(color, 1))
#lines(0.9 * x, 0.9 * y, col = sample(color, 1), lwd=0.9)
lines(0.8 * x, 0.8 * y, col = sample(color, 1), lwd=0.9)
#lines(0.7 * x, 0.7 * y, col = sample(color, 1), lwd=0.9)
lines(0.6 * x, 0.6 * y, col = sample(color, 1), lwd=0.9)
lines(0.4 * x, 0.4 * y, col = sample(color, 1), lwd=0.9)
lines(0.3 * x, 0.3 * y, col = sample(color, 1), lwd=0.9)
lines(0.1 * x, 0.1 * y, col = sample(color, 1), lwd=0.9)


legend("topleft", legend = "lsdview", bty = "n", text.col = "gray80")



# ----------------------------

# If you want to show an image coming from the web, first download it with R:
download.file("https://www.nasa.gov/sites/default/files/thumbnails/image/p1639ay-goodss-160930.jpg" , destfile="my_image.jpg")
#Else, just place the image in the current directory

# Charge the image as an R object with the "JPEG" package
install.packages("jpeg")
library(jpeg)
my_image=readJPEG("my_image.jpg")

# Set up a plot area with no plot
plot(1:2, type='n', main="", xlab="x", ylab="y")

# Get the plot information so the image will fill the plot box, and draw it
lim <- par()
rasterImage(my_image, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
#grid()

#Add your plot !
lines(c(1, 1.2, 1.4, 1.6, 1.8, 2.0), c(1, 1.3, 1.7, 1.6, 1.7, 1.0), type="b", lwd=5, col="white")

