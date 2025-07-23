-----------------------#*#*#*#*#* AMO-----------------------------------------
-- PATIENT LOG - DETAILS
--P2_DISTRICT
select distinct DISTRICT as d, DISTRICT as r from IM_USER_LOGIN where AADHAAR_LINKED_MOBILE_NO=:APP_USER
--Function:
CREATE OR REPLACE FUNCTION im_own_district_fn(p_mobile bigint)
	RETURNS Character varying
	language plpgsql
AS $$
DECLARE
v_district character varying;
BEGIN
	select distinct DISTRICT INTO v_district from IM_USER_LOGIN 
	where AADHAAR_LINKED_MOBILE_NO=p_mobile;

	RETURN v_district;
END;
$$;

-- SELECT im_own_district_fn(p_mobile);
-- SELECT  im_own_district_fn(8925591069);

--P2_NAME_OF_THE_INSTITUTION
select NAME_OF_THE_INSTITUTION as d, NAME_OF_THE_INSTITUTION as r from IM_USER_LOGIN where AADHAAR_LINKED_MOBILE_NO=:APP_USER order by NAME_OF_THE_INSTITUTION ASC;
--Function:
CREATE OR REPLACE FUNCTION im_institution_name_fn(p_mobile BIGINT)
	RETURNS character varying
	LANGUAGE plpgsql
AS $$
DECLARE
v_institude Character varying;
BEGIN
	select DISTINCT NAME_OF_THE_INSTITUTION INTO v_institude from IM_USER_LOGIN
	where AADHAAR_LINKED_MOBILE_NO= p_mobile;

	RETURN v_institude;

END;
$$;
--SELECT  im_institution_name_fn(p_mobile);
--SELECT  im_institution_name_fn(9500666115);


--P2_PATIENT_DISEASE
select distinct NAME_OF_THE_DISEASE as d, NAME_OF_THE_DISEASE as r from IM_DISEASE where system=:P2_SYSTEM order by NAME_OF_THE_DISEASE asc;

--Function:
CREATE OR REPLACE FUNCTION im_patient_disease_fn(
	p_mobile bigint)
	RETURNS TABLE (disease character varying)
	language plpgsql
AS $$
BEGIN
	RETURN Query
	select distinct NAME_OF_THE_DISEASE 
	from IM_DISEASE where           = (SELECT DISTINCT system FROM IM_USER_LOGIN
	                               WHERE AADHAAR_LINKED_MOBILE_NO= p_mobile )
	Order by 1 ASC;

END;
$$;

-- SELECT * FROM im_patient_disease_fn(8925591784);


--P2_PATIENT_GENDER
Male, Female, Boy Child, Girl Child, Transgender
--Function:
CREATE OR REPLACE  FUNCTION im_gender_fn()
	RETURNS TABLE(gender TEXT)
	LANGUAGE plpgsql
AS $$
BEGIN
	RETURN query
	SELECT 'Male'
	UNION ALL
	SELECT 'Female'
	UNION ALL
	SELECT 'Boy Child'
	UNION ALL
	SELECT 'Girl Child'
	UNION ALL
	SELECT 'Transgender';	

END;
$$;

--SELECT * FROM im_gender_fn()


--P2_MEDICINE_NAME
select distinct MEDICINE_NAME as d, MEDICINE_NAME as r from STOCK_DETAILS where
INSTITUTION_NAME = :P2_NAME_OF_THE_INSTITUTION;

--Function:
CREATE OR REPLACE FUNCTION im_medicine_name_fn(p_name_of_the_institude character varying)
	RETURNS TABLE(p_institude character varying)
	language plpgsql
	AS $$
BEGIN
	RETURN QUERY
	select distinct MEDICINE_NAME from STOCK_DETAILS 
	where INSTITUTION_NAME = p_name_of_the_institude;

END;
$$;

--SELECT im_medicine_name_fn('Ariyapopapuram');




-- When Click submit button , That time Run Below queries:  
--1.
INSERT INTO PATIENT_LOG(PATIENT_NAME,	MOBILE_NUMBER,	PATIENT_DISEASE,	PATIENT_GENDER,	MEDICINE_NAME , MEDICINE_QUANTITY , CREATED_BY ,	NAME_OF_THE_INSTITUTION , DISTRICT, SYSTEM)
 Values(:P2_PATIENT_NAME,	:P2_MOBILE_NUMBER,	:P2_PATIENT_DISEASE,	:P2_PATIENT_GENDER,	:P2_MEDICINE_NAME , :P2_MEDICINE_QUANTITY , :P2_CREATED_BY ,	:P2_NAME_OF_THE_INSTITUTION , :P2_DISTRICT, :P2_SYSTEM);  
--2.
UPDATE STOCK_DETAILS
SET QUANTITY = QUANTITY - :P2_MEDICINE_QUANTITY
WHERE medicine_name = :P2_MEDICINE_NAME and INSTITUTION_NAME = :P2_NAME_OF_THE_INSTITUTION and created_by = :APP_USER_NAME;

-- Function:
CREATE OR REPLACE FUNCTION ins_patient_fn(
	p_name character varying,
	p_mobile character varying,
	p_dicease character varying,
	p_gender character varying,
	p_Medicine character varying,
	p_quantity numeric,
	p_institution character varying,
	p_district character varying,
	p_system character varying)
	RETURNS VOID
	LANGUAGE plpgsql
    VOLATILE PARALLEL UNSAFE
AS $$
BEGIN
	INSERT INTO PATIENT_LOG(PATIENT_NAME
	                    ,	MOBILE_NUMBER
						,	PATIENT_DISEASE
						,	PATIENT_GENDER
						,	MEDICINE_NAME
						,   MEDICINE_QUANTITY
						,   CREATED_BY 
						,	NAME_OF_THE_INSTITUTION 
						,   DISTRICT
						,   SYSTEM)
				Values(p_name
				     , p_mobile
					 , p_dicease
					 , p_gender 
					 , p_Medicine 
					 , p_quantity
					 , p_mobile
					 , p_institution
					 , p_district
					 , p_system);
					 
	UPDATE STOCK_DETAILS
	SET QUANTITY = p_quantity,
		Updated_by = p_mobile
	WHERE medicine_name = p_Medicine
	and INSTITUTION_NAME = p_institution
	and created_by = p_mobile;
				 
END;
$$;

SELECT ins_patient_fn('Ram', '9751601990', 'dicease','gender','Medicine',5,'institution','district','system');


-- Indent Medicine:
SELECT
  c.MEDICINE_NAME,
  c.PACKING_SIZE,
  c.AMOUNT,
  c.QUANTITY,
  c.TOTAL_AMOUNT,
  c.INDENT_TYPE,
  c.NAME_OF_THE_INSTITUTION,
  c.QUARTERS,
  c.CREATED_BY,
  c.CREATED_DATE,
  c.UPDATED_BY,
  c.UPDATED_DATE,
  c.SNO,
  c.FINANCIAL_YEAR,
  c.NAME_OF_THE_DISTRICT,
  c.SYSTEM,
  c.SCHEME_NAME,
  c.INSTITUTION_TYPE,
  c.STOCK_AVAILBLE,
  c.STATUS,
  (SELECT regular FROM IM_ALLOTTED_BUDGET WHERE NAME_OF_THE_INSTITUTION = :P8_NAME_OF_THE_INSTITUTION and SYSTEM = :P8_SYSTEM) AS allotted_regular,
  b.REGULAR AS available_regular
FROM
  INDENT_MEDICINE_DETAILS c
LEFT JOIN
  IM_AVAILABLE_BUDGET b
ON
  c.NAME_OF_THE_INSTITUTION = b.NAME_OF_THE_INSTITUTION and c.SYSTEM = b.SYSTEM
WHERE
  c.NAME_OF_THE_INSTITUTION = :P8_NAME_OF_THE_INSTITUTION and c.SYSTEM = :P8_SYSTEM;  
  
--Function:
CREATE OR REPLACE FUNCTION im_INDENT_MEDICINE_DETAILS_fn(
	p_institution character varying,
	p_system character varying)
RETURNS TABLE(
  MEDICINE_NAME character varying,
  PACKING_SIZE character varying,
  AMOUNT character varying,
  QUANTITY numeric,
  TOTAL_AMOUNT character varying,
  INDENT_TYPE character varying,
  NAME_OF_THE_INSTITUTION character varying,
  QUARTERS character varying,
  CREATED_BY character varying,
  CREATED_DATE timestamp with time zone,
  UPDATED_BY character varying,
  UPDATED_DATE timestamp with time zone,
  SNO bigint,
  FINANCIAL_YEAR character varying,
  NAME_OF_THE_DISTRICT character varying,
  SYSTEM character varying,
  SCHEME_NAME character varying,
  INSTITUTION_TYPE character varying,
  STOCK_AVAILBLE numeric,
  STATUS character varying,
  allotted_regular numeric,
  available_regular numeric)
	language plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT
  c.MEDICINE_NAME,
  c.PACKING_SIZE,
  c.AMOUNT,
  c.QUANTITY,
  c.TOTAL_AMOUNT,
  c.INDENT_TYPE,
  c.NAME_OF_THE_INSTITUTION,
  c.QUARTERS,
  c.CREATED_BY,
  c.CREATED_DATE,
  c.UPDATED_BY,
  c.UPDATED_DATE,
  c.SNO,
  c.FINANCIAL_YEAR,
  c.NAME_OF_THE_DISTRICT,
  c.SYSTEM,
  c.SCHEME_NAME,
  c.INSTITUTION_TYPE,
  c.STOCK_AVAILBLE,
  c.STATUS,
  (SELECT i.regular FROM IM_ALLOTTED_BUDGET i
   WHERE i.NAME_OF_THE_INSTITUTION = p_institution 
   and i.SYSTEM = p_system) AS allotted_regular,
  b.REGULAR AS available_regular
FROM
  INDENT_MEDICINE_DETAILS c LEFT JOIN  IM_AVAILABLE_BUDGET b
ON
  c.NAME_OF_THE_INSTITUTION = b.NAME_OF_THE_INSTITUTION and c.SYSTEM = b.SYSTEM 
WHERE( c.NAME_OF_THE_INSTITUTION = p_institution OR p_institution IS NULL)
and (c.SYSTEM = p_system OR p_system is null);  
END;
$$;

--SELECT * FROM im_INDENT_MEDICINE_DETAILS_fn ('Kuruthancode', 'Siddha');
--SELECT * FROM im_INDENT_MEDICINE_DETAILS_fn (null, null);

  
-- When click CReate Button:  
1.
BEGIN 
INSERT INTO INDENT_MEDICINE_DETAILS(MEDICINE_NAME,PACKING_SIZE,AMOUNT,QUANTITY,TOTAL_AMOUNT,
INDENT_TYPE,NAME_OF_THE_INSTITUTION,QUARTERS,CREATED_BY,
CREATED_DATE,UPDATED_BY,UPDATED_DATE,SNO,FINANCIAL_YEAR,NAME_OF_THE_DISTRICT,
SYSTEM,SCHEME_NAME,INSTITUTION_TYPE,STOCK_AVAILBLE,STATUS) values(:P8_MEDICINE_NAME,:P8_PACKING_SIZE,:P8_AMOUNT,:P8_QUANTITY,:P8_TOTAL_AMOUNT,
:P8_INDENT_TYPE,:P8_NAME_OF_THE_INSTITUTION,:P8_QUARTERS,:P8_CREATED_BY,:P8_CREATED_DATE,:P8_UPDATED_BY,
:P8_UPDATED_DATE,:P8_SNO,:P8_FINANCIAL_YEAR,:P8_NAME_OF_THE_DISTRICT,:P8_SYSTEM,:P8_SCHEME_NAME,:P8_INSTITUTION_TYPE,:P8_STOCK_AVAILBLE,'Initiated');

EXCEPTION 
WHEN others then
dbms_output.put_line('Please Contact ADMIN');
END;  

--Procedure:
CREATE OR REPLACE PROCEDURE im_medicine_details_ins_sp(
	p_medicine character varying,
	 p_size character varying,
	 p_amount character varying,
	 p_quantity numeric,
	 p_total character varying,
	 p_type character varying,
	 p_institution character varying,
	 p_quarters character varying,
	 p_created_by character varying,
	 p_final_year character varying,
	 p_district character varying,
	 p_system character varying,
	 p_scheme character varying,
	 p_inst_type character varying,
	 p_stock numeric)
	 LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO INDENT_MEDICINE_DETAILS(MEDICINE_NAME,PACKING_SIZE,AMOUNT,QUANTITY,TOTAL_AMOUNT,
		INDENT_TYPE,NAME_OF_THE_INSTITUTION,QUARTERS,CREATED_BY,
		FINANCIAL_YEAR,NAME_OF_THE_DISTRICT,
		SYSTEM,SCHEME_NAME,INSTITUTION_TYPE,STOCK_AVAILBLE,STATUS) 
	values(p_medicine ,
	 p_size ,
	 p_amount ,
	 p_quantity ,
	 p_total ,
	 p_type ,
	 p_institution ,
	 p_quarters ,
	 p_created_by ,
	 p_final_year ,
	 p_district ,
	 p_system ,
	 p_scheme,
	 p_inst_type ,
	 p_stock ,
	 'Initiated' );
	EXCEPTION 
		WHEN others then
		RAISE NOTICE 'Please Contact ADMIN';
END;  
$$;

--Call procedure:
call im_medicine_details_ins_sp(
'p_medicine' ,
	 'p_size' ,
	 'p_amount' ,
	 5 ,
	 'p_total' ,
	 'p_type' ,
	 'p_institution' ,
	 'p_quarters' ,
	 'p_created_by' ,
	 'p_final_year' ,
	 'p_district' ,
	 'p_system' ,
	 'p_scheme',
	 'p_inst_type' ,
	 3);

This document have 4 APIs

As per provided document:
1. API – E-sevai form submition -- Get success after correct the payload request
2. API – E-sevai form status  -- Get failed (Error: Access Denied)
3. API – E-sevai Payment -- Get success

																																																						SYSTEM,SCHEME_NAME,INSTITUTION_TYPE,STOCK_AVAILBLE,STATUS) 

--GRAND TOTAL			
SELECT SUM(TOTAL_AMOUNT) INTO :GRAND_TOTAL
    FROM INDENT_MEDICINE_DETAILS where Status = 'Initiated' and CREATED_BY = :APP_USER_NAME;		
-- Function:
CREATE OR REPLACE FUNCTION im_grant_total_fn(p_user character varying)
	RETURNS INTEGER
	language plpgsql
AS $$
DECLARE 
v_amount INTEGER;
BEGIN
	SELECT SUM(TOTAL_AMOUNT) INTO v_amount
    FROM INDENT_MEDICINE_DETAILS where Status = 'Initiated' and CREATED_BY = p_user;		

	RETURN v_amount;
END;
$$;
--SELECT im_grant_total_fn(p_user);
	
--Total Quantity
SELECT SUM(Quantity) INTO :TOTAL_QTY
    FROM INDENT_MEDICINE_DETAILS where Status = 'Initiated' and CREATED_BY = :APP_USER_NAME;
--Function:
CREATE OR REPLACE FUNCTION im_total_fn(p_user character varying)
	RETURNS INTEGER
	language plpgsql
AS $$
DECLARE
	v_total INTEGER;
BEGIN
	SELECT SUM(Quantity) INTO v_total
    FROM INDENT_MEDICINE_DETAILS where Status = 'Initiated' and CREATED_BY = p_user;

	RETURN v_total;
END;
$$;

--SELECT im_total_fn(p_user);

--When Press Place indent Running Below query:
--SUBMIT_INDENT
DECLARE
v_no VARCHAR2(100);
BEGIN 
-- INSERT INTO INDENT_MEDICINE_PLACED(MEDICINE_NAME,PACKING_SIZE,AMOUNT,
-- QUANTITY,TOTAL_AMOUNT,INDENT_TYPE,NAME_OF_THE_INSTITUTION,
-- QUARTERS,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,SNO,
-- FINANCIAL_YEAR,NAME_OF_THE_DISTRICT,SYSTEM,SCHEME_NAME,INSTITUTION_TYPE, STOCK_AVAILABLE)
-- select MEDICINE_NAME,PACKING_SIZE,round (AMOUNT,2) as Amount,QUANTITY,TOTAL_AMOUNT,
-- INDENT_TYPE,NAME_OF_THE_INSTITUTION,QUARTERS,CREATED_BY,
-- CREATED_DATE,UPDATED_BY,UPDATED_DATE,SNO,FINANCIAL_YEAR,NAME_OF_THE_DISTRICT,SYSTEM,SCHEME_NAME,INSTITUTION_TYPE, STOCK_AVAILBLE
-- from INDENT_MEDICINE_DETAILS where CREATED_BY = :APP_USER_NAME;
-- END;
SELECT 'IM/'||TO_CHAR(SYSDATE,'YYMMDD')||'/'||LPAD(IM_INDENT_ID_NUMBER.NEXTVAL,4,0) INTO v_no FROM dual;
--Update INDENT_MEDICINE_DETAILS set STATUS = 'Order Placed' where CREATED_BY = :APP_USER_NAME;

Update INDENT_MEDICINE_DETAILS set STATUS = 'Order Placed' ,INDENT_ID_NUMBER = v_no where CREATED_BY = :APP_USER_NAME AND INDENT_ID_NUMBER IS NULL;
-- BEGIN
-- delete from indent_medicine_details where CREATED_BY = :APP_USER_NAME;
:GRAND_TOTAL := 0;
:TOTAL_QTY := 0;
EXCEPTION 
WHEN others then
dbms_output.put_line('Please Contact ADMIN');
END;
	-- Function:
	CREATE OR REPLACE FUNCTION im_submit_indent_fn(p_user character varying)
	RETURNS character varying
	language plpgsql
AS $$
BEGIN 
	Update INDENT_MEDICINE_DETAILS 
		set STATUS = 'Order Placed' ,
		INDENT_ID_NUMBER = 'IM/'||TO_CHAR(CURRENT_DATE,'YYMMDD')||'/'||NEXTVAL('IM_INDENT_ID_NUMBER')
	where CREATED_BY = p_user 
	AND INDENT_ID_NUMBER IS NULL;
	RETURN 'Data submitted successfully!';
EXCEPTION 
	WHEN others then
		RETURN 'Please Contact ADMIN';
	END;
$$;



-- Stock Details:
 select INSTITUTION_NAME,
SLNO,
       MEDICINE_NAME,
       PACKAGE_SIZE,
       QUANTITY,
       BATCH_NO,
       EXPIRY_DATE
  from STOCK_DETAILS 
  where CREATED_BY = :APP_USER_NAME 
  AND INSTITUTION_NAME = 
  (SELECT NAME_OF_THE_INSTITUTION FROM IM_USER_LOGIN 
   WHERE NAME_OF_THE_INDENTING_OFFICER = :APP_USER_NAME
   AND AADHAAR_LINKED_MOBILE_NO = :APP_USER)
  and QUANTITY IS NOT NULL order by EXPIRY_DATE ASC
--Function:
CREATE OR REPLACE FUNCTION im_stock_details_fn(
	p_user character varying,
	p_mobile bigint)
	RETURNS TABLE(p_institution character varying,
				  p_slno bigint,
				  p_medicine character varying,
				  p_size character varying,
				  p_qty text,
				  p_batch character varying,
				  p_date date)
	language plpgsql
AS $$
BEGIN
	RETURN QUERY
	select INSTITUTION_NAME,
	   SLNO,
       MEDICINE_NAME,
       PACKAGE_SIZE,
       QUANTITY,
       BATCH_NO,
       EXPIRY_DATE
  from STOCK_DETAILS 
  where CREATED_BY = p_user 
  AND INSTITUTION_NAME = (SELECT NAME_OF_THE_INSTITUTION FROM IM_USER_LOGIN 
  						   WHERE NAME_OF_THE_INDENTING_OFFICER = p_user
						   AND AADHAAR_LINKED_MOBILE_NO = p_mobile)
  and QUANTITY IS NOT NULL order by EXPIRY_DATE ASC;

END;
$$;
--SELECT * FROM im_stock_details_fn( 'V.Sowmmiya', '8925591782');


-- When Click on Add Button it move to another form Page:  
--P10_INSTITUTION_NAME
select distinct NAME_OF_THE_INSTITUTION as d, NAME_OF_THE_INSTITUTION as r from IM_USER_LOGIN where AADHAAR_LINKED_MOBILE_NO = :APP_USER;
--Function:
 SELECT im_institution_name_fn(p_mobile bigint);

--P10_MEDICINE_NAME
select distinct NAME_OF_THE_MEDICINE as d, NAME_OF_THE_MEDICINE as r from IM_MEDICINE join IM_USER_LOGIN on IM_MEDICINE.SYSTEM = IM_USER_LOGIN.SYSTEM and 
IM_USER_LOGIN.AADHAAR_LINKED_MOBILE_NO = :APP_USER order by NAME_OF_THE_MEDICINE asc
--Function:
 CREATE OR REPLACE FUNCTION im_name_of_medicine_fn(
	p_mobile bigint )
	returns character varying
	language plpgsql
AS $$
BEGIN
	select distinct NAME_OF_THE_MEDICINE from IM_MEDICINE m join IM_USER_LOGIN u
	      on m.SYSTEM = u.SYSTEM 
		  and u.AADHAAR_LINKED_MOBILE_NO = p_mobile 
		  order by NAME_OF_THE_MEDICINE asc;
END;
$$;


--P10_PACKAGE_SIZE
select distinct Packing_size as d, Packing_size as r from IM_MEDICINE where NAME_OF_THE_MEDICINE = :P10_MEDICINE_NAME

--FUnction:
CREATE OR REPLACE FUNCTION im_pack_size_fn(
	p_medicine character varying)
	returns table(p_size character varying)
	language plpgsql
AS $$
DECLARE
	v_size character varying(100);
BEGIN
	RETURN QUERY
	select distinct Packing_size from IM_MEDICINE 
	where NAME_OF_THE_MEDICINE = p_medicine;

END;
$$;

-- SELECT * FROM im_pack_size_fn('Aavarai Kudineer Chooranam');




-- WHen press Create button Running Beolow Query:
INSERT INTO STOCK_DETAILS(MEDICINE_NAME,	PACKAGE_SIZE,	QUANTITY,	BATCH_NO,	EXPIRY_DATE,	CREATED_BY,	INSTITUTION_NAME)
                Values(:P10_MEDICINE_NAME,	:P10_PACKAGE_SIZE,	:P10_QUANTITY,	:P10_BATCH_NO,	:P10_EXPIRY_DATE,	:P10_CREATED_BY,	:P10_INSTITUTION_NAME)
CREATE OR REPLACE PROCEDURE im_stock_dtls_ins_sp(
		p_medicine character varying,
		p_size character varying,
		p_qty text,
		p_batch character varying,
		p_date date,
		p_user character varying,
		p_institude character varying)
		language plpgsql
AS $$		
BEGIN
		INSERT INTO STOCK_DETAILS(MEDICINE_NAME,PACKAGE_SIZE,QUANTITY,	BATCH_NO,	EXPIRY_DATE,	CREATED_BY,	INSTITUTION_NAME)
			Values(p_medicine,p_size,p_qty,p_batch,p_date,p_user,p_institude);
END;
$$
--Calling procedure
Call im_stock_dtls_ins_sp(
		'p_medicine',
		'p_size character varying',
		'p_qty text',
		'p_batch character varying',
		current_date,
		'p_user character varying',
		'p_institude character varying')


-- View Indent Status:
--P12_INSTITUTION_NAME
select NAME_OF_THE_INSTITUTION as d, NAME_OF_THE_INSTITUTION as r from IM_USER_LOGIN where AADHAAR_LINKED_MOBILE_NO = :APP_USER; 
--Function:
 SELECT im_institution_name_fn(p_mobile bigint);

--P12_SYSTEM
select  distinct SYSTEM as d, SYSTEM as r from IM_USER_LOGIN where AADHAAR_LINKED_MOBILE_NO = :APP_USER; 
CREATE OR REPLACE FUNCTION im_system_fn(
	p_user bigint)
	returns table(system character varying)
	language plpgsql
AS $$
BEGIN
	RETURN query
	select  distinct i.SYSTEM from IM_USER_LOGIN i
	where i.AADHAAR_LINKED_MOBILE_NO = p_user;
END;
$$;

--Function:
SELECT im_system_fn(8925591944);

--P12_FINANCIAL_YEAR
select distinct FINANCIAL_YEAR as d, FINANCIAL_YEAR as r from indent_medicine_details;

CREATE OR REPLACE FUNCTION im_year_fn()
	RETURNS TABLE(year character varying)
	language plpgsql
AS $$
BEGIN
	RETURN QUERY
	select distinct FINANCIAL_YEAR from indent_medicine_details;
END;
$$
--function:
SELECT im_year_fn()

--P12_QUARTER
1st Quarter, 2nd Quarter, 3rd Quarter, 4th Quarter, Annual Indent

CREATE OR REPLACE  FUNCTION im_quarter_fn()
	RETURNS TABLE(quarter text)
	language plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT '1st Quarter'
	UNION ALL
	SELECT '2nd Quarter'
	UNION ALL
	SELECT '3rd Quarter'
	UNION ALL
	SELECT '4th Quarter'
	UNION ALL
	SELECT 'Annual Indent';
END;
$$;
--Function
SELECT im_quarter_fn();


--P12_INDENT_TYPE
Regular, Scheme
CREATE OR REPLACE FUNCTION im_Indent_typ_fn()
	RETURNs TABLE (type TEXT)
	language plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT 'Regular'
	UNION ALL 
	SELECT 'Scheme';
END;
$$;
--Function
SELECT im_Indent_typ_fn()


--P12_SCHEME_NAME
select distinct SCHEME_NAME as d, SCHEME_NAME as r from Indent_medicine_details where scheme_name is not null
--Function:
CREATE OR REPLACE FUNCTION im_scheme_names_fn()
RETURNS TABLE(scheme text)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT SCHEME_NAME 
  FROM Indent_medicine_details
  WHERE scheme_name IS NOT NULL;
END;
$$;



SELECT
IMED.SNO,
    IMED.MEDICINE_NAME,
    IMED.PACKING_SIZE,
    ROUND(IMED.AMOUNT, 2) AS Amount,
    IMED.QUANTITY,
    IMED.TOTAL_AMOUNT,
    IMED.SYSTEM,
    IMED.INDENT_TYPE,
    IMED.SCHEME_NAME,
    IMED.NAME_OF_THE_INSTITUTION,
    IMED.QUARTERS,
    IMED.CREATED_DATE,
    IMED.FINANCIAL_YEAR,
    IMED.NAME_OF_THE_DISTRICT,
    IMED.INSTITUTION_TYPE,
    IMED.STATUS
    FROM INDENT_MEDICINE_DETAILS IMED, IM_USER_LOGIN u
WHERE IMED.STATUS = 'Order Placed'
AND ((:P12_INSTITUTION_NAME IS NULL OR IMED.NAME_OF_THE_INSTITUTION = :P12_INSTITUTION_NAME)
     AND (:P12_FINANCIAL_YEAR IS NULL OR IMED.FINANCIAL_YEAR = :P12_FINANCIAL_YEAR)
     AND (:P12_QUARTER IS NULL OR IMED.QUARTERS = :P12_QUARTER)
     AND (:P12_INDENT_TYPE IS NULL OR IMED.INDENT_TYPE = :P12_INDENT_TYPE)
     AND (:P12_SCHEME_NAME IS NULL OR IMED.SCHEME_NAME = :P12_SCHEME_NAME)
     AND (:P12_STATUS IS NULL OR IMED.STATUS = :P12_STATUS)
     and (:P12_SYSTEM IS NULL OR IMED.system = :P12_SYSTEM)
     and (IMED.NAME_OF_THE_DISTRICT = u.DISTRICT) 
     and (IMED.NAME_OF_THE_INSTITUTION = U.NAME_OF_THE_INSTITUTION)
          and (IMED.system = U.system)
     AND (u.AADHAAR_LINKED_MOBILE_NO = :APP_USER));

--FUnction:
CREATE OR REPLACE FUNCTION im_indent_medicine_details_get_fn(
  p_institution_name text,
  p_financial_year text  ,
  p_quarter text  ,
  p_indent_type text  ,
  p_scheme_name text  ,
  p_status text  ,
  p_system text  ,
  p_mobile bigint
)
RETURNS TABLE (
  SNO bigint,
  MEDICINE_NAME text,
  PACKING_SIZE text,
  Amount numeric,
  QUANTITY numeric,
  TOTAL_AMOUNT numeric,
  SYSTEM text,
  INDENT_TYPE text,
  SCHEME_NAME text,
  NAME_OF_THE_INSTITUTION text,
  QUARTERS text,
  CREATED_DATE timestamp,
  FINANCIAL_YEAR text,
  NAME_OF_THE_DISTRICT text,
  INSTITUTION_TYPE text,
  STATUS text
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    IMED.SNO,
    IMED.MEDICINE_NAME,
    IMED.PACKING_SIZE,
    ROUND(IMED.AMOUNT, 2) AS Amount,
    IMED.QUANTITY,
    IMED.TOTAL_AMOUNT,
    IMED.SYSTEM,
    IMED.INDENT_TYPE,
    IMED.SCHEME_NAME,
    IMED.NAME_OF_THE_INSTITUTION,
    IMED.QUARTERS,
    IMED.CREATED_DATE,
    IMED.FINANCIAL_YEAR,
    IMED.NAME_OF_THE_DISTRICT,
    IMED.INSTITUTION_TYPE,
    IMED.STATUS
  FROM INDENT_MEDICINE_DETAILS IMED
  JOIN IM_USER_LOGIN u
    ON IMED.NAME_OF_THE_DISTRICT = u.DISTRICT
   AND IMED.NAME_OF_THE_INSTITUTION = u.NAME_OF_THE_INSTITUTION
   AND IMED.SYSTEM = u.SYSTEM
  WHERE IMED.STATUS = 'Order Placed'
    AND (p_institution_name IS NULL OR IMED.NAME_OF_THE_INSTITUTION = p_institution_name)
    AND (p_financial_year IS NULL OR IMED.FINANCIAL_YEAR = p_financial_year)
    AND (p_quarter IS NULL OR IMED.QUARTERS = p_quarter)
    AND (p_indent_type IS NULL OR IMED.INDENT_TYPE = p_indent_type)
    AND (p_scheme_name IS NULL OR IMED.SCHEME_NAME = p_scheme_name)
    AND (p_status IS NULL OR IMED.STATUS = p_status)
    AND (p_system IS NULL OR IMED.SYSTEM = p_system)
    AND (u.AADHAAR_LINKED_MOBILE_NO = p_mobile);
END;
$$;

-- Received Medicine Report:
--Despatch Details
select distinct SNO,
       MEDICINE_NAME,
       PACKING_SIZE,
       AMOUNT,
       INDENTED_QUANTITY,
       GODOWN_STOCK_AVAILABLITY,
       SUPPLY_QUANTITY,
       SUPPLY_PRICE,
       PERCENTAGE_OF_DESPATCH_QUANTITY,
       BALANCE_QUANTITY_TO_BE_SUPPLIED,
       STATUS,
       CREATED_BY,
       CREATED_DATE,
       UPDATED_BY,
       UPDATED_DATE,
       REQUEST_STATUS,
       FORWARD_TO,
       REMARKS,
       RECEIVED_QUANTITY,
       PRICE,
       DNO,
       NAME,
       EXPIRY_DATE,
       BATCH,
       MOBILE
  from DESPATCH_MEDICINE WHERE REQUEST_STATUS='S' AND FORWARD_TO=:APP_USER_NAME;
  
--Function:
CREATE FUNCTION im_despatch_medicine_fn(
    p_forward_to TEXT
)
RETURNS TABLE (
    SNO bigint,
    MEDICINE_NAME text,
    PACKING_SIZE text,
    AMOUNT numeric,
    INDENTED_QUANTITY numeric,
    GODOWN_STOCK_AVAILABLITY numeric,
    SUPPLY_QUANTITY numeric,
    SUPPLY_PRICE numeric,
    PERCENTAGE_OF_DESPATCH_QUANTITY numeric,
    BALANCE_QUANTITY_TO_BE_SUPPLIED numeric,
    STATUS text,
    CREATED_BY text,
    CREATED_DATE timestamp,
    UPDATED_BY text,
    UPDATED_DATE timestamp,
    REQUEST_STATUS text,
    FORWARD_TO text,
    REMARKS text,
    RECEIVED_QUANTITY numeric,
    PRICE numeric,
    DNO text,
    NAME text,
    EXPIRY_DATE date,
    BATCH text,
    MOBILE bigint
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT
      SNO,
      MEDICINE_NAME,
      PACKING_SIZE,
      AMOUNT,
      INDENTED_QUANTITY,
      GODOWN_STOCK_AVAILABLITY,
      SUPPLY_QUANTITY,
      SUPPLY_PRICE,
      PERCENTAGE_OF_DESPATCH_QUANTITY,
      BALANCE_QUANTITY_TO_BE_SUPPLIED,
      STATUS,
      CREATED_BY,
      CREATED_DATE,
      UPDATED_BY,
      UPDATED_DATE,
      REQUEST_STATUS,
      FORWARD_TO,
      REMARKS,
      RECEIVED_QUANTITY,
      PRICE,
      DNO,
      NAME,
      EXPIRY_DATE,
      BATCH,
      MOBILE
  FROM DESPATCH_MEDICINE
  WHERE REQUEST_STATUS = 'S'
    AND FORWARD_TO = p_forward_to;
END;
$$;
  

--Despatch Details
select (CASE
    WHEN :P3_SELECTED_VALUE LIKE '%' || SNO || '|%'
    THEN 'checked'
    ELSE NULL
  END) AS Sellect_request,
  SNO,
       MEDICINE_NAME,
       PACKING_SIZE,
       AMOUNT,
       INDENTED_QUANTITY,
       GODOWN_STOCK_AVAILABLITY,
       SUPPLY_QUANTITY,
       SUPPLY_PRICE,
       PERCENTAGE_OF_DESPATCH_QUANTITY,
       BALANCE_QUANTITY_TO_BE_SUPPLIED,
       STATUS,
       CREATED_BY,
       CREATED_DATE,
       UPDATED_BY,
       UPDATED_DATE,
       REQUEST_STATUS,
       FORWARD_TO,
       REMARKS,
       RECEIVED_QUANTITY,
       PRICE,
       NAME,
       EXPIRY_DATE,
       BATCH,
       MOBILE
  from DESPATCH_MEDICINE WHERE REQUEST_STATUS='S' and FORWARD_TO= :APP_USER_NAME;

  
-- When Press Button  Approve:
1.
UPDATE DESPATCH_MEDICINE DM
SET DM.REQUEST_STATUS = 'A',
    DM.FORWARD_TO = 'DSMO'
WHERE DM.SNO IN (
    SELECT regexp_substr(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL)
    FROM dual
    CONNECT BY LEVEL <= regexp_count(:P3_SELECTED_VALUE, '|') + 1
);
2.
DECLARE
  v_sno NUMBER;

BEGIN
  FOR r IN (
    SELECT REGEXP_SUBSTR(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL) AS id
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL) IS NOT NULL
  ) LOOP
    SELECT STOCK_DETAILS_SEQ.NEXTVAL INTO v_sno FROM DUAL;

    MERGE INTO STOCK_DETAILS SD
    USING (
      SELECT r.id AS SNO,
             MEDICINE_NAME,
             PACKING_SIZE,
             INDENTED_QUANTITY,
             BATCH,
             EXPIRY_DATE
      FROM DESPATCH_MEDICINE
      WHERE SNO = r.id
    ) DM ON (SD.MEDICINE_NAME = DM.MEDICINE_NAME)
    WHEN MATCHED THEN
      UPDATE SET
        SD.DNO = v_sno,
        SD.PACKAGE_SIZE = DM.PACKING_SIZE,
        SD.QUANTITY = DM.INDENTED_QUANTITY,
        SD.BATCH_NO = DM.BATCH,
        SD.EXPIRY_DATE = DM.EXPIRY_DATE
    WHEN NOT MATCHED THEN
      INSERT (DNO, MEDICINE_NAME, PACKAGE_SIZE, QUANTITY, BATCH_NO, EXPIRY_DATE)
      VALUES (v_sno, DM.MEDICINE_NAME, DM.PACKING_SIZE, DM.INDENTED_QUANTITY, DM.BATCH, DM.EXPIRY_DATE);
      
    COMMIT;
  END LOOP;
  EXCEPTION
WHEN others then
dbms_output.put_line('Please Contact ADMIN');
END;
3.
UPDATE INDENT_MEDICINE_DETAILS
SET STATUS = 'Dispatched'
WHERE SNO IN (SELECT TO_NUMBER(REGEXP_SUBSTR(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL))
             FROM DUAL
             CONNECT BY REGEXP_SUBSTR(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL) IS NOT NULL);
			 
			 
-- When press Back button
1.
BEGIN 
delete from DESPATCH_MEDICINE where 
GODOWN_STOCK_AVAILABLITY is null or SUPPLY_QUANTITY is null or
SUPPLY_PRICE is null or PERCENTAGE_OF_DESPATCH_QUANTITY is null or
BALANCE_QUANTITY_TO_BE_SUPPLIED is null;
EXCEPTION
WHEN others then
dbms_output.put_line('Please Contact ADMIN');
END;
--FUnction:
CREATE  PROCEDURE Im_delete_null_despatch_medicine_fn()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM DESPATCH_MEDICINE
    WHERE GODOWN_STOCK_AVAILABLITY IS NULL 
       OR SUPPLY_QUANTITY IS NULL 
       OR SUPPLY_PRICE IS NULL 
       OR PERCENTAGE_OF_DESPATCH_QUANTITY IS NULL 
       OR BALANCE_QUANTITY_TO_BE_SUPPLIED IS NULL;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Please Contact ADMIN';
END;
$$;

2.
UPDATE INDENT_MEDICINE_DETAILS
SET STATUS = 'Order Placed'
WHERE SNO IN (SELECT TO_NUMBER(REGEXP_SUBSTR(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL))
             FROM DUAL
             CONNECT BY REGEXP_SUBSTR(:P3_SELECTED_VALUE, '[^|]+', 1, LEVEL) IS NOT NULL);
--procedure:
CREATE PROCEDURE im_upd_indent_status_sp(p_selected_value TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE INDENT_MEDICINE_DETAILS
    SET STATUS = 'Order Placed'
    WHERE SNO IN (
        SELECT CAST(token AS INTEGER)
        FROM regexp_split_to_table(p_selected_value, '\|') AS token
        WHERE token ~ '^\d+$'  -- Ensure it's numeric
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Please Contact ADMIN';
END;
$$;
			 
			 
 -- Patient Details
P38_FROM_DATE, P38_TO_DATE (Date picker)
 SELECT PL.PATIENT_ID,
       PL.PATIENT_NAME,
       PL.MOBILE_NUMBER,
       PL.AADHAAR_NUMBER,
       PL.PATIENT_DISEASE,
       PL.PATIENT_GENDER,
       PL.MEDICINE_NAME,
       PL.MEDICINE_QUANTITY,
       PL.CREATED_BY,
       PL.CREATED_DATE,
       PL.UPDATED_BY,
       PL.UPDATED_DATE,
       PL.NAME_OF_THE_INSTITUTION,
       PL.DISTRICT,
       PL.SYSTEM
FROM PATIENT_LOG PL, IM_USER_LOGIN UL
WHERE PL.CREATED_DATE BETWEEN TO_DATE(:P38_FROM_DATE, 'MM/DD/YYYY') AND (TO_DATE(:P38_TO_DATE, 'MM/DD/YYYY')+1)
AND UL.SYSTEM = PL.SYSTEM
AND UL.AADHAAR_LINKED_MOBILE_NO = :APP_USER and PL.NAME_OF_THE_INSTITUTION = UL.NAME_OF_THE_INSTITUTION;

--Function:
CREATE  FUNCTION im_patient_details_by_date_fn(
    p_from_date DATE,
    p_to_date DATE,
    p_mobile BIGINT
)
RETURNS TABLE (
    PATIENT_ID TEXT,
    PATIENT_NAME TEXT,
    MOBILE_NUMBER BIGINT,
    AADHAAR_NUMBER TEXT,
    PATIENT_DISEASE TEXT,
    PATIENT_GENDER TEXT,
    MEDICINE_NAME TEXT,
    MEDICINE_QUANTITY INTEGER,
    CREATED_BY TEXT,
    CREATED_DATE TIMESTAMP,
    UPDATED_BY TEXT,
    UPDATED_DATE TIMESTAMP,
    NAME_OF_THE_INSTITUTION TEXT,
    DISTRICT TEXT,
    SYSTEM TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        PL.PATIENT_ID,
        PL.PATIENT_NAME,
        PL.MOBILE_NUMBER,
        PL.AADHAAR_NUMBER,
        PL.PATIENT_DISEASE,
        PL.PATIENT_GENDER,
        PL.MEDICINE_NAME,
        PL.MEDICINE_QUANTITY,
        PL.CREATED_BY,
        PL.CREATED_DATE,
        PL.UPDATED_BY,
        PL.UPDATED_DATE,
        PL.NAME_OF_THE_INSTITUTION,
        PL.DISTRICT,
        PL.SYSTEM
    FROM PATIENT_LOG PL
    JOIN IM_USER_LOGIN UL
        ON UL.SYSTEM = PL.SYSTEM
       AND PL.NAME_OF_THE_INSTITUTION = UL.NAME_OF_THE_INSTITUTION
    WHERE PL.CREATED_DATE BETWEEN p_from_date AND (p_to_date + INTERVAL '1 day')
      AND UL.AADHAAR_LINKED_MOBILE_NO = p_mobile;
END;
$$;