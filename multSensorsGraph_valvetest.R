#this is for multiple sensors download & graph. This is modified specifically for the valve beta test. 
#Permisions for url and subset under "Reading in Valve List" may have to be modified for this to run.


#---------------Needed Libraries---------------
library(jsonlite)
library(gsheet)

#---------------Inputs---------------

wd <-"/Users/Hal/Google Drive/Danielle/Beta Test/Good Sensors"
setwd(wd)

save.data <- ("yes") #"no"
save.graph <- ("yes") #"no"
graph.var <- "capacitance"
# "battery", "humidity", "temperature", "electrical_conductivity", "light", "capacitance"

#---------------Reading in Valve List---------------

url <- "https://docs.google.com/spreadsheets/d/1S_fWL0MZptmiUj0D02eGnxpFXIuVcC1c5Ax4vbYqu64/edit?usp=sharing"

sList <- gsheet2tbl(url)
low <- sList$Sensor.ID[sList$Subset=="l"]
quest <- sList$Sensor.ID[sList$Subset=="y"]
good <- sList$Sensor.ID[sList$Subset=="g"]

#---------------The Function---------------

multSensorsGraph <- function(sensors, graph.var, save.file="yes", save.graph="yes", readings=2016, offset=0){
	for(i in 1:length(sensors)){
		link = paste('http://readings.newton.edyn.com/devices/', sensors[i], '/readings?limit=', readings, '&offset=', offset, sep="" )
  		jsonData <- fromJSON(link)
  		data <- jsonData$response
  		
		tit<-paste(sensors[i], graph.var, sep=" ")	#title name for graph
		color.list <- c(rep(NA, 5), "black", "lightblue", "red", "green", "yellow", rep(NA, 17), "blue3")

		if(graph.var=="capacitance"){
			#converting capacitance to vwc and cleaning
			data$capacitance <- (log(data$capacitance)^2) * 1.3104 + 15.541 * log(data$capacitance) + 45.654	
#			data$capacitance[data$capacitance < 2] <- NA
			data$capacitance[data$capacitance > 60] <- NA
			yaxis <- "volumetric water content (%)"
		} else {
			color <- color.list[which(names(data)==graph.var)]
			yaxis <- paste("raw", graph.var, sep = " ")
		}
		if(save.graph=="yes"){
			png(paste(sensors[i],"_", graph.var, ".png", sep=""), width=800, height=480)	
		}

		t1 = min(data[["timestamp"]]); t2 = max(data[["timestamp"]])
		plot(data[[graph.var]]~data[["timestamp"]], 
			main=tit, ylab = yaxis, xaxt = "n", pch=19, type="p", xlab = "",
			col = color.list[which(names(data)==graph.var)])
		ts.axis <- as.POSIXct(seq(t1, t2, 43200), origin="1970-01-01")
		axis.POSIXct(1, at=ts.axis, labels = format(ts.axis, "%m/%d %H:%M"), las = 2)
		if(save.graph == "yes"){dev.off()}
		if(save.file == "yes"){
		write.csv(data, paste(sensors[i], ".csv", sep=""), row.names = FALSE, quote = FALSE)	
		}
		cat(paste("..", i, ".."))
	}
}

multSensorsGraph(sensors=good, graph.var="capacitance")


