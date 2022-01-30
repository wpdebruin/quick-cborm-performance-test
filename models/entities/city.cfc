/**
 * A cool country entity
 */
component persistent="true" table="cities"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";

	// Properties
	property name="name";
	property name="shops" fieldtype="one-to-many" cfc="shop" fkcolumn="city_id" type="array";


	// Validation
	this.constraints = {
		// Example: age = { required=true, min="18", type="numeric" }
	};

	// Mementifier
	this.memento = {
	};

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}
}

