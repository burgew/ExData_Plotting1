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

png("plot1.png", width = 480, height = 480)
with(subsetPowerData, hist(round(Global_active_power), breaks=12, col="red",
                           xlab="Global Active Power (kilowatts)",
                           main="Global Active Power",
                           xaxt="n")
)
axis(1, at=c(0,2,4,6))

# Finally, write out the png file and close that graphics device
dev.off()
