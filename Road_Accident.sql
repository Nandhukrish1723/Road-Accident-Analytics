select * from road_acc
select SUM(number_of_casualties) as CY_Casualties from road_acc where YEAR(accident_date)='2022'
select COUNT(Distinct accident_index) as CY_Accidents from road_acc where YEAR(accident_date)='2022'
-- CY_Fatal_Casualties
select SUM(number_of_casualties) as CY_Fatal_Casualties from road_acc where YEAR(accident_date)='2022' and accident_severity = 'Fatal'
-- CY_Serious_Casualties
select SUM(number_of_casualties) as CY_Serious_Casualties from road_acc where YEAR(accident_date)='2022' and accident_severity = 'Serious'
-- CY_Slight_Casualties
select SUM(number_of_casualties) as CY_Slight_Casualties from road_acc where YEAR(accident_date)='2022' and accident_severity = 'Slight'
-- CY Slight,Fatal,Serious Casualties & PCT
select CAST(sum(number_of_casualties) as decimal(10,2))*100/(select CAST(sum(number_of_casualties) as decimal(10,2)) from road_acc) as PCT from road_acc where accident_severity='Fatal'
-- Casualties by Vehiles
select
case
	when vehicle_type In ('Agricultural vehicle') then 'Agricultural'
	when vehicle_type in ('Car', 'Taxi/Private hire car') then 'Cars'
	when vehicle_type in ('Motorcylce 125cc and under', 'Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') then 'Bikes'
	when vehicle_type in ('Bus or coach(17 or more pass seats)','Minibus(8-16 passenger seats)') then 'Bus'
	when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van/Goods 3.5 tonnes mgw or under') then 'Van'
	else 'Other'
end as Vehicle_group,
SUM(number_of_casualties) as CY_Casualties
from road_acc
where YEAR(accident_date) = '2022'
group by
	case
	when vehicle_type In ('Agricultural vehicle') then 'Agricultural'
	when vehicle_type in ('Car', 'Taxi/Private hire car') then 'Cars'
	when vehicle_type in ('Motorcylce 125cc and under', 'Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') then 'Bikes'
	when vehicle_type in ('Bus or coach(17 or more pass seats)','Minibus(8-16 passenger seats)') then 'Bus'
	when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van/Goods 3.5 tonnes mgw or under') then 'Van'
	else 'Other'
	end
	-- Monthly trend by CY_Casualties
	select DATENAME(Month, accident_date) as Month_Name,SUM(number_of_casualties) as CY_Casualties
	from road_acc
	where YEAR(accident_date) = '2022'
	group by DATENAME(month, accident_date)
	-- Casualties by Road_Type
	select road_type as Road_Type, SUM(number_of_casualties) as CY_Casualties from road_acc
	where YEAR(accident_date) = '2022'
	group by road_type
	-- Casualties by Urban/Rural & Percent of Total
select urban_or_rural_area as Urban_or_Rural,SUM(number_of_casualties) as CY_Casualties,CAST(round(SUM(number_of_casualties)*100/
	(select SUM(number_of_casualties)  from road_acc where YEAR(accident_date) = '2022'),2) as decimal(10,2)) as Percent_of_Casualties
	from road_acc
	where YEAR(accident_date) = '2022'
	group by urban_or_rural_area
	-- Casualties by Light_Condition
select
case
	when light_conditions In ('Daylight') then 'Day'
	when light_conditions In ('Darkness - lighting unknown','Darkness - lights lit','Darkness - lights unlit','Darkness - no lighting') then 'Night'
end as Light_Conditions,
cast(cast(SUM(number_of_casualties) as decimal(10,2))*100/
(select CAST(sum(number_of_casualties) as decimal(10,2)) from road_acc where year(accident_date) = '2022') as decimal(10,2)) as CY_Casualties_PCT
from road_acc
where YEAR(accident_date) = '2022'
group by
	case
	when light_conditions In ('Daylight') then 'Day'
	when light_conditions In ('Darkness - lighting unknown','Darkness - lights lit','Darkness - lights unlit','Darkness - no lighting') then 'Night'
	end
	-- TOP 10 Locations by No_of_Casualties
	select top 10 local_authority, SUM(number_of_casualties) as Total_Casualties
	from road_acc
	group by local_authority
	order by Total_Casualties Desc
	