import java.io.Serializable;

public class Person implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 717015672629057179L;
	private int age;
	private final String race;
	private String name;
	private int weight;
	private int height;
	private int riskLevel;
	private int bp; //proxy for systolic bloodpressure
	private int totalCholesterol;
	private int hdl;
	private int ldl;
	private int triglycerides;
	private int crp;
	private int bnp;
	private boolean smoker;
	private boolean diabetic;
	private boolean male;
	
	public Person(String name, int age, String race, String gender, int weight, int height, int bp, boolean smoker, boolean diabetic){
		this.age = age;
		this.race = new String(race);
		this.name = new String(name);
		this.weight = weight;
		this.height = height;
		this.bp = bp;
		this.smoker = smoker;
		this.diabetic = diabetic;
		if(gender.toLowerCase().equals("male")){
			this.male = true;
		} else {this.male = false;}
	}
	
	public Person(String name, int age, String race, String gender, int weight, int height, 
			int bp, int totalCholesterol, int hdl, int ldl, int triglycerides, int crp,
			boolean smoker, boolean diabetic){
		this.age = age;
		this.race = new String(race);
		this.name = new String(name);
		this.weight = weight;
		this.height = height;
		this.bp = bp;
		this.totalCholesterol = totalCholesterol;
		this.hdl = hdl;
		this.ldl = ldl;
		this.triglycerides = triglycerides;
		this.crp = crp;
		this.smoker = smoker;
		this.diabetic = diabetic;
		if(gender.toLowerCase().equals("male")){
			this.male = true;
		} else {this.male = false;}
	}
	
	public int getAge() { return this.age; }
	public String getName() { return this.name; }
	public String getRace() { return this.race; }
	public int getWeight() { return this.weight; }
	public int getRiskLevel() {return this.riskLevel; }
	public int getHeight() { return this.height; }
	public int getBp() { return this.bp; }
	public int getTotalCholesterol() { return this.totalCholesterol; }
	public int getHdl() { return this.hdl; }
	public int getLdl() { return this.ldl; }
	public int getTriglycerides() { return this.triglycerides; }
	public int getCrp() { return this.crp; }
	public int getBnp() { return this.bnp; }
	public boolean isSmoker() { return this.smoker; }
	public boolean isDiabetic() { return this.diabetic; }
	public boolean isMale() { return this.male; }
	public void setBp(int bp) { this.bp = bp; }
	public void setTotalCholesterol(int tc) { this.totalCholesterol = tc; }
	public void setHdl(int hdl) { this.hdl = hdl; }
	public void setLdl(int ldl) { this.ldl = ldl; }
	public void setTriglycerides(int tris) { this.triglycerides = tris; }
	public void setCrp(int crp) { this.crp = crp; }
	public void setBnp(int bnp) { this.bnp = bnp; }
	public void setRiskLevel(int risk) { 
		if(risk > this.riskLevel){
			this.riskLevel = risk; 
		}
	}
	public void setDiabetic( boolean diabetic ) { this.diabetic = diabetic; }
	public void setSmoker( boolean smoker ) { this.smoker = smoker; }
	
	public double getRisk() {
		double risk;
		if (this.totalCholesterol == 0){
			return 0;
		}
		if( this.male ){
			risk = this.predictMaleRisk();
		} else {
			risk = this.predictFemaleRisk();
		}
		return risk;
	}
	
	private double predictMaleRisk() {
		//calcultes athersclerotic cardiovascular disease risk based on https://www.ahajournals.org/doi/pdf/10.1161/01.cir.0000437741.48606.98
		double maleRisk;
		int smoker =  this.smoker ? 1 : 0 ;
		int diabetes = this.diabetic ? 1 : 0;
		maleRisk = ( 12.344 * this.ln(this.age) )
				+ ( 11.854 * this.ln(this.totalCholesterol) )
				+ ( -2.664 * this.ln(this.age) * this.ln(this.totalCholesterol) )
				+ ( -7.99 * this.ln(this.hdl) )
				+ ( 1.769 * this.ln(this.age) * this.ln(this.hdl) )
				+ ( 1.764 * this.ln(this.bp) ) //assumes untreated systolic blood pressure
				+ ( 7.837 * smoker )
				+ ( -1.795 * this.ln(this.age) * smoker )
				+ (.685 * diabetes );
		maleRisk = 1 - Math.pow(.9144, maleRisk - 61.18);
		System.out.println(100*maleRisk);
		return 100*maleRisk;
	}
	
	private double predictFemaleRisk() {
		//calcultes athersclerotic cardiovascular disease risk based on https://www.ahajournals.org/doi/pdf/10.1161/01.cir.0000437741.48606.98
		double femaleRisk;
		int smoker =  this.smoker ? 1 : 0 ;
		int diabetes = this.diabetic ? 1 : 0;
		femaleRisk = -29.799 * ln(this.age)
				+ 4.884 * this.ln(this.age*this.age)
				+ 13.54 * this.ln(this.totalCholesterol)
				+ -3.114 * this.ln(this.age) * this.ln(this.totalCholesterol)
				+ -13.578 * this.ln(this.hdl)
				+ 3.149 * this.ln(this.age) * this.ln(this.hdl)
				+ 1.957 * this.ln(this.bp)
				+ 7.574 * smoker
				+ -1.665 * this.ln(this.age) * smoker
				+ .661 * diabetes;
		return 100*femaleRisk;
	}
	
	private double ln(int value){
		//helper function to ignore null values in the risk formula
		if(value <= 0){
			return 0;
		} else {
			return Math.log( (double)value );
		}
	}

}


