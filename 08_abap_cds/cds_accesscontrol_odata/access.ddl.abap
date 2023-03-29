@EndUserText.label: 'Zugriffskontrolle für View'
@MappingRole: true
define role ZVZACC_CALC {
    grant 
        select
            on
                ZVZCDS_CALC
                    where
                        (carrid) = aspect pfcg_auth(S_CARRID, CARRID);
                        
}