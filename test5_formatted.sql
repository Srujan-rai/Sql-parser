INSERT INTO REPORTS_DATA.TB_DST_LOGISTICS WITH VC_TARGET_DSR_DATA AS
  (SELECT DISTINCT a.ACTUAL_MFG_PLANT,
                   a.PRODUCT_SALES_TEAM,
                   a.REPORT_DATE,
                   MAX(a.VC_TARGET) AS VC_TARGET
   FROM MAN_UPLOAD.TB_VC_TARGET_DSR a
   GROUP BY a.ACTUAL_MFG_PLANT,
            a.PRODUCT_SALES_TEAM,
            a.REPORT_DATE)
SELECT DISTINCT 'B' AS REPORT_FLAG,
                zd.COMPANY_REGION_CLUBBED AS COMPANY_REGION_CLUBBED,
                zd.COMPANY_REGION_CLUBBED_2 AS COMPANY_REGION_CLUBBED_2,
                CASE
                    WHEN zd.COMPANY_REGION_CLUBBED_2 IN ('North East')
                         AND cma.REGION_CODE IN ('25',
                                                 '21',
                                                 '04')
                         AND zd.ZSM_CODE_TRANSACTION NOT IN ('EMP0004411') THEN 'East'
                    WHEN CAST(zd.BILLINGDATE AS DATE) >= '2024-06-01'
                         AND (zd.DISTRIBUTIONCHANNEL IN ('02')
                              AND (cma.ATTRIBUTE_3 IN ('12')
                                   OR cma.BP_TYPE IN ('ZV38')))=0
                         AND cmc.REGION_CODE IN ('12',
                                                 '24',
                                                 '35',
                                                 '30') THEN 'Central'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010',
                                                   '1030',
                                                   '5010')
                         AND (cma.REGION_CODE IN ('05',
                                                  '10',
                                                  '13')
                              OR LEFT(cma.CUSTOMER_GRP2, 2) IN ('KA',
                                                                'GA',
                                                                'MH')) THEN 'South West'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010',
                                                   '1030',
                                                   '5010')
                         AND cma.REGION_CODE IN ('12')
                         AND zd.MANUFACTURING_PLANT IN ('1360') THEN 'South West'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010',
                                                   '1030',
                                                   '5010')
                         AND (cma.REGION_CODE IN ('36')
                              OR LEFT(cma.CUSTOMER_GRP2, 2) IN ('TS')) THEN 'South'
                    WHEN zd.SALES_ORGANISATION IN ('1030',
                                                   '5010')
                         OR zd.BUSINESS_AREA IN ('1360') THEN 'South West'
                    ELSE zd.COMPANY_REGION_CLUBBED
                END AS COMPANY_REGION_CLUBBED_3,
                CASE
                    WHEN zd.COMPANY_REGION_CLUBBED_2 IN ('North East')
                         AND cma.REGION_CODE IN ('25',
                                                 '21',
                                                 '04')
                         AND zd.ZSM_CODE_TRANSACTION NOT IN ('EMP0004411') THEN 'East'
                    WHEN CAST(zd.BILLINGDATE AS DATE) >= '2024-06-01'
                         AND (zd.DISTRIBUTIONCHANNEL IN ('02')
                              AND (cma.ATTRIBUTE_3 IN ('12')
                                   OR cma.BP_TYPE IN ('ZV38')))=0
                         AND cmc.REGION_CODE IN ('12',
                                                 '24',
                                                 '35',
                                                 '30') THEN 'Central'
                    ELSE zd.COMPANY_REGION_CLUBBED_2
                END AS COMPANY_REGION_CLUBBED_4,
                zd.SALES_ORGANISATION AS SALES_ORGANISATION,
                zd.DIVISIONCODE AS DIVISIONCODE,
                zd.DISTRIBUTIONCHANNEL AS DISTRIBUTIONCHANNEL,
                zd.SALES_TYPE AS SALES_TYPE,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('03') THEN 'Stock Transfer'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('04') THEN 'Self Consumption'
                    WHEN zd.BILLINGTYPE IN ('ZLIT')
                         OR zd.STOLOC IN ('CT01',
                                          'DM01',
                                          'IPW1',
                                          'LIST',
                                          'LT01',
                                          'TL01',
                                          'ZSIT',
                                          'OCFD',
                                          'OCFG',
                                          'ST01')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZOTH') THEN 'Damage'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('06')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmb.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmc.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP') THEN 'Export Sales'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.DISTRIBUTIONCHANNEL IN ('01')
                         AND (cma.REGION_CODE IN ('26')
                              OR cma.CUSTOMER_GRP2 IN ('AN1')) THEN 'Institutional'
                    ELSE zd.SALES_TYPE
                END AS SALES_TYPE_2,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('03') THEN 'Stock Transfer'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('04') THEN 'Self Consumption'
                    WHEN zd.BILLINGTYPE IN ('ZLIT')
                         OR zd.STOLOC IN ('CT01',
                                          'DM01',
                                          'IPW1',
                                          'LIST',
                                          'LT01',
                                          'TL01',
                                          'ZSIT',
                                          'OCFD',
                                          'OCFG',
                                          'ST01')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZOTH') THEN 'Damage'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('06')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmb.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmc.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP') THEN 'Institutional'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('02')
                         AND (cma.ATTRIBUTE_3 IN ('12')
                              OR cma.BP_TYPE IN ('ZV38')) THEN 'Consignment'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00114',
                                                   'DC00030',
                                                   'DC00055',
                                                   'DC00060',
                                                   'DC00116',
                                                   'F01SR0000BU0001',
                                                   'F01SR000DLHWTN1',
                                                   'F01SR000DLHWTN2',
                                                   'F01SR000DLHWTN3',
                                                   'F01SR000DLHWTN4') THEN 'Institutional'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00002',
                                                   'DC00013',
                                                   'F01OW000DPABNN1',
                                                   'F01OW000DLHWTN1') THEN 'Institutional'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00115',
                                                   'DC00027',
                                                   'F01OP53S0BU0001',
                                                   'F01OP53SDHDWTN1') THEN 'Institutional'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.DISTRIBUTIONCHANNEL IN ('01')
                         AND (cma.REGION_CODE IN ('26')
                              OR cma.CUSTOMER_GRP2 IN ('AN1')) THEN 'Institutional'
                    ELSE zd.SALES_TYPE
                END AS SALES_TYPE_5,
                zd.BILLINGDOCUMENT AS BILLINGDOCUMENT,
                zd.SHIPMENTNO AS SHIPMENTNO,
                zd.DELIVERY_NO AS DELIVERY_NO,
                zd.SONUMBER AS SONUMBER,
                zdc.KWMENG AS ORDERQUANTITY,
                zd.CANCELLEDINVOICENO AS CANCELLEDINVOICENO,
                zd.DOCUMENT_CATEGORY AS DOCUMENT_CATEGORY,
                zd.BILLINGTYPE AS BILLINGTYPE,
                zd.SALES_FLAG AS SALES_FLAG,
                zd.QUANTITY_ZERO_FLAG AS QUANTITY_ZERO_FLAG,
                zd.EWAYBILLNO AS EWAYBILLNO,
                zd.EWAYDATE AS EWAYDATE,
                CASE
                    WHEN zd.BILLINGTYPE IN ('ZCMR',
                                            'ZPCR',
                                            'ZDMR',
                                            'ZCFR') THEN 0
                    ELSE COALESCE(zd.INVOICEDQUANTITY, 0)
                END AS INVOICEDQUANTITY,
                zd.NETWR_VFKP AS NETWR_VFKP,
                zb.MRP_RS_BAG AS MRP_RS_BAG,
                zb.GROSS_BILL_PRICE AS GROSS_BILL_PRICE,
                zb.INVOICE_PD AS INVOICE_PD,
                zb.MANUAL_PD AS MANUAL_PD,
                zb.NET_BILL_PRICE AS NET_BILL_PRICE,
                zb.SGST AS SGST,
                zb.CGST AS CGST,
                zb.IGST AS IGST,
                zb.TOTAL_TAX AS TOTAL_TAX,
                zb.PRIMARY_FREIGHT AS PRIMARY_FREIGHT,
                zb.MANUAL_FREIGHT AS MANUAL_FREIGHT,
                zb.TOTAL_PRIMARY_FREIGHT AS TOTAL_PRIMARY_FREIGHT,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('03') THEN zd.NETWR_VFKP
                    ELSE zb.TOTAL_PRIMARY_FREIGHT
                END AS PRIMARY_FREIGHT_2,
                zb.SECONDARY_FREIGHT AS SECONDARY_FREIGHT,
                zb.TOTAL_FREIGHT AS TOTAL_FREIGHT,
                zb.HANDLING_CHARGE AS HANDLING_CHARGE,
                zb.GODOWN_RENT AS GODOWN_RENT,
                zb.BRANCH_EXPENSES_MANUAL AS BRANCH_EXPENSES_MANUAL,
                zb.TDC AS TDC,
                zb.TOTAL_DISCOUNT AS TOTAL_DISCOUNT,
                zb.TOTAL_COMMISION AS TOTAL_COMMISION,
                zb.TOTAL_DISCOUNT_COMMISION AS TOTAL_DISCOUNT_COMMISION,
                zb.CLINKER_PERCENTAGE AS CLINKER_PERCENTAGE,
                zb.TOTAL_CLINKER_FREIGHT AS TOTAL_CLINKER_FREIGHT,
                zb.PACKING_CHARGES AS PACKING_CHARGES,
                zb.OTHER_MANUAL_ADJUSTMENT AS OTHER_MANUAL_ADJUSTMENT,
                zb.NCR_WITHOUT_SUBSIDY AS NCR_WITHOUT_SUBSIDY,
                zb.TOTAL_REMISSION AS TOTAL_REMISSION,
                zb.FINAL_NCR AS FINAL_NCR,
                zb.TOTAL_CASH_REMMISSION AS TOTAL_CASH_REMMISSION,
                zb.NET_BILL_PRICE_WITH_GD_IMPACT AS NET_BILL_PRICE_WITH_GD_IMPACT,
                zb.PF_DIST AS PF_DIST,
                zb.SF_DIST AS SF_DIST,
                zd.ORDER_PLATFORM AS ORDER_PLATFORM,
                zd.PONUMBER AS PONUMBER,
                zd.PO_DATE AS PO_DATE,
                CAST(zd.BILLINGDATE AS DATE) AS REPORT_DATE,
                CASE
                    WHEN DAY(zd.BILLINGDATE) >=1
                         AND DAY(zd.BILLINGDATE) <= 7 THEN 'W1'
                    WHEN DAY(zd.BILLINGDATE) >=8
                         AND DAY(zd.BILLINGDATE) <= 14 THEN 'W2'
                    WHEN DAY(zd.BILLINGDATE) >=15
                         AND DAY(zd.BILLINGDATE) <= 21 THEN 'W3'
                    WHEN DAY(zd.BILLINGDATE) >=22
                         AND DAY(zd.BILLINGDATE) <= 28 THEN 'W4'
                    ELSE 'W5'
                END AS WEEK_NO,
                CAST(zd.BILLINGDATE AS TIMESTAMP) AS BILLINGDATE_TIMESTAMP,
                CAST(zd.BILLINGDATE AS DATE) AS BILLINGDATE,
                CAST(zd.SODATE AS DATE) AS SODATE,
                CAST(t.DO_RELEASE_DATE_TIME AS DATETIME) AS DO_RELEASE_DATE_TIME,
                CAST(t.SCHEDULE_DATE_TIME AS DATETIME) AS SCHEDULE_DATE_TIME,
                CAST(t.SO_RELEASE_DATE_TIME AS DATETIME) AS SO_RELEASE_DATE_TIME,
                CAST(t.DELIVERY_DATE_TIME AS DATETIME) AS DELIVERY_DATE_TIME,
                CAST(t.TRANS_TAGG_DATE_TIME AS DATETIME) AS TRANS_TAGG_DATE_TIME,
                CAST(t.SHIP_DATE_TIME AS DATETIME) AS SHIP_DATE_TIME,
                CAST(t.PKGCALL_DATE_TIME AS DATETIME) AS PKGCALL_DATE_TIME,
                CAST(t.YARD_IN_DATE_TIME AS DATETIME) AS YARD_IN_DATE_TIME,
                CAST(t.YARD_OUT_DATE_TIME AS DATETIME) AS YARD_OUT_DATE_TIME,
                CAST(t.SECURITY_IN_DATE_TIME AS DATETIME) AS SECURITY_IN_DATE_TIME,
                CAST(t.TARE_DATE_TIME AS DATETIME) AS TARE_DATE_TIME,
                CAST(t.ACTUAL_LOAD_DATE_TIME AS DATETIME) AS ACTUAL_LOAD_DATE_TIME,
                CAST(t.GROSS_DATE_TIME AS DATETIME) AS GROSS_DATE_TIME,
                CAST(t.BILLING_DATE_TIME AS DATETIME) AS BILLING_DATE_TIME,
                CAST(t.SECURITY_OUT_DATE_TIME AS DATETIME) AS SECURITY_OUT_DATE_TIME,
                t.TAT AS TAT,
                t.SO_DO_TIME AS SO_DO_TIME,
                t.DO_SHIP_TIME AS DO_SHIP_TIME,
                t.DO_TRANS_TAGG_TIME AS DO_TRANS_TAGG_TIME,
                t.TRANS_TAGG_SHIP_TIME AS TRANS_TAGG_SHIP_TIME,
                t.SHIP_PH_CALL_TIME AS SHIP_PH_CALL_TIME,
                t.PH_SEC_CALL_TIME AS PH_SEC_CALL_TIME,
                t.SEC_TARE_CALL_TIME AS SEC_TARE_CALL_TIME,
                t.TW_LOAD_TIME AS TW_LOAD_TIME,
                t.LOAD_GW_TIME AS LOAD_GW_TIME,
                t.GW_INV_TIME AS GW_INV_TIME,
                t.INV_GO_TIME AS INV_GO_TIME,
                t.SLA_DATE_TIME AS SLA_DATE_TIME,
                zd.INCOTERMS1 AS INCOTERMS1,
                zd.REGIO AS STATE_CODE_TRANSACTION,
                zd.GEOGDISTRICTCODE AS RATE_CODE,
                UPPER(zd.GEOGDISTRICTNAME) AS RATE_CODE_DESC,
                zd.TZONE AS TZONE,
                UPPER(zd.TZONEDESC) AS TZONE_DESC,
                zd.MATERIALNUMBER AS MATERIALNUMBER,
                m.MATERIAL_DESCRIPTION AS MATERIAL_DESCRIPTION,
                m.MATERIAL_SUBTYPE_MKT AS MATERIAL_SUBTYPE_MKT,
                CASE
                    WHEN m.MATNR_BRAND IN ('Loose') THEN 'LOOSE'
                    ELSE m.BAG_TYPE_ACTUAL
                END AS BAG_TYPE_ACTUAL,
                m.PRODUCT_SALES_TEAM AS PRODUCT_SALES_TEAM,
                m.PRODUCT_MFG_TEAM AS PRODUCT_MFG_TEAM,
                m.MATNR_BRAND AS MATNR_BRAND,
                m.BLENDED_NONBLENDED AS BLENDED_NONBLENDED,
                CASE
                    WHEN m.MATNR_BRAND IN ('Loose') THEN 'Loose'
                    ELSE 'Bag'
                END AS BAG_LOOSE,
                zd.MANUFACTURING_PLANT AS MANUFACTURING_PLANT,
                CASE
                    WHEN zd.MANUFACTURING_PLANT = '1325' THEN '1321'
                    ELSE zd.MANUFACTURING_PLANT
                END AS ACTUAL_MFG_PLANT,
                zd.PLANTCODE AS PLANTCODE,
                UPPER(zd.PLANTDESC) AS PLANTDESC,
                p.PLANT_TYPE_2 AS PLANT_TYPE_2,
                p.PLANT_DEPOT_TYPE AS PLANT_DEPOT_TYPE,
                p.PLANT_CODE_CLUBBED AS PLANT_CODE_CLUBBED,
                p.PLANT_NAME_CLUBBED AS PLANT_NAME_CLUBBED,
                p.PLANT_STATE_CODE AS PLANT_STATE_CODE,
                p.PLANT_STATE_NAME AS PLANT_STATE_NAME,
                p.PLANT_SUB_STATE AS PLANT_SUB_STATE,
                zd.DEPODIRECT AS DEPODIRECT,
                CASE
                    WHEN p.PLANT_DEPOT_TYPE IN ('Plant',
                                                'E2E') THEN 'Direct'
                    ELSE 'Depot'
                END AS DEPODIRECT_2,
                zd.ROUTE AS ROUTE,
                UPPER(zd.ROUTEDESC) AS ROUTEDESC,
                zd.TRANSPORTERCODE AS TRANSPORTERCODE,
                UPPER(zd.TRANSPORTERNAME) AS TRANSPORTERNAME,
                UPPER(zd.DRIVERNAME) AS DRIVERNAME,
                zd.MOBILENO_DRIVER AS MOBILENO_DRIVER,
                zd.LORRYORTRUCKNO AS LORRYORTRUCKNO,
                zd.TRUCKTYPEHU AS TRUCKTYPEHU,
                zd.TRUCKTYPEDESCHU AS TRUCKTYPEDESCHU,
                zd.SHIPMENTTYPE AS SHIPMENTTYPE,
                zd.SHIPPINGTYPE AS SHIPPINGTYPE,
                zd.CHARG AS CHARG,
                zd.BATCHSOURCE AS BATCHSOURCE,
                zd.BATCHNUMBER AS BATCHNUMBER,
                zd.MODEOFTRANSPORT AS MODEOFTRANSPORT,
                zd.VTEXT AS MEANSOFTRANSPORT_TYPE,
                zd.STOLOC AS STOLOC,
                CASE
                    WHEN zd.BILLINGTYPE IN ('ZLIT') THEN 'Damage'
                    WHEN zd.STOLOC IN ('RG01',
                                       'RL01',
                                       'SA01',
                                       'RSD1') THEN 'Fresh'
                    WHEN zd.STOLOC IN ('CS01') THEN 'Loose'
                    WHEN zd.STOLOC IN ('CT01',
                                       'DM01',
                                       'IPW1',
                                       'LIST',
                                       'LT01',
                                       'TL01',
                                       'ZSIT',
                                       'OCFD',
                                       'OCFG',
                                       'ST01') THEN 'Damage'
                    ELSE 'Others'
                END AS DAMAGE_FLAG,
                CASE
                    WHEN zd.BILLINGTYPE IN ('ZLIT') THEN 'Damage'
                    WHEN zd.STOLOC IN ('RG01',
                                       'RL01',
                                       'SA01',
                                       'RSD1',
                                       'CS01') THEN 'Fresh'
                    WHEN zd.STOLOC IN ('CT01',
                                       'DM01',
                                       'IPW1',
                                       'LIST',
                                       'LT01',
                                       'TL01',
                                       'ZSIT',
                                       'OCFD',
                                       'OCFG',
                                       'ST01') THEN 'Damage'
                    ELSE 'Others'
                END AS DAMAGE_FLAG_2,
                zd.TRIPID AS TRIPID,
                zd.SHIFT AS SHIFT,
                zd.SO_CODE_TRANSACTION AS SO_CODE_TRANSACTION,
                UPPER(zd.SO_NAME_TRANSACTION) AS SO_NAME_TRANSACTION,
                zd.ASM_CODE_TRANSACTION AS ASM_CODE_TRANSACTION,
                UPPER(zd.ASM_NAME_TRANSACTION) AS ASM_NAME_TRANSACTION,
                zd.RSM_CODE_TRANSACTION AS RSM_CODE_TRANSACTION,
                UPPER(zd.RSM_NAME_TRANSACTION) AS RSM_NAME_TRANSACTION,
                zd.ZSM_CODE_TRANSACTION AS ZSM_CODE_TRANSACTION,
                UPPER(zd.ZSM_NAME_TRANSACTION) AS ZSM_NAME_TRANSACTION,
                zd.STATE_HEAD_TRANSACTION AS RSD_CODE_TRANSACTION,
                UPPER(zd.STATE_HEAD_NAME_TRANSACTION) AS RSD_NAME_TRANSACTION,
                zd.Z6_CODE_TRANSACTION AS Z6_CODE_TRANSACTION,
                UPPER(zd.Z6_NAME_TRANSACTION) AS Z6_NAME_TRANSACTION,
                zd.SOLDTOPARTYCODE AS SOLDTOPARTYCODE,
                UPPER(TRIM(cma.BUSINESS_PARTNER_NAME||' '||cma.CUSTOMER_NAME2)) AS SOLDTOPARTYNAME,
                cma.REGION_CODE AS STATE_CODE_SOLDTO,
                UPPER(cma.REGION_NAME) AS STATE_NAME_SOLDTO,
                cma.CITY_CODE AS CITY_CODE_SOLDTO,
                UPPER(cma.CITY_NAME) AS CITY_NAME_SOLDTO,
                cma.COUNTY_CODE AS COUNTY_CODE_SOLDTO,
                UPPER(cma.COUNTY_NAME) AS COUNTY_NAME_SOLDTO,
                cma.SALES_TERRITORY AS SALES_TERRITORY_SOLDTO,
                cma.TALUKA_CODE AS TALUKA_CODE_SOLDTO,
                UPPER(cma.TRANSPORTATION_ZONE) AS TZONE_SOLDTO,
                UPPER(cma.TRANSPORT_ZONE_NAME) AS TZONE_NAME_SOLDTO,
                cma.LONGITUDE AS LONGITUDE_SOLDTO,
                cma.LATITUDE AS LATITUDE_SOLDTO,
                cma.BP_TYPE AS BP_TYPE_SOLDTO,
                UPPER(cma.BP_DESCRIPTION) AS BP_DESCRIPTION_SOLDTO,
                cma.SALES_DISTRICT AS RATE_CODE_SOLDTO,
                UPPER(cma.SALES_DISTRICT_NAME) AS RATE_CODE_DESC_SOLDTO,
                cma.CUSTOMER_GRP1 AS CUSTOMER_GRP1_SOLDTO,
                UPPER(cma.CUSTOMER_GRP1_DESCRIPTION) AS CUSTOMER_GRP1_DESC_SOLDTO,
                cma.CUSTOMER_GRP2 AS CUSTOMER_GRP2_SOLDTO,
                cma.CUSTOMER_GROUP AS CUSTOMER_GROUP_SOLDTO,
                CASE
                    WHEN cma.CUSTOMER_GROUP IN ('GA',
                                                'GC',
                                                'GI',
                                                'GR',
                                                'GV') THEN 'Government'
                    ELSE 'Others'
                END AS CUSTOMER_GROUP_GOVT_SOLDTO,
                cma.CUSTOMER_ACCOUNT_GROUP AS CUSTOMER_ACCOUNT_GROUP_SOLDTO,
                cma.Z1_VENDOR_CODE AS SO_CODE_MASTER_SOLDTO,
                UPPER(cma.Z1_VENDOR_NAME) AS SO_NAME_MASTER_SOLDTO,
                cma.Z2_VENDOR_CODE AS ASM_CODE_MASTER_SOLDTO,
                UPPER(cma.Z2_VENDOR_NAME) AS ASM_NAME_MASTER_SOLDTO,
                cma.Z3_VENDOR_CODE AS RSM_CODE_MASTER_SOLDTO,
                UPPER(cma.Z3_VENDOR_NAME) AS RSM_NAME_MASTER_SOLDTO,
                cma.Z4_VENDOR_CODE AS ZSM_CODE_MASTER_SOLDTO,
                UPPER(cma.Z4_VENDOR_NAME) AS ZSM_NAME_MASTER_SOLDTO,
                cma.Z7_VENDOR_CODE AS RSD_CODE_MASTER_SOLDTO,
                UPPER(cma.Z7_VENDOR_NAME) AS RSD_NAME_MASTER_SOLDTO,
                cma.Z6_VENDOR_CODE AS Z6_CODE_MASTER_SOLDTO,
                UPPER(cma.Z6_VENDOR_NAME) AS Z6_NAME_MASTER_SOLDTO,
                zd.SHIPTOPARTYCODE AS SHIPTOPARTYCODE,
                UPPER(TRIM(cmb.BUSINESS_PARTNER_NAME||' '||cmb.CUSTOMER_NAME2)) AS SHIPTOPARTYNAME,
                cmb.Z6_VENDOR_CODE AS Z6_CODE_MASTER_SHIPTO,
                UPPER(cmb.Z6_VENDOR_NAME) AS Z6_NAME_MASTER_SHIPTO,
                zd.UNLOADINGPOINTCODE AS UNLOADINGPOINTCODE,
                UPPER(TRIM(cmc.BUSINESS_PARTNER_NAME||' '||cmc.CUSTOMER_NAME2)) AS UNLOADINGPOINTNAME,
                cmc.REGION_CODE AS STATE_CODE_UNLOADINGPOINT,
                UPPER(cmc.REGION_NAME) AS STATE_NAME_UNLOADINGPOINT,
                cmc.CITY_CODE AS CITY_CODE_UNLOADINGPOINT,
                UPPER(cmc.CITY_NAME) AS CITY_NAME_UNLOADINGPOINT,
                cmc.COUNTY_CODE AS COUNTY_CODE_UNLOADINGPOINT,
                UPPER(cmc.COUNTY_NAME) AS COUNTY_NAME_UNLOADINGPOINT,
                cmc.SALES_TERRITORY AS SALES_TERRITORY_UNLOADINGPOINT,
                cmc.TALUKA_CODE AS TALUKA_CODE_UNLOADINGPOINT,
                UPPER(cmc.TRANSPORTATION_ZONE) AS TZONE_UNLOADINGPOINT,
                UPPER(cmc.TRANSPORT_ZONE_NAME) AS TZONE_NAME_UNLOADINGPOINT,
                cmc.LONGITUDE AS LONGITUDE_UNLOADINGPOINT,
                cmc.LATITUDE AS LATITUDE_UNLOADINGPOINT,
                cmc.BP_TYPE AS BP_TYPE_UNLOADINGPOINT,
                UPPER(cmc.BP_DESCRIPTION) AS BP_DESCRIPTION_UNLOADINGPOINT,
                cmc.SALES_DISTRICT AS RATE_CODE_UNLOADINGPOINT,
                UPPER(cmc.SALES_DISTRICT_NAME) AS RATE_CODE_DESC_UNLOADINGPOINT,
                cmc.CUSTOMER_GRP1 AS CUSTOMER_GRP1_UNLOADINGPOINT,
                UPPER(cmc.CUSTOMER_GRP1_DESCRIPTION) AS CUSTOMER_GRP1_DESC_UNLOADINGPOINT,
                cmc.CUSTOMER_GRP2 AS CUSTOMER_GRP2_UNLOADINGPOINT,
                cmc.CUSTOMER_GROUP AS CUSTOMER_GROUP_UNLOADINGPOINT,
                cmc.CUSTOMER_ACCOUNT_GROUP AS CUSTOMER_ACCOUNT_GROUP_UNLOADINGPOINT,
                cmc.Z1_VENDOR_CODE AS SO_CODE_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z1_VENDOR_NAME) AS SO_NAME_MASTER_UNLOADINGPOINT,
                cmc.Z2_VENDOR_CODE AS ASM_CODE_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z2_VENDOR_NAME) AS ASM_NAME_MASTER_UNLOADINGPOINT,
                cmc.Z3_VENDOR_CODE AS RSM_CODE_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z3_VENDOR_NAME) AS RSM_NAME_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z3_VENDOR_EMAIL_ID) AS RSM_EMAIL_MASTER_UNLOADINGPOINT,
                cmc.Z4_VENDOR_CODE AS ZSM_CODE_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z4_VENDOR_NAME) AS ZSM_NAME_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z4_VENDOR_EMAIL_ID) AS ZSM_EMAIL_MASTER_UNLOADINGPOINT,
                cmc.Z7_VENDOR_CODE AS RSD_CODE_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z7_VENDOR_NAME) AS RSD_NAME_MASTER_UNLOADINGPOINT,
                cmc.Z6_VENDOR_CODE AS Z6_CODE_MASTER_UNLOADINGPOINT,
                UPPER(cmc.Z6_VENDOR_NAME) AS Z6_NAME_MASTER_UNLOADINGPOINT,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL NOT IN ('02') THEN zd.SALES_TYPE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('02')
                         AND cma.ATTRIBUTE_3 IN ('02') THEN 'Key'
                    ELSE 'Non Key'
                END AS KEY_NONKEY_1,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL NOT IN ('02') THEN zd.SALES_TYPE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('02') THEN (CASE
                                                                    WHEN cma.ATTRIBUTE_3 IN ('12')
                                                                         OR cma.BP_TYPE IN ('ZV38') THEN 'Consignment'
                                                                    WHEN cma.ATTRIBUTE_3 IN ('02') THEN 'Key'
                                                                    WHEN cma.ATTRIBUTE_3 IN ('03') THEN 'Non Key'
                                                                    ELSE 'Non Key'
                                                                END)
                    ELSE 'Non Key'
                END AS KEY_NONKEY_2,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL NOT IN ('02') THEN zd.SALES_TYPE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('02') THEN (CASE
                                                                    WHEN cma.ATTRIBUTE_3 IN ('12')
                                                                         OR cma.BP_TYPE IN ('ZV38') THEN 'Consignment'
                                                                    WHEN cma.ATTRIBUTE_3 IN ('02') THEN 'National Key'
                                                                    WHEN cma.ATTRIBUTE_3 IN ('03') THEN 'Regional Key'
                                                                    ELSE 'Non Key'
                                                                END)
                    ELSE 'Non Key'
                END AS KEY_NONKEY_3,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('02') THEN (CASE
                                                                    WHEN cma.ATTRIBUTE_3 IN ('12')
                                                                         OR cma.BP_TYPE IN ('ZV38') THEN 'Consignment'
                                                                    ELSE 'Regular'
                                                                END)
                    ELSE 'Regular'
                END AS REGULAR_CONSIGNMENT,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('03') THEN 'Stock Transfer'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('04') THEN 'Self Consumption'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('06')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmb.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmc.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP') THEN 'Export Sales'
                    WHEN zd.BILLINGTYPE IN ('ZLIT')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZOTH') THEN 'Damage'
                    WHEN zd.SALES_ORGANISATION IN ('1020',
                                                   '3000',
                                                   '6000')
                         AND UPPER(TRIM(cma.BUSINESS_PARTNER_NAME)) IN ('CASH SALES PLANT') THEN 'OTH'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00114',
                                                   'DC00030',
                                                   'DC00055',
                                                   'DC00060',
                                                   'DC00116',
                                                   'F01SR0000BU0001',
                                                   'F01SR000DLHWTN1',
                                                   'F01SR000DLHWTN2',
                                                   'F01SR000DLHWTN3',
                                                   'F01SR000DLHWTN4') THEN cmc.CUSTOMER_GRP2||' SRPC'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00002',
                                                   'DC00013',
                                                   'F01OW000DPABNN1',
                                                   'F01OW000DLHWTN1') THEN 'OWC'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00115',
                                                   'DC00027',
                                                   'F01OP53S0BU0001',
                                                   'F01OP53SDHDWTN1') THEN 'SOC'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00110',
                                                   'F01OP043DHDPKN1') THEN 'Govt Tancem'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00052',
                                                   'F01PPAMADHDWTN1') THEN 'Govt AMMA'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.DISTRIBUTIONCHANNEL IN ('01')
                         AND (cma.REGION_CODE IN ('26')
                              OR cma.CUSTOMER_GRP2 IN ('AN1')) THEN 'AN1'
                    WHEN zd.SALES_ORGANISATION IN ('1020',
                                                   '3000',
                                                   '6000')
                         AND wfa.CUSTOMER_CATEGORY_WF IN ('Government NE',
                                                          'Government East') THEN wfa.CUSTOMER_CATEGORY_WF
                    WHEN zd.SALES_ORGANISATION IN ('1020',
                                                   '3000',
                                                   '6000') THEN (CASE
                                                                     WHEN cmc.REGION_CODE IN ('03') THEN 'ASM'
                                                                     WHEN cmc.REGION_CODE IN ('15') THEN 'MGH'
                                                                     WHEN cmc.REGION_CODE IN ('02') THEN 'ARP'
                                                                     WHEN cmc.REGION_CODE IN ('23') THEN 'TRP'
                                                                     WHEN cmc.REGION_CODE IN ('14') THEN 'MNP'
                                                                     WHEN cmc.REGION_CODE IN ('16') THEN 'MIZO'
                                                                     WHEN cmc.REGION_CODE IN ('17') THEN 'NGL'
                                                                     WHEN cma.REGION_CODE IN ('03') THEN 'ASM'
                                                                     WHEN cma.REGION_CODE IN ('15') THEN 'MGH'
                                                                     WHEN cma.REGION_CODE IN ('02') THEN 'ARP'
                                                                     WHEN cma.REGION_CODE IN ('23') THEN 'TRP'
                                                                     WHEN cma.REGION_CODE IN ('14') THEN 'MNP'
                                                                     WHEN cma.REGION_CODE IN ('16') THEN 'MIZO'
                                                                     WHEN cma.REGION_CODE IN ('17') THEN 'NGL'
                                                                     ELSE cmc.CUSTOMER_GRP2
                                                                 END)
                    WHEN zd.SALES_ORGANISATION IN ('1030',
                                                   '5010') THEN (CASE
                                                                     WHEN cmc.REGION_CODE IN ('12') THEN 'MP1'
                                                                     WHEN cmc.REGION_CODE IN ('13')
                                                                          AND zd.BILLINGTYPE IN ('ZRES') THEN 'OTH'
                                                                     ELSE COALESCE(COALESCE(cmc.CUSTOMER_GRP2, cmb.CUSTOMER_GRP2), cma.CUSTOMER_GRP2)
                                                                 END)
                    ELSE COALESCE(COALESCE(cmc.CUSTOMER_GRP2, cmb.CUSTOMER_GRP2), cma.CUSTOMER_GRP2)
                END AS STATE_WATERFALL_SD_WO_T_NT,
                CASE
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('03') THEN 'Stock Transfer'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('04') THEN 'Self Consumption'
                    WHEN zd.DISTRIBUTIONCHANNEL IN ('06')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmb.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP')
                         OR cmc.CUSTOMER_ACCOUNT_GROUP IN ('ZEXP') THEN 'Export Sales'
                    WHEN zd.BILLINGTYPE IN ('ZLIT')
                         OR cma.CUSTOMER_ACCOUNT_GROUP IN ('ZOTH') THEN 'Damage'
                    WHEN zd.SALES_ORGANISATION IN ('1020',
                                                   '3000',
                                                   '6000')
                         AND UPPER(TRIM(cma.BUSINESS_PARTNER_NAME)) IN ('CASH SALES PLANT') THEN 'OTH NT'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00114',
                                                   'DC00030',
                                                   'DC00055',
                                                   'DC00060',
                                                   'DC00116',
                                                   'F01SR0000BU0001',
                                                   'F01SR000DLHWTN1',
                                                   'F01SR000DLHWTN2',
                                                   'F01SR000DLHWTN3',
                                                   'F01SR000DLHWTN4') THEN cmc.CUSTOMER_GRP2||' SRPC'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00002',
                                                   'DC00013',
                                                   'F01OW000DPABNN1',
                                                   'F01OW000DLHWTN1') THEN 'OWC'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00115',
                                                   'DC00027',
                                                   'F01OP53S0BU0001',
                                                   'F01OP53SDHDWTN1') THEN 'SOC'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00110',
                                                   'F01OP043DHDPKN1') THEN 'Govt Tancem'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.MATERIALNUMBER IN ('DC00052',
                                                   'F01PPAMADHDWTN1') THEN 'Govt AMMA'
                    WHEN zd.SALES_ORGANISATION IN ('1000',
                                                   '4010')
                         AND zd.DISTRIBUTIONCHANNEL IN ('01')
                         AND (cma.REGION_CODE IN ('26')
                              OR cma.CUSTOMER_GRP2 IN ('AN1')) THEN 'AN1 NT'
                    WHEN zd.SALES_ORGANISATION IN ('1020',
                                                   '3000',
                                                   '6000')
                         AND wfa.CUSTOMER_CATEGORY_WF IN ('Government NE',
                                                          'Government East') THEN wfa.CUSTOMER_CATEGORY_WF
                    ELSE (CASE
                              WHEN zd.SALES_ORGANISATION IN ('1020',
                                                             '3000',
                                                             '6000') THEN (CASE
                                                                               WHEN cmc.REGION_CODE IN ('03') THEN 'ASM'
                                                                               WHEN cmc.REGION_CODE IN ('15') THEN 'MGH'
                                                                               WHEN cmc.REGION_CODE IN ('02') THEN 'ARP'
                                                                               WHEN cmc.REGION_CODE IN ('23') THEN 'TRP'
                                                                               WHEN cmc.REGION_CODE IN ('14') THEN 'MNP'
                                                                               WHEN cmc.REGION_CODE IN ('16') THEN 'MIZO'
                                                                               WHEN cmc.REGION_CODE IN ('17') THEN 'NGL'
                                                                               WHEN cma.REGION_CODE IN ('03') THEN 'ASM'
                                                                               WHEN cma.REGION_CODE IN ('15') THEN 'MGH'
                                                                               WHEN cma.REGION_CODE IN ('02') THEN 'ARP'
                                                                               WHEN cma.REGION_CODE IN ('23') THEN 'TRP'
                                                                               WHEN cma.REGION_CODE IN ('14') THEN 'MNP'
                                                                               WHEN cma.REGION_CODE IN ('16') THEN 'MIZO'
                                                                               WHEN cma.REGION_CODE IN ('17') THEN 'NGL'
                                                                               ELSE cmc.CUSTOMER_GRP2
                                                                           END)
                              WHEN zd.SALES_ORGANISATION IN ('1030',
                                                             '5010') THEN (CASE
                                                                               WHEN cmc.REGION_CODE IN ('12') THEN 'MP1'
                                                                               WHEN cmc.REGION_CODE IN ('13')
                                                                                    AND zd.BILLINGTYPE IN ('ZRES') THEN 'OTH'
                                                                               ELSE COALESCE(COALESCE(cmc.CUSTOMER_GRP2, cmb.CUSTOMER_GRP2), cma.CUSTOMER_GRP2)
                                                                           END)
                              ELSE COALESCE(COALESCE(cmc.CUSTOMER_GRP2, cmb.CUSTOMER_GRP2), cma.CUSTOMER_GRP2)
                          END) || (CASE
                                       WHEN zd.DISTRIBUTIONCHANNEL IN ('01') THEN ' T'
                                       ELSE ' NT'
                                   END)
                END AS STATE_WATERFALL_SD,
                COALESCE(vc.VC_TARGET, 0) AS VC_RP_PER_MT,
                zd.INVOICEDQUANTITY * COALESCE(vc.VC_TARGET, 0) AS VC_RP_VALUE,
                CASE
                    WHEN COALESCE(vc.VC_TARGET, 0) = 0 THEN 0
                    ELSE zb.FINAL_NCR - (zd.INVOICEDQUANTITY * COALESCE(vc.VC_TARGET, 0))
                END AS CONTRIBUTION_RP_VALUE,
                CASE
                    WHEN zd.BILLINGTYPE IN ('ZCMR',
                                            'ZPCR',
                                            'ZDMR',
                                            'ZCFR') THEN 0
                    ELSE COALESCE(zd.INVOICEDQUANTITY, 0) * COALESCE(a767.A767_FREIGHT, 0)
                END AS A767_FREIGHT_VALUE,
                CASE
                    WHEN zd.BILLINGTYPE IN ('ZCMR',
                                            'ZPCR',
                                            'ZDMR',
                                            'ZCFR') THEN 0
                    ELSE COALESCE(zd.INVOICEDQUANTITY, 0) * (CASE
                                                                 WHEN p.PLANT_TYPE_2 IN ('YPMP',
                                                                                         'YPEP') THEN COALESCE(a767.A767_FREIGHT_Z3, 0)
                                                                 ELSE COALESCE(a767.A767_FREIGHT_ZJ, 0)
                                                             END)
                END AS A767_Z3_ZJ_FREIGHT_VALUE,
                CASE
                    WHEN zd.BILLINGTYPE IN ('ZCMR',
                                            'ZPCR',
                                            'ZDMR',
                                            'ZCFR') THEN 0
                    ELSE COALESCE(zd.INVOICEDQUANTITY, 0) * COALESCE(a893.A893_KBETR_ZLAB, 0)
                END AS A893_KBETR_ZLAB_VALUE,
                zd.BUSINESS_AREA,
                zd.PROFIT_CENTRE
FROM
  (SELECT *
   FROM EDWDM.TB_Z_DISP_INFO1 zd
   WHERE zd.BILLINGDATE < TO_CHAR(CAST(FROM_UTC_TIMESTAMP(CURRENT_TIMESTAMP, 'Asia/Kolkata') AS DATE), 'YYYYMMDD')
     AND zd.BILLINGDATE >= '20241201' ) zd
LEFT JOIN SAPSLT1.VBAP zdc ON zdc.VBELN = zd.SONUMBER
AND zdc.FKREL IN ('A')
AND zdc.SPART IN ('01')
AND zdc.POSNR IN ('000010')
LEFT JOIN EDWDM.TB_Z_DISP_INFO2 t ON zd.BILLINGDOCUMENT = t.BILLINGDOCUMENT
LEFT JOIN EDWDM.TB_Z_BILL_NCR zb ON zd.BILLINGDOCUMENT = zb.BILLINGDOCUMENT
LEFT JOIN EDWDM.TB_ORG_MASTER_INFO p ON zd.PLANTCODE = p.PLANT_CODE
LEFT JOIN EDWDM.TB_MATERIAL_INFO m ON zd.MATERIALNUMBER = m.MATERIAL_CODE
LEFT JOIN EDWDM.TB_FG_SFG mm ON (CASE
                                     WHEN zd.MANUFACTURING_PLANT = '1325' THEN '1321'
                                     ELSE zd.MANUFACTURING_PLANT
                                 END) = mm.WERKS
AND zd.MATERIALNUMBER = mm.MATNR
AND zd.DIVISIONCODE = mm.SPART
LEFT JOIN TRANSFORMATION.TB_CUSTOMER_MASTER_DETAILS cma ON zd.DISTRIBUTIONCHANNEL = cma.DISTRIBUTION_CHANNEL
AND zd.SALES_ORGANISATION = cma.SALES_ORGANISATION
AND zd.DIVISIONCODE = cma.DIVISION
AND zd.SOLDTOPARTYCODE = cma.BUSINESS_PARTNER_CODE
LEFT JOIN TRANSFORMATION.TB_CUSTOMER_MASTER_DETAILS cmb ON zd.DISTRIBUTIONCHANNEL = cmb.DISTRIBUTION_CHANNEL
AND zd.SALES_ORGANISATION = cmb.SALES_ORGANISATION
AND zd.DIVISIONCODE = cmb.DIVISION
AND zd.SHIPTOPARTYCODE = cmb.BUSINESS_PARTNER_CODE
LEFT JOIN TRANSFORMATION.TB_CUSTOMER_MASTER_DETAILS cmc ON zd.DISTRIBUTIONCHANNEL = cmc.DISTRIBUTION_CHANNEL
AND zd.SALES_ORGANISATION = cmc.SALES_ORGANISATION
AND zd.DIVISIONCODE = cmc.DIVISION
AND zd.UNLOADINGPOINTCODE = cmc.BUSINESS_PARTNER_CODE
LEFT JOIN MAN_UPLOAD.TB_CUSTOMER_CATEGORY_WF wfa ON wfa.CUSTOMER_CODE = zd.SOLDTOPARTYCODE
LEFT JOIN TRANSFORMATION.TB_BILLINGDOCUMENT_A767_FREIGHT a767 ON a767.BILLINGDOCUMENT = zd.BILLINGDOCUMENT
LEFT JOIN TRANSFORMATION.TB_BILLINGDOCUMENT_A893_KBETR_ZLAB a893 ON a893.BILLINGDOCUMENT = zd.BILLINGDOCUMENT
LEFT JOIN VC_TARGET_DSR_DATA vc ON vc.PRODUCT_SALES_TEAM = m.PRODUCT_SALES_TEAM
AND vc.ACTUAL_MFG_PLANT = (CASE
                               WHEN zd.MANUFACTURING_PLANT = '1325' THEN '1321'
                               ELSE zd.MANUFACTURING_PLANT
                           END)
AND FIRST_DAY(vc.REPORT_DATE) = FIRST_DAY(CAST(zd.BILLINGDATE AS DATE)) ;