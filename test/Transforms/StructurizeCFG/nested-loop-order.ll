; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -structurizecfg %s -o - | FileCheck %s

define void @main(float addrspace(1)* %out) {
; CHECK-LABEL: @main(
; CHECK-NEXT:  main_body:
; CHECK-NEXT:    br label [[LOOP_OUTER:%.*]]
; CHECK:       LOOP.outer:
; CHECK-NEXT:    [[TEMP8_0_PH:%.*]] = phi float [ 0.000000e+00, [[MAIN_BODY:%.*]] ], [ [[TMP13:%.*]], [[FLOW3:%.*]] ]
; CHECK-NEXT:    [[TEMP4_0_PH:%.*]] = phi i32 [ 0, [[MAIN_BODY]] ], [ [[TMP12:%.*]], [[FLOW3]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       LOOP:
; CHECK-NEXT:    [[TMP0:%.*]] = phi i32 [ undef, [[LOOP_OUTER]] ], [ [[TMP12]], [[FLOW:%.*]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi float [ undef, [[LOOP_OUTER]] ], [ [[TMP13]], [[FLOW]] ]
; CHECK-NEXT:    [[TEMP4_0:%.*]] = phi i32 [ [[TEMP4_0_PH]], [[LOOP_OUTER]] ], [ [[TMP15:%.*]], [[FLOW]] ]
; CHECK-NEXT:    [[TMP20:%.*]] = add i32 [[TEMP4_0]], 1
; CHECK-NEXT:    [[TMP22:%.*]] = icmp sgt i32 [[TMP20]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = xor i1 [[TMP22]], true
; CHECK-NEXT:    br i1 [[TMP2]], label [[ENDIF:%.*]], label [[FLOW]]
; CHECK:       Flow2:
; CHECK-NEXT:    [[TMP3:%.*]] = phi float [ [[TEMP8_0_PH]], [[IF29:%.*]] ], [ [[TMP9:%.*]], [[FLOW1:%.*]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = phi i32 [ [[TMP20]], [[IF29]] ], [ undef, [[FLOW1]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = phi i1 [ [[TMP32:%.*]], [[IF29]] ], [ true, [[FLOW1]] ]
; CHECK-NEXT:    br label [[FLOW]]
; CHECK:       Flow3:
; CHECK-NEXT:    br i1 [[TMP16:%.*]], label [[ENDLOOP:%.*]], label [[LOOP_OUTER]]
; CHECK:       ENDLOOP:
; CHECK-NEXT:    [[TEMP8_1:%.*]] = phi float [ [[TMP14:%.*]], [[FLOW3]] ]
; CHECK-NEXT:    [[TMP23:%.*]] = icmp eq i32 [[TMP20]], 3
; CHECK-NEXT:    [[DOT45:%.*]] = select i1 [[TMP23]], float 0.000000e+00, float 1.000000e+00
; CHECK-NEXT:    store float [[DOT45]], float addrspace(1)* [[OUT:%.*]]
; CHECK-NEXT:    ret void
; CHECK:       ENDIF:
; CHECK-NEXT:    [[TMP31:%.*]] = icmp sgt i32 [[TMP20]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = xor i1 [[TMP31]], true
; CHECK-NEXT:    br i1 [[TMP6]], label [[ENDIF28:%.*]], label [[FLOW1]]
; CHECK:       Flow1:
; CHECK-NEXT:    [[TMP7:%.*]] = phi i32 [ [[TMP20]], [[ENDIF28]] ], [ [[TMP0]], [[ENDIF]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = phi float [ [[TMP35:%.*]], [[ENDIF28]] ], [ [[TMP1]], [[ENDIF]] ]
; CHECK-NEXT:    [[TMP9]] = phi float [ [[TMP35]], [[ENDIF28]] ], [ [[TEMP8_0_PH]], [[ENDIF]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = phi i1 [ [[TMP36:%.*]], [[ENDIF28]] ], [ true, [[ENDIF]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = phi i1 [ false, [[ENDIF28]] ], [ true, [[ENDIF]] ]
; CHECK-NEXT:    br i1 [[TMP11]], label [[IF29]], label [[FLOW2:%.*]]
; CHECK:       IF29:
; CHECK-NEXT:    [[TMP32]] = icmp sgt i32 [[TMP20]], 2
; CHECK-NEXT:    br label [[FLOW2]]
; CHECK:       Flow:
; CHECK-NEXT:    [[TMP12]] = phi i32 [ [[TMP7]], [[FLOW2]] ], [ [[TMP0]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP13]] = phi float [ [[TMP8]], [[FLOW2]] ], [ [[TMP1]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP14]] = phi float [ [[TMP3]], [[FLOW2]] ], [ [[TEMP8_0_PH]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP15]] = phi i32 [ [[TMP4]], [[FLOW2]] ], [ undef, [[LOOP]] ]
; CHECK-NEXT:    [[TMP16]] = phi i1 [ [[TMP10]], [[FLOW2]] ], [ true, [[LOOP]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = phi i1 [ [[TMP5]], [[FLOW2]] ], [ true, [[LOOP]] ]
; CHECK-NEXT:    br i1 [[TMP17]], label [[FLOW3]], label [[LOOP]]
; CHECK:       ENDIF28:
; CHECK-NEXT:    [[TMP35]] = fadd float [[TEMP8_0_PH]], 1.000000e+00
; CHECK-NEXT:    [[TMP36]] = icmp sgt i32 [[TMP20]], 2
; CHECK-NEXT:    br label [[FLOW1]]
;
main_body:
  br label %LOOP.outer

LOOP.outer:                                       ; preds = %ENDIF28, %main_body
  %temp8.0.ph = phi float [ 0.000000e+00, %main_body ], [ %tmp35, %ENDIF28 ]
  %temp4.0.ph = phi i32 [ 0, %main_body ], [ %tmp20, %ENDIF28 ]
  br label %LOOP

LOOP:                                             ; preds = %IF29, %LOOP.outer
  %temp4.0 = phi i32 [ %temp4.0.ph, %LOOP.outer ], [ %tmp20, %IF29 ]
  %tmp20 = add i32 %temp4.0, 1
  %tmp22 = icmp sgt i32 %tmp20, 3
  br i1 %tmp22, label %ENDLOOP, label %ENDIF

ENDLOOP:                                          ; preds = %ENDIF28, %IF29, %LOOP
  %temp8.1 = phi float [ %temp8.0.ph, %LOOP ], [ %temp8.0.ph, %IF29 ], [ %tmp35, %ENDIF28 ]
  %tmp23 = icmp eq i32 %tmp20, 3
  %.45 = select i1 %tmp23, float 0.000000e+00, float 1.000000e+00
  store float %.45, float addrspace(1)* %out
  ret void

ENDIF:                                            ; preds = %LOOP
  %tmp31 = icmp sgt i32 %tmp20, 1
  br i1 %tmp31, label %IF29, label %ENDIF28

IF29:                                             ; preds = %ENDIF
  %tmp32 = icmp sgt i32 %tmp20, 2
  br i1 %tmp32, label %ENDLOOP, label %LOOP

ENDIF28:                                          ; preds = %ENDIF
  %tmp35 = fadd float %temp8.0.ph, 1.0
  %tmp36 = icmp sgt i32 %tmp20, 2
  br i1 %tmp36, label %ENDLOOP, label %LOOP.outer
}

attributes #0 = { "enable-no-nans-fp-math"="true" "unsafe-fp-math"="true" }
attributes #1 = { nounwind readnone }
attributes #2 = { readnone }
