data_sale = LOAD '/DataBigData/game_sale.csv' USING PigStorage(',') as ( ID:int,Other_Sales:float,Global_Sales:float,NA_Sales:float,EU_Sales:float,JP_Sales:float);

data_game = LOAD '/DataBigData/game.csv' USING PigStorage(',') as ( ID:int,Name:chararray,Platform:chararray,Year:int,Genre:chararray,Publisher:chararray);

data_filter = FILTER data_game by Year > 2009;

data_join = JOIN data_filter BY ID LEFT OUTER, data_sale BY ID;

game_group =  Group data_join BY Genre; 

game_sale_EU = FOREACH game_group GENERATE group as Genre, SUM(data_join.EU_Sales) AS Total_EU_Sales;

game_sale_order = ORDER game_sale_EU BY Total_EU_Sales DESC;

dump game_sale_order;
