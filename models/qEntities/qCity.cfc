component table="cities" extends="quick.models.BaseEntity" accessors="true" {

	property name="id";
	property name="name";
	property name="country_id";

	function shops(){
		return hasMany("qShop", "city_id");
	}
}
