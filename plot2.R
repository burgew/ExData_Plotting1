# Only create the subset if it has not already been created
if (!exists("subsetPowerData")) {
  powerConsumptionData <- read.csv("household_power_consumption.txt", sep=";", na.strings = "?", header = TRUE);
  
  subsetPowerData <- subset(powerConsumptionData,
                            Date == '1/2/2007' | Date == '2/2/2007')
  subsetPowerData$Time <- strptime(paste(subsetPowerData$Date,
                                         subsetPowerData$Time, " "),
                                   format="%d/%m/%Y %H:%M:%S")
  subsetPowerData$Date <- as.Date.factor(subsetPowerData$Date,
                                         format="%d/%m/%Y");
  
}

png("plot2.png", width = 480, height = 480)
minTime <- as.POSIXlt(min(subsetPowerData$Time))
maxTime <- as.POSIXlt(max(subsetPowerData$Time))
afterTime <- maxTime + as.difftime(1, units="days")
afterTime <- trunc(afterTime, units="days")

daterange=c(minTime, maxTime, afterTime)

with(subsetPowerData,
     plot(subsetPowerData$Time, subsetPowerData$Global_active_power,
          xaxt="n", xlab="", ylab="Global Active Power (kilowatts)", type="n"))
axis.POSIXct(1, at=seq(daterange[1], daterange[3], by="day"), format="%a")
points(subsetPowerData$Time, subsetPowerData$Global_active_power, type="l")

# Finally, write out the png file and close that graphics device
dev.off()
