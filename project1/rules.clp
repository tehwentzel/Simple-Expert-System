(reset)
(deftemplate Person (declare (from-class Person)))
(deftemplate Recommendation (declare (from-class Recommendation)(include-variables TRUE)))
(deftemplate Record (declare (from-class Record)))
(deftemplate Condition (declare (from-class Condition) (include-variables TRUE)))

/*global constants for recommendations codes*/
(defglobal ?*CHOLESTEROL_SCREENING* = 1)
(defglobal ?*LOW_INTENSITY_STATIN* = 2)
(defglobal ?*MEDIUM_INTENSITY_STATIN* = 3)
(defglobal ?*HIGH_INTENSITY_STATIN* = 4)
(defglobal ?*FIBRATE* = 5)
(defglobal ?*PRESCRIPTION* = 6)
(defglobal ?*CRP_TEST* = 7)
(defglobal ?*DIAGNOSIS* = 8)
(defglobal ?*LIFESTYLE_CHANGES* = 9)
(defglobal ?*MISC_FURTHER_EVALUTION* = 10)
(defglobal ?*OTHER* = 0)

/*constants for conditions codes*/
(defglobal ?*CARDIOVASCULAR_CONDITION* = 1)
(defglobal ?*STATIN_INTERACTION* = 2)
(defglobal ?*IMPAIRED_KIDNEY_OR_LIVER* = 3)
(defglobal ?*MUSCLE_DISORDER* = 4)
(defglobal ?*HIV* = 5)
(defglobal ?*PRE_HYPERTENSION* = 6)
(defglobal ?*HYPERTENSION* = 7)

;(set-strategy "breadth")

(deffunction lipidTest (?person ?hdl ?ldl ?triglycerides)
	(modify ?person 
		(totalCholesterol (+ ?hdl ?ldl))
	)
	(modify ?person 
		(hdl ?hdl)
	)
	(modify ?person 
		(ldl ?ldl)
	)
	(modify ?person 
		(triglycerides ?triglycerides)
	)
	(add 
		(new Record "lipid test")
	)
)

(deffunction retire (?recommendation)
   (modify ?recommendation (active FALSE) ) 
)

(defrule dont-have-two-active-statin-prescriptions ""
    (Recommendation {code == ?*HIGH_INTENSITY_STATIN* && active == TRUE})
    ?r <- (Recommendation {code == ?*MEDIUM_INTENSITY_STATIN* && active == TRUE})
    =>
    (retire ?r)
)



(defrule you-should-be-on-statins-if-youve-had-a-heart-attack ""
    (declare(salience 10))
    (Condition {code == ?*CARDIOVASCULAR_CONDITION*})
	=>
    (add (new Recommendation "Patient should be on statins since they have had a history of stroke or heart attack" ?*HIGH_INTENSITY_STATIN*))
)

(defrule old-people-should-be-screened ""
	?p <- (Person {age > 75})
	(not 
		(Record {description == "lipid test"})
	)
    (not
       (Recommendation {code == ?*CHOLESTEROL_SCREENING*}) 
    )
	=>
	(add (new Recommendation "A lipid panel is recommended as they are over 75" ?*CHOLESTEROL_SCREENING*))
	(modify ?p (riskLevel 3))
) 

(defrule oldish-males-should-be-screened ""
	?p <- (Person {age > 35 && male == TRUE})
	(not 
		(Record {description == "lipid test"})
	)
    (not
       (Recommendation {code == ?*CHOLESTEROL_SCREENING*}) 
    )
	=>
	(add (new Recommendation "A lipid panel is recommended as they are a male over 35" ?*CHOLESTEROL_SCREENING*))
	(modify ?p (riskLevel 3))
) 

(defrule people-with-risk-factors-should-be-screened ""
	?p <- (Person {age > 20 && (smoker == TRUE || diabetic == TRUE)})
	(not 
		(Record {description == "lipid test"})
	)
    (not
       (Recommendation {code == ?*CHOLESTEROL_SCREENING*}) 
    )
	=>
	(add (new Recommendation "A lipid panel is recommended due to their age" ?*CHOLESTEROL_SCREENING*))
) 

(defrule not-young-people-with-diabetes-should-be-screened ""
	?p <- (Person 
			{age >= 40 
			&& age <= 75 }
			)
	(not 
		(Record {description == "lipid test"})
	)
    (not
       (Recommendation {code == ?*CHOLESTEROL_SCREENING*}) 
    )
	=>
	(add (new Recommendation "A lipid panel is recommended due to the patient being over 40" ?*CHOLESTEROL_SCREENING*))
	(modify ?p (riskLevel 3))
)

(defrule dude-yo-cholesterol-super-high ""
    (declare(salience 10))
	(Person {ldl >= 190})
	(not 
		(Recommendation {code == ?*HIGH_INTENSITY_STATIN*})
	)
	=>
	(add (new Recommendation "A high-intensity statin treatment is recommended due the the patients high (> 190) ldl" ?*HIGH_INTENSITY_STATIN*))
    (add (new Recommendation "An LDL-C lowering nonstatin therapy should be considered in conjunction with statin therapy due the the patients high (> 190) ldl" ?*HIGH_INTENSITY_STATIN*))
)

(defrule diabetes-and-aging-and-high-stroke-risk-is-very-bad ""
    (declare(salience 10))
	(Person {ldl >= 70
			&& age > 40
			&& diabetic == TRUE
			&& risk >= 7.5}
	)
	(not 
		(Recommendation {code == ?*HIGH_INTENSITY_STATIN*})
	)
	=>
	(add (new Recommendation "A high-intensity statin treatment is recommended due to the patient's diabetes and high stroke risk" ?*HIGH_INTENSITY_STATIN*))
)	

(defrule diabetes-and-aging-is-bad ""
    (declare(salience 10))
	(Person {ldl >= 70
			&& age > 40
			&& diabetic == TRUE
			&& risk < 7.5}
	)
	(not 
		(Recommendation {code == ?*HIGH_INTENSITY_STATIN* || code == ?*MEDIUM_INTENSITY_STATIN*})
	)
	=>
	(add (new Recommendation "A medium-intensity statin treatment is recommended due to the patient's diabetes" ?*MEDIUM_INTENSITY_STATIN*))
)

(defrule use-fibrates-for-high-triglycerides ""
    (Person {triglycerides >= 1000})
    (not
        (Recommendation {code == ?*FIBRATE*})
    )
    =>
    (add (new Recommendation "Use of fibrates is recommended due to their high triglyceride level" ?*FIBRATE*))
)

(defrule twenty-percent-risk-counts-as-chd ""
    (Person {risk > 20})
    (not
        (Condition {code == ?*CARDIOVASCULAR_CONDITION*})
    )
    =>
    (add (new Condition "Coronary Heart Disease" ?*CARDIOVASCULAR_CONDITION*))
    (add (new Recommendation "Patient has been diagnosed with Coronary Heart Disease due to their 10 year risk of a stroke or heart attack being above 20%" ?*DIAGNOSIS))
)

(defrule niacin-for-moderate-hypertriglyceridemia
    (Person {triglycerides > 150})
    =>
    (add (new Recommendation "An evaluation for risk of secondary causes of high triglycerides is recommended, including diabetes, hypothyroidism, and certain medications" ?*MISC_FURTHER_EVALUTION*))
)

(defrule lifestyle-changes-for-high-ldl
    (Person {risk < 10 && ldl > 160})
    (not 
        (Recommendation {code == ?*LIFESTYLE_CHANGES*})
    )
    =>
    (add (new Recommendation "Therapeutic Lifestyle Changes are suggested for the patient due to their elevated ldl but low risk of stroke or heart attack" ?*LIFESTYLE_CHANGES*))
)

(defrule highish-bp-means-prehypertension
    (Person {bp > 120 && bp < 130})
    (not
        (Condition {code == ?*PRE_HYPERTENSION*})
    )
    =>
    (add (new Condition "Prehypertension" ?*PRE_HYPERTENSION*))
)

(defrule high-bp-means-stage1-hypertension
    (Person {bp >= 130 && bp <= 139})
    (not
        (Condition {code == ?*HYPERTENSION*})
    )
    =>
    (add (new Condition "Stage 1 hypertension" ?*HYPERTENSION*))
)

(defrule very-high-bp-means-stage2-hypertension ""
    (Person {bp >= 140})
    (not
        (Condition {code == ?*HYPERTENSION*})
    )
    =>
    (add (new Condition "Stage 2 hypertension" ?*HYPERTENSION*))
)

(defrule lifestyle-changes-for-hypertension ""
    ?c <- (Condition {code == ?*PRE_HYPERTENSION* || code == ?*HYPERTENSION*})
    (not
        (Recommendation {code == ?*LIFESTYLE_CHANGES*})
    )
    =>
    (add (new Recommendation (str-cat "Therapeutic Lifestyle Changes are suggested due to " ?person.name "'s " ?c.description) ?*LIFESTYLE_CHANGES*))
)

(defrule prescribe-some-chill-pills-for-high-bp ""
    ?c <- (Condition {code == ?*HYPERTENSION*})
    =>
    (add (new Recommendation (str-cat ?person.name " has been diagnosed with " ?c.description " due to their high blood-pressure.") ?*DIAGNOSIS*))
)

/*lower-priority rules*/

(defrule lifestyle-changes-for-chd-patients
    (declare (salience -10))
    (Condition {code == ?*CARDIOVASCULAR_CONDITION*})
    (not 
        (Recommendation {code == ?*LIFESTYLE_CHANGES*})
    )
    =>
    (add (new Recommendation "Therapeutic Lifestyle Changes are suggested for the patient due to their existing heart condition" ?*LIFESTYLE_CHANGES*))
)

(defrule check-on-some-people-to-be-sure 
    (declare (salience -10))
    (not 
        (Recommendation {code == ?*HIGH_INTENSITY_STATIN* || code == ?*MEDIUM_INTENSITY_STATIN* || code == ?*CRP_TEST*})
    )
    (Person {risk > 5})
    =>
    (add (new Recommendation "A C-reactive protein level may help in further determining if the patient should be given a statin" ?*CRP_TEST*))
)

(defrule maybe-statins-for-people-with-high-crp ""
    (declare (salience -11))
    ?r <- (Recommendation {code == ?*CRP_TEST* && active == TRUE})
    (Person {crp >= 2})
    =>
    (add (new Recommendation "A statin is recommended due to their risk factors and elevated crp levels" ?*MEDIUM_INTENSITY_STATIN*))
    (retire ?r)
)

/*lowerer-priority-rules*/

(defrule no-longer-need-bloodtests-once-taken ""
    (declare (salience -20))
	(Record {description == "lipid test"})
	?r <- (Recommendation {code == ?*CHOLESTEROL_SCREENING*})
	=>
	(retire ?r)
)

(defrule old-people-shouldnt-take-strong-statins ""
    (declare (salience -20))
	(Person {age >= 75})
    ?r <- (Recommendation {code == ?*HIGH_INTENSITY_STATIN* && active == TRUE})
    =>
    (retire ?r)
    (add (new Recommendation (str-cat ?person.name " should take a medium-intensity statin due to their age")
            ?*MEDIUM_INTENSITY_STATIN*))    
)

(defrule asians-shouldnt-take-strong-statins ""
    (declare (salience -20))
	(Person (race /asian/))
    ?r <- (Recommendation {code == ?*HIGH_INTENSITY_STATIN* && active == TRUE})
    =>
    (retire ?r)
    (add (new Recommendation (str-cat ?person.name " should take a medium-intensity statin as their Asian-Heritage makes them more likely to have side-effects from high doses")
            ?*MEDIUM_INTENSITY_STATIN*))    
)

(defrule dont-take-strong-statins-if-you-might-have-medical-complications ""
    (declare (salience -20))
	?c <- (Condition {code == ?*STATIN_INTERACTION*
    				|| code == ?*IMPAIRED_KIDNEY_OR_LIVER*
    				|| code == ?*MUSCLE_DISORDER* })
	?r <- (Recommendation {code == ?*HIGH_INTENSITY_STATIN* && active == TRUE})
	=>
	(retire ?r)
	(add 
    	(new Recommendation 
        	(str-cat "We recommend the patient take a medium-intensity statin, due to their condition: " ?c.description ", which precludes using a strong statin")
            ?*MEDIUM_INTENSITY_STATIN*
        )
    )   
)

(defrule fibrates-can-give-you-rhybo ""
    (declare (salience -19))
    ?r <- (Recommendation {code == ?*FIBRATE* && active == TRUE})
    (Condition {code == ?*MUSCLE_DISORDER*})
    =>
    (retire ?r)
    (add (new Recommendation (str-cat ?person.name " should avoid fibrates if possible due to their muscle disorder, consider alternative methods of lowering triglycerides") ?*OTHER*))
)

(defrule list-drug-options-for-moderate-statins ""
    (declare (salience -20))
    (Recommendation {code == ?*MEDIUM_INTENSITY_STATIN* && active == TRUE})
    (not 
        (Condition {code == ?*HIV*})
    )
    =>
    (add (new Recommendation "Suggested statins for the patient are: atorvastatin 10-20mg, lovastatin 40mg, pravastatin 40mg, or simvastatin 20-40mg" ?*PRESCRIPTION*))
)

(defrule list-drug-options-for-strong-statins ""
    (declare (salience -20))
    (Recommendation {code == ?*HIGH_INTENSITY_STATIN* && active == TRUE})
    =>
    (add (new Recommendation "The suggested statin is 40-80mg of atorvastatin for patients requiring a strong statin" ?*PRESCRIPTION*))
)

(defrule hiv-patients-shouldnt-take-some-statins
    (declare (salience -21))
    (Condition {code == ?*HIV*})
    (Recommendation {code == ?*MEDIUM_INTENSITY_STATIN* && active == TRUE})
    =>
    (add (new Recommendation "HIV postive patients should consider the following statins: atorvastatin 10mg, pravastatin 40mg, or fluvastatin 20mg.  Low doses are recommended." ?*PRESCRIPTION*))
)

(defrule health-patients-get-stickers
    (declare (salience -1000))
    (not
        (Recommendation)
    )
    =>
    (add (new Recommendation (str-cat "Our system has no recommendations. Give " ?person.name " a sticker or something.") ?*OTHER*))
)