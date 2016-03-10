#this is a single sensor download & graph. For multiple sensors, see multSensorsGraph.R

rm(list = ls())

#---------------Needed Libraries---------------
library(jsonlite)


#---------------Inputs---------------

#directory <-"/Users/Hal/......"

#sensors <- "a6ebe"
#readings <- 100
#offset <- 0
#save.data <- ("yes") #"no"
#save.graph <- ("yes") #"no"
#graph.var <- "electrical_conductivity"
# "battery", "humidity", "temperature", "electrical_conductivity", "light", "capacitance"



#---------------Get Data---------------
#getting the dataset if it is not already present in the working directory:



single_graph <- function(sensors, graph.var=graph.var, save.file="yes", save.graph="yes", directory){
	setwd(directory)
	datafile <- paste(sensors, ".csv", sep="")
	if (!file.exists(datafile)) {
		link = paste('http://readings.newton.edyn.com/devices/', sensors, '/readings?limit=', readings, '&offset=', offset, sep="" )
 		jsonData <- fromJSON(link)
 		 data <- jsonData$response
 	 } else {
 	 	data <- read.csv(datafile)
 	 }
	tit<-paste(sensors, graph.var, sep=" ")	#title name for graph
	color.list <- c(rep(NA, 5), "black", "lightblue", "red", "green", "yellow", rep(NA, 17), "blue3")
	if(graph.var=="capacitance"){
		#converting capacitance to vwc and cleaning
		data$capacitance <- (log(data$capacitance)^2) * 1.3104 + 15.541 * log(data$capacitance) + 45.654	
		data$capacitance[data$capacitance < 2] <- NA
		data$capacitance[data$capacitance > 60] <- NA
		yaxis <- "volumetric water content (%)"
	} else {
		color <- color.list[which(names(data)==graph.var)]
		yaxis <- paste("raw", graph.var, sep = " ")
	}
	if(save.graph=="yes"){
		png(paste(sensor,"_", graph.var, ".png", sep=""), width=800, height=480)	
	}

	t1 = min(data[["timestamp"]]); t2 = max(data[["timestamp"]])
	plot(data[[graph.var]]~data[["timestamp"]], 
		main=tit, ylab = yaxis, xaxt = "n", pch=19, type="p", xlab = "",
		col = color.list[which(names(data)==graph.var)])
	ts.axis <- as.POSIXct(seq(t1, t2, 7200), origin="1970-01-01")
	axis.POSIXct(1, at=ts.axis, labels = format(ts.axis, "%m/%d %H:%M"), las = 2)
	if(save.graph == "yes"){dev.off()}
	if(save.file == "yes"){
	write.csv(data, datafile, row.names = FALSE, quote = FALSE)	
	}
}



