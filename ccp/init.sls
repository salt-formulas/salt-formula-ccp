{%- if pillar.ccp is defined %}
include:
{%- if pillar.ccp.control is defined %}
- ccp.control
{%- endif %}
{%- endif %}
