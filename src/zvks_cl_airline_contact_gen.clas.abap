CLASS zvks_cl_airline_contact_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES:
      gty_tt_contact TYPE STANDARD TABLE OF zvks_a_contact WITH DEFAULT KEY.

    METHODS:
      get_contact RETURNING VALUE(rt_contact) TYPE gty_tt_contact,
      set_contact RETURNING VALUE(rt_contact) TYPE gty_tt_contact.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvks_cl_airline_contact_gen IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( me->set_contact( ) ).
  ENDMETHOD.

  METHOD get_contact.

    DATA:
      lv_utc_tmstmpl TYPE tzntstmpl.

    FINAL(lv_user_id)      = cl_abap_context_info=>get_user_technical_name( ).

    GET TIME STAMP FIELD lv_utc_tmstmpl.

    rt_contact = VALUE #(
    (
     client          = sy-mandt
     contact_id    = 0000000001
     first_name    = 'John'
     last_name     = 'Doe'
     title         = 'Mr.'
     street        = 'Redmond'
     postal_code   = '112041'
     city          = 'Delaware'
     country_code  = 'US'
     phone_number  = '+1 202-918-2132'
     email_address = 'yahoo@gmail.com'
     "- Admin Data
     created_by      = lv_user_id
     created_at      = lv_utc_tmstmpl
      ) ).

  ENDMETHOD.

  METHOD set_contact.

    DELETE FROM zvks_a_contact.
    COMMIT WORK AND WAIT.

    rt_contact = me->get_contact( ).

    IF rt_contact IS NOT INITIAL.
      MODIFY zvks_a_contact FROM TABLE @rt_contact.
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
