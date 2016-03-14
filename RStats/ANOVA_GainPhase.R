#To run an ANOVA on my data

#I saved the data in an excel file called output_GPh.xlsx

#Now to perform the excel import my data as shown in Stats 
#course from UCI (lecture 1).

library(xlsx)
#To read data from sheet 1 of my output_GPh.xlsx,
output_GPh <- read.xlsx('output_GPh.xlsx', 1, header = T)

#To import each category
MorN <- output_GPh$MorN
#Here 'm' means magnetic and 'n' means non-magnetic

Gain <- output_GPh$Gain
PhaseDiff <- output_GPh$PhaseDiff

MorN <-as.factor(MorN)
model_Gain <- aov(Gain ~ MorN)
summary(model_Gain)
plot(Gain~factor(MorN))

model_PhaseDiff <- aov(PhaseDiff ~ MorN)
summary(model_PhaseDiff)
plot(PhaseDiff~factor(MorN))
