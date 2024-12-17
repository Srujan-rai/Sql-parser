INSERT INTO PRE_NCR.TB_STAGE10_2_1
SELECT 
	bd.BILLINGDOCUMENT, 
	bd.BILLINGDATE,
	MAX(b2.HO_COST_BEX2) AS HO_COST_BEX2,
	MAX(b2.FIX_CODE_BEX2) AS FIX_CODE_BEX2, 
	MAX(b3.ROAD_PMT_ZSDE155_BEX3) AS ROAD_PMT_ZSDE155_BEX3, 
	MAX(b3.RAIL_PMT_ZSDE155_BEX3) AS RAIL_PMT_ZSDE155_BEX3, 
	MAX(b3.RDDIV_PMT_ZSDE155_BEX3) AS RDDIV_PMT_ZSDE155_BEX3, 
	MAX(b3.RDTRN_PMT_ZSDE155_BEX3) AS RDTRN_PMT_ZSDE155_BEX3, 
	MAX(b3.RLDIV_PMT_ZSDE155_BEX3) AS RLDIV_PMT_ZSDE155_BEX3,
	MAX(b3.RLTRN_PMT_ZSDE155_BEX3) AS RLTRN_PMT_ZSDE155_BEX3,
	MAX(b4.ROAD_PMT_ZSDE155_BEX4) AS ROAD_PMT_ZSDE155_BEX4,
	MAX(b4.RAIL_PMT_ZSDE155_BEX4) AS RAIL_PMT_ZSDE155_BEX4,
	MAX(b5.PROFIT_RATE_PMT_BEX5) AS PROFIT_RATE_PMT_BEX5,
	MAX(s1.TS_RATE) AS TS_RATE, 
	MAX(s2.TS_RATE_STP) AS TS_RATE_STP, 
	MAX(s3.RATE_PER_TON) AS M_FREIGHT_T,
	MAX(s4.RATE_PER_TON) AS M_FREIGHT_INCO_T, 
	MAX(r1.RATE_PER_TON) AS ROYALTY_AMOUNT,
	MAX(CAST(o1.OTHER_RATE_P_T AS DECIMAL(15,4))) AS OTHER_RATE_P_T,
	MAX(s8.RATE_P_T_ON_DEALER_SALES) AS RATE_P_T_ON_DEALER_SALES, 
	MAX(s8.RATE_P_T_ON_SUB_DEALER_SA) AS RATE_P_T_ON_SUB_DEALER_SA,
	bd.BUSINESS_AREA,
	bd.PROFIT_CENTRE 
FROM EDWDM.TB_SALES_Z_DISP bd 
LEFT JOIN (
SELECT 
	t1.PLANT, t1.STORAGE_LOCATION, t1.VALID_FROM_BEX2, t1.VALID_TO_BEX2, MAX(t1.FIX_CODE_BEX2) AS FIX_CODE_BEX2, MAX(t1.HO_COST_BEX2) AS HO_COST_BEX2
FROM MAN_UPLOAD.ZSDE155_BEX2 t1
GROUP BY t1.PLANT, t1.STORAGE_LOCATION, t1.VALID_FROM_BEX2, t1.VALID_TO_BEX2
) b2 ON bd.PLANTCODE = b2.PLANT AND bd.STORAGE_LOCATION = b2.STORAGE_LOCATION
AND (bd.BILLINGDATE >= b2.VALID_FROM_BEX2 AND bd.BILLINGDATE <= b2.VALID_TO_BEX2)
LEFT JOIN (
SELECT 
	t2.PLANT, t2.STORAGE_LOCATION, t2.QUALITY_BEX3, t2.VALID_FROM_ZSDE155_BEX3, t2.VALID_TO_ZSDE155_BEX3,
	MAX(t2.ROAD_PMT_ZSDE155_BEX3) AS ROAD_PMT_ZSDE155_BEX3, 
	MAX(t2.RAIL_PMT_ZSDE155_BEX3) AS RAIL_PMT_ZSDE155_BEX3,
	MAX(t2.RDDIV_PMT_ZSDE155_BEX3) AS RDDIV_PMT_ZSDE155_BEX3, 
	MAX(t2.RDTRN_PMT_ZSDE155_BEX3) AS RDTRN_PMT_ZSDE155_BEX3,
	MAX(t2.RLDIV_PMT_ZSDE155_BEX3) AS RLDIV_PMT_ZSDE155_BEX3, 
	MAX(t2.RLTRN_PMT_ZSDE155_BEX3) AS RLTRN_PMT_ZSDE155_BEX3
FROM MAN_UPLOAD.ZSDE155_BEX3 t2
GROUP BY t2.PLANT, t2.STORAGE_LOCATION, t2.QUALITY_BEX3, t2.VALID_FROM_ZSDE155_BEX3, t2.VALID_TO_ZSDE155_BEX3
) b3 ON bd.PLANTCODE = b3.PLANT AND bd.STORAGE_LOCATION = b3.STORAGE_LOCATION AND bd.MATERIALNUMBER = b3.QUALITY_BEX3 
AND (bd.BILLINGDATE >= b3.VALID_FROM_ZSDE155_BEX3 AND bd.BILLINGDATE <= b3.VALID_TO_ZSDE155_BEX3)
LEFT JOIN (
SELECT 
	t3.PLANT, t3.STORAGE_LOCATION,QUALITY_BEX4, t3.VALID_FROM_ZSDE155_BEX4, t3.VALID_TO_ZSDE155_BEX4,
	MAX(t3.ROAD_PMT_ZSDE155_BEX4) AS ROAD_PMT_ZSDE155_BEX4, MAX(t3.RAIL_PMT_ZSDE155_BEX4) AS RAIL_PMT_ZSDE155_BEX4
FROM PRE_NCR.ZSDE155_BEX4 t3
GROUP BY t3.PLANT, t3.STORAGE_LOCATION, t3.QUALITY_BEX4, t3.VALID_FROM_ZSDE155_BEX4, t3.VALID_TO_ZSDE155_BEX4
) b4 ON bd.PLANTCODE = b4.PLANT AND bd.STORAGE_LOCATION = b4.STORAGE_LOCATION AND bd.MATERIALNUMBER = b4.QUALITY_BEX4 
AND (bd.BILLINGDATE >= b4.VALID_FROM_ZSDE155_BEX4 AND bd.BILLINGDATE <= b4.VALID_TO_ZSDE155_BEX4)
LEFT JOIN MAN_UPLOAD.ZSDE155_BEX5 b5 ON bd.PLANTCODE = b5.PLANT AND bd.STORAGE_LOCATION = b5.STORAGE_LOCATION AND (bd.BILLINGDATE >= b5.VALID_FROM_BEX5 AND bd.BILLINGDATE <= b5.VALID_TO_BEX5)
LEFT JOIN (
SELECT t4.COMPANY_CODE, t4.SHIP_TO_RATE_CODE, t4.VALID_FROM, t4.VALID_TO, MAX(t4.TS_RATE) AS TS_RATE
FROM MAN_UPLOAD.SALES_TS_C_SHR t4 
GROUP BY t4.COMPANY_CODE, t4.SHIP_TO_RATE_CODE, t4.VALID_FROM, t4.VALID_TO 
) s1 ON bd.GEOGDISTRICTCODE = s1.SHIP_TO_RATE_CODE AND bd.SALES_ORGANISATION = s1.COMPANY_CODE 
AND (bd.BILLINGDATE >= s1.VALID_FROM AND bd.BILLINGDATE <= s1.VALID_TO)
LEFT JOIN (
SELECT t5.COMPANY_CODE, t5.SHIP_TO_RATE_CODE, t5.STP_STATE_CODE, t5.VALID_FROM, t5.VALID_TO, MAX(t5.TS_RATE) AS TS_RATE_STP
FROM MAN_UPLOAD.SALES_TS_C_SHR_SC t5
GROUP BY t5.COMPANY_CODE, t5.SHIP_TO_RATE_CODE, t5.STP_STATE_CODE, t5.VALID_FROM,VALID_TO
) s2 ON bd.GEOGDISTRICTCODE = s2.SHIP_TO_RATE_CODE AND bd.SALES_ORGANISATION = s2.COMPANY_CODE AND bd.SOLD_TO_STATE = RIGHT(CONCAT('0',s2.STP_STATE_CODE),2) 
AND (bd.BILLINGDATE >= s2.VALID_FROM AND bd.BILLINGDATE <= s2.VALID_TO)
LEFT JOIN (
SELECT t6.COMPANY_CODE, t6.MOTHER_PLANT_CODE, t6.PLANT_CODE, t6.MODE_OF_TRANSPORT, t6.VALID_FROM,VALID_TO, MAX(t6.RATE_PER_TON) AS RATE_PER_TON
FROM MAN_UPLOAD.SALES_FREIGHT_CHARGES_C_MP_P_MOD t6
GROUP BY t6.COMPANY_CODE, t6.MOTHER_PLANT_CODE, t6.PLANT_CODE, t6.MODE_OF_TRANSPORT, t6.VALID_FROM, t6.VALID_TO
) s3 ON bd.MANUFACTURING_PLANT = s3.MOTHER_PLANT_CODE AND bd.PLANTCODE = s3.PLANT_CODE AND bd.MODEOFTRANSPORT = s3.MODE_OF_TRANSPORT 
AND (bd.BILLINGDATE >= s3.VALID_FROM AND bd.BILLINGDATE <= s3.VALID_TO)
LEFT JOIN (
SELECT t7.COMPANY_CODE, t7.MOTHER_PLANT_CODE, t7.PLANT_CODE, t7.INCO_TERM, t7.MODE_OF_TRANSPORT, t7.VALID_FROM, t7.VALID_TO, MAX(t7.RATE_PER_TON) AS RATE_PER_TON
FROM MAN_UPLOAD.SALES_FREIGHT_C_MP_P_I_MOD t7
GROUP BY t7.COMPANY_CODE, t7.MOTHER_PLANT_CODE, t7.PLANT_CODE, t7.INCO_TERM, t7.MODE_OF_TRANSPORT, t7.VALID_FROM, t7.VALID_TO 
) s4 ON bd.MANUFACTURING_PLANT = s4.MOTHER_PLANT_CODE AND bd.PLANTCODE = s4.PLANT_CODE AND bd.MODEOFTRANSPORT = s4.MODE_OF_TRANSPORT AND bd.INCOTERMS1 = s4.INCO_TERM
AND (bd.BILLINGDATE >= s4.VALID_FROM AND bd.BILLINGDATE <= s4.VALID_TO)
LEFT JOIN (
SELECT t8.PLANT_CODE, t8.MATERIAL_CODE, t8.VALID_FROM, t8.VALID_TO, MAX(t8.RATE_PER_TON) AS RATE_PER_TON
FROM MAN_UPLOAD.SALES_ROYALTY_MP_M t8
GROUP BY t8.PLANT_CODE, t8.MATERIAL_CODE, t8.VALID_FROM, t8.VALID_TO 
) r1 ON bd.MANUFACTURING_PLANT = r1.PLANT_CODE AND bd.MATERIALNUMBER = r1.MATERIAL_CODE AND (bd.BILLINGDATE >= r1.VALID_FROM AND bd.BILLINGDATE <= r1.VALID_TO) 
LEFT JOIN (
SELECT t9.MOTHER_PLANT, t9.PLANT, t9.VALID_FROM, t9.VALID_TO, MAX(t9.OTHER_CHARGES_MP_P) AS OTHER_RATE_P_T 
FROM MAN_UPLOAD.SALES_OTHER_CHARGES_MP_P t9
GROUP BY t9.MOTHER_PLANT, t9.PLANT, t9.VALID_FROM, t9.VALID_TO
) o1 ON bd.MANUFACTURING_PLANT = CAST(o1.MOTHER_PLANT AS VARCHAR(4)) AND bd.PLANTCODE = CAST(o1.PLANT AS VARCHAR(4))
AND (bd.BILLINGDATE >= o1.VALID_FROM AND bd.BILLINGDATE <= o1.VALID_TO)
LEFT JOIN (
SELECT 
	t10.YEARS, t10.MONTHS, t10.COMPANY_CODE, t10.STATE_CODE, t10.MATERIAL_CODE, 
	MAX(t10.RATE_P_T_ON_DLEALER_SALES) AS RATE_P_T_ON_DEALER_SALES, 
	MAX(t10.RATE_P_T_ON_SUB_DEALER_SA) AS RATE_P_T_ON_SUB_DEALER_SA 
FROM MAN_UPLOAD.SALES_DSP_C_S_M t10 
GROUP BY t10.YEARS, t10.MONTHS, t10.COMPANY_CODE, t10.STATE_CODE, t10.MATERIAL_CODE
) s8 ON bd.SALES_ORGANISATION = CAST(s8.COMPANY_CODE AS VARCHAR(4)) AND bd.SHIP_TO_STATE = RIGHT(CONCAT('0',s8.STATE_CODE),2) AND bd.MATERIALNUMBER = s8.MATERIAL_CODE
-- AND MONTHNAME(CAST(bd.BILLINGDATE AS DATE)) = s8.MONTHS 
-- AND (
-- CASE 
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=1 THEN 'January'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=2 THEN 'February'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=3 THEN 'March'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=4 THEN 'April'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=5 THEN 'May'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=6 THEN 'June'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=7 THEN 'July'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=8 THEN 'August'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=9 THEN 'September'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=10 THEN 'October'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=11 THEN 'November'
-- 	WHEN EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE))=12 THEN 'December'
-- END) = s8.MONTHS
AND DECODE(EXTRACT(MONTH FROM CAST(bd.BILLINGDATE AS DATE)),1,'January',2,'February',3,'March',4,'April',5,'May',6,'June',7,'July',8,'August',9,'September',10,'October',11,'November',12,'December','NA') = s8.MONTHS
AND YEAR(CAST(bd.BILLINGDATE AS DATE)) = s8.YEARS  
-- WHERE bd.BILLINGDOCUMENT IN ('2420505185','2420505172')
GROUP BY bd.BILLINGDOCUMENT, bd.BILLINGDATE, bd.BUSINESS_AREA, bd.PROFIT_CENTRE
;
