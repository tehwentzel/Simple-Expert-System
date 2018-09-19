
#### Domain

	My domain is in the area of Clinical Decision Support Systems, and application of expert systems that are designed to aid medical professional with making medical decisions.  These systems aren’t intended to fully replace medical professionals, as many decisions are guided by personal judgment, but can aid greatly in speeding up decision making and reducing errors in a medical setting, where professionals are often short on time, and rules for many conditions can become extremely complex.

	This specific example covers some of the basics of dealing with high cholesterol and some related heart conditions in individuals, as today heart disease is the leading cause of death and there is a wealth of literature on treatment.  

	The specifics of the prototype cover some of the basic guidelines for prescribing treatment high cholesterol based on certain patient information and cholesterol levels.  It will also make some basic insights into related issues - namely diagnosing high blood pressure - and finally provided suggestions for specific popular drugs based on the results.  

#### System Design

	The system is designed to be used for a unique individual.  It defines 4 classes (in java) and corresponding templates in lisp: Person, Condition, Record, and Recommendation.

	The *Person *class is required.  A number of fields are given regarding the patient that were chosen to reflect normal information taken at the time of a doctor visit (name, weight, height, etc), which are included in the constructor for the class.  A number of additional information is included that is used to calculate the patients 10-year risk of having a heart attack or stroke according to [1], which is encapsulated in the private methods *predictMaleRisk() *and *predictFemaleRisk()*.  The latter fields are defined in the system by using the "lipid-panel" function in Jess or can be set manually.   This functionality is chosen to reflect the fact that patients may not necessarily have information about their cholesterol levels on their first visit to a doctor.  

	The *Condition *class is a small class that is meant to encapsulate different conditions the patient may have.  Each condition has a *description *which is a string, and a *code, *which is an integer that the system uses to classify them.  Conditions can be put in manually, or can be outputs of the system* *(e.g. high blood pressure).  The existence of certain conditions can be used to determine if certain recommendations should be made or altered.  E.g. Patients with HIV on protease inhibitors have certain statins they shouldn’t take.  Any patient with an existing heart condition should automatically be prescribed statins.

	The *Recommendation *Class is the actual output of the system.  Like Conditions, they each have a *description *and a *code.  *Additionally, a boolean field called *active* is used to allow Recommendations to be inactivated to prevent loops where recommendations are removed, causing the rules that created them to re-fire.

	The *Record *Class is largely a placeholder to allow for further expansion to the system.  It contains a *description.  *It is meant to be used in the potential case where patients and doctors could be continually interacting, and records could be added dynamically.  Here, when a "lipid panel" is created, it creates a corresponding record.

#### Running The System and Output

	The system can be run in an IDE (e.g. Eclipse), or from the command line by navigating to the folder "project 1" and running the command:

	>java MyClinicalSupportSystem

The command line will prompt you for a file to run for the test case.  Pressing <enter> will result in the default file being run, defined in the *testCaseFile *static field at the top of the MyClinicalSupportSystem class.  This can be changed as well.

	Several test cases have been given as examples of the form *test_case[0-6].clp*.  The files are in the form of jess files that instantiate a *Person *object, and an option (but highly recommended) lipid test and one or more conditions.  A template is also given in the *test_case_template.clp* file, where all input strings and integers are replaced by /* INTEGER */ and /* STRING */, respectively.  The Person initialization is required.  The lipid panel and conditions are recommended, or the system will just tell you to get a lipid test or not, probably.

	The system will then run and print out all active generated by the expert system.

#### A Bit More on the Logic and All That

	The logic in the system works largely in three stages.  In the first stage, patient information is taken in.  In the event that a lipid test is not included, the system will decide if one is suggested (based on age).  The system will also look at the patient’s blood pressure and will add a condition and corresponding recommendation if the patient has hypertension.

	In the event of a lipid test, more information can be gleamed.  The Person class implements a risk variable that calculates a 10-year likelihood of someone having a stroke or heart attack.  A risk of >20% will result in the patient being diagnosed with Cardiovascular  Disease, as this is an equivalent clinical definition. 

	Several factors are then used to check for cases where guidelines recommend the use of different treatments.  The treatments covered in this systems are predominantly:

* Moderate or High Intensity Statins, which lower bad LDL cholesterol.

* Fibrates, which lower triglycerides.

* Therapeutic Lifestyle Changes (TLC), which are the first-line recommendation for many case.

Factors that are considered are age, 10-year risk, LDL cholesterol levels, Triglyceride levels, if the patient has diabetes, and presence of certain conditions such as a previous heart attack or hypertension.

	After this stage, certain conditions are checked against the resulting recommendations for contra-indications.  One example of this is that people of Asian descent are more likely to face side effects from high-intensity statins, and should be downgraded to taking medium-intensity statins.  When this occurs, previous recommendations are deactivated, where there *active  *field is set to FALSE, instead of being removed.  This allows logic to prevent the recommendations from being re-generated.

	Finally, some specific recommendations for medications are generated for the prescription of statins.  While there are a number of different drugs, these recommendations are based on the subset of those recommended in [3], due to their effectiveness and cost.  At this point the system could allow for interactions with specific drugs to be checked.  For this example, patients with a Condition with the HIV code will be given a different set of statin recommendations.

	

Miscellania

	This system uses forward chaining to generate recommendations.  However, for systems where a medical professional is able to more dynamically, backward chaining systems are often used.  In these cases, the professional can try to check for a specific diagnosis, and will be able to be given any suite of tests that are required in order to reach a conclusion. 

The algorithm used for calculating 10-year risk is take from literature and covers the values given for white males and females.  African-american and hispanic specific algorithms also exists, but were not included due to difficulty in finding them.

The test cases provided cover most of the cases considered in testing the system.  Certain results are taken from literature, but the specific conditions haven’t been found as they rely on a large number of variables and specific ranges for calculating 10-year risk.

Certain guidelines among the cited literature are fuzzy and contradict each other in certain situations.  None of the rules in this system should be taken as fact and are purely demonstrative.  Please don’t sue me if this system tells you you’re ok and then your heart explodes.  

This system makes use of certain demographic factors such as gender and race.  These are used in relation to how they are cited in literature and are not meant to be exhaustive or reflect the views of the author.

Sources

Most of the rules in this system are drawn from the *2013 ACC/AHA Guideline on the Assessment of Cardiovascular Risk* (NOTE:  Andrus, Bruce, and Diane Lacaille. "2013 ACC/AHA guideline on the assessment of cardiovascular risk." Journal of the American College of Cardiology 63.25 Part A (2014): 2886.)*, *as well as the the National Cholesterol Education Program’s published report on *Detection, Evaluation, and Treatment of High Blood Cholesterol In Adults (Adult Treatment Panel)* (NOTE:  Expert Panel on Detection, Evaluation. "Executive summary of the third report of the National Cholesterol Education Program (NCEP) expert panel on detection, evaluation, and treatment of high blood cholesterol in adults (Adult Treatment Panel III)." Jama 285.19 (2001): 2486.)*.  *Certain  guidelines for suggesting specific drugs were taken from *Consumer Reports Best Buy Drugs: Evaluating Statin Drugs to Treat High Cholesterol and Heart Disease* (NOTE: http://article.images.consumerreports.org/prod/content/dam/cro/news_articles/health/PDFs/StatinsUpdate-FINAL.pdf)*.   *

This system is implemented using Java and Jess. (NOTE:  Friedman-Hill, Ernest, "Jess in Action: Rule-based Systems in Java", ISBN 1930110898.
)

