component table="shops" extends="quick.models.BaseEntity" accessors="true" {

	property name="id";
	property name="name";
	property name="city_id";

	function employees(){
		return hasMany("qEmployee", "shop_id");
	}
}
