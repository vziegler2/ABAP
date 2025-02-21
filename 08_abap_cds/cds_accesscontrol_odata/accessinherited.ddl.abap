@EndUserText.label: 'Access Control für View auf View'
@MappingRole: true
define role ZVZACC_CALC2 {
    grant
        select
            on
                ZVZCDS_CALC2 //projection
                    where
//Parameter-Filter:     $parameters.p_parameter_name = 'VALUE' and
                        inheriting conditions from entity ZVZCDS_CALC;
//Für Projections muss die Access Control abgeleitet werden, sonst Syntaxfehler                        
}