{%- set vPaymentsMethodsLists = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] -%}

select 
    p.order_id
    {%- for vPaymentMethod in vPaymentsMethodsLists %}
    , sum(case when p.payment_method='{{vPaymentMethod}}' then p.amount else 0 end) {{vPaymentMethod}}_amount
    {%- endfor%}
from {{ ref('stg_payments') }} as p
where p.status = 'success'
group by 
    p.order_id
