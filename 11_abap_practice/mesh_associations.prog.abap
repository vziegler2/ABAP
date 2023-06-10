REPORT zcvvz_001.

TYPES: BEGIN OF t_manager,
         name   TYPE char10,
         salary TYPE int4,
       END OF t_manager,
       tt_manager TYPE STANDARD TABLE OF t_manager WITH EMPTY KEY.

TYPES: BEGIN OF t_developer,
         name    TYPE char10,
         salary  TYPE int4,
         manager TYPE char10,
       END OF t_developer,
       tt_developer TYPE STANDARD TABLE OF t_developer WITH EMPTY KEY.
*Die Assoziation [ASSOCIATION] beinhaltet die Zeile der Tabelle [TO], deren Element [ON 1] gleich unserem Element [ON 2] ist.
TYPES: BEGIN OF MESH m_team,
         managers   TYPE tt_manager ASSOCIATION my_employee TO developers ON manager = name,
         developers TYPE tt_developer ASSOCIATION my_manager TO managers ON name = manager,
       END OF MESH m_team.

DATA: ls_team TYPE m_team.

DATA(lt_manager) = VALUE tt_manager( ( name = 'Jason' salary = 3000 )
                                     ( name = 'Thomas' salary = 3200 ) ).
DATA(lt_developer) = VALUE tt_developer( ( name = 'Bob' salary = 2100 manager = 'Jason' )
                                         ( name = 'David' salary = 2000 manager = 'Thomas' )
                                         ( name = 'Jack' salary = 1000 manager = 'Thomas' )
                                         ( name = 'Jerry' salary = 1000 manager = 'Jason' )
                                         ( name = 'John' salary = 2100 manager = 'Thomas' )
                                         ( name = 'Tom' salary = 2000 manager = 'Jason' ) ).

ls_team-managers   = lt_manager.
ls_team-developers = lt_developer.

ASSIGN lt_developer[ name = 'Jerry' ] TO FIELD-SYMBOL(<ls_jerry>).
*Assoziationswert(ls_jmanager) = Mesh(ls_team)-Tabelle(developers)\Assoziationsname(my_manager)[ Struktur(<ls_jerry>) ].
DATA(ls_jmanager) =  ls_team-developers\my_manager[ <ls_jerry> ].

WRITE: / |Jerry's manager: { ls_jmanager-name }|,30
         |Salary: { ls_jmanager-salary }|.

SKIP.
WRITE: / |Thomas' developers:|.

ASSIGN lt_manager[ name = 'Thomas' ] TO FIELD-SYMBOL(<ls_thomas>).
*Ermittelt nur den ersten passenden Wert im Gegensatz zum nachfolgenden Loop
DATA(ls_tdeveloper) =  ls_team-managers\my_employee[ <ls_thomas> ].
*Loopt über die Tabelle der Assoziation mit dem Schlüssel der Assoziation
LOOP AT ls_team-managers\my_employee[ <ls_thomas> ]
        ASSIGNING FIELD-SYMBOL(<ls_emp>).
  WRITE: / |Employee name: { <ls_emp>-name }|.
ENDLOOP.