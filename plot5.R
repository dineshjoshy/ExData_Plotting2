
#setting directory and extracting data
setwd("C://Users//user//Documents//GitHub//ExData_Plotting2")
unzip(".//data//exdata-data-NEI_data.zip")
# install.packages("plyr")
library(plyr)

# load data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Task5 How have emissions from motor vehicle sources changed 
# from 1999–2008 in Baltimore City?

# figuring out what SCC values represent motor vehicle-related sources
MotorRelated <- grep("On-Road", unique(SCC$EI.Sector), value = T)
split <- SCC$EI.Sector %in% MotorRelated
SCCMotor <- subset(SCC, split == T)$SCC

# creating a subset of NEI dataset, only contain data in baltimore
baltimore <- subset(NEI,NEI$fips == "24510")

# creating a subset of the baltimore dataset, only contain motor vehicle related sources in Baltimore
split <- baltimore$SCC %in% SCCMotor
motorBaltimore <- subset(baltimore, split == T)

# calcuating total pm2.5 emissions per year
pm25Motor <- ddply(motorBaltimore, .(year), summarise, totalEmissions = sum(Emissions))

# creating plot
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./figure/plot5.png", 
    width = 480, height = 480, 
    units = "px")

plot(pm25Motor$year,pm25Motor$totalEmissions, xlab="Year", ylab = "Total PM2.5 Emission", pch = 19, col = "blue")
title(main= "Total PM2.5 Emissions From Motor Vehicle Related Sources In Baltimore")

dev.off()