{%- macro cents_to_dolars(pFldName, pDecimals = 2) -%}

round({{pFldName}}/100, {{pDecimals}})

{%- endmacro -%}