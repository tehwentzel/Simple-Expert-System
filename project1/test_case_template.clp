/*Here is a file to input the information on a patient
This slot is not option - it contains the base information of the person*/

(bind ?person 
	( add 
		(new Person 
            /* STRING */  ;name
            /* INTEGER */ ;age
            /* STRING */  ;race.  important options are asian and african-american
            /* STRING */  ;gender.  guidlines distinguish between males and females. other genders will be treated as female
            /* INTEGER */ ;weight in pounds
            /* INTEGER */ ;height, unused
            /* INTEGER */ ;systolic blood pressure in mmHg
            /* BOOLEAN */ ;is the person a smoker.  Options are TRUE/FALSE
            /* BOOLEAN */ ;is the person diabetic.  Options are TRUE/FALSE.  does not distinguish between type 1 or 2.
        )
	)
)

/*Here is an optional parameter to add in results from a blood test for lipid in the patient
It is required for most of the rules in the system */

(lipidTest ?person 
    /* INTEGER */ ;HDL cholesterol (good cholesterol)
    /* INTEGER */ ;LDL cholesterol (bad cholesterol)
    /* INTEGER */ ;Triglycerides (also bad)
)

/*Here are optional conditions for the patient defines by a description and a code
examples of each code type is included in further comments*/

(add
    (new Condition
        /* STRING */   ;description of the condition
        /* INTEGER */  ;integer 0-7, see condition class or rules.clp for specific constants, or examples below
    )
)

/* More examples*/
	;(add (new Condition "patient has had a previous stroke" ?*CARDIOVASCULAR_CONDITION*))
	;(add (new Condition "patient is taking a calcium channel blocker which can interfere with statins" ?*STATIN_INTERACTION*))
	;(add (new Condition "patient has pancreatitis" ?*IMPAIRED_KIDNEY_OR_LIVER*))
	;(add (new Condition "patient does not even lift" ?*MUSCLE_DISORDER*))
	;(add (new Condition "patient has HIV and is on protease inhibitors" ?*HIV*))
