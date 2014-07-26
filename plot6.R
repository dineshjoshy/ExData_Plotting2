
#setting directory and extracting data
setwd("C://Users//user//Documents//GitHub//ExData_Plotting2")
unzip(".//data//exdata-data-NEI_data.zip")

# install.packages("plyr")
# install.packages("ggplot2")
library(plyr)
library(ggplot2)

# load data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Task6 Compare emissions from motor vehicle sources in Baltimore 
# City with emissions from motor vehicle sources in Los Angeles County,
# California (fips == "06037"). Which city has seen greater changes 
# over time in motor vehicle emissions?

# figuring out what SCC values represent motor vehicle-related sources
MotorRelated <- grep("On-Road", unique(SCC$EI.Sector), value = T)
split <- SCC$EI.Sector %in% MotorRelated
SCCMotor <- subset(SCC, split == T)$SCC

# creating two  subsets of NEI dataset one for baltimore one for la
baltimore <- subset(NEI,NEI$fips == "24510")
la <- subset(NEI, NEI$fips == "06037")

# creating subsets of the two dataset, only contain motor vehicle related sources
split <- baltimore$SCC %in% SCCMotor
motorBaltimore <- subset(baltimore, split == T)
split <- la$SCC %in% SCCMotor
motorLa <- subset(la, split == T)

# calcuating total pm2.5 emissions per year
pm25MotorBaltimore <- ddply(motorBaltimore, .(year), summarise, totalEmissions = sum(Emissions))
pm25MotorLa <- ddply(motorLa, .(year), summarise, totalEmissions = sum(Emissions))

# combining the data sets
pm25MotorBaltimore$location <- "Baltimore"
pm25MotorLa$location <- "Los Angeles County"
two <- rbind(pm25MotorLa, pm25MotorBaltimore)

# creating the plot
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./figure/plot6.png", 
    width = 480, height = 480, 
    units = "px")

g <- qplot(year, totalEmissions, data = two, color = location, geom = c("point","line"))
g + geom_point(size = 4)+labs(y = "Total PM2.5 Emissions", title = "Motor Vehicle Related PM2.5 Emissions Per Year in Baltimore and Los Angeles County")

=======
setwd("~/Desktop/Online Coursera/Coursera-Exploratory-Data-Analysis/ExData_Plotting2/")
unzip("./data/exdata-data-NEI_data.zip", exdir = "./data/")
# Check if both data exist in the environment. If not, load the data.
if (!"neiData" %in% ls()) {
    neiData <- readRDS("./data/summarySCC_PM25.rds")
}
if (!"sccData" %in% ls()) {
    sccData <- readRDS("./data/Source_Classification_Code.rds")
}

subset <- neiData[neiData$fips == "24510"|neiData$fips == "06037", ]

# if (!"load_data.R" %in% list.files()) {
#     setwd("~/Desktop/Online Coursera/Coursera-Exploratory-Data-Analysis/ExData_Plotting2/")
# } 
# source("load_data.R")

library(ggplot2)
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./figure/plot6.png", 
    width = 480, height = 480, 
    units = "px", bg = "transparent")
motor <- grep("motor", sccData$Short.Name, ignore.case = T)
motor <- sccData[motor, ]
motor <- subset[subset$SCC %in% motor$SCC, ]

g <- ggplot(motor, aes(year, Emissions, color = fips))
g + geom_line(stat = "summary", fun.y = "sum") +
    ylab(expression('Total PM'[2.5]*" Emissions")) +
    ggtitle("Comparison of Total Emissions From Motor\n Vehicle Sources in Baltimore City\n and Los Angeles County from 1999 to 2008") +
    scale_colour_discrete(name = "Group", label = c("Los Angeles","Baltimore"))

dev.off()