-- QA1
SELECT u.full_name, e.title, e.city, e.start_date
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
JOIN Events e ON r.event_id = e.event_id
WHERE e.status = 'upcoming'
AND u.city = e.city
ORDER BY e.start_date;

-- QA2
SELECT e.title, AVG(f.rating) avg_rating
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY avg_rating DESC;

-- QA3
SELECT *
FROM Users
WHERE user_id NOT IN (
    SELECT user_id
    FROM Registrations
    WHERE registration_date >= CURDATE() - INTERVAL 90 DAY
);

-- QA4
SELECT event_id, COUNT(*) total_sessions
FROM Sessions
WHERE TIME(start_time) BETWEEN '10:00:00' AND '12:00:00'
GROUP BY event_id;

-- QA5
SELECT u.city, COUNT(DISTINCT r.user_id) total_users
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
GROUP BY u.city
ORDER BY total_users DESC
LIMIT 5;

-- QA6
SELECT e.title,
COUNT(r.resource_id) total_resources
FROM Events e
LEFT JOIN Resources r
ON e.event_id = r.event_id
GROUP BY e.event_id, e.title;

-- QA7
SELECT u.full_name,
f.comments,
e.title
FROM Feedback f
JOIN Users u ON f.user_id=u.user_id
JOIN Events e ON f.event_id=e.event_id
WHERE f.rating < 3;

-- QA8
SELECT e.title,
COUNT(s.session_id) session_count
FROM Events e
LEFT JOIN Sessions s
ON e.event_id=s.event_id
WHERE e.status='upcoming'
GROUP BY e.event_id,e.title;

-- QA9

SELECT u.full_name,
e.status,
COUNT(*) total_events
FROM Users u
JOIN Events e
ON u.user_id=e.organizer_id
GROUP BY u.full_name,e.status;

-- QA10
SELECT e.title
FROM Events e
JOIN Registrations r
ON e.event_id=r.event_id
LEFT JOIN Feedback f
ON e.event_id=f.event_id
WHERE f.feedback_id IS NULL
GROUP BY e.title;

-- QA11
SELECT registration_date,
COUNT(*) total_users
FROM Users
WHERE registration_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY registration_date;

-- QA12
SELECT e.title
FROM Events e
JOIN Sessions s
ON e.event_id = s.event_id
GROUP BY e.event_id,e.title
HAVING COUNT(*) = (
    SELECT MAX(session_count)
    FROM (
        SELECT COUNT(*) session_count
        FROM Sessions
        GROUP BY event_id
    ) t
);


-- QA13
SELECT e.city,
AVG(f.rating) avg_rating
FROM Events e
JOIN Feedback f
ON e.event_id = f.event_id
GROUP BY e.city;

-- QA14
SELECT e.title,
COUNT(r.registration_id) total_registrations
FROM Events e
JOIN Registrations r
ON e.event_id = r.event_id
GROUP BY e.event_id,e.title
ORDER BY total_registrations DESC
LIMIT 3;

-- QA15
SELECT s1.event_id,
s1.title AS session1,
s2.title AS session2
FROM Sessions s1
JOIN Sessions s2
ON s1.event_id = s2.event_id
AND s1.session_id < s2.session_id
AND s1.start_time < s2.end_time
AND s1.end_time > s2.start_time;

-- QA16
SELECT *
FROM Users u
WHERE registration_date >= CURDATE() - INTERVAL 30 DAY
AND NOT EXISTS (
    SELECT 1
    FROM Registrations r
    WHERE r.user_id = u.user_id
);

-- QA17
SELECT speaker_name,
COUNT(*) total_sessions
FROM Sessions
GROUP BY speaker_name
HAVING COUNT(*) > 1;

-- QA18
SELECT e.title
FROM Events e
LEFT JOIN Resources r
ON e.event_id = r.event_id
WHERE r.resource_id IS NULL;

-- QA19
SELECT 
    e.title,
    COUNT(DISTINCT r.registration_id) total_registrations,
    AVG(f.rating) avg_rating
FROM
    Events e
        LEFT JOIN
    Registrations r ON e.event_id = r.event_id
        LEFT JOIN
    Feedback f ON e.event_id = f.event_id
WHERE
    e.status = 'completed'
GROUP BY e.event_id , e.title;

-- QA20
SELECT u.full_name,
COUNT(DISTINCT r.event_id) attended_events,
COUNT(DISTINCT f.feedback_id) feedback_count
FROM Users u
LEFT JOIN Registrations r
ON u.user_id = r.user_id
LEFT JOIN Feedback f
ON u.user_id = f.user_id
GROUP BY u.user_id,u.full_name;


-- QA21
SELECT u.full_name,
COUNT(*) feedback_count
FROM Users u
JOIN Feedback f
ON u.user_id = f.user_id
GROUP BY u.user_id,u.full_name
ORDER BY feedback_count DESC
LIMIT 5;

-- QA22
SELECT user_id,
event_id,
COUNT(*) duplicate_count
FROM Registrations
GROUP BY user_id,event_id
HAVING COUNT(*) > 1;

-- QA23
SELECT DATE_FORMAT(registration_date,'%Y-%m') AS month,
COUNT(*) registrations
FROM Registrations
WHERE registration_date >= CURDATE() - INTERVAL 12 MONTH
GROUP BY DATE_FORMAT(registration_date,'%Y-%m');

-- QA24
SELECT event_id,
AVG(TIMESTAMPDIFF(MINUTE,start_time,end_time))
AS avg_duration_minutes
FROM Sessions
GROUP BY event_id;

-- QA25
SELECT e.title
FROM Events e
LEFT JOIN Sessions s
ON e.event_id = s.event_id
WHERE s.session_id IS NULL;
