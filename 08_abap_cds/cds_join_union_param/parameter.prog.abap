REPORT zvzp_cds.

PARAMETERS: pa_carr TYPE s_carr_id DEFAULT 'LH'.

SELECT * FROM zvzcds_parameter( p_carrid = @pa_carr ) INTO TABLE @DATA(it).

cl_demo_output=>display( it ).