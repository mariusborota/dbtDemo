{% macro clean_stale_models(pDatabase = target.database, pSchema = target.schema, pDays = 7, pDry_run = True) %}
    
    {# Database and schema names are usually written with capital letters; this block is merely a precaution.#}
    {% set pDatabase = pDatabase | upper %} 
    {% set pSchema = pSchema | upper %}

    {# SQL Statments #}
    {% set get_drop_commands_query %}
        set VREFERENCEDATE = DateADD(day, - {{pDays}} ,CURRENT_DATE()); 
        select 
            'drop '
            || case Table_Type when 'VIEW' then 'view ' else 'table' end
            || ' ' || TABLE_CATALOG || '.' || t.TABLE_SCHEMA || '.' || TABLE_NAME    
        from {{pDatabase}}.INFORMATION_SCHEMA.TABLES as t
        where t.TABLE_SCHEMA = '{{pSchema}}' and t.LAST_ALTERED <  $VREFERENCEDATE;
    {% endset %}
    
    {# get old objects #}
    {% set drop_queries = run_query(get_drop_commands_query).columns[0].values() %}

    {# parse the old objects and remove them #}
    {% for drop_query in drop_queries %}
        {{drop_query}}
        {% if dry_run %}
            {{ log(drop_query, info=True) }}
        {% else %}
            {{ log('Dropping table/view with command: ' ~ drop_query, info=True) }}
            {% do run_query(drop_query) %}    
        {% endif %}
    {% endfor %}
  
{% endmacro %}