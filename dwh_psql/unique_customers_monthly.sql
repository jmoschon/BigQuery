
--- calculate unique customers acquired on a monthly level MY --------

Select
count(distinct(c.mobile)),
count(distinct(o.customer_id)),
count(distinct(b.new_customer_uuid)),
to_char(first_order_date,'yyyy-mm') as month_cohort

from dwh_il.fct_orders o
left join merge_layer_rdbms.customers c on o.rdbms_id=c.rdbms_id and c.id::varchar=o.customer_id
left join dwh_il.meta_order_status x on o.status_id=x.status_id and o.rdbms_id=x.rdbms_id
left join dwh_il.fct_customers_uuid b on o.rdbms_id=b.rdbms_id and o.customer_ident=b.customer_id
left join dwh_il.dim_first_order fo on fo.rdbms_id=b.rdbms_id and fo.new_customer_uuid=b.new_customer_uuid

left join dwh_il.dim_countries d on b.rdbms_id=d.rdbms_id
where x.valid_order=1
and o.rdbms_id=16
group by 4