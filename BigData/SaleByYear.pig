data_sale = LOAD '/Pig_Data/covid_19_clean_complete.csv' USING PigStorage(',') as ( ID:int,Other_Sales:int,Global_Sales:int,NA_Sales:int,EU_Sales:int,JP_Sales:int);

data_game = LOAD '/Pig_Data/covid_19_clean_complete.csv' USING PigStorage(',') as ( ID:int,Name:chararray,Platform:chararray,Year:int,Genre:chararray,Publisher:chararray);

data_gamefull= JOIN data_game BY ID, data_sale BY ID;

game_group =  Group data_gamefull BY Year; 

game_by_year = FOREACH game_group GENERATE group as Year, data_gamefull.Name,data_gamefull.Genre, MAX(data_gamefull.Global_Sales) AS Global_Sales;

dump game_by_year;	