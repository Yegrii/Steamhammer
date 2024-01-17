-- Constructor total wins

SELECT
    cons.name AS Constructor,
    COUNT(CASE WHEN position = 1 THEN 1 ELSE NULL END) AS win
FROM
    constructors AS cons
INNER JOIN constructorStandings AS stand ON cons.constructorId = stand.constructorId
GROUP BY
    Constructor
ORDER BY
    win DESC
LIMIT 10;


-- Driver race wins

SELECT
    d.surname AS Surname,
    COUNT(CASE WHEN ds.position = 1 THEN 1 ELSE NULL END) AS win
FROM
    drivers AS d
JOIN driverStandings AS ds ON d.driverId = ds.driverId
GROUP BY
    Surname
ORDER BY
    win DESC
LIMIT
    10;


-- Driver quali wins

SELECT
    d.surname AS Surname,
    COUNT(CASE WHEN q.position = 1 THEN 1 ELSE NULL END) AS win
FROM
    drivers AS d 
JOIN qualifying AS q ON d.driverId = q.driverId
GROUP BY
    Surname
ORDER BY
    win DESC
LIMIT 10;


-- Constructor total wins

SELECT
    c.name AS Constructor,
    COUNT(CASE WHEN cs.position = 1 THEN 1 ELSE NULL END) AS Wins
FROM
    constructors AS c 
INNER JOIN constructorStandings AS cs ON
    c.constructorId = cs.constructorId
GROUP BY 
    Constructor
ORDER BY
    Wins DESC
LIMIT 10;


-- Top-10 Ferrari drivers

SELECT
    c.name AS Constructor,
    d.surname AS Driver,
    COUNT(CASE WHEN r.position = 1 THEN 1 ELSE NULL END) AS Wins
FROM
    constructors AS c
INNER JOIN results AS r ON
    c.constructorId = r.constructorId
INNER JOIN drivers AS d ON
    d.driverId = r.driverId
WHERE
    r.constructorId = 6
GROUP BY
    Constructor, Driver
ORDER BY
    Wins DESC
LIMIT 10;


-- Top-10 McLaren drivers

SELECT
    c.name AS Constructor,
    d.surname AS Driver,
    COUNT(CASE WHEN r.position = 1 THEN 1 ELSE NULL END) AS Wins
FROM
    constructors AS c
INNER JOIN results AS r ON
    c.constructorId = r.constructorId
INNER JOIN drivers AS d ON
    d.driverId = r.driverId
WHERE
    r.constructorId = 1
GROUP BY
    Constructor, Driver
ORDER BY
    Wins DESC
LIMIT 10;


-- Top-10 Williams drivers

SELECT
    c.name AS Constructor,
    d.surname AS Driver,
    COUNT(CASE WHEN r.position = 1 THEN 1 ELSE NULL END) AS Wins
FROM
    constructors AS c
INNER JOIN results AS r ON
    c.constructorId = r.constructorId
INNER JOIN drivers AS d ON
    d.driverId = r.driverId
WHERE
    r.constructorId = 3
GROUP BY
    Constructor, Driver
ORDER BY
    Wins DESC
LIMIT 10;


-- Top-10 Mercedes drivers

SELECT
    c.name AS Constructor,
    d.surname AS Driver,
    COUNT(CASE WHEN r.position = 1 THEN 1 ELSE NULL END) AS Wins
FROM
    constructors AS c
INNER JOIN results AS r ON
    c.constructorId = r.constructorId
INNER JOIN drivers AS d ON
    d.driverId = r.driverId
WHERE
    r.constructorId = 131
GROUP BY
    Constructor, Driver
ORDER BY
    Wins DESC
LIMIT 10;



-- Maximum number of wins on one track

SELECT
    c.name AS circuit,
    d.surname AS driver,
    SUM(
        CASE WHEN res.position = 1
        THEN  res.position
        ELSE 0
        END) AS wins_on_circuit
FROM
    races r
JOIN results res 
    ON r.raceId = res.raceId
JOIN circuits c 
    ON r.circuitId = c.circuitId
JOIN drivers d 
    ON res.driverId = d.driverId

/*
WHERE
    r.year >= 1990
*/

GROUP BY
    c.name, d.surname
ORDER BY
    wins_on_circuit DESC
LIMIT
    10;



-- The most wins in one season

SELECT
    r.year AS season,
    d.surname AS driver,
    SUM(
        CASE WHEN res.position = 1 
        THEN res.position
        ELSE 0
        END) AS wins,
    MAX(r.round) AS rounds
FROM
    races r
JOIN
    results res ON
    r.raceId = res.raceId
JOIN
    drivers d ON
    res.driverId = d.driverId
GROUP BY
    season, driver
HAVING wins > 0
ORDER BY
    wins DESC
LIMIT
    10;


-- Percent of wins

SELECT
    r.year AS season,
    c.name AS Constructor,
    SUM(
        CASE
            WHEN res.position = 1 THEN 1
            ELSE 0
        END
    ) AS wins,
    ROUND(SUM(
        CASE
            WHEN res.position = 1 THEN 1
            ELSE 0
        END
    ) / MAX(r.round) * 100, 1) AS percent_of_wins
FROM
    races r
JOIN
    results res ON 
    r.raceId = res.raceId
JOIN
    constructors c ON
    res.constructorId = c.constructorId
WHERE
    r.year IN (2001, 2002, 2004, 2011, 2013, 2014, 2018, 2019, 2022, 2023)
GROUP BY
    season,
    Constructor
HAVING
    wins > 0
ORDER BY
    season DESC, 
    percent_of_wins DESC;



-- Fastest lap on each track

SELECT
    c.name AS circuit,
    d.surname AS driver,
    res.fastestLapTime AS best_time
FROM
    results res 
JOIN
    races r ON 
        res.raceId = r.raceId
JOIN
    circuits c ON
        r.circuitId = c.circuitId
JOIN
    drivers d ON
        res.driverId = d.driverId
JOIN (
    SELECT
        r.circuitId,
        MIN(res.fastestLapTime) AS min_fastestLapTime
    FROM
        results res
    JOIN
        races r ON res.raceId = r.raceId
    WHERE
        res.fastestLapTime IS NOT NULL
    GROUP BY
        r.circuitId
) AS minTimes ON r.circuitId = minTimes.circuitId AND res.fastestLapTime = minTimes.min_fastestLapTime
WHERE
    res.fastestLapTime IS NOT NULL
ORDER BY
    circuit, best_time;


-- Fastest lap on each track

SELECT
    c.name AS circuit,
    d.surname AS driver,
    res.fastestLapTime AS best_time,
    r.year AS year_of_best_time
FROM
    results res 
JOIN
    races r ON 
        res.raceId = r.raceId
JOIN
    circuits c ON
        r.circuitId = c.circuitId
JOIN
    drivers d ON
        res.driverId = d.driverId
JOIN (
    SELECT
        r.circuitId,
        MIN(res.fastestLapTime) AS min_fastestLapTime
    FROM
        results res
    JOIN
        races r ON res.raceId = r.raceId
    WHERE
        res.fastestLapTime IS NOT NULL
    GROUP BY
        r.circuitId
) AS minTimes ON r.circuitId = minTimes.circuitId AND res.fastestLapTime = minTimes.min_fastestLapTime
WHERE
    res.fastestLapTime IS NOT NULL
ORDER BY
    year_of_best_time;

