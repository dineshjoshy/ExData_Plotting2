
#setting directory and extracting data
setwd("C://Users//user//Documents//GitHub//ExData_Plotting2")
unzip(".//data//exdata-data-NEI_data.zip")

# install.packages("ggplot2")
# install.packages("plyr")
library(plyr)
library(ggplot2)

# load data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Task4 Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999 t0 2008?

# figuring out what SCC values represent coal combustion-related sources
CoalRelated <- grep("Coal", unique(SCC$EI.Sector), value = T)
split <- SCC$EI.Sector %in% CoalRelated
SCCCoal <- subset(SCC, split == T)$SCC

# creating a subset of the NEI dataset, only contain coal combustion-related sources
split <- NEI$SCC %in% SCCCoal
coal <- subset(NEI, split == T)

# calcuating total pm2.5 emissions per year
pm25Coal <- ddply(coal, .(year), summarise, totalEmissions = sum(Emissions))

# creating plot
png(filename = "./figure/plot4.png", 
    width = 480, height = 480, 
    units = "px")

plot(pm25Coal$year,pm25Coal$totalEmissions, xlab="Year", ylab = "Total PM2.5 Emission", pch = 19, col = "blue")
title(main= "Total PM2.5 Emissions From Coal Combustion Related Sources")

dev.off()