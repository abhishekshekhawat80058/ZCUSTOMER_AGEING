CLASS zcustomer_ageing_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*    DATA:wa_final TYPE zcustomer_ageing_cds,
*         it_final TYPE TABLE OF zcustomer_ageing_cds.
*    DATA: lt_response TYPE TABLE OF zcustomer_ageing_cds.
*    DATA:lt_current_output TYPE TABLE OF zcustomer_ageing_cds.
*    DATA:wa1 TYPE zcustomer_ageing_cds.
    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCUSTOMER_AGEING_CLASS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

*
*    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
*    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
*    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
*    DATA(lt_fields)        = io_request->get_requested_elements( ).
*    DATA(lt_sort)          = io_request->get_sort_elements( ).
*    DATA(lt_filter)        = io_request->get_filter( )->get_as_sql_string( ).
*    DATA(get_aggregation)        = io_request->get_aggregation( )."get_filter( )->get_as_sql_string( ).
*
*
*    TRY.
*        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
*        DATA(lt_filter_cond1) = io_request->get_filter( )->get_as_tree( ).
*      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
*    ENDTRY.
*
*
*    DATA(postingdate)  =  VALUE #( lt_filter_cond[ name =  'POSTINGDATE'  ]-range OPTIONAL ).
*    DATA(key_days)  =  VALUE #( lt_filter_cond[ name =  'KEY_DAYS'  ]-range OPTIONAL ).
*    DATA(status)       =  VALUE #( lt_filter_cond[ name =  'STATUS'  ]-range OPTIONAL ).
*    DATA(supplier)     =  VALUE #( lt_filter_cond[ name =  'SUPPLIER'  ]-range OPTIONAL ).
*
*    "]=================
*    DO 10 TIMES.
*      wa_final-supplier = SY-TABIX.
*      wa_final-asasas   = '10'.
*      APPEND wa_final TO it_final.
*      wa_final-asasas   = '20'.
*      APPEND wa_final TO it_final.
*    ENDDO.
*    MOVE-CORRESPONDING it_final TO lt_response.
*
*    TRY.
*        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*        DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
*        DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
*        DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited
*                                    THEN 0
*                                    ELSE lv_page_size ).
*        " sorting
*        DATA(sort_elements) = io_request->get_sort_elements( ).
*        DATA(lt_sort_criteria) = VALUE string_table(
*            FOR sort_element IN sort_elements
*            ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
*                                                   THEN ` descending`
*                                                   ELSE ` ascending` ) ) ).
*
*        DATA lv_sort_string TYPE string .
*        lv_sort_string  = COND #( WHEN lt_sort_criteria IS INITIAL THEN '                                   '
*                                                                            ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).
*        " requested elements
*        DATA(lt_req_elements) = io_request->get_requested_elements( ).
*        " aggregate
*        DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).
*
*        IF lt_aggr_element IS NOT INITIAL.
*          LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
*            DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element.
*            DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
*            APPEND lv_aggregation TO lt_req_elements.
*          ENDLOOP.
*        ENDIF.
*        DATA(lv_req_elements) = concat_lines_of( table = lt_req_elements
*                                                 sep   = `, ` ).
*        " grouping
*        DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
*        DATA(lv_grouping) = concat_lines_of( table = lt_grouped_element
*                                             sep   = `, ` ).
*
*
*        IF lv_sort_string IS INITIAL.
*          IF lv_grouping IS NOT INITIAL .
*            lv_sort_string = lv_grouping .
*          ELSE .
**            lv_sort_string  = 'POSTINGDATE' .
*            lv_sort_string  = 'SUPPLIER' .
*          ENDIF .
*        ENDIF .
*
*        SELECT (lv_req_elements) FROM @lt_response AS a
*                                            WHERE (lt_clause)
*                                            GROUP BY (lv_grouping)
*                                            ORDER BY (lv_sort_string)
*                                            INTO CORRESPONDING FIELDS OF TABLE @lt_current_output
*                                            OFFSET @lv_offset
*                                             UP TO @lv_max_rows ROWS.
*
*        IF io_request->is_total_numb_of_rec_requested(  ).
*          io_response->set_total_number_of_records( lines( lt_response ) ).
*        ENDIF.
*
*        IF io_request->is_data_requested(  ).
*          io_response->set_data( lt_current_output ).
*        ENDIF.
*
*      CATCH cx_root INTO DATA(lv_exception).
*
*    ENDTRY.

  ENDMETHOD.
ENDCLASS.
