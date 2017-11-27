(set-logic SLIA) (synth-fun f ((name String)) String    ((Start String (ntString))     (ntString String (name " " "+" "-" "."                       (str.++ ntString ntString)                       (str.replace ntString ntString ntString)                       (str.at ntString ntInt)                       (int.to.str ntInt)                       (str.substr ntString ntInt ntInt)))      (ntInt Int (0 1 2 3 4 5                  (+ ntInt ntInt)                  (- ntInt ntInt)                  (str.len ntString)                  (str.to.int ntString)                  (str.indexof ntString ntString ntInt)))      (ntBool Bool (true false                    (str.prefixof ntString ntString)                    (str.suffixof ntString ntString)                    (str.contains ntString ntString)))));;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;(define-fun ithSplit ((s String) (delimiter String) (i Int)) String    (let ((firstSpacePos Int (str.indexof s delimiter 0)))    (let ((SecondSpacePos Int (str.indexof s delimiter (+ firstSpacePos 1))))    (let ((ThirdSpacePos Int (str.indexof s delimiter (+ SecondSpacePos 1))))            (ite (= i 0)                (ite (= firstSpacePos (- 1))                     s ; Return the whole string, there was no space                     (str.substr s 0 firstSpacePos)                )                (ite (= i 1)                    (ite (= firstSpacePos (- 1))                        "" ; There was no space, so index 1 is out of bounds                        (ite (= SecondSpacePos (- 1))                            (str.substr s (+ firstSpacePos 1) (str.len s)) ; till the end of the String                            (str.substr s (+ firstSpacePos 1) (- (- SecondSpacePos 1) firstSpacePos)) ; to the next space; second arg of str.substr is shift, not position                        )                    )                    (ite (= i 2)                        (ite (or (= firstSpacePos (- 1)) (= SecondSpacePos (- 1)))                            "" ; There was no space, so index 2 is out of bounds                            (ite (= ThirdSpacePos (- 1))                                (str.substr s (+ SecondSpacePos 1) (str.len s)) ; till the end of the String                                (str.substr s (+ SecondSpacePos 1) (- (- ThirdSpacePos 1) SecondSpacePos)) ; to the next space; second arg of str.substr is shift, not position                            )                        )                        "" ; Unhandled values of i (> 2)                    )                )            )    ))))(define-fun precond ((s String)) Bool    (and (>= (str.indexof s " " 0) 2)         (= (str.indexof s " " (+ 1 (str.indexof s " " 0))) (- 1))  ; only one space         (let ((digits String (ithSplit s " " 1))) (and             (= (str.indexof digits "-" 0) 3)             (= (str.indexof digits "-" 4) 7)             (= (str.indexof digits "-" 8) (- 1))             (= (str.len digits) 11)               ; xxx-xxx-xxx (11 chars)         ))         (= (str.at s 0) "+")    ));;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (constraint (= (f "+106 769-858-438") "106.769.858.438")); (constraint (= (f "+83 973-757-831") "83.973.757.831")); (constraint (= (f "+62 647-787-775") "62.647.787.775")); (constraint (= (f "+172 027-507-632") "172.027.507.632")); (constraint (= (f "+72 001-050-856") "72.001.050.856")); (constraint (= (f "+95 310-537-401") "95.310.537.401")); (constraint (= (f "+6 775-969-238") "6.775.969.238"))(declare-var s String)(constraint    (=> (precond s) 	(= (f s) 		(str.++ 			(str.substr (ithSplit s " " 0) 1 (- (str.len (ithSplit s " " 0)) 1)) "."			(ithSplit (ithSplit s " " 1) "-" 0 ) "." 			(ithSplit (ithSplit s " " 1) "-" 1 ) "." 			(ithSplit (ithSplit s " " 1) "-" 2 )		)	)))(check-synth)