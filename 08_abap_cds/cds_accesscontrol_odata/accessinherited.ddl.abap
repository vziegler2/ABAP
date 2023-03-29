@EndUserText.label: 'Access Control für View auf View'
@MappingRole: true
define role ZVZACC_CALC2 {
    grant
        select
            on
                ZVZCDS_CALC2
                    where
                        inheriting conditions from entity ZVZCDS_CALC;
                        
}