CLASS zcl_zbtp_data_entry DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_oo_adt_classrun.

    METHODS:
      " Flush the data from the tables on each execution
      refresh,
      " Enter data in Master Tables
      enter_master_data,
      " Enter Data in Transactional Tables
      enter_transactional_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zbtp_data_entry IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    CALL METHOD refresh.
    CALL METHOD enter_master_data.
    CALL METHOD enter_transactional_data.

    out->write(
      EXPORTING
        data = 'Data Entered Successfully'
    ).
  ENDMETHOD.

  METHOD refresh.
    DELETE FROM : zbtp_dt_so,
                  zbtp_dt_soit,
                  zbtp_dt_prod,
                  zbtp_dt_cust,
                  zbtp_dt_dlsh,   "Delivery Schedule Table
                  zbtp_dt_inv.    "Invoice Table
  ENDMETHOD.

  METHOD enter_master_data.
    DATA: li_prod TYPE TABLE OF zbtp_dt_prod,
          ls_prod TYPE zbtp_dt_prod,
          li_cust TYPE TABLE OF zbtp_dt_cust,
          ls_cust TYPE zbtp_dt_cust.

    " Product ID RNG
    cl_abap_random_int=>create(
      EXPORTING min = 1000000  max = 9000000
      RECEIVING prng = DATA(lobj_prod)
    ).

    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Pen'         price = '12'   currency = 'INR' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Pencil'      price = '2'    currency = 'INR' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Compass Box' price = '121'  currency = 'INR' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Drafter'     price = '2'    currency = 'EUR' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Laptop'      price = '1200' currency = 'EUR' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Hard-Disk'   price = '20'   currency = 'EUR' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'RAM'         price = '120'  currency = 'USD' ) TO li_prod.
    APPEND VALUE #( prod_id = lobj_prod->get_next( ) desct = 'Mouse'       price = '20'   currency = 'USD' ) TO li_prod.

    INSERT zbtp_dt_prod FROM TABLE @li_prod.

    " Customer ID RNG
    cl_abap_random_int=>create(
      EXPORTING min = 100000000  max = 900000000
      RECEIVING prng = DATA(lobj_cust)
    ).

    APPEND VALUE #( cust_id = lobj_cust->get_next( ) name = 'Vishal' company_name = 'Tech'        country = 'IN' city = 'Hyd'  mobile = 231423289 ) TO li_cust.
    APPEND VALUE #( cust_id = lobj_cust->get_next( ) name = 'Rohit'  company_name = 'FineDines'   country = 'IN' city = 'Pune' mobile = 23145789 )  TO li_cust.
    APPEND VALUE #( cust_id = lobj_cust->get_next( ) name = 'AJ'     company_name = 'AnyAnalytics' country = 'IN' city = 'Hyd'  mobile = 2314789 )   TO li_cust.
    APPEND VALUE #( cust_id = lobj_cust->get_next( ) name = 'Rahul'  company_name = 'ABC Corps'    country = 'IN' city = 'Delhi' mobile = 231434789 ) TO li_cust.
    APPEND VALUE #( cust_id = lobj_cust->get_next( ) name = 'Virat'  company_name = 'IT Multi'     country = 'IN' city = 'Mum'   mobile = 231434789 ) TO li_cust.
    APPEND VALUE #( cust_id = lobj_cust->get_next( ) name = 'Suraya' company_name = 'IndexIT'      country = 'IN' city = 'Mum'   mobile = 231412789 ) TO li_cust.

    INSERT zbtp_dt_cust FROM TABLE @li_cust.
  ENDMETHOD.

  METHOD enter_transactional_data.
    DATA: li_so       TYPE TABLE OF zbtp_dt_so,
          li_soit     TYPE TABLE OF zbtp_dt_soit,
          li_delv_sch TYPE TABLE OF zbtp_dt_dlsh,
          li_inv      TYPE TABLE OF zbtp_dt_inv.

    SELECT prod_id, price, currency
      FROM zbtp_dt_prod
      INTO TABLE @DATA(li_prod).

    SELECT cust_id
      FROM zbtp_dt_cust
      INTO TABLE @DATA(li_cust).

    " RNGs
    cl_abap_random_int=>create( EXPORTING min = 4000000 max = 4999999 RECEIVING prng = DATA(lobj_prng_so)    ).
    cl_abap_random_int=>create( EXPORTING min = 40000   max = 49999   RECEIVING prng = DATA(lobj_prng_soit)  ).
    cl_abap_random_int=>create( EXPORTING min = 100000  max = 299999  RECEIVING prng = DATA(lobj_prng_dlv)   ).
    cl_abap_random_int=>create( EXPORTING min = 8000000 max = 9999999 RECEIVING prng = DATA(lobj_prng_inv)   ).
    cl_abap_random_int=>create( EXPORTING min = 1       max = 6       RECEIVING prng = DATA(lobj_cust_count) ).
    cl_abap_random_int=>create( EXPORTING min = 1       max = 6       RECEIVING prng = DATA(lobj_prod_count) ).
    cl_abap_random_int=>create( EXPORTING min = 1       max = 6       RECEIVING prng = DATA(lobj_item_count) ).

    DO 10 TIMES.
      " Sales Order Header
      DATA(lv_soid)    = lobj_prng_so->get_next( ).
      DATA(lv_p_count) = lobj_cust_count->get_next( ).

      cl_abap_tstmp=>timet_to_tstmp(
        EXPORTING time_t = '123456'
        RECEIVING r_tstmp = DATA(lv_timestamp_created)
      ).
      cl_abap_tstmp=>timet_to_tstmp(
        EXPORTING time_t = '773456'
        RECEIVING r_tstmp = DATA(lv_timestamp_changed)
      ).

      DATA(lv_url) = 'https://m.media-amazon.com/images/I/71BLNfKfR3L._UF1000,1000_QL80_.jpg'.

      APPEND VALUE #(
        soid          = lv_soid
        buyer         = li_cust[ lv_p_count ]-cust_id
        sales_person  = 'Operator'
        sales_manager = 'Rocket Singh'
        created_by    = 'C0898005587'
        changed_by    = 'C0898005587'
        created_on    = lv_timestamp_created
        changed_on    = lv_timestamp_changed
        url           = lv_url
      ) TO li_so.

      INSERT zbtp_dt_so FROM TABLE @li_so.
      CLEAR li_so.

      " Sales Order Items
      DO 3 TIMES.
        DATA(lv_item)   = lobj_prng_soit->get_next( ).
        DATA(lv_c_count) = lobj_prod_count->get_next( ).

        DATA: image_item TYPE string.
        CASE sy-index.
          WHEN 1.
            image_item = 'https://m.media-amazon.com/images/I/71uPkyrIiplL.jpg'.
          WHEN 2.
            image_item = |https://m.media-amazon.com/images/I/51oUTHyDqGL| && |_UF1000,1000_QL80_.jpg|.
          WHEN 3.
            image_item = |https://m.media-amazon.com/images/I/61LsEH0okL|   && |_AC_UF1000,1000_QL80_.jpg|.
        ENDCASE.

        APPEND VALUE #(
          soid       = lv_soid
          item_id    = lv_item
          product    = li_prod[ lv_c_count ]-prod_id
          amount     = li_prod[ lobj_prod_count->get_next( ) ]-price
          currency   = li_prod[ lobj_prod_count->get_next( ) ]-currency
          changed_by = 'C0898005587'
        ) TO li_soit.

        CLEAR image_item.

        " Delivery Schedules (2 per item)
        DO 2 TIMES.
          APPEND VALUE #(
            soid          = lv_soid
            item_id       = lv_item
            delv_id       = lobj_prng_dlv->get_next( )
            product       = li_prod[ lv_c_count ]-prod_id
            quantity      = 2
            delivery_date = sy-datum
          ) TO li_delv_sch.

          INSERT zbtp_dt_dlsh FROM TABLE @li_delv_sch.
          CLEAR li_delv_sch.

          APPEND VALUE #(
            soid    = lv_soid
            item_id = lv_item
            delv_id = lobj_prng_dlv->get_next( )
            product = li_prod[ lv_c_count ]-prod_id
            quantity = 7
          ) TO li_delv_sch.

          INSERT zbtp_dt_dlsh FROM TABLE @li_delv_sch.
          CLEAR li_delv_sch.

          " Invoice (1 per item for demo)
          APPEND VALUE #(
            soid        = lv_soid
            item_id     = lv_item
            invoice_id  = lobj_prng_inv->get_next( )
            buyer       = li_cust[ lv_p_count ]-cust_id
            billing_amt = 200
          ) TO li_inv.

          INSERT zbtp_dt_inv FROM TABLE @li_inv.
          CLEAR li_inv.
        ENDDO.
      ENDDO.

      INSERT zbtp_dt_soit FROM TABLE @li_soit.
      CLEAR li_soit.

      CLEAR: lv_soid.
    ENDDO.
  ENDMETHOD.

ENDCLASS.

