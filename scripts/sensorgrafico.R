
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

funcoes <- c("sin", "cos", "tan", "sqrt", "log", "log10", "exp")


# --

x = sin(counting)
y = cos(counting)

text(x = 5, y = 5, family = "serif")
op = par(bg = 'white', mar = rep(0.5, 4), family = "serif")

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

lines(x, y, col = sample(color, 1))
lines(0.8 * x, 0.8 * y, col = sample(color, 1), lwd=0.9)
lines(0.6 * x, 0.6 * y, col = sample(color, 1), lwd=0.9)
lines(0.4 * x, 0.4 * y, col = sample(color, 1), lwd=0.9)
lines(0.3 * x, 0.3 * y, col = sample(color, 1), lwd=0.9)
lines(0.1 * x, 0.1 * y, col = sample(color, 1), lwd=0.9)

legend("topleft", legend = "lsdview", bty = "n", text.col = "gray80")

# --

x = cos(counting)
y = -tan(counting)

text(x = 5, y = 5, family = "serif")
op = par(bg = 'white', mar = rep(0.5, 4), family = "serif")

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

lines(x*1.6, y*1.6, col = sample(color, 1))
lines(x, y, col = sample(color, 1))
lines(0.8 * x, 0.8 * y, col = sample(color, 1), lwd=0.9)
lines(0.6 * x, 0.6 * y, col = sample(color, 1), lwd=0.9)
lines(0.4 * x, 0.4 * y, col = sample(color, 1), lwd=0.9)
lines(0.3 * x, 0.3 * y, col = sample(color, 1), lwd=0.9)
lines(0.1 * x, 0.1 * y, col = sample(color, 1), lwd=0.9)

legend("topleft", legend = "lsdview", bty = "n", text.col = "gray80")

# --

text(x = 5, y = 5, family = "serif")
op = par(bg = 'white', mar = rep(0.5, 4), family = "serif")

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

lines(exp(2)^(sin(counting)+cos(counting)), tan(exp(2)^counting), col = sample(color, 1))
lines(-exp(2)^(sin(counting)+cos(counting)), -tan(exp(2)^counting), col = sample(color, 1))

x = cos(counting)
y = sin(counting)

lines(x, y, col = sample(color, 1))
lines(0.8 * x, 0.8 * y, col = sample(color, 1), lwd=0.9)
lines(0.6 * x, 0.6 * y, col = sample(color, 1), lwd=0.9)
lines(0.4 * x, 0.4 * y, col = sample(color, 1), lwd=0.9)
lines(0.3 * x, 0.3 * y, col = sample(color, 1), lwd=0.9)
lines(0.1 * x, 0.1 * y, col = sample(color, 1), lwd=0.9)

lines(-10/exp(2)^(sin(counting)+cos(counting)), -10/tan(exp(2)^counting), col = sample(color, 1))
lines(10/exp(2)^(sin(counting)+cos(counting)), tan(100/exp(2)^counting), col = sample(color, 1))


# --

text(x = 5, y = 5, family = "serif")
op = par(bg = 'black', mar = rep(0.5, 4), family = "serif")

plot.new()
plot.window(xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

x = sin(counting) + cos(counting)
y = sin(counting) * cos(counting)


lines(x * 1.3, y * 1.3, col = sample(color, 1))
lines(x, y, col = sample(color, 1))
lines(0.8 * x, 0.8 * y, col = sample(color, 1), lwd=0.9)
lines(0.6 * x, 0.6 * y, col = sample(color, 1), lwd=0.9)
lines(0.4 * x, 0.4 * y, col = sample(color, 1), lwd=0.9)
lines(0.3 * x, 0.3 * y, col = sample(color, 1), lwd=0.9)
lines(0.1 * x, 0.1 * y, col = sample(color, 1), lwd=0.9)



# ----------------------------
library(devtools)
install_github("Gibbsdavidl/CatterPlots")

library(CatterPlots)
x <- -10:10
y <- -x^2 + 10
purr <- catplot(xs=x, ys=y, cat=3, catcolor=c(0,1,1,1))

cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))

# for more fun ...
meow <- multicat(xs=x, ys=y, cat=c(1,2,3), catcolor=list(c(1,1,0,1),c(0,1,1,1)), canvas=c(-0.1,1.1, -0.1, 1.1))
morecats(purr, x, 10*sin(x)+40, size=0.05, cat=c(4,5,6), catcolor=list(c(0,0,1,1),c(0,1,0,1)), type="line")

# random cats
meow <- multicat(xs=x, ys=rnorm(21),
                 cat=c(1,2,3,4,5,6,7,8,9,10),
                 catcolor=list(c(0,0,0,1)),
                 canvas=c(-0.1,1.1, -0.1, 1.1),
                 xlab="some cats", ylab="other cats", main="Random Cats")



rainbowCats <- function(xs, ys, ptsize=0.1, yspread=0.1, xspread=0.1,
                        cat=11, catshiftx=0, catshifty=0, spar=NA, canvas=c(-0.5,1.5,-1,1.5)) {
  require(png)
  data(cats)
  
  if (is.na(spar)) {
    sm <- smooth.spline(ys~xs)
  } else {
    sm <- smooth.spline(ys~xs, spar=spar)
  }
  max_x <- max(xs)
  min_x <- min(xs)
  z <- predict(sm, x=seq(min_x,max_x,by=xspread))
  
  cp <- multipoint(xs=z$x, ys=z$y, ptsize=ptsize, catcolor=c(1,1,1,0), canvas=canvas)
  
  cols <- colorRamp(rainbow(7))(seq(0.0,1,by=0.12)) / 255
  mults <- seq(-4,4) * yspread
  
  for (i in 1:nrow(cols)) {
    morepoints(cp, xs=z$x, ys=z$y, ptsize=ptsize, catcolor=cols[i,], yshift=mults[i])
  }
  
  print(paste(z$x[length(z$x)], "  ", z$y[length(z$y)]))
  morecats(cp, xs=z$x[length(z$x)], ys=z$y[length(z$y)],
           xshift=catshiftx, yshift=catshifty, size=1, cat=cat)
}


x <- -10:10
y <- -x^2 + 10
rainbowCats(x, y, yspread=0.05, xspread=0.05, ptsize=2, catshiftx=0.5, canvas=c(-0.5,1.5,-1,1.5))


# -------------------------

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

