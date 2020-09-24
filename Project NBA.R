
#View(NBA_data)
#readRDS(NBA_data)
Roster= NBA_data[["Roster"]]
Game=NBA_data[["Per.Game"]]
Salaries=NBA_data[["Salaries"]]
sum(is.na(Salaries))
dim(Salaries)
#install.packages("dplyr")
library(dplyr)
head(Game,2)
head(Game[2],1)
#-----------------------------------------------------------------------------------------
#RENAMING BLANK COLUMNS
Game=rename(Game,player = 2)
Roster=rename(Roster,x=7)
Salaries=rename(Salaries,player=2)

dim(Game)
#[1] 2867   30
length(unique(Game$player))
#[1] 938
length(unique(Salaries$player))
#1023

#If we had salary for all unique players, for 5 years; we should have 4,690 rows
#938*5
#[1] 4690
length(unique(Game$Year))
#[1] 5
length(unique(Game$Team))
#[1] 30
length(unique(Roster$Player))
#[1] 964

str(Roster)
install.packages("sqldf")
library(sqldf)
LJ_Rosg=sqldf("SELECT * from Roster r
         Left JOIN Game g on r.player=g.player
         WHERE r.Year=g.Year
         AND r.Team=g.Team")
dim(LJ_Rosg)
#[1] 2704   41
dim(Roster)
#[1] 2795   11
t1=Roster%>%left_join(Game,by=c("player"="player","Year"="Year"))

#Salaries LJ game----------------------------------------------------------------------------------------------------------------------


SG=sqldf("SELECT g.*,s.salary from Salaries s,Game g
             WHERE s.player= g.player
             AND s.Year=g.Year
             AND s.Team =g.Team")
SG_LJ=sqldf("SELECT g.*,s.Salary from Salaries s
             LEFT JOIN Game g on s.player= g.player
             WHERE s.Year=g.Year
             AND s.Team =g.Team")

#[1] 2464   35
View(SG)
View(SG_LJ)
dim(SG_LJ)
#[1] 2464   35
sum(is.na(SG_LJ$`3PA`))
#[1] 0
sum(is.na(SG))
#[1] 396
sum(is.na(SG_LJ))
SG=na.omit(SG)
dim(SG)
#[1] 2172   35
str(Roster)
length(unique(Joined$player))
#[1] 780
#SG Left Join Roster----------------------------------------------------------------------------------------------------------------

Joined= sqldf("SELECT t.*,r.Pos,r.Ht,r.Wt,r.Exp,r.College FROM SG t
               LEFT JOIN Roster r on t.player=r.player
              WHERE t.Year=r.Year
              AND t.Team=r.Team")


Joined$Salary=as.numeric(gsub("[\\$,]", "", Joined$Salary))  

Joined$Salary=Joined$Salary/1000000
Joined$Team=as.factor(Joined$Team)
Joined$Year=as.factor(Joined$Year)
Joined$Pos=as.factor(Joined$Pos)
Joined$Ht=as.factor(Joined$Ht)
Joined$Exp=ifelse(Joined$Exp=='R',0,Joined$Exp)
Joined$Exp=as.numeric(Joined$Exp)
Joined$College=as.factor(Joined$College)

str(Joined)

#Converting height to numerical
install.packages("tidyr")
library(tidyr)
Joined = Joined %>% separate( Ht, c('feet', 'inches'), "-", convert = TRUE) %>% mutate(cm = as.numeric((12*feet + inches)*2.54))
Joined$Ht=Joined$cm

dim(Joined)
#[1] 2406   36

Joined=na.omit(Joined)


View(Joined)


agelabels <- c("19-23","24-28","29-33","34-38","39-43")
#unique(cut(RJ$Age, breaks=c(19,24,29,34, 39,44), right = FALSE, labels = agelabels))

#First is start of first fgroup, secong is end of first grp exclusive i.e. below 24, and start of second group, i.e. from 24 0n
#to 29-1, from '29', till 34-1 etc last group is ...from 39 t0 44-1
Joined$AgeGroups= cut(Joined$Age, breaks =c(19,24,29,34,39,44), right = FALSE, labels = agelabels)
View(Joined)
Jtable=Joined
# Long form - clearer---setDT(RJ)[age <24, agegroup := "19-23"]-----------------------------------------------------------------------------
#data[age > (24-1) & age <29, agegroup := "24-28"]
#data[age >(29-1) & age <34, agegroup := "29-33"]
#data[age >(34-1) & age <39, agegroup := "34-38"]
#data[age >(39-1) & age <44, agegroup := "39-43"]

View(Jtable)
hist(Jtable$Age)
#plotting age distribution
ggplot(data=Jtable)+geom_histogram(mapping=aes(x=Age,fill=Pos),bins = 6,color="white",stat = "count")+
                                     labs(title='Age Distribution of Players', x= 'Age', y='Frequency')+
  scale_x_binned(breaks=c(19,23,28,33,38,43))
##Binning experience-------------------------------------------------------------------------------------------------------------------------
Explabels <- c("0-3","4-16","17-21")
Jtable$Expgrps=cut(Jtable$Exp, breaks = c(0,4,17,22),right = FALSE, labels = Explabels)
##Binning Height-----------------------------------------------------------------------------------------------------------------------------

hist(Jtable$Ht)
range(Jtable$Ht)
sort(unique(Jtable$Ht))
ggplot(data=Jtable)+geom_histogram(mapping=aes(x=Ht,fill=Pos),bins =10,color="white",stat = "count")+
  labs(title='Height Distribution of Players', x = 'Height', y ='Frequency')+
  scale_x_binned(breaks=c(175,180,185,190,195,200,205,210,215,220,224))

Htlabels <- c("175-179","180-184","185-189","190-194","195-199","200-204","205-209","210-214","215-219","220-224")
Jtable$Htgrps=cut(Jtable$Ht, breaks = c(175,180,185,190,195,200,205,210,215,220,224) ,right = FALSE, labels = Htlabels)
#View(cbind(Jtable$Exp,Jtable$Expgrps))

#Reducing Join by removing percentages-------------------------------------------------------------------------------------------------------

RJ=Jtable[,!colnames(Jtable) %in% c('Rk','FG%','3P%','2P%','eFG%','FT%')]
#View(RJ)


#install.packages("corrplot")
library(corrplot)
range(RJ$Age)
#[1] 19 43
str(RJnumeric)
#class(Bdata$TAX)
RJ=na.omit(RJ)

categorical=c("player","Team","Pos","Ht","Htgrps","College","AgeGroups","Exp","Expgrps","Age","Year")
RJnumeric=RJ[,!colnames(RJ) %in% c(categorical)]
#str(RJnumeric)
cormat=cor(RJnumeric)
corrplot(cormat, method= "circle")

plot(RJnumeric)
#Removing G,GS,3P,3PA,MP,FGA,FT,FTA  Keep FG, remove 2PA, keep 2P, keep DRB,TOV,PTS/G
#So..keep FG,2P,DRB,TOV,PTS/G


plot(RJnumeric[,colnames(RJnumeric) %in% c('FG','2P',"DRB",'TOV','PTS/G','Salary')])
#Remove FG.

numericskeep= c('2p',"DRB",'TOV','PTS/G','Salary')
To_keep=rbind(categorical,numericskeep)

#Analytics table-------------------------------------------------------------------------------------------------------------------------------

Analyticstable=RJ[,colnames(RJ) %in% c('2p',"DRB",'TOV','PTS/G','Salary',"player","Team","Pos","Ht","College","AgeGroups","Exp","Age","Year")]
AT=RJ[,colnames(RJ) %in% c(To_keep)]


#model,check plots,regsubsets

### Question 1
#Using forward selection (with AIC), find the best subset of predictor variables to predict Box.Office.

fullmodel <- formula(lm(Salary ~ ., data = AT[,!colnames(Jtable) %in% c('player')]))
step1 <- step(lm(Salary ~ 1, data = AT), direction = "forward", scope = fullmodel, trace = 0)
summary(step1)
#Adjusted R-squared:  0.5798
m1=lm(formula = Salary ~ `PTS/G` + Exp + AgeGroups + DRB + Year + 
        Age + TOV + Pos + Team, data = AT)

#Removing 0 salaries
Jtable2<- subset(Jtable, Salary >0)

#AIC ON Joined
Jtable=Joined
dim(Jtable)
fullmodel <- formula(lm(Salary ~ ., data = Jtable[,!colnames(Jtable) %in% c("player","Age")]))
step2 <- step(lm(Salary ~ 1, data = Jtable[,!colnames(Jtable) %in% c("player","Age")]), 
              direction = "forward", scope = fullmodel, trace = 0)
summary(step2)
#Adjusted R-squared:  0.6289 
m2=lm(formula = Salary ~ `PTS/G` + Expgrps + DRB + Year + PF + GS + 
        AST + cm + `eFG%` + AgeGroups + FT + `FT%` + `2PA` + BLK + 
        Wt + `2P%`, data = Jtable[, !colnames(Jtable) %in% c("player", "Age")])
summary(m2)
m2s=summary(m2)
plot(m2)
str(Joined)
#Adjusted R-squared:  0.6273


#salaries>0-     AIC on Joined--------------------------------------------------------------------------------------------------------------------------------------
fullmodel <- formula(lm(Salary ~ ., data = Jtable2[,!colnames(Jtable2) %in% c("player","Age")]))
step2a <- step(lm(Salary ~ 1, data = Jtable2[,!colnames(Jtable2) %in% c("player","Age")]), 
              direction = "forward", scope = fullmodel, trace = 0)
summary(step2)
#Adjusted R-squared:  0.629
m2a=lm(formula = Salary ~ `PTS/G` + Expgrps + DRB + Year + PF + GS + 
        AST + cm + `eFG%` + AgeGroups + FT + `FT%` + `2PA` + BLK + 
        Wt + `2P%`, data = Jtable2[, !colnames(Jtable2) %in% c("player", "Age")])

plot(m2a)
Jtable22=Jtable2

colSums(Jtable22 == 0)

colSums(Jtable2 < 0)
colSums(Jtable2 == 0)
Jtable22=Jtable2
Jtable22$GS=Jtable2$GS+1
Jtable22$FG =Jtable2$FG+1 
Jtable22$`FG%`=Jtable2$`FG%`+1
Jtable22$`3P%`=Jtable2$`3P%`+1
Jtable22$`3P`=Jtable2$`3P`+1
Jtable22$`3PA`=Jtable2$`3PA`+1
Jtable22$`2P`=Jtable2$`2P`+1
Jtable22$`2P%`=Jtable2$`2P%`+1
Jtable22$`eFG%`=Jtable2$`eFG%`+1
Jtable22$FT=Jtable2$FT+1
Jtable22$FTA=Jtable2$FTA+1
Jtable22$`FT%`=Jtable2$`FT%`+1
Jtable22$ORB=Jtable2$ORB+1
Jtable22$DRB=Jtable2$DRB+1
Jtable22$TRB=Jtable2$TRB+1
Jtable22$AST=Jtable2$AST+1
Jtable22$STL=Jtable2$STL+1
Jtable22$BLK=Jtable2$BLK+1
Jtable22$TOV=Jtable2$TOV+1
Jtable22$PF=Jtable2$PF+1
Jtable22$inches=Jtable2$inches+1
Jtable22$Exp=Jtable2$Exp+1
str(Jtable2)
head(Jtable22$Exp,2)



m2at=lm(log(Salary) ~ `PTS/G` + Expgrps + DRB + PF + GS + 
         AST + cm + `eFG%` + AgeGroups + FT + `FT%` + `2PA` + BLK + 
         Wt + `2P%`, data = Jtable2[, !colnames(Jtable2) %in% c("player", "Age")])
summary(m2at)
plot(m2at)


#Interpretation-----------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------


install.packages("lmtest")
library(lmtest)
bptest(m2at)

m2at2=lm( log(Salary) ~ log(`PTS/G`) + Expgrps + log(DRB) + Year + log(PF) + log(GS) + 
        log( AST) + log(cm) + log(`eFG%`) + AgeGroups + log(FT) + log(`FT%`) + log(`2PA`) + log(BLK) + 
         log(Wt) + log(`2P%`), data = Jtable2[, !colnames(Jtable2) %in% c("player", "Age")])
plot(m2at)

#________________________________________________________________________________________________________________________________________________

m2b=lm(log(Salary) ~ log(`PTS/G`) + Expgrps + log(DRB) + Year + log(PF) +log(GS)+ 
         log(AST) + log(cm)+ log(`eFG%`) + log(FG) + log(`FT%`),
       data = Jtable22[, !colnames(Jtable22) %in% c("player")])
summary(m2b)
plot(m2b)


#_________________________________________________________________________________________________________________________________________________
m2p=lm(log(Salary) ~ sqrt(`PTS/G`)+Expgrps+sqrt(DRB)+Year+sqrt(PF)+sqrt(GS)+
         sqrt(AST)+sqrt(cm)+sqrt(`eFG%`)+sqrt(FG)+sqrt(`FT%`),
       data = Jtable22[, !colnames(Jtable22) %in% c("player", "Age")])
summary(m2p)
plot(m2p)



#Using backward crossvalidation AIC
step2b <- step(lm(Salary~ ., data = AT[,!colnames(AT) %in% c('player')]), direction = "backward", trace = 0)
summary(step2b)
#Adjusted R-squared:  0.5798 


#-----------------------------------------------------------------------------------------------------------------------------------------------------
#BIC forward
n=nrow(Jtable[,!colnames(Jtable) %in% c('player')])
fullmodel <- formula(lm(Salary ~ .,data = Jtable[,!colnames(Jtable) %in% c('player')]))
step3 <- step(lm(Salary ~ 1, data = Jtable[,!colnames(Jtable) %in% c('player')]), direction = "forward", scope = fullmodel, k = log(n), trace = 0)
summary(step3)
#Adjusted R-squared:  0.6248 
m3=lm(Salary ~ `PTS/G` + Expgrps + DRB + Year + PF + GS + 
        AST + cm + `eFG%` + FG + `FT%`, data = Jtable[, !colnames(Jtable) %in% c("player")])
m3s=summary(m3)   



                                                    
##CHANGE QSTN? Predict Pointe per game for each player                            
mx=lm(`PTS/G`~ Expgrps + DRB + Year + PF + GS +  AST + cm + `eFG%` + FG + `FT%`, data = Jtable[, !colnames(Jtable) %in% c("player","Salary")])
mfull=lm(`PTS/G`~ . ,Jtable[, !colnames(Jtable) %in% c("player","Salary")])                           

fm=lm(Salary~ ., data=Jtable[,!colnames(Joined) %in% c('player')])
#summary(fm)

#Adjusted R-squared:  0.6517 

















