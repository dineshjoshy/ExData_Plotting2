
#setting directory and extracting data
setwd("C://Users//user//Documents//GitHub//ExData_Plotting2")
unzip(".//data//exdata-data-NEI_data.zip")


# install.packages("plyr")
library(plyr)

# load data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Task 2 Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system
# to make a plot answering this question.

# create subset only contain data about baltimore
baltimore <- subset(NEI,NEI$fips == "24510")

# calculating total emissions for each year in baltimore
pm25Baltimore <- ddply(baltimore, .(year), summarise, totalEmissions = sum(Emissions))

# creating the plot
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./figure/plot2.png", 
    width = 480, height = 480, 
    units = "px")
totalEmissions <- aggregate(pm25Baltimore$totalEmissions, list(pm25Baltimore$year), FUN = "sum")
# options(scipen=0)
# options(scipen=999)
plot(totalEmissions, type = "l", xlab = "Year", 
     main = "Total Emissions in Baltimore City from 1999 to 2008", 
     ylab = expression('Total PM'[2.5]*" Emission"))

dev.off()

