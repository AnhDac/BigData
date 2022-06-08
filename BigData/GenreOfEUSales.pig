data_sale = LOAD '/Pig_Data/covid_19_clean_complete.csv' USING PigStorage(',') as ( ID:int,Other_Sales:int,Global_Sales:int,NA_Sales:int,EU_Sales:int,JP_Sales:int);

data_game = LOAD '/Pig_Data/covid_19_clean_complete.csv' USING PigStorage(',') as ( ID:int,Name:chararray,Platform:chararray,Year:int,Genre:chararray,Publisher:chararray);

data_filter = FILTER data_gamefull by Year > 2009;

data_join = JOIN data_filter BY ID, data_sale BY ID;

game_group =  Group data_join BY Genre; 

game_sale_EU= FOREACH game_group GENERATE group as Genre, SUM(data_join.EU_Sales) AS Total_EU_Sales;

dump game_sale_EU;