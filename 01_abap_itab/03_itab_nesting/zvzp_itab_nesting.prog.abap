REPORT zvzp_exercism.

TYPES: BEGIN OF artists_type,
         artist_id   TYPE string,
         artist_name TYPE string,
       END OF artists_type.
TYPES artists TYPE STANDARD TABLE OF artists_type WITH KEY artist_id.
TYPES: BEGIN OF albums_type,
         artist_id  TYPE string,
         album_id   TYPE string,
         album_name TYPE string,
       END OF albums_type.
TYPES albums TYPE STANDARD TABLE OF albums_type WITH KEY artist_id album_id.
TYPES: BEGIN OF songs_type,
         artist_id TYPE string,
         album_id  TYPE string,
         song_id   TYPE string,
         song_name TYPE string,
       END OF songs_type.
TYPES songs TYPE STANDARD TABLE OF songs_type WITH KEY artist_id album_id song_id.


TYPES: BEGIN OF song_nested_type,
         song_id   TYPE string,
         song_name TYPE string,
       END OF song_nested_type.
TYPES: BEGIN OF album_song_nested_type,
         album_id   TYPE string,
         album_name TYPE string,
         songs      TYPE STANDARD TABLE OF song_nested_type WITH KEY song_id,
       END OF album_song_nested_type.
TYPES: BEGIN OF artist_album_nested_type,
         artist_id   TYPE string,
         artist_name TYPE string,
         albums      TYPE STANDARD TABLE OF album_song_nested_type WITH KEY album_id,
       END OF artist_album_nested_type.
TYPES nested_data TYPE STANDARD TABLE OF artist_album_nested_type WITH KEY artist_id.

DATA(artists) = VALUE artists( ( artist_id = '1' artist_name = 'Godsmack' )
                               ( artist_id = '2' artist_name = 'Shinedown' ) ).

DATA(albums) = VALUE albums( ( artist_id = '1' album_id = '1' album_name = 'Faceless' )
                             ( artist_id = '1' album_id = '2' album_name = 'When Lengends Rise' )
                             ( artist_id = '2' album_id = '1' album_name = 'The Sound of Madness' )
                             ( artist_id = '2' album_id = '2' album_name = 'Planet Zero' ) ).

DATA(songs) = VALUE songs( ( artist_id = '1' album_id = '1' song_id = '1' song_name = 'Straight Out Of Line' )
                           ( artist_id = '1' album_id = '1' song_id = '2' song_name = 'Changes' )
                           ( artist_id = '1' album_id = '2' song_id = '1' song_name = 'Bullet Proof' )
                           ( artist_id = '1' album_id = '2' song_id = '2' song_name = 'Under Your Scars' )
                           ( artist_id = '2' album_id = '1' song_id = '1' song_name = 'Second Chance' )
                           ( artist_id = '2' album_id = '1' song_id = '2' song_name = 'Breaking Inside' )
                           ( artist_id = '2' album_id = '2' song_id = '1' song_name = 'Dysfunctional You' )
                           ( artist_id = '2' album_id = '2' song_id = '2' song_name = 'Daylight' ) ).

DATA(lo_ex) = NEW zvzcl_exercism(  ).

DATA(return) = lo_ex->perform_nesting( artists = artists albums = albums songs = songs ).

TRY.
    DATA: o_salv TYPE REF TO cl_salv_table.
    CALL METHOD cl_salv_table=>factory(
      IMPORTING
        r_salv_table = o_salv
      CHANGING
        t_table      = return ).

    o_salv->display(  ).
  CATCH cx_salv_msg.
ENDTRY.