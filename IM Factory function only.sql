---------#*#*#*##**#*#*#*#*#*#*#*#**#*#*#**# Factory #*#*#*#*#*#*#*#*#*#*#*#*#**#*#*#

 --VIEW INDENT DETAILS - factory
 --P15_NAME_OF_THE_DISTRICT 
--Function:
SELECT im_get_district_list_fn(	p_mobile bigint);
	   
--P15_NAME_OF_THE_INSTITUTION	   
 --Function:
SELECT im_get_institution_list_fn(	p_mobile bigint);

 --P15_SYSTEM
 --Function:
SELECT im_system_fn();

 --P15_FINANCIAL_YEAR
 --Function:
SELECT im_year_fn();

 --P15_QUARTERS
--Function:
SELECT im_quarter_fn();

 --P15_INDENT_TYPE
 --Function:
 SELECT im_indent_typ_fn();

 --P15_SCHEME_NAME
--Function:
SELECT im_scheme_names_fn();

-- Report:
--Function:
SELECT CREATE FUNCTION im_indent_medicine_factory_data_fn(
    p_institution TEXT DEFAULT NULL,
    p_district TEXT DEFAULT NULL,
    p_fin_year TEXT DEFAULT NULL,
    p_quarter TEXT DEFAULT NULL,
    p_indent_type TEXT DEFAULT NULL,
    p_system TEXT DEFAULT NULL,
    p_scheme_name TEXT DEFAULT NULL);

 -- When press move to dispatch running below query:
 1.
 --Procedure:
CALL im_ins_despatch_medicine_sp(p_ids TEXT);
2.
--PRocedure:
Call im_upd_indent_status_dispatched_sp(p_ids TEXT);

--Download Despatched Medicine - Factory
-- P46_DISTRICT
SELECT  get_factory_districts_fn();

-- P46_INSTITUTION
--Function:
SELECT get_institutions_by_district_fn(    p_district TEXT);

-- P46_SYSTEM
--Function:
SELECT im_system_fn();

-- P46_QUARTERS
--Function:
SELECT im_quarter_fn();

-- P46_FINANCIAL
--Function:
SELECT im_year_fn();

-- Report:
--Function:
SELECT im_get_factory_despatch_report_fn(
    p_institution TEXT,
    p_district TEXT,
    p_financial TEXT,
    p_quarters TEXT);

-- AMO Approved report - Factory
--FunctioN:
SELECT FUNCTION get_factory_dispatch_medicine_fn();

-- District wise consolidate Report. (Financial year, Quarter)
--P37_FINANCIAL_YEAR
--Function:
SELECT im_year_fn();

--P37_QUARTERS
--Function:
SELECT im_quarter_fn();


-- Report:
SELECT im_get_medicine_details_fn(    p_financial_year text,    p_quarters text);

--Financial year, Quarter, Regular
--P40_FINANCIAL_YEAR
--Function:
SELECT im_year_fn();

--P40_QUARTERS
--Function:
SELECT im_quarter_fn();

-- Report:
--Function:
SELECT im_get_medicine_detail_fn(    p_financial_year text,    p_quarters text);

-- Financial year, Quarter, Scheme
--P60_FINANCIAL_YEAR
--Function:
SELECT im_year_fn();

--P60_QUARTERS
--Function:
SELECT im_quarter_fn();

--P60_SCHEME_NAME
--Function:
SELECT im_scheme_fn();

-- Report:
--Function:
SELECT FUNCTION get_scheme_medicine_details(    p_financial_year text,    p_quarters text,    p_scheme_name text);
