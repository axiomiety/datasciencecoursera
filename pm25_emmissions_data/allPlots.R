#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

plot1 <- function() {
  total_emissions_by_year <- tapply(NEI$Emissions, NEI$year, sum)
  df <- data.frame(total_emissions_by_year)
  png("plot1.png",width = 480,height = 480,units="px",bg="transparent")
  plot(rownames(df), df$total_emissions_by_year, pch=19, xlab="Year", ylab="Total Emissions")
  dev.off()
}

plot2 <- function() {
  baltimore_maryland <- NEI[NEI$fips == "24510",]
  total_emissions_by_year_for_baltimore <- tapply(baltimore_maryland$Emissions, baltimore_maryland$year, sum)
  df <- data.frame(total_emissions_by_year_for_baltimore)
  png("plot2.png",width = 480,height = 480,units="px",bg="transparent")
  plot(rownames(df), df$total_emissions_by_year_for_baltimore, pch=19, xlab="Year", ylab="Total Emissions (Baltimore)")
  dev.off()
}

plot3 <- function() {
  library(ggplot2)
  library(dplyr)
  baltimore_maryland <- NEI[NEI$fips == "24510",]
  baltimore_maryland$type <- as.factor(baltimore_maryland$type)
  s <- baltimore_maryland %>%
        group_by(type, year) %>%
        summarise(total=sum(Emissions))
  ggplot(s, aes(x=year, y=total, color=type)) +
      geom_line() +
      geom_point() +
      labs(color="Source Type", x="Year", y="Total Emissions (Baltimore)")
}

plot4 <- function() {
  library(dplyr)
  scc_combustion_coal <- dplyr::filter(SCC, grepl("Combustion", SCC.Level.One), grepl("Coal", SCC.Level.Three))
  coal_subset <- subset(NEI, SCC %in% scc_combustion_coal$SCC)
  total_coal_emissions_by_year <- tapply(coal_subset$Emissions, coal_subset$year, sum)
  df <- data.frame(total_coal_emissions_by_year)
  #TODO convert as numeric!
  plot(rownames(df), df$total_coal_emissions_by_year, pch=19, xlab="Year",
       ylab="Total Emissions (Coal)")
}

plot5 <- function() {
  library(dplyr)
  scc_motor_vehicles <- dplyr::filter(SCC, grepl("Mobile Sources", SCC.Level.One), grepl("Vehicles", SCC.Level.Two))
  motor_vehicles_baltimore <- filter(NEI, SCC %in% scc_motor_vehicles$SCC, fips == "24510")
  total_motor_vehicles_baltimore <- tapply(motor_vehicles_baltimore$Emissions, motor_vehicles_baltimore$year, sum)
  df <- data.frame(total_motor_vehicles_baltimore)
  ggplot(df, aes(x=rownames(df),y=total_motor_vehicles_baltimore)) +
    geom_line() +
    geom_point()
}

plot6 <- function() {
  la_california <- NEI[NEI$fips = "06037"]
  total_emissions_by_year_for_la <- tapply(la_california$Emissions, la_california$year, sum)
  df_la = data.frame(year=names(total_emissions_by_year_for_la), emissions=as.numeric(total_emissions_by_year_for_la))
  df_baltimore = data.frame(year=names(total_emissions_by_year_for_baltimore), emissions=as.numeric(total_emissions_by_year_for_baltimore))
  m <- merge(df_la, df_baltimore, by="year")
  g <- gather(m, A,B,2:3)
  ggplot(g, aes(x=year,y=B,color=A)) +
    geom_line() +
    geom_point()
}