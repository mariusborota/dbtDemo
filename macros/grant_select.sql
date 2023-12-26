{% macro grant_select(pSchema = target.schema, pRole = target.role) %}

    {% set sql %}
        grant usage on schema {{ pSchema }} to role {{ pRole }};
        grant select on all tables in schema {{ pSchema }} to role {{ pRole }};
        grant select on all views in schema {{ pSchema }} to role {{ pRole }};
    {% endset %}

    {{ log('Granting select on all tables and views in schema ' ~ target.schema ~ ' to role ' ~ role, info=True) }}
    {% do run_query(sql) %}
    {{ log('Privileges granted', info=True) }}
    
{% endmacro %}