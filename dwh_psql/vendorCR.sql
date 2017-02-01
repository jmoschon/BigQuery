describe dwh_il.fct_vendor_visits_cr;


select
v.code as Vendor_code,
v.id as code,
vcr.rdbms_id,
operatingsystem,
date,
coalesce(sum(cr3_start)::float,0) as cr3_start,
coalesce(sum(cr3_completion)::float,0) as cr3_completion,
coalesce(sum(cr4_completion)::float,0) as cr4_completion
from dwh_il.fct_vendor_visits_cr  vcr
left join dwh_mysql_fp_in."Vendors" v on vcr.vendor_id=v.id
where  (date Between current_date-3 And current_date-1)
and v.id='5898'
and operatingsystem='Android'
and vcr.rdbms_id=11

 group by 1,2,3,4,5;
 --order by cr3_start



------------------------------------------------------------------------------------------------------------------------

Select
        to_char(date,'YYYY-IW') as Week,
        date,
        --vc.code as Chain_code,
        --vc.title as Chain,
       -- v.id as Vendor_ID,
        --v.code as Vendor_code,
        --v.title as Vendor,
        sum(cr3_start)  as cr3_start,
        sum(cr3_completion) as cr3_completion,
        sum(cr4_completion) as cr4_completion,
        sum(cr4_completion)::numeric/ sum(cr3_start)::numeric as CR,
        sum(cr3_completion)::numeric/ sum(cr3_start)::numeric as CR3,
        sum(cr4_completion)::numeric/ sum(cr3_completion)::numeric as CR4
        from dwh_il.fct_vendor_visits_cr  vcr
       -- left join dwh_mysql_fp_in."Vendors" v on vcr.vendor_id=v.id
       -- left join dwh_mysql_fp_in."Vendorschains" vc on v.chain_id=vc.id
        where
--vc.code='cr6sa' and
to_char(date(date), 'IYYY-IW') >= to_char(current_date-56, 'IYYY-IW')
        and to_char(date(date), 'IYYY-IW')<=to_char(current_date-6, 'IYYY-IW')
        and vcr.rdbms_id=11
        and platform='app'
        and operatingsystem='Android'
        group by 1,2
        order by 1,2;
