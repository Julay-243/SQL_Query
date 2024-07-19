SELECT * FROM stock_details;

-- Total Stock Snapshot With Total

SELECT 
SUM(CASE WHEN Weight THEN Weight ELSE 0 END) AS Total_Weight,
SUM(CASE WHEN Project_Manager = 'BOP' THEN Weight ELSE 0 END) AS BOP_Weight,
SUM(CASE WHEN Project_Manager != 'BOP' THEN Weight ELSE 0 END) AS Weight_Excluding_BOP,
SUM(CASE WHEN Project_Manager != 'BOP' AND Weight <1000 THEN Weight ELSE 0 END) AS 1MT_Coils_Weight,
SUM(CASE WHEN Project_Manager != 'BOP' AND Weight >1000 THEN Weight ELSE 0 END) AS Wight_Excluding_BOP_AND_1MT,
SUM(CASE WHEN Project_Manager != 'BOP' AND Weight >1000 AND Coil_Ageing >300 THEN Weight ELSE 0 END) AS Dead_Coils_Weight,
SUM(CASE WHEN Project_Manager != 'BOP' AND Weight >1000 AND Coil_Ageing <300 THEN Weight ELSE 0 END) AS Final_Weight
FROM stock_details;

-- Zone Wise Stock List With Total

SELECT Project_Manager,
SUM(CASE WHEN Coil_Ageing >300 AND Weight >1000 THEN Weight ELSE 0 END) AS '>300 Days',
SUM(CASE WHEN Coil_Ageing >200 AND Coil_Ageing <=300 AND Weight >1000 THEN Weight ELSE 0 END) AS '201-300 Day',
SUM(CASE WHEN Coil_Ageing >100 AND Coil_Ageing <=200 AND Weight >1000 THEN Weight ELSE 0 END) AS '101-200 Day',
SUM(CASE WHEN Coil_Ageing <100 AND Weight >1000 THEN Weight ELSE 0 END) AS '<100 Days',
SUM(CASE WHEN Weight >1000 THEN Weight ELSE 0 END) AS FINAL_WEIGHT
FROM stock_details
GROUP BY Project_Manager 
UNION ALL
SELECT 'Z_GRAND_TOTAL' AS Project_Manager,
SUM(CASE WHEN Coil_Ageing >300 AND Weight >1000 THEN Weight ELSE 0 END) AS '>300 Days',
SUM(CASE WHEN Coil_Ageing >200 AND Coil_Ageing <=300 AND Weight >1000 THEN Weight ELSE 0 END) AS '201-300 Day',
SUM(CASE WHEN Coil_Ageing >100 AND Coil_Ageing <=200 AND Weight >1000 THEN Weight ELSE 0 END) AS '101-200 Day',
SUM(CASE WHEN Coil_Ageing <100 AND Weight >1000 THEN Weight ELSE 0 END) AS '<100 Days',
SUM(CASE WHEN Weight >1000 THEN Weight ELSE 0 END) AS FINAL_WEIGHT
FROM stock_details
ORDER BY Project_Manager;

-- Project Wise Stock List With Total

SELECT Projects, SUM(Weight) AS T_Weight, Project_Manager
FROM stock_details
WHERE Project_Manager != 'BOP' AND Weight >1000
GROUP BY Projects, Project_Manager

UNION ALL
SELECT 'ALL' AS Projects, SUM(Weight), 'ALL' AS project_Manager
FROM stock_details
WHERE Project_Manager != 'BOP' AND Weight >1000
ORDER BY 2 DESC;

-- Usable Coil Wise Stock List With Total

SELECT Coil_Details, SUM(Weight) AS T_Weight, Projects, Project_Manager
FROM stock_details
WHERE Project_Manager != 'BOP' AND Weight > 1000 AND Coil_Ageing < 300
GROUP BY Coil_Details, Projects, Project_Manager
UNION ALL
SELECT 'ALL' AS Coil_Details, SUM(Weight) AS T_Weight, 'ALL' AS Projects, 'ALL' AS Project_Manager
FROM stock_details
WHERE Project_Manager != 'BOP' AND Weight > 1000 AND Coil_Ageing < 300
ORDER BY T_Weight DESC;


-- Dead stock More Than 300 DaysWith Total

SELECT Coil_Details, SUM(Weight) AS T_Weight, Projects, Project_Manager
FROM stock_details
WHERE Project_Manager != 'BOP' AND Weight > 1000 AND Coil_Ageing > 300
GROUP BY Coil_Details, Projects, Project_Manager
UNION ALL
SELECT 'ALL' AS Coil_Details, SUM(Weight) AS T_Weight, 'ALL' AS Projects, 'ALL' AS Project_Manager
FROM stock_details
WHERE Project_Manager != 'BOP' AND Weight > 1000 AND Coil_Ageing > 300
ORDER BY T_Weight DESC;

-- Stock_Ready to Dead

SELECT Coil_Details, SUM(Weight) AS T_Weight, Projects, Project_Manager, Coil_Ageing
FROM stock_details
WHERE Coil_Ageing <300 AND Coil_Ageing >270 AND project_Manager != 'BOP'
GROUP BY Coil_Details, Projects, Project_Manager, Coil_Ageing
UNION ALL
SELECT 'ALL' AS Coil_Details, SUM(Weight) AS T_Weight, 'ALL' AS  Projects, 'ALL' AS Project_Manager, 'ALL' Coil_Ageing
FROM stock_details
WHERE Coil_Ageing <300 AND Coil_Ageing >270 AND project_Manager != 'BOP'
ORDER BY T_Weight DESC;

