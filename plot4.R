# Only create the subset if it has not already been created
if (!exists("subsetPowerData")) {
  powerConsumptionData <-
    read.csv("household_power_consumption.txt", sep=";", na.strings = "?",
             header = TRUE);
  
  subsetPowerData <- subset(powerConsumptionData,
                            Date == '1/2/2007' | Date == '2/2/2007')
  subsetPowerData$Time <- strptime(paste(subsetPowerData$Date,
                                         subsetPowerData$Time, " "),
                                   format="%d/%m/%Y %H:%M:%S")
  subsetPowerData$Date <- as.Date.factor(subsetPowerData$Date,
                                         format="%d/%m/%Y");
  
}

png("plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))

# First, plot Global Active Power by day
########
minTime <- as.POSIXlt(min(subsetPowerData$Time))
maxTime <- as.POSIXlt(max(subsetPowerData$Time))
afterTime <- maxTime + as.difftime(1, units="days")
afterTime <- trunc(afterTime, units="days")

daterange=c(minTime, maxTime, afterTime)

with(subsetPowerData,
     plot(subsetPowerData$Time, subsetPowerData$Global_active_power,
          xaxt="n", xlab="", ylab="Global Active Power", type="n"))
axis.POSIXct(1, at=seq(daterange[1], daterange[3], by="day"), format="%a")
points(subsetPowerData$Time, subsetPowerData$Global_active_power, type="l")
########

# Then, plot Voltage by day
with(subsetPowerData,
     plot(subsetPowerData$Time, subsetPowerData$Voltage,
          xaxt="n", xlab="datetime", ylab="Voltage", type="n"))
axis.POSIXct(1, at=seq(daterange[1], daterange[3], by="day"), format="%a")
points(subsetPowerData$Time, subsetPowerData$Voltage, type="l")
########

# Then, plot Energy sub metering by day
with(subsetPowerData,
     plot(subsetPowerData$Time, subsetPowerData$Sub_metering_1,
          xaxt="n", xlab="", ylab="Energy sub metering", type="n"))
axis.POSIXct(1, at=seq(daterange[1], daterange[3], by="day"), format="%a")
points(subsetPowerData$Time, subsetPowerData$Sub_metering_1, type="l", col="black")
points(subsetPowerData$Time, subsetPowerData$Sub_metering_2, type="l", col="red")
points(subsetPowerData$Time, subsetPowerData$Sub_metering_3, type="l", col="blue")
legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       bty="n",
       lty=c(1,1,1),
       cex=0.75,
       col=c("black","red","blue"))
########

# Then, plot Global reactive power by day
with(subsetPowerData,
     plot(subsetPowerData$Time, subsetPowerData$Global_reactive_power,
          xaxt="n", xlab="datetime", ylab="Global_reactive_power", type="n"))
axis.POSIXct(1, at=seq(daterange[1], daterange[3], by="day"), format="%a")
points(subsetPowerData$Time, subsetPowerData$Global_reactive_power, type="l")

# Finally, write out the png file and close that graphics device
dev.off()
