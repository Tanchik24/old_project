1) База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:
SELECT a.city,
       count(a.airport_code) airports
FROM dst_project.airports a
GROUP BY a.city
ORDER BY 2 DESC

2)
Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. Сколько всего статусов для рейсов определено в таблице?
select count(distinct status)
from dst_project.flights

Какое количество самолетов находятся в воздухе на момент среза в базе (статус рейса «самолёт уже вылетел и находится в воздухе»).
select count(status)
from dst_project.flights
where status = 'Departed'

Места определяют схему салона каждой модели. Сколько мест имеет самолет модели  (Boeing 777-300)?
SELECT count(s.seat_no)
FROM dst_project.aircrafts a
JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code
WHERE a.model = 'Boeing 777-300'

Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года?
SELECT count(f.flight_id)
FROM dst_project.flights f
WHERE f.scheduled_departure >= '2017-04-01'::date
  AND f.scheduled_departure <= '2017-09-01'::date
  AND f.status = 'Arrived'

3)
Сколько всего рейсов было отменено по данным базы?
SELECT count(f.flight_id)
FROM dst_project.flights f
WHERE f.status = 'Cancelled'

Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок?
SELECT 'Boeing' model,
                count(*)
FROM dst_project.aircrafts
WHERE model = 'Boeing 777-300'
  OR model = 'Boeing 767-300'
  OR model = 'Boeing 737-300'
UNION
SELECT 'Sukhoi Superjet',
       count(*)
FROM dst_project.aircrafts
WHERE model = 'Sukhoi Superjet-100'
UNION
SELECT 'Airbus',
       count(*)
FROM dst_project.aircrafts
WHERE model = 'Airbus A320-200'
  OR model = 'Airbus A321-200'
  OR model = 'Airbus A319-100'

В какой части (частях) света находится больше аэропортов?
SELECT 'Asia' continent,
              count(*)
FROM dst_project.airports
WHERE timezone like 'Asia%'
UNION
SELECT 'Europe',
       count(*)
FROM dst_project.airports
WHERE timezone like 'Europe%'

 У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id).
 SELECT date_trunc('hour', (scheduled_arrival - actual_arrival)) delay,
       flight_id
FROM dst_project.flights
ORDER BY 1

4)
Когда был запланирован самый первый вылет, сохраненный в базе данных?
select min(scheduled_departure)
from dst_project.flights

Сколько минут составляет запланированное время полета в самом длительном рейсе?
SELECT max(extract('hour'
                   FROM (scheduled_arrival - scheduled_departure)) * 60 + extract('minute'
                                                                                  FROM (scheduled_arrival - scheduled_departure)))
FROM dst_project.flights

Между какими аэропортами пролегает самый длительный по времени запланированный рейс?
SELECT flight_id,
       extract('hour'
               FROM (scheduled_arrival - scheduled_departure)) * 60 + extract('minute'
                                                                              FROM (scheduled_arrival - scheduled_departure)),
       departure_airport,
       arrival_airport
FROM dst_project.flights
ORDER BY 2 DESC


Сколько составляет средняя дальность полета среди всех самолетов в минутах? Секунды округляются в меньшую сторону (отбрасываются до минут).
SELECT sum(extract('hour'
                   FROM (scheduled_arrival - scheduled_departure)) * 60 + extract('minute'
                                                                                  FROM (scheduled_arrival - scheduled_departure)))/ count(*) sum_duration
FROM dst_project.flights


5)
Мест какого класса у SU9 больше всего?
SELECT count(s.fare_conditions),
       s.fare_conditions
FROM dst_project.aircrafts a
JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code
WHERE a.aircraft_code = 'SU9'
GROUP BY s.fare_conditions
ORDER BY 1 DESC


Какую самую минимальную стоимость составило бронирование за всю историю?
select
min(total_amount)
from dst_project.bookings


Какой номер места был у пассажира с id = 4313 788533?
SELECT b.seat_no
FROM dst_project.tickets t
JOIN dst_project.boarding_passes b ON t.ticket_no = b.ticket_no
WHERE t.passenger_id = '4313788533'

АНАПА

Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?
SELECT count(*)
FROM dst_project.airports a
JOIN dst_project.flights f ON a.airport_code = f.arrival_airport
WHERE city = 'Anapa'
  AND extract('year'
              FROM actual_arrival) = 2017

Сколько рейсов из Анапы вылетело зимой 2017 года?
SELECT count(*)
FROM dst_project.airports a
JOIN dst_project.flights f ON a.airport_code = f.arrival_airport
WHERE city = 'Anapa'
  AND extract('year'
              FROM actual_departure) = 2017
  AND extract('month'
              FROM actual_departure) in (12,
                                         01,
                                         02)


Посчитайте количество отмененных рейсов из Анапы за все время.
SELECT count(*)
FROM dst_project.airports a
JOIN dst_project.flights f ON a.airport_code = f.arrival_airport
WHERE city = 'Anapa'
  AND f.status = 'Cancelled'


Сколько рейсов из Анапы не летают в Москву?
SELECT count(*)
FROM dst_project.airports a
JOIN dst_project.flights f ON a.airport_code = f.arrival_airport
WHERE departure_airport = 'AAQ'
  AND arrival_airport != 'SVO'


Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?
SELECT ac.model,
       count(seat_no)
FROM dst_project.flights f
JOIN dst_project.airports ap ON ap.airport_code = f.departure_airport
JOIN dst_project.aircrafts ac ON f.aircraft_code = ac.aircraft_code
JOIN dst_project.seats s ON ac.aircraft_code = s.aircraft_code
WHERE city = 'Anapa'
GROUP BY ac.model


Конечный запрос: 

WITH main_db AS
  (SELECT *
   FROM dst_project.flights
   WHERE departure_airport = 'AAQ'
     AND (date_trunc('month', scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
     AND status not in ('Cancelled') ),
     fuel_consumption AS
  (SELECT 'Boeing 777-300' model,
                           '773' aircraft_code,
                                 115 kg_per_min
   UNION SELECT 'Boeing 767-300',
                '763',
                75
   UNION SELECT 'Sukhoi Superjet-100',
                'SU9',
                28
   UNION SELECT 'Airbus A320-200',
                '320',
                43
   UNION SELECT 'Airbus A321-200',
                '321',
                53
   UNION SELECT 'Airbus A319-100',
                '319',
                43
   UNION SELECT 'Boeing 737-300',
                '733',
                43
   UNION SELECT 'Cessna 208 Caravan',
                'CN1',
                5
   UNION SELECT 'Bombardier CRJ-200',
                'CR2',
                21),
     travel_time AS
  (SELECT extract('hour'
                  FROM (scheduled_arrival - scheduled_departure)) * 60 + extract('minute'
                                                                                 FROM (scheduled_arrival - scheduled_departure)) travel_time_min,
          flight_id,
          aircraft_code
   FROM main_db),
     fuel AS
  (SELECT travel_time_min * kg_per_min kg_fuel,
          flight_id
   FROM travel_time t
   JOIN fuel_consumption f ON t.aircraft_code = f.aircraft_code),
     rub_fuel AS
  (SELECT (46.2 * kg_fuel) money_spent_fuel,
          flight_id
   FROM fuel),
     total_amount AS
  (SELECT m.flight_id,
          sum(tf.amount) income
   FROM main_db m
   LEFT JOIN dst_project.ticket_flights tf ON m.flight_id = tf.flight_id
   GROUP BY m.flight_id),
     profit AS
  (SELECT r.flight_id,
          t.income - r.money_spent_fuel profit
   FROM rub_fuel r
   JOIN total_amount t ON r.flight_id = t.flight_id),
     num_of_people AS
  (SELECT count(ticket_no) people_on_flight,
          flight_id
   FROM dst_project.ticket_flights
   GROUP BY flight_id),
     all_seats AS
  (SELECT a.model,
          count(s.seat_no) all_seats
   FROM dst_project.aircrafts a
   JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code
   GROUP BY a.model),
     full_seats AS
  (SELECT n.people_on_flight,
          s.all_seats,
          m.flight_id,
          ac.model
   FROM main_db m
   LEFT JOIN num_of_people n ON m.flight_id = n.flight_id
   JOIN dst_project.aircrafts ac ON m.aircraft_code = ac.aircraft_code
   JOIN all_seats s ON s.model = ac.model)
SELECT m.flight_id,
       m.flight_no,
       m.departure_airport,
       m.arrival_airport,
       m.scheduled_departure,
       extract('month'
               FROM m.scheduled_departure) month_departure,
       ap.city,
       ap.latitude,
       ap.longitude,
       f_c.model,
       f_s.all_seats,
       f_s.people_on_flight,
       f_c.kg_per_min,
       t_t.travel_time_min,
       f.kg_fuel,
       r_f.money_spent_fuel,
       t_a.income,
       p.profit
FROM main_db m
JOIN dst_project.airports ap ON m.arrival_airport = ap.airport_code
JOIN fuel_consumption f_c ON m.aircraft_code = f_c.aircraft_code
JOIN travel_time t_t ON m.flight_id = t_t.flight_id
JOIN fuel f ON m.flight_id = f.flight_id
JOIN rub_fuel r_f ON m.flight_id = r_f.flight_id
JOIN total_amount t_a ON m.flight_id = t_a.flight_id
JOIN profit p ON m.flight_id = p.flight_id
JOIN full_seats f_s ON f_s.flight_id = m.flight_id