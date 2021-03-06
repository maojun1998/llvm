; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX2

; fold (sdiv undef, x) -> 0
define i32 @combine_sdiv_undef0(i32 %x) {
; CHECK-LABEL: combine_sdiv_undef0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = sdiv i32 undef, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_sdiv_undef0(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_sdiv_undef0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = sdiv <4 x i32> undef, %x
  ret <4 x i32> %1
}

; fold (sdiv x, undef) -> undef
define i32 @combine_sdiv_undef1(i32 %x) {
; CHECK-LABEL: combine_sdiv_undef1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = sdiv i32 %x, undef
  ret i32 %1
}

define <4 x i32> @combine_vec_sdiv_undef1(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_sdiv_undef1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = sdiv <4 x i32> %x, undef
  ret <4 x i32> %1
}

; fold (sdiv x, 1) -> x
define i32 @combine_sdiv_by_one(i32 %x) {
; CHECK-LABEL: combine_sdiv_by_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %1 = sdiv i32 %x, 1
  ret i32 %1
}

define <4 x i32> @combine_vec_sdiv_by_one(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_sdiv_by_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = sdiv <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %1
}

; fold (sdiv x, -1) -> 0 - x
define i32 @combine_sdiv_by_negone(i32 %x) {
; CHECK-LABEL: combine_sdiv_by_negone:
; CHECK:       # %bb.0:
; CHECK-NEXT:    negl %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %1 = sdiv i32 %x, -1
  ret i32 %1
}

define <4 x i32> @combine_vec_sdiv_by_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sdiv_by_negone:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sdiv_by_negone:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = sdiv <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

; TODO fold (sdiv x, x) -> 1
define i32 @combine_sdiv_dupe(i32 %x) {
; CHECK-LABEL: combine_sdiv_dupe:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %edi
; CHECK-NEXT:    retq
  %1 = sdiv i32 %x, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_sdiv_dupe(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sdiv_dupe:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrd $1, %xmm0, %ecx
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    movl %eax, %ecx
; SSE-NEXT:    movd %xmm0, %esi
; SSE-NEXT:    movl %esi, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %esi
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    pinsrd $1, %ecx, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %ecx
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    pinsrd $2, %eax, %xmm1
; SSE-NEXT:    pextrd $3, %xmm0, %ecx
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    pinsrd $3, %eax, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sdiv_dupe:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    movl %eax, %ecx
; AVX-NEXT:    vmovd %xmm0, %esi
; AVX-NEXT:    movl %esi, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %esi
; AVX-NEXT:    vmovd %eax, %xmm1
; AVX-NEXT:    vpinsrd $1, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %ecx
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    vpinsrd $2, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    vpinsrd $3, %eax, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = sdiv <4 x i32> %x, %x
  ret <4 x i32> %1
}

; fold (sdiv x, y) -> (udiv x, y) iff x and y are positive
define <4 x i32> @combine_vec_sdiv_by_pos0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sdiv_by_pos0:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    psrld $2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sdiv_by_pos0:
; AVX:       # %bb.0:
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpsrld $2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = sdiv <4 x i32> %1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_sdiv_by_pos1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sdiv_by_pos1:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrld $3, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    psrld $4, %xmm0
; SSE-NEXT:    psrld $2, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_sdiv_by_pos1:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vpsrld $4, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $2, %xmm0, %xmm2
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    vpsrld $3, %xmm0, %xmm2
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_sdiv_by_pos1:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = sdiv <4 x i32> %1, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %2
}

; fold (sdiv x, (1 << c)) -> x >>u c
define <4 x i32> @combine_vec_sdiv_by_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sdiv_by_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psrld $30, %xmm1
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    psrad $2, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sdiv_by_pow2a:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX-NEXT:    vpsrld $30, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrad $2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sdiv <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_sdiv_by_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sdiv_by_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrd $1, %xmm0, %eax
; SSE-NEXT:    movl %eax, %ecx
; SSE-NEXT:    sarl $31, %ecx
; SSE-NEXT:    shrl $30, %ecx
; SSE-NEXT:    addl %eax, %ecx
; SSE-NEXT:    sarl $2, %ecx
; SSE-NEXT:    pextrd $2, %xmm0, %eax
; SSE-NEXT:    pextrd $3, %xmm0, %edx
; SSE-NEXT:    pinsrd $1, %ecx, %xmm0
; SSE-NEXT:    movl %eax, %ecx
; SSE-NEXT:    sarl $31, %ecx
; SSE-NEXT:    shrl $29, %ecx
; SSE-NEXT:    addl %eax, %ecx
; SSE-NEXT:    sarl $3, %ecx
; SSE-NEXT:    pinsrd $2, %ecx, %xmm0
; SSE-NEXT:    movl %edx, %eax
; SSE-NEXT:    sarl $31, %eax
; SSE-NEXT:    shrl $28, %eax
; SSE-NEXT:    addl %edx, %eax
; SSE-NEXT:    sarl $4, %eax
; SSE-NEXT:    pinsrd $3, %eax, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sdiv_by_pow2b:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    movl %eax, %ecx
; AVX-NEXT:    sarl $31, %ecx
; AVX-NEXT:    shrl $30, %ecx
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    sarl $2, %ecx
; AVX-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %eax
; AVX-NEXT:    movl %eax, %ecx
; AVX-NEXT:    sarl $31, %ecx
; AVX-NEXT:    shrl $29, %ecx
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    sarl $3, %ecx
; AVX-NEXT:    vpinsrd $2, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $3, %xmm0, %eax
; AVX-NEXT:    movl %eax, %ecx
; AVX-NEXT:    sarl $31, %ecx
; AVX-NEXT:    shrl $28, %ecx
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    sarl $4, %ecx
; AVX-NEXT:    vpinsrd $3, %ecx, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = sdiv <4 x i32> %x, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %1
}
