public class Record {
	private String description;

	public Record(String description){
		this.description = description.toLowerCase();
	}
	
	public String getDescription(){ return this.description; }
	public void setDescription( String newDescription ) { this.description = newDescription.toLowerCase(); }
}
