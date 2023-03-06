class ZCL_MINI_CALC definition
  public
  final
  create public .

public section.

  class-methods CALCULATE
    importing
      !IM_OP1 type I
      !IM_OPER type C
      !IM_OP2 type I
    exporting
      !EX_RESULT type STRING
    raising
      CX_SY_ZERODIVIDE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MINI_CALC IMPLEMENTATION.


  METHOD calculate.
    CASE im_oper.
      WHEN '+'.
        ex_result = im_op1 + im_op2.
      WHEN '-'.
        ex_result = im_op1 - im_op2.
      WHEN '*'.
        ex_result = im_op1 * im_op2.
      WHEN '/'.
        IF im_op2 = 0.
          RAISE EXCEPTION TYPE cx_sy_zerodivide.
        ELSE.
          ex_result = im_op1 / im_op2.
        ENDIF.
      WHEN OTHERS.
        ex_result = 'Falscher Operator'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.