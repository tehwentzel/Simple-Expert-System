public class Condition {
	
	public static final int CARDIOVASCULAR_CONDITION = 1;
	public static final int STATIN_INTERACTION = 2;
	public static final int IMPAIRED_KINDEY_OR_LIVER = 3;
	public static final int MUSCLE_DISORDER = 4;
	public static final int HIV = 5;
	public static final int PRE_HYPERTENSION = 6;
	public static final int HYPERTENSION = 7;
	
	private String description;
	private int code;

	public Condition(){
		return;
	}
	
	public Condition(String description, int code){
		this.description = description.toLowerCase();
		this.code = code;
	}
	
	public String getDescription(){ return this.description; }
	public void setDescription( String newDescription ) { this.description = newDescription.toLowerCase(); }
	
	public int getCode() { return this.code; }
	public void setCode (int newCode) { this.code = newCode; }
}
