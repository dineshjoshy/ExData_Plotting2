
#setting directory and extracting data
setwd("C://Users//user//Documents//GitHub//ExData_Plotting2")
unzip(".//data//exdata-data-NEI_data.zip")

# install.packages("plyr")
library(plyr)

# load data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# task 1 Have total emissions from PM2.5 decreased in the United States
# from 1999 to 2008? Using the base plotting system, make a plot showing
# the total PM2.5 emission from all sources for each of the years 1999, 
# 2002, 2005, and 2008.

# calculate total pm2.5 emissions for each year
pm25 <- ddply(NEI, .(year), summarise, totalEmissions = sum(Emissions))

# creating plots
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./figure/plot1.png", 
    width = 480, height = 480, 
    units = "px")
totalEmissions <- aggregate(NEI$Emissions, list(NEI$year), FUN = "sum")
# options(scipen=0)
# options(scipen=999)
plot(totalEmissions, type = "l", xlab = "Year", 
     main = "Total Emissions in the United States from 1999 to 2008", 
     ylab = expression('Total PM'[2.5]*" Emission"))


dev.off()



