REPORT zvzp_cdsasso.

SELECT carrid, connid, fldate, \_saplane[ (*) INNER WHERE planetype = '747-400' ]-seatsmax, \_spfli-cityfrom, \_spfli\_airportfrom-name
FROM zvzcds_asso2 ORDER BY carrid, connid INTO TABLE @DATA(it).

cl_demo_output=>display( it ).