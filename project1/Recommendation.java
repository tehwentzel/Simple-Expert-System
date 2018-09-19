public class Recommendation {
	private final String description;
	private final int code;
	private boolean active;
	
	public static final int CHOLESTEROL_SCREENING = 1;
	public static final int LOW_INTENSITY_STATIN = 2;
	public static final int MEDIUM_INTENSITY_STATIN = 3;
	public static final int HIGH_INTENSITY_STATIN = 4;
	public static final int FIBRATE = 5;
	public static final int PRESCRIPTION = 6;
	public static final int CRP_TEST = 7;
	public static final int DIAGNOSIS = 8;
	public static final int LIFESTYLE_CHANGES = 9;
	public static final int MISC_FURTHER_EVALUATION = 10;
	public static final int OTHER = 0;

	public Recommendation(String description, int code){
		this.description = description;
		this.code = code;
		this.active = true;
		//System.out.println(this.description);
	}
	
	public String getDescription(){ return this.description; }
	public int getCode() { return this.code; }
	public boolean isActive() {return this.active; }
	public void setActive( boolean isActive ) { this.active = isActive; }
}