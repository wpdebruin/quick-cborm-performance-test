component accessors="true" {

	property name="id";
	property name="name";
	property name="country_fk";

	function init(){
		variables.id = createUUID();
		//artificial delay
		sleep(1);
		return this;
	}

	function getName(){
		return "something again";
	}
	function stores(){
		return "something"
	}
}
