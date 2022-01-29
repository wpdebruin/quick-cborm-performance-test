component table="employees" extends="quick.models.BaseEntity" accessors="true" {

	property name="id";
	property name="name";
	property name="shop_id";

	//function employees(){
	//	return hasMany("qEmployee", "employee_fk");
	//}
}
