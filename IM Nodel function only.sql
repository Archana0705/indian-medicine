--#*#**#*#*#*#*#*#*#**#*#*#*#*#*           NODAL          #*#*#**#*#*#*#*#*#**#*#*#*#*       
--VIEW INDENT DETAILS - Nodal
--P33_NAME_OF_THE_DISTRICT
--FUnction:
SELECT im_own_district_fn(null);	 
	   
--P33_NAME_OF_THE_INSTITUTION
--Function:
im_institude_fn(p_district character varying);

--P33_SYSTEM
--Function:
SELECT im_system_fn();

--P33_FINANCIAL_YEAR
--Function:
SELECT im_year_fn();

--P33_QUARTERS
--Function:
SELECT im_quarter_fn();

--P33_INDENT_TYPE
 --Function:
 SELECT im_indent_typ_fn();

--P33_SCHEME_NAME
--Function:
SELECT im_scheme_names_fn();

-- Report:
--Function:
SELECT im_get_indent_medicine_outsource_fn(
    p_institution TEXT DEFAULT NULL,
    p_district TEXT DEFAULT NULL,
    p_financial_year TEXT DEFAULT NULL,
    p_quarters TEXT DEFAULT NULL,
    p_indent_type TEXT DEFAULT NULL,
    p_system TEXT DEFAULT NULL,
    p_scheme_name TEXT DEFAULT NULL)


  -- When click on "Move to dispatch " Button Running below query:
Call move_to_dispatch_sp(p_ids TEXT)

--Call procedure:
CALL move_to_dispatch_sp('101|102|103');

--District Financial Year:
--P27_DISTRICT
--P27_FINANCIAL_YEAR
--Report:
--Function:
SELECT im_get_indent_medicine_summary_fn(    p_district TEXT,    p_financial_year TEXT);

-- District, Finacial Year, System, Quarter
-- P31_DISTRICT
-- P31_QUARTERS		
-- P31_FINANCIAL_YEAR
-- P31_SYSTEM

-- Report:
--Function:
SELECT get_outsource_indent_summary(    p_district TEXT,    p_financial_year TEXT,    p_system TEXT,    p_quarters TEXT)

-- District, Financial year, System, Quarter, Regular
--P32_DISTRICT 
--P32_FINANCIAL_YEAR
--P32_SYSTEM
--P32_QUARTERS
-- Report:

--Function:
SELECT im_get_outsource_regular_indent_summary_fn(    p_district TEXT,    p_financial_year TEXT,    p_system TEXT,    p_quarters TEXT);

-- District, Financial year, System, Quarter, Scheme
--P34_DISTRICT
--P34_FINANCIAL_YEAR
--P34_SYSTEM
--P34_QUARTERS
--P34_SCHEME_NAME
--Report:
--Function
SEELCT im_get_outsource_scheme_indent_summary_fn(    p_district TEXT,    p_financial_year TEXT,    p_system TEXT,    p_quarters TEXT,    p_scheme_name TEXT);


--Download despatched medicine - Nodal
-- P30_DISTRICT
-- P30_INSTITUTION
-- P30_SYSTEM
-- P30_QUARTERS
-- P30_FINANCIAL
-- Report:
--Function:
SELECT im_get_outsource_despatch_medicine_fn(    p_institution TEXT,    p_district TEXT,    p_financial TEXT,    p_quarters TEXT);
     
-- AMO Approved Report:
--Function:
SELECT im_get_outsource_despatch_summary_fn()

-- District wise consolidated Report:
--Financial year, Quarter Only
--P61_FINANCIAL_YEAR
--P61_QUARTERS
--Report:
--Function:
CREATE FUNCTION im_outsource_indent_summary_fn(    p_financial_year TEXT,    p_quarters TEXT);

--Financial year, Quarter, Regular
--P62_FINANCIAL_YEAR
--P62_QUARTERS
-- Report:
--FUnction:
SEELCT im_get_regular_indent_report_fn(    p_financial_year TEXT,    p_quarters TEXT);

--Financial year, Quarter, Scheme
--P63_FINANCIAL_YEAR
--P63_QUARTERS
--P63_SCHEME_NAME
-- Report:
--Function:
SELECT im_get_scheme_indent_report_fn(    p_financial_year TEXT,    p_quarters TEXT,    p_scheme_name TEXT)