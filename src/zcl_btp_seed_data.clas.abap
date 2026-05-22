CLASS zcl_btp_seed_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      c_currency         TYPE zbtp_dt_prod-currency VALUE 'USD',
      c_min_items_per_so TYPE i VALUE 2,
      c_max_items_per_so TYPE i VALUE 5,
      c_num_customers    TYPE i VALUE 10,
      c_num_products     TYPE i VALUE 15,
      c_num_orders       TYPE i VALUE 30.

    TYPES:
      BEGIN OF ty_cust,
        client             TYPE mandt,
        cust_id            TYPE zvkjun01_de_cust_id,
        name               TYPE zbtp_dt_cust-name,
        company_name       TYPE string,
        country            TYPE land1,
        city               TYPE zbtp_dt_cust-city,
        mobile             TYPE zbtp_dt_cust-mobile,
        local_last_changed TYPE abp_locinst_lastchange_tstmpl,
        last_changed       TYPE abp_lastchange_tstmpl,
        local_changed_by   TYPE abp_creation_user,
        last_changed_by    TYPE abp_lastchange_user,
      END OF ty_cust,
      tt_cust TYPE STANDARD TABLE OF ty_cust WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_prod,
        client   TYPE mandt,
        prod_id  TYPE zvkjun01_de_prod_id,
        desct    TYPE string,
        price    TYPE zbtp_dt_prod-price,  " abap.curr(7,2)
        currency TYPE zbtp_dt_prod-currency,
      END OF ty_prod,
      tt_prod TYPE STANDARD TABLE OF ty_prod WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_so,
        client             TYPE mandt,
        soid               TYPE sysuuid_x16, " matches UUID raw(16)
        buyer              TYPE zvkjun01_de_cust_id,
        sales_person       TYPE syuname,
        sales_timestamp    TYPE timestamp,   " dec(15)
        sales_manager      TYPE syuname,
        approval_timestamp TYPE timestamp,
        created_by         TYPE syuname,
        created_on         TYPE timestamp,
        changed_by         TYPE syuname,
        changed_on         TYPE timestamp,
        url                TYPE string,
      END OF ty_so,
      tt_so TYPE STANDARD TABLE OF ty_so WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_soit,
        client             TYPE mandt,
        soid               TYPE sysuuid_x16,
        item_id            TYPE zbtp_dt_soit-item_id,
        product            TYPE zvkjun01_de_prod_id,
        amount             TYPE zbtp_dt_soit-amount,
        currency           TYPE zbtp_dt_soit-currency,
        sales_person       TYPE syuname,
        sales_timestamp    TYPE timestamp,
        sales_manager      TYPE syuname,
        approval_timestamp TYPE timestamp,
        changed_by         TYPE syuname,
        changed_on         TYPE timestamp,
      END OF ty_soit,
      tt_soit TYPE STANDARD TABLE OF ty_soit WITH EMPTY KEY.

    METHODS seed_customers
      RETURNING VALUE(rt_cust) TYPE tt_cust.
    METHODS seed_products
      RETURNING VALUE(rt_prod) TYPE tt_prod.
    METHODS seed_orders
      IMPORTING
        it_cust          TYPE tt_cust
        it_prod          TYPE tt_prod
      EXPORTING
        et_items         TYPE tt_soit
      RETURNING
        VALUE(rt_header) TYPE tt_so.

    METHODS now_ts RETURNING VALUE(rv_ts) TYPE timestamp.
    METHODS uuid16  RETURNING VALUE(rv_uuid) TYPE sysuuid_x16.
    METHODS random_between
      IMPORTING iv_min        TYPE i
                iv_max        TYPE i
      RETURNING VALUE(rv_val) TYPE i.
ENDCLASS.


CLASS zcl_btp_seed_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA lt_cust TYPE tt_cust.
    DATA lt_prod TYPE tt_prod.
    DATA lt_so   TYPE tt_so.
    DATA lt_soit TYPE tt_soit.

    " 1) Build in-memory demo data
    lt_cust = seed_customers( ).
    lt_prod = seed_products( ).
    lt_so   = VALUE #( ).
    lt_soit = VALUE #( ).

    DATA(lt_hdr) = VALUE tt_so( ).
    DATA(lt_itm) = VALUE tt_soit( ).
    lt_hdr = seed_orders( EXPORTING it_cust = lt_cust it_prod = lt_prod
                          IMPORTING et_items = lt_itm ).

    " 2) Optional cleanup of previous demo rows (only those with our patterns)
    "    Safe to skip if you want pure upsert via MODIFY.
    DELETE FROM zbtp_dt_soit
      WHERE soid IN
        ( SELECT soid FROM zbtp_dt_so WHERE url LIKE 'https://demo.example/%' ).
    DELETE FROM zbtp_dt_so
      WHERE  url LIKE 'https://demo.example/%'.
    DELETE FROM zbtp_dt_prod
      WHERE  prod_id LIKE 'PRD%'.
    DELETE FROM zbtp_dt_cust
      WHERE cust_id LIKE 'CUST%'.

    " 3) Upsert to DB in FK-safe order: Customers -> Products -> SO -> SO Items
    MODIFY zbtp_dt_cust FROM TABLE @lt_cust.
    MODIFY zbtp_dt_prod FROM TABLE @lt_prod.
    MODIFY zbtp_dt_so   FROM TABLE @lt_hdr.
    MODIFY zbtp_dt_soit FROM TABLE @lt_itm.

    COMMIT WORK.

    out->write( |Seed complete. Customers: { lines( lt_cust ) } Products : { lines( lt_prod ) } SO Hdrs  : { lines( lt_hdr ) } SO Items : { lines( lt_itm ) }| ).
  ENDMETHOD.

  METHOD seed_customers.
    " Create CUST001..CUST010
    DO c_num_customers TIMES.
      DATA(lv_idx) = sy-index.
      APPEND VALUE ty_cust(
        client       = sy-mandt
        cust_id = |CUST{ lv_idx WIDTH = 3 PAD = '0' }|
           name         = |Cust { lv_idx }|
        company_name = |Demo Company { lv_idx } Inc.|
        country      = COND land1( WHEN lv_idx MOD 2 = 0 THEN 'US' ELSE 'CA' )
        mobile       = |9{ lv_idx MOD 10 }{ lv_idx MOD 10 }555{ lv_idx MOD 10 }{ lv_idx MOD 10 }|
      ) TO rt_cust.
    ENDDO.
  ENDMETHOD.

  METHOD seed_products.
    " Create PRD001..PRD015 with simple prices
    DO c_num_products TIMES.
      DATA(lv_idx) = sy-index.
      APPEND VALUE ty_prod(
        client   = sy-mandt
        prod_id = |PRD{ lv_idx WIDTH = 3 PAD = '0' }|
        desct    = |Demo Product { lv_idx }|
        price    = ( 4 * lv_idx + 9 ) / 1 " make a simple ascending price
        currency = c_currency
      ) TO rt_prod.
    ENDDO.
  ENDMETHOD.

  METHOD seed_orders.
    " Generate 10 SOs with 2–5 items each, linked to existing customers/products
    DATA(lv_now) = now_ts( ).

    LOOP AT it_cust ASSIGNING FIELD-SYMBOL(<c>) FROM 1 TO c_num_orders.
      DATA(lv_soid) = uuid16( ).
      DATA(lv_items) = random_between(
   iv_min = c_min_items_per_so
   iv_max = c_max_items_per_so ).


      " Header
      APPEND VALUE ty_so(
        client             = sy-mandt
        soid               = lv_soid
        buyer              = <c>-cust_id
        sales_person       = sy-uname
        sales_timestamp    = lv_now
        sales_manager      = sy-uname
        approval_timestamp = lv_now
        created_by         = sy-uname
        created_on         = lv_now
        changed_by         = sy-uname
        changed_on         = lv_now
        url                = |https://demo.example/{ sy-uname }/SO{ sy-tabix }|
      ) TO rt_header.

      " Items — pick products in a sliding window so they exist for sure
      DATA(lv_start) = ( sy-tabix MOD lines( it_prod ) ) + 1.
      DO lv_items TIMES.
        DATA(lv_item_no) = sy-index.
        DATA(lv_pos) = ( lv_start + lv_item_no - 1 ).
        IF lv_pos > lines( it_prod ).
          lv_pos = lv_pos - lines( it_prod ).
        ENDIF.

        READ TABLE it_prod ASSIGNING FIELD-SYMBOL(<p>) INDEX lv_pos.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        APPEND VALUE ty_soit(
          client             = sy-mandt
          soid               = lv_soid
          item_id            = |{ lv_item_no WIDTH = 6 PAD = '0' }|
          product            = <p>-prod_id   " FK to product table
          amount             = <p>-price     " simple: amount = product price
          currency           = <p>-currency
          sales_person       = sy-uname
          sales_timestamp    = lv_now
          sales_manager      = sy-uname
          approval_timestamp = lv_now
          changed_by         = sy-uname
          changed_on         = lv_now
        ) TO et_items.
      ENDDO.
    ENDLOOP.
  ENDMETHOD.

  METHOD now_ts.
    " Convert TIMESTAMPL (21) to TIMESTAMP (15) by dropping milliseconds
    DATA lv_tsl TYPE timestampl.

    GET TIME STAMP FIELD lv_tsl.
    rv_ts = lv_tsl / 1000. " 20251005123456.789 -> 20251005123456
  ENDMETHOD.

  METHOD uuid16.
    " Generate RAW(16) UUID suitable for DB field type UUID
    cl_system_uuid=>create_uuid_x16_static( RECEIVING uuid = rv_uuid ).
  ENDMETHOD.

  METHOD random_between.
    " Simple, deterministic-ish spread without external seeds
    " (good enough for test data)
    DATA(lv_span) = iv_max - iv_min + 1.
    IF lv_span <= 1.
      rv_val = iv_min.
      RETURN.
    ENDIF.
    rv_val = iv_min + ( ( sy-uzeit MOD 97 ) MOD lv_span ).
  ENDMETHOD.

ENDCLASS.

