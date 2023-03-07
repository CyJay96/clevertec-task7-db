-- Вывести к каждому самолету класс обслуживания и количество мест этого класса:
select a.model, a.aircraft_code, s.fare_conditions, count(s.seat_no) from aircrafts a
inner join seats s on a.aircraft_code = s.aircraft_code
group by a.model, a.aircraft_code, s.fare_conditions
order by a.model, s.fare_conditions;

-- Найти 3 самых вместительных самолета (модель + кол-во мест):
select a.model, count(s.seat_no) seats_count from aircrafts a
inner join seats s on a.aircraft_code = s.aircraft_code
group by a.model
order by seats_count desc
limit 3;

-- Вывести код, модель самолета и места не эконом класса для самолета 'Аэробус A321-200' с сортировкой по местам:
select a.aircraft_code, a.model, s.fare_conditions, s.seat_no from aircrafts a
inner join seats s on a.aircraft_code = s.aircraft_code
where a.model = 'Аэробус A321-200' and s.fare_conditions != 'Economy'
order by s.seat_no;

-- Вывести города в которых больше 1 аэропорта (код аэропорта, аэропорт, город):
select airport_code, airport_name, city from airports a1
where (select count(city) from airports a2 where a1.city = a2.city) > 1;

-- Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация:
-- Способ 1:
select f.*, dep.city departure_city, arr.city arrival_city from flights f, airports dep, airports arr
where f.departure_airport = dep.airport_code AND f.arrival_airport = arr.airport_code and
      dep.city = 'Екатеринбург' and arr.city = 'Москва' and f.status in ('Scheduled', 'On Time', 'Delayed')
order by f.actual_departure
limit 1;
-- Способ 2:
select f.*, dep.city departure_city, arr.city arrival_city from flights f
inner join airports dep on f.departure_airport = dep.airport_code
inner join airports arr on f.arrival_airport = arr.airport_code
where dep.city = 'Екатеринбург' and arr.city = 'Москва' and f.status in ('Scheduled', 'On Time', 'Delayed')
order by f.actual_departure
limit 1;
-- Способ 3 - через представление:
select * from flights_v
where departure_city = 'Екатеринбург' and  arrival_city = 'Москва' and status in ('Scheduled', 'On Time', 'Delayed')
order by departure_city
limit 1;

-- Вывести самый дешевый и дорогой билет и стоимость (в одном результирующем ответе):
-- Способ 1:
(select * from ticket_flights
 order by amount
 limit 1)
union
(select * from ticket_flights
 order by amount desc
 limit 1);
-- Способ 2:
(select * from ticket_flights
 where amount = (select min(amount) from ticket_flights)
 limit 1)
union
(select * from ticket_flights
 where amount = (select max(amount) from ticket_flights)
 limit 1);
