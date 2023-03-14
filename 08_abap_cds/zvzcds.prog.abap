REPORT zvzp_cds.

SELECT * FROM zvzcds_spfli INTO TABLE @DATA(it).

cl_demo_output=>display( it ).