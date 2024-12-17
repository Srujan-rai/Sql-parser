INSERT INTO EDWDM.TB_STAGE10_TRANSFORMATION
SELECT DISTINCT 
	a.MATERIALNUMBER, 
	a.BILLINGDOCUMENT, 
	a.BILLINGDATE, 
	a.BILLINGTYPE, 
	a.COMPANY_CODE, 
	a.DEPODIRECT, 
	a.DISTRIBUTIONCHANNEL, 
	a.DOC_CONDITION_NUMBER, 
	a.MANUFACTURING_PLANT, 
	a.STORAGE_LOCATION, 
	a.MODEOFTRANSPORT, 
	a.BATCHSOURCE, 
	a.CHARG,
	a.BATCH, 
	a.SALES_ORGANISATION, 
	a.SALES_TYPE, 
	a.DIVISIONCODE, 
	a.TZONE, 
	a.SHIPPINGTYPE, 
	a.SONUMBER, 
	a.BATCHNUMBER, 
	a.GEOGDISTRICTCODE, 
	a.GEOGDISTRICTNAME, 
	a.TRANSPORTATIONPLANPOINT, 
	a.CUSTOMERGROUPSALES, 
	a.SOLDTOPARTYCODE, 
	a.SOLD_TO_SUBSTATE, 
	a.SOLD_TO_DISTRICT_CODE, 
	a.SOLD_TO_STATE,
	a.SOLD_TO_STATE_NAME, 
	a.CUSTOMER_ACCOUNT_GROUP, 
	a.COMPANY_REGION, 
	a.REGION, 
	a.SHIPTOPARTYCODE, 
	a.SHIP_TO_STATE, 
	a.SHIP_TO_STATE_NAME,
	a.SHIP_TO_PARTY_SUBSTATE,
	a.SHIPTO_CUSTOMERACCOUNTGROUP, 
	a.SHIP_TO_DISTRICT_CODE,
	a.SALES_DISTRICT, 
	a.SALES_DISTRICT_NAME, 
	a.DELIVERY_NO, 
	a.INVOICEDQUANTITY, 
	a.INCOTERMS1, 
	a.TRANSPORTERCODE, 
	a.TRUCKTYPEHU, 
	a.ROUTE, 
	a.PLANTCODE, 
	a.PLANT_STATE_CODE, 
	a.SHIPMENTNO, 
	a.E2E_FLAG,
	a.NET_VALUE_NETWR, 
	a.TAX_AMOUNT_MWSBK, 
	a.ORDER_PLATFORM,
	a.ZBILL_INVOICE_VALUE, 
	a.NETWR_VFKP,
	a.SGST, 
	a.SGST_PERCENT, 
	a.SGST_R, 
	a.CGST, 
	a.CGST_PERCENT, 
	a.CGST_R, 
	a.IGST, 
	a.IGST_PERCENT, 
	a.IGST_R, 
	a.SGST_PERCENT_MP, 
	a.CGST_PERCENT_MP, 
	a.IGST_PERCENT_MP,
	a.INVOICE_PD, 
	a.INVOICE_CD, 
	a.GROSS_PRICE, 
	a.BILL_PRICE, 
	a.BASIC_PRICE, 
	a.EXCISE_DUTY_BASIC, 
	a.EXCISE_DUTY_BASE_VALUE, 
	a.TAX_PERCENT, 
	a.IGSR_NOT_RECOVERABLE, 
	a.PF_BUG, 
	a.GROSS, 
	a.EXCISE_DUTY_FIXED, 
	a.CESS, 
	a.HEC, 
	a.VAT_VALUE, 
	a.VAT_RATE, 
	a.CST_VALUE, 
	a.CST_RATE, 
	a.ENTRY_TAX, 
	a.GROSS_BILL_ZFOC, 
	a.FREIGHT_DISCOUNT, 
	a.TEMPORARY_FREIGHT_PRIMARY, 
	a.ZFT3_FREIGHT, 
	a.ZFTF_FREIGHT, 
	a.TEMPORARY_FREIGHT_PRIMARY_ZFT5, 
	a.ZQAD_DISCOUNT, 
	a.IP_COMISSION, 
	a.OTHER_DISCOUNT_2, 
	a.STKCLR_DISCOUNT, 
	a.CASH_DISCOUNT, 
	a.INVOICE_DISCOUNT123, 
	a.INVOICE_DISCOUNT, 
	a.CLEARANCE_DISCOUNT, 
	a.MRP, 
	a.UP_SPECIAL_TAX, 
	a.TCS_TAX, 
	a.FREIGHT_MT_0043000040_SOUTH_MP, 
	a.FREIGHT_MT_0043000041_SOUTH_MP, 
	a.FREIGHT_MT_0043000040_SOUTH, 
	a.FREIGHT_MT_0043000041_SOUTH,
	a.FREIGHT_MT_0043000040_MP, 
	a.IDT_0_0043000040, 
	a.IDT_1_0043000040, 
	a.IDT_2_0043000040,
	a.FREIGHT_MT_0043000041_MP, 
	a.IDT_0_0043000041, 
	a.IDT_1_0043000041, 
	a.IDT_2_0043000041,
	a.PACKING_BAG_T,
	b.HO_COST_BEX2, 
	b.FIX_CODE_BEX2, 
	b.ROAD_PMT_ZSDE155_BEX3, 
	b.RAIL_PMT_ZSDE155_BEX3, 
	b.RDDIV_PMT_ZSDE155_BEX3, 
	b.RDTRN_PMT_ZSDE155_BEX3, 
	b.RLDIV_PMT_ZSDE155_BEX3, 
	b.RLTRN_PMT_ZSDE155_BEX3, 
	b.ROAD_PMT_ZSDE155_BEX4, 
	b.RAIL_PMT_ZSDE155_BEX4, 
	b.PROFIT_RATE_PMT_BEX5, 
	b.TS_RATE, 
	b.TS_RATE_STP, 
	b.M_FREIGHT_T, 
	b.M_FREIGHT_INCO_T, 
	b.ROYALTY_AMOUNT, 
	b.OTHER_RATE_P_T, 
	f.EXCEPTION_EXP_AMOUNT, 
	f.OTHER_RATE_T, 
	f.CLINKER_FREIGHT_RATE, 
	f.TSONCLINKER_MT, 
	f.CHW,
	f.M_SF,
	f.M_SF_INCO,
	b.RATE_P_T_ON_DEALER_SALES,
	b.RATE_P_T_ON_SUB_DEALER_SA,
	f.RATE_P_T_ON_DEALER_SALES_Z,
	f.RATE_P_T_ON_SUB_DEALER_SA_Z,
	f.SP_COMMISSION_RATE_ZONE,
	f.SP_COMMISSION,
	c.DIRECTDISPATCHDISCOINT_INV_CUS,
	c.MOVING_AVERAGE_PRICE_VERPR,
	c.DIRECTDISPATCHDISCOINT_SO_MP_CUS,
	c.DAP_ID,
	c.BP_TYPE,
	c.MATERIAL_GROUP,
	c.MATERIAL_BRAND,
	c.BAG_TYPE,
	c.BAG_LOOSE,
	c.QUALITY,
	c.NET_PRICE_BRAND,
	c.RATE_INCO_PLANT_PRODUCT,
	c.PD,
	c.DISTANCE,
	c.DISCOUNT_RATE,
	c.QUARTERLY_DISCOUNT_QD_SOUTH,
	c.PD_COUNTY_WISE,
	c.CASH_DISCOUNT_CD_NEW,
	c.QUARTERLY_DISCOUNT_QD_NEW,
	c.SUB_DEALER_DISCOUNT_NEW,
	c.NEW_DISCOUNT_1_NEW,
	c.NEW_DISCOUNT_2_NEW,
	c.NEW_DISCOUNT_3_NEW,
	c.NEW_DISCOUNT_4_NEW,
	c.NEW_DISCOUNT_5_NEW,
	c.NEW_DISCOUNT_6_NEW,
	c.NEW_DISCOUNT_7_NEW,
	c.NEW_DISCOUNT_8_NEW,
	c.LASF_NEW,
	c.DATE_DIST_FROM,
	c.PD_STATE_INCO_SALESDIST_PRODUCT,
	d.SGST_INCENTIVE,
	d.SGST_REMISSION,
	d.CGST_REMISSION,
	d.PD_T_ZONE,
	d.PACKING_CHARGE_2546,
	d.GD_COMPANY_STATE_DIST_PRODUCT,
	d.GST_ON_GD,
	d.GD_COMPANY_STATE_RATECODE_PRODUCT,
	d.GST_ON_GD_R,
	d.GD_GL_BASED_ADJUSTMENT, 
	d.PD_COMPANY_STATE_DIST_PRODUCT,
	d.DATE_DIST_FROM_P,
	d.CASH_DISCOUNT_CD_NEW_PLANT,
	d.QUARTERLY_DISCOUNT_QD_NEW_PLANT,
	d.SUB_DEALER_DISCOUNT_NEW_PLANT,
	d.NEW_DISCOUNT_1_NEW_PLANT,
	d.NEW_DISCOUNT_2_NEW_PLANT,
	d.NEW_DISCOUNT_3_NEW_PLANT,
	d.NEW_DISCOUNT_4_NEW_PLANT,
	d.NEW_DISCOUNT_5_NEW_PLANT,
	d.NEW_DISCOUNT_6_NEW_PLANT,
	d.NEW_DISCOUNT_7_NEW_PLANT,
	d.NEW_DISCOUNT_8_NEW_PLANT,
	d.LASF_NEW_PLANT,
	d.MANUAL_DISCOUNT_UPLOAD_C_S_P,
	d.RAKE_DISCOUNT,
	d.PD_SOUTH_C_SOLD_M,
	d.PF_TEMP,
	d.MISSING_RAIL_FREIGHT,
	d.MISSING_RAIL_FREIGHT_2,
	d.DISTZ,
	d.BRAND_DISCOUNT,
	d.NE_COMMISSON,
	d.ORC_EXCEL,
	d.CLINKER_PERCENTAGE,
	e.RATE_KBETR_KONP_A927_SUM,
	e.RATE_KBETR_KONP_A927_AVG,
	e.RATE_KBETR_KONP_A767,
	e.A767_KBETR_FPD,
	e.RATE_KBETR_KONP_A881_SUM,
	e.RATE_KBETR_KONP_A881_YHCL,
	e.RATE_KBETR_KONP_A892,
	e.RATE_KBETR_KONP_A981,
	e.RATE_KBETR_KONP_A963,
	e.GODOWN_RENT_RATE,
	e.DATE_DISCOUNT_ZONE,
	e.CASH_DISCOUNT_CD_ZONE,
	e.QUARTERLY_DISCOUNT_QD_ZONE,
	e.SUB_DEALER_DISCOUNT_ZONE,
	e.NEW_DISCOUNT_1_ZONE,
	e.NEW_DISCOUNT_2_ZONE,
	e.NEW_DISCOUNT_3_ZONE,
	e.NEW_DISCOUNT_4_ZONE,
	e.NEW_DISCOUNT_5_ZONE,
	e.NEW_DISCOUNT_6_ZONE,
	e.NEW_DISCOUNT_7_ZONE,
	e.NEW_DISCOUNT_8_ZONE,
	e.LASF_ZONE,
	e.MANUAL_PD_R_P_T,
	e.SGST_R_P_T,
	e.CGST_R_P_T,
	e.IGST_R_P_T,
	e.PRIMARY_FREIGHT_R_P_T,
	e.IDT_1_R_P_T,
	e.IDT_2_R_P_T,
	e.IDT_3_R_P_T,
	e.MANUAL_FREIGHT_R_P_T,
	e.PRIMARY_FREIGHT_GTA_R_P_T,
	e.SEC_FREIGHT_R_P_T,
	e.SEC_FREIGHT_GTA_R_P_T,
	e.HANDLING_CHARGES_R_P_T,
	e.GODOWN_RENT_R_P_T,
	e.FREIGHT_DISCOUNT_R_P_T,
	e.CASH_DISCOUNT_R_P_T,
	e.INVOICE_DISCOUNT_R_P_T,
	e.QUARTERLY_DISCOUNT_R_P_T,
	e.ANNUAL_DISCOUNT_R_P_T,
	e.SOUTH_DISCOUNT_R_P_T,
	e.DSP_R_P_T,
	e.BRAND_DISCOUNT_R_P_T,
	e.STKCLR_DISCOUNT_R_P_T,
	e.RAKE_DISCOUNT_R_P_T,
	e.OTHER_DISCOUNT_R_P_T,
	e.QTY_DISCOUNT_R_P_T,
	e.OTHER_INV_DISCOUNT_R_,
	e.SP_COMMISION_R_P_T,
	e.IA_COMMISION_R_P_T,
	e.ORC_R_P_T,
	e.LASF_R_P_T,
	e.PRI_CLINKER_FREIGHT_R_P_T,
	e.SEC_CLINKER_FREIGHT_R_P_T,
	e.CLINKER_PERCENTAGE_R_P_T,
	e.CLINKER_FREIGHT_GTA_R_P_T,
	e.PACKING_CHARGES_R_P_T,
	e.BRAND_FEE_R_P_T,
	e.ROYALTY_R_P_T,
	e.OTHER_MANUAL_ADJ_R_P_T,
	e.ED_REMMISSION_R_P_T,
	e.SGST_REM_R_P_T,
	e.CGST_REM_R_P_T,
	e.IGST_REM_R_P_T,
	e.TS_RATE_R_P_T,
	e.EXCEPTION_EXP,
	e.CASH_DISCOUNT_CD_PLANT,
	e.QUARTERLY_DISCOUNT_QD_PLANT,
	e.SUB_DEALER_DISCOUNT_PLANT,
	e.NEW_DISCOUNT_1_PLANT,
	e.NEW_DISCOUNT_2_PLANT,
	e.NEW_DISCOUNT_3_PLANT,
	e.NEW_DISCOUNT_4_PLANT,
	e.NEW_DISCOUNT_5_PLANT,
	e.NEW_DISCOUNT_6_PLANT,
	e.NEW_DISCOUNT_7_PLANT,
	e.NEW_DISCOUNT_8_PLANT,
	e.DIRECT_DISPATCH_DISCOUNT,
	e.DATE_DIST_FROM_SP,
	e.LOGISTICS_SALES_TYPE,
	e.STATE_WATERFALL_SD,
	e.FLAG_STP,
	e.PF_EXPENSES_PER_T,
	e.BRANCH_EXPENSES_PER_T,
	e.SF_EXPENSES_PER_T,
	e.PACKING_EXPENSES_PER_T,
	e.DISCOUNT_EXPENSES_PER_T,
	e.ORC_EXPENSES_PER_T,
	a.VTEXT,
	c.PD_COUNTY_WISE_U,
	e.M_PF_PER_TON_C_MP_I,
	e.M_SF_PER_TON_C_MP_I,
	e.M_CHW_PER_TON_C_MP_I,
	e.M_PF_PER_TON_C_P_R_I_MOD,
	e.M_SF_PER_TON_C_P_R_I_MOD,
	e.M_CHW_PER_TON_C_P_R_I_MOD,
	e.TRATY,
	c.DIRECT_DEPOT_INCL_E2E,
	f.VC_RS_T_MANUAL,
	f.CLINKER_FREIGHT_RS_T_MANUAL,
	a.BUSINESS_AREA,
	a.PROFIT_CENTRE,
	a.IDNRK,
	a.COMPANY_REGION_CLUBBED_2,
	d.SP_IP_COMMISSION
FROM PRE_NCR.TB_STAGE10_1 a
LEFT JOIN PRE_NCR.TB_STAGE10_2_1 b ON b.BILLINGDOCUMENT = a.BILLINGDOCUMENT 
LEFT JOIN PRE_NCR.TB_STAGE10_3 c ON c.BILLINGDOCUMENT = a.BILLINGDOCUMENT 
LEFT JOIN PRE_NCR.TB_STAGE10_4 d ON d.BILLINGDOCUMENT = a.BILLINGDOCUMENT 
LEFT JOIN PRE_NCR.TB_STAGE10_5 e ON e.BILLINGDOCUMENT = a.BILLINGDOCUMENT 
LEFT JOIN PRE_NCR.TB_STAGE10_2_2 f ON f.BILLINGDOCUMENT = a.BILLINGDOCUMENT  
WHERE a.BILLINGDATE >= '20241201'
;
