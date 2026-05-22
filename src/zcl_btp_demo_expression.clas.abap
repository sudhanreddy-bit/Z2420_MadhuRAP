CLASS zcl_btp_demo_expression DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_btp_demo_expression IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_demo TYPE STANDARD TABLE OF zbtp_dt_demo.

    lt_demo = VALUE #(
      ( client = sy-mandt id = '00011'
        char_field1   = 'ABCDEF'
        char_field2   = 'CHARFIELD2'
        char_field3   = 'This is CHARFIELD3'
        numc_field1   = '654321'
        numc_field2   = '9876543210'
        string_field  = 'String field with long content 01'
        sstring_field = 'Short text 01'
        date_field    = '20250701'
        time_field    = '123456'
        int1_field    = 255
        int2_field    = 32767
        int4_field    = 2147483647
        dec_field     = '9999999.99'
        curr_field    = '12345.67'
        quan_field    = '9876.543'
        currency_key  = 'USD'
        unit_key      = 'KG'
        raw_data      = '0102030405060708' )

      ( client = sy-mandt id = '00012'
        char_field1   = 'GHIJKL'
        char_field2   = 'CHARFIELD22'
        char_field3   = 'Another CHARFIELD3 demo'
        numc_field1   = '123456'
        numc_field2   = '1122334455'
        string_field  = 'String field with long content 02'
        sstring_field = 'Short text 02'
        date_field    = '20250702'
        time_field    = '223344'
        int1_field    = 200
        int2_field    = 12345
        int4_field    = 987654321
        dec_field     = '8888888.88'
        curr_field    = '54321.21'
        quan_field    = '1234.321'
        currency_key  = 'INR'
        unit_key      = 'LTR'
        raw_data      = '1020304050607080' )

      ( client = sy-mandt id = '00022'
        char_field1   = 'GHIJKL'
        char_field2   = 'CHARFIELD22'
        char_field3   = 'Another CHARFIELD3 demo'
        numc_field1   = '123456'
        numc_field2   = '1122334455'
        string_field  = 'String field with long content 02'
        sstring_field = 'Short text 02'
        date_field    = '20250702'
        time_field    = '223344'
        int1_field    = 200
        int2_field    = 12345
        int4_field    = 987654321
        dec_field     = '8888888.88'
        curr_field    = '54321.21'
        quan_field    = '1234.321'
        currency_key  = 'INR'
        unit_key      = 'LTR'
        raw_data      = '1020304050607080' )

      ( client = sy-mandt id = '00023'
        char_field1   = 'MNOPQR'
        char_field2   = 'CHARFLD33'
        char_field3   = 'Demo text CHARFIELD3 again'
        numc_field1   = '331111'
        numc_field2   = '2332222222'
        string_field  = 'String field with long content 03'
        sstring_field = 'Short text 03'
        date_field    = '20250703'
        time_field    = '101010'
        int1_field    = 133
        int2_field    = 22456
        int4_field    = 182837465
        dec_field     = '7777777.77'
        curr_field    = '66432.10'
        quan_field    = '2245.678'
        currency_key  = 'EUR'
        unit_key      = 'MTR'
        raw_data      = 'ABCDEF2234567890' )

      ( client = sy-mandt id = '00013'
        char_field1   = 'MNOPQR'
        char_field2   = 'CHARFLD33'
        char_field3   = 'Demo text CHARFIELD3 again'
        numc_field1   = '331111'
        numc_field2   = '2332222222'
        string_field  = 'String field with long content 03'
        sstring_field = 'Short text 03'
        date_field    = '20250703'
        time_field    = '101010'
        int1_field    = 133
        int2_field    = 22456
        int4_field    = 182837465
        dec_field     = '7777777.77'
        curr_field    = '66432.10'
        quan_field    = '2245.678'
        currency_key  = 'EUR'
        unit_key      = 'MTR'
        raw_data      = 'ABCDEF2234567890' )

      ( client = sy-mandt id = '00014' char_field1 = 'UVWXYZ' char_field2 = 'CHARF44D' char_field3 = 'Maxed out field demo'
        numc_field1 = '999999' numc_field2 = '0000000001' string_field = 'Long string content 04' sstring_field = 'SStr04'
        date_field = '20250704' time_field = '111111' int1_field = 1 int2_field = 11111 int4_field = 456789123
        dec_field = '6666666.66' curr_field = '43210.99' quan_field = '3456.789' currency_key = 'GBP' unit_key = 'TON'
        raw_data = 'AABBCCDDEEFF0011' )

      ( client = sy-mandt id = '00015' char_field1 = 'ABC123' char_field2 = 'ABCDE12345' char_field3 = 'Full CHAR FIELD text'
        numc_field1 = '123123' numc_field2 = '3213213210' string_field = 'String 05' sstring_field = 'Short05'
        date_field = '20250705' time_field = '222222' int1_field = 2 int2_field = 22222 int4_field = 567891234
        dec_field = '5555555.55' curr_field = '11111.11' quan_field = '1111.111' currency_key = 'AUD' unit_key = 'BAG'
        raw_data = 'BBCCDDEEFF112233' )

      ( client = sy-mandt id = '00016' char_field1 = 'ZZZZZZ' char_field2 = 'CH2ZZZZZ' char_field3 = 'CHAR 3 TEXT 6'
        numc_field1 = '111222' numc_field2 = '2223334444' string_field = 'String 06 content' sstring_field = 'SStr06'
        date_field = '20250706' time_field = '141414' int1_field = 3 int2_field = 30000 int4_field = 678912345
        dec_field = '4444444.44' curr_field = '22222.22' quan_field = '2222.222' currency_key = 'CAD' unit_key = 'BOX'
        raw_data = 'CCDD001122334455' )

*      // Add 9 more records for total 15
      ( client = sy-mandt id = '00017' char_field1 = 'A1B2C3' char_field2 = 'DEMOFLD07' char_field3 = 'Field3 - 07'
        numc_field1 = '444444' numc_field2 = '5555555555' string_field = 'String content 07' sstring_field = 'SStr07'
        date_field = '20250707' time_field = '070707' int1_field = 4 int2_field = 123 int4_field = 789012345
        dec_field = '3333333.33' curr_field = '33333.33' quan_field = '3333.333' currency_key = 'SGD' unit_key = 'TUB'
        raw_data = '0011002200330044' )

      ( client = sy-mandt id = '00018' char_field1 = 'X1Y2Z3' char_field2 = 'FIELD8XYZ' char_field3 = 'Content for field3'
        numc_field1 = '898888' numc_field2 = '9999999999' string_field = 'Long string 08' sstring_field = 'SStr08'
        date_field = '20250708' time_field = '080808' int1_field = 5 int2_field = 200 int4_field = 101010101
        dec_field = '2222222.22' curr_field = '44444.44' quan_field = '4444.444' currency_key = 'JPY' unit_key = 'CAN'
        raw_data = '9988776655443322' )

      ( client = sy-mandt id = '00028' char_field1 = 'X1Y2Z3' char_field2 = 'FIELD8XYZ' char_field3 = 'Content for field3'
        numc_field1 = '898888' numc_field2 = '9999999999' string_field = 'Long string 08' sstring_field = 'SStr08'
        date_field = '20250708' time_field = '080808' int1_field = 5 int2_field = 200 int4_field = 101010101
        dec_field = '2222222.22' curr_field = '44444.44' quan_field = '4444.444' currency_key = 'JPY' unit_key = 'CAN'
        raw_data = '9988776655443322' )

    ).

    " Fill dummy rows up to 15
    DO 7 TIMES.
      APPEND VALUE #( client = sy-mandt
                      id = |{ sy-index  }|  " ID 00009 to 00015
                      char_field1 = 'FILLER'
                      char_field2 = 'CHARFILLER'
                      char_field3 = 'Filler CHARFIELD3'
                      numc_field1 = '123000'
                      numc_field2 = '4567891234'
                      string_field = |Generated string { sy-index + 8 }|
                      sstring_field = |SStr{ sy-index + 8 }|
                      date_field = '20250709'
                      time_field = '090909'
                      int1_field = 10
                      int2_field = 1000
                      int4_field = 654321987
                      dec_field = '1111111.11'
                      curr_field = '10000.00'
                      quan_field = '1000.000'
                      currency_key = 'CHF'
                      unit_key = 'PKG'
                      raw_data = 'A1A2A3A4A5A6A7A8' ) TO lt_demo.
    ENDDO.

    " Insert or update
    MODIFY zbtp_dt_demo FROM TABLE @lt_demo.

    IF sy-subrc = 0.
      out->write( |Successfully updated/inserted { lines( lt_demo ) } rows.| ).
    ELSE.
      out->write( |Update failed with SY-SUBRC = { sy-subrc }.| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
