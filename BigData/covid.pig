data = LOAD '/Pig_Data/covid_19_clean_complete.csv' USING PigStorage(',') as ( Country:chararray, Lat:float ,Long:float, Date:chararray,Confirmed:int,Deaths:int,Recovered:int, Active:chararray);
data_region = LOAD '/Pig_Data/RegionOfCountry.csv' USING PigStorage(',') as (Country:chararray, WHORegion:chararray);
data_group = Group data BY Country; 
covid_by_country = FOREACH data_group GENERATE group as Country, MAX(data.Confirmed) AS confirmed;
data_join= JOIN covid_by_country BY Country , data_region BY Country;
data_join_group = Group data_join BY WHORegion; 
result = FOREACH data_join_group GENERATE group as Continent, SUM(data_join.confirmed) as totalConfirm;
dump result;