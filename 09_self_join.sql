-- 1. How many stops are in the database.

SELECT COUNT(DISTINCT stop)
  FROM route
  JOIN stops ON route.stop = stops.id;

-- 2. Find the id value for the stop 'Craiglockhart'.

SELECT id
  FROM stops
 WHERE name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT id, name
  FROM stops
  JOIN route ON stops.id = route.stop
 WHERE num = '4'
   AND company = 'LRT';

-- 4. The query shown gives the number of routes that visit either London Road
-- (149) or Craiglockhart (53). Run the query and notice the two services
-- that link these stops have a count of 2. Add a HAVING clause to restrict
-- the output to these two routes.

  SELECT company, num, COUNT(*)
    FROM route
   WHERE stop = 149 OR stop = 53
GROUP BY company, num
  HAVING COUNT(*) = 2;

-- 5. Execute the self join shown and observe that b.stop gives all the places
-- you can get to from Craiglockhart, without changing routes. Change the
-- query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
  FROM route a
  JOIN route b ON a.company = b.company AND a.num = b.num
 WHERE a.stop = 53
   AND b.stop = 149;

-- 6. The query shown is similar to the previous one, however by joining two
-- copies of the stops table we can refer to stops by name rather than by
-- number. Change the query so that the services between 'Craiglockhart' and
-- 'London Road' are shown. If you are tired of these places try
-- 'Fairmilehead' against 'Tollcross'.

SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a
  JOIN route b ON a.company = b.company AND a.num = b.num

  JOIN stops stopa ON a.stop = stopa.id
  JOIN stops stopb ON b.stop = stopb.id

 WHERE stopa.name = 'Craiglockhart'
   AND stopb.name = 'London Road';

-- 7. Give a list of all the services which connect stops 115 and 137
-- ('Haymarket' and 'Leith').

SELECT DISTINCT a.company, a.num
  FROM route a, route b
 WHERE a.company = b.company AND a.num = b.num
   AND a.stop = 115
   AND b.stop = 137;

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and
-- 'Tollcross'.

SELECT DISTINCT R1.company, R1.num
  FROM route R1, route R2,
       stops S1, stops S2
 WHERE R1.company = R2.company
   AND R1.num = R2.num
   AND R1.stop = S1.id
   AND R2.stop = S2.id
   AND S1.name = 'Craiglockhart'
   AND S2.name = 'Tollcross';

-- 9. Give a distinct list of the stops which may be reached from
-- 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself,
-- offered by the LRT company. Include the company and bus no. of the
-- relevant services.

SELECT DISTINCT S2.name, R2.company, R2.num
  FROM route R1, route R2,
       stops S1, stops S2
 WHERE R1.company = R2.company
   AND R1.num = R2.num
   AND R1.stop = S1.id
   AND R2.stop = S2.id
   AND S1.name = 'Craiglockhart';

-- 10. Find the routes involving two buses that can go from Craiglockhart
-- to Sighthill. Show the bus no. and company for the first bus, the name of
-- the stop for the transfer, and the bus no. and company for the second bus.

SELECT first_ride.start_num,
       first_ride.start_company,
       first_ride.transfer_stop,
       second_ride.end_num,
       second_ride.end_company

  FROM (SELECT DISTINCT R1.num AS start_num,
                        R1.company AS start_company,
                        S2.name AS transfer_stop

          FROM route R1, route R2,
               stops S1, stops S2

         WHERE R1.company = R2.company
           AND R1.num = R2.num
           AND R1.stop = S1.id
           AND R2.stop = S2.id
           AND S1.name = 'Craiglockhart') AS first_ride

  JOIN (SELECT DISTINCT S3.name AS transfer_stop,
                        R4.num AS end_num,
                        R4.company AS end_company

          FROM route R3, route R4,
               stops S3, stops S4

         WHERE R3.company = R4.company
           AND R3.num = R4.num
           AND R3.stop = S3.id
           AND R4.stop = S4.id
           AND S4.name = 'Sighthill') AS second_ride

 WHERE first_ride.transfer_stop = second_ride.transfer_stop;

-- Note: The order of the 'end_num' column in the result is not exactly
-- the same.
