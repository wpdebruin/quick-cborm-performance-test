component table="countries" extends="quick.models.BaseEntity" accessors="true" {

	property name="id";
	property name="name";

	function cities(){
		return hasMany("qCity", "country_id");
	}
}
