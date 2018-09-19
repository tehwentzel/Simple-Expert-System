/*Here is a file to input the information on a patient
This slot is not option - it contains the base information of the person*/

(bind ?person 
	( add 
		(new Person 
            "johnnita" ;name
            50         ;age
            "white"    ;race.  important options are asian and african-american
            "female"   ;gender.  guidlines distinguish between males and females. other genders will be treated as female
            150        ;weight in pounds
            100        ;height, unused
            200        ;systolic blood pressure in mmHg.  This person probably has bigger problems than cholesterol
            FALSE      ;is the person a smoker.  Options are TRUE/FALSE
            FALSE       ;is the person diabetic.  Options are TRUE/FALSE.  does not distinguish between type 1 or 2.
        ) 
	)
)

/*Here is an optional parameter to add in results from a blood test for lipid in the patient
It is required for most of the rules in the system */

(lipidTest ?person 
    30     ;HDL cholesterol (good cholesterol)
    180    ;LDL cholesterol (bad cholesterol)
    200    ;Triglycerides (also bad)
)

/*Here are optional conditions for the patient defines by a description and a code
examples of each code type is included in further comments*/

(add (new Condition 
        "Patient has liver damage" ;description
        ?*IMPAIRED_KIDNEY_OR_LIVER* ;code
     )
)

/* More examples*/
	;(add (new Condition "patient has had a previous stroke" ?*CARDIOVASCULAR_CONDITION*))
	;(add (new Condition "patient is taking a calcium channel blocker which can interfere with statins" ?*STATIN_INTERACTION*))
	;(add (new Condition "patient has pancreatitis" ?*IMPAIRED_KIDNEY_OR_LIVER*))
	;(add (new Condition "patient does not even lift" ?*MUSCLE_DISORDER*))
	;(add (new Condition "patient has HIV and is on protease inhibitors" ?*HIV*))
