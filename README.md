# Predicting-NBA-Players-Salaries---SQLdf & Regression (Team Project)

# Summary
The objective of the project was to predict an NBA player's salary and find key characteristics that drive these salaries, e.g. type of baskets scored, number of baskets scored etc. through statistical modelling.

Five years wrth of data from basketball leagues was obtained from a sports website, cleaned, tables describing different aspects of the players joined with SQLdf, prediction done with linear regression, and a log transformation on dependent variable (Salaries) implemented to get better fitting model.

AIC and BIC techniques were used for model reduction


# Motivation
The motivation for the project was to evaluate which variables describing the player’s physique 
and game efficiency drive their salary. Our presumption was that a 
strong positive correlation exists between points per game and salary. We also wanted to see 
whether the kind of points made i.e. whether 3-pointers or 2-pointers, would have a different
effect on the player’s salary. 

We were also eager to see the relationship between variables 
that measure the efficiency of a player such as their years of experience, with salary. Does their 
salary increase at a decreasing rate with experience? i.e. is there a peak number of years of 
experience after which the increase in experience does not translate to an increase in salary?
We also wanted to test the old basketball ‘myth’ that height is key in the game, and so were 
looking out to see if height got picked by the model as a significant regressor. It was not.

# Data
We obtained NBA basketball data from https://www.basketball-reference.com/. This data was 
split up into several tables, and we chose three to model the player’s salary. They are as 
follows:

1. The Roster table which contained details of the player such as their Name, Position, 
Height, Weight, their date of birth, years of experience and finally the College they were 
recruited from. 

2. The Per Game table which included the following variables (the quantitative ones are an 
average for a particular year: The player’s rank, name, age,
The average number of:
• Games played in a particular year, games started, minutes played, field goals 
made per game, field goal attempts made per game, 3-point field goals made per 
game, 3-point field goal attempts per game, 2-point field goals made per game, 
2-point field goal attempts made per game, offensive rebounds per game, 
defensive rebounds per game, total rebounds per game , assists per game, steals 
per game, blocks per game, turnovers per game, personal fouls per game, points 
per game

3. The Salaries table: Player’s name, salary for the year3

# Modelling Process

# Data Preparation
The data was scraped from the website. It was then joined using 
SQLDF. Since the Roster table entries were less than those in per game, we did an inner join 
with the Roster table and game table to get only the variables in both tables. We then did a left 
join on the Salaries table as the base table with this joined table.

We then binned the player’s height, age, and experience. Heights were binned in 2-year
intervals, age was binned into 3 year intervals and Experience into 3 bins: ‘0-3’ , ‘4-16’, ‘17-21’ 
based on the similar coefficients observed between 0-3 years, 4-6 years’ experience, and 17-21 
years.

The notebook includes:
1. Exploratory Data Analysis
2. Modelling process :
      . Base model - linear regression
      . Variable selection using AIC and BIC methods - Starting out with a linear regression, we expected a lot of the variables to be dropped, due to high 
correlation between the variables.
      . Evaluation of whether the data fits a linear model using residual and Q-Q plots and RMSE
      . Log transformation to better fit a linear regression
3. Interprating the model

# Conclusion
In summary, a player earnings are mainly impacted by his scoring ability (measured 
by points per game, effective field goals percentage, rebounds and the assists the player made 
to help another player score) and declines with increasing personal fouls. Players who are 
efficient scorers and low on fouls have a higher salary. Mid-range experience (4-16 years) is also 
the peak of increasing salary. After a certain number of years, experience does not add too
much value to a player’s technique

