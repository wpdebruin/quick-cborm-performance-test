component table="employees" extends="quick.models.BaseEntity" accessors="true" {

	property name="id";
	property name="employeename" column=name;;
	property name="shop_id";
	property name="mail" column="email";

	//function employees(){
	//	return hasMany("qEmployee", "employee_fk");
	//}
}
