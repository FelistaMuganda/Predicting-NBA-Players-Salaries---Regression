# Predicting-NBA-Players-Salaries---SQLdf & Regression (Team Project)

# Summary
The objective of the project was to predict an NBA player's salary and find key characteristics that drive these salaries, e.g. type of baskets scored, number of baskets scored etc. through statistical modelling.

Five years wrth of data from basketball leagues was obtained from a sports website, cleaned, tables describing different aspects of the players joined with SQLdf, prediction done with linear regression, and a log transformation on dependent variable (Salaries) implemented to get better fitting model.

AIC and BIC techniques were used for model reduction


# Motivation
The motivation for the project was evaluate which variables describing the player’s physique 
and game efficiency are most influential in determining their salary. Our presumption was that a 
strong positive correlation exists between points per game and salary. We also wanted to see 
whether the kind of points made i.e. whether 3-pointers or 2-pointers, would have a different
effect on the player’s salary. 

Starting out with a linear regression, we expected a lot of the variables to be dropped, due to high 
correlation between the variables. We were also eager to see the relationship between variables 
that measure the efficiency of a player such as their years of experience, with salary. Does their 
salary increase at a decreasing rate with experience? i.e. is there a peak number of years of 
experience after which the increase in experience does not translate to an increase in salary?
We also wanted to test the old basketball ‘myth’ that height is key in the game, and so were 
looking out to see if height got picked by the model as a significant regressor. It was not.

# Introduction
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
The data was scraped from the website with the assistance of Scott. It was then joined using 
SQLDF. Since the Roster table entries were less than those in per game, we did an inner join 
with the Roster table and game table to get only the variables in both tables. We then did a left 
join on the Salaries table as the base table with this joined table.

We then binned the player’s height, age, and experience. Heights were binned in 2-year
intervals, age was binned into 3 year intervals and Experience into 3 bins: ‘0-3’ , ‘4-16’, ‘17-21’ 
based on the similar coefficients observed between 0-3 years, 4-6 years’ experience, and 17-21 
years.
