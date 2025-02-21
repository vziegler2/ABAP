@EndUserText.label: 'Zugriffskontrolle für View'
@MappingRole: true
define role ZVZACC_CALC {
    grant 
        select
            on
                ZVZCDS_CALC //view
                    where
                        (carrid) = aspect pfcg_auth(S_CARRID, CARRID, ACTVT = '03')
                        and SeatsOccupied < '100';
//Access Controls filtern nach View-Feldern
//Bestehende ACs finden: Ctrl+Shift+G -> Get Where-Used List
//1. View für alle filtern: CarrierId = 'SQ'
//2. Filter gemäß Berechtigungsobjekt, s. Beispiel oben
//   (view_field1) = aspect pfcg_auth(authorization_object, authorization_field, filter);
}