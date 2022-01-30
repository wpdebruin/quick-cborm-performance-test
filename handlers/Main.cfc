component extends="coldbox.system.EventHandler" {

	property name="qb" inject="provider:QueryBuilder@qb";
	property name="countryService" inject="entityService:country";
	property name="cityService" inject="entityService:city";
	property name="debugsettings" inject="coldbox:modulesettings:cbdebugger";
	/**
	 * Default Action
	 */
	function index( event, rc, prc ) {
	}

	function basicTest( event, rc, prc ){
		timeIt("quick entity: getInstance('qCountry')", () => getInstance("qCountry"),20 );
		timeIt("quick entity: getInstance('qCountry').find(1)", () => getInstance("qCountry").find(1),20 );
		timeIt("cborm: countryService.get(1)", () => countryService.get(1) );
		timeIt("simple model: new models.tempModel()", () => new models.tempModel() ,20 );
		timeIt("wirebox simple model: getInstance('tempModel')", () => getInstance("tempModel") );
	}

	function invokeTest( event, rc, prc ){
		var qCountry=countryService.get(1);
		timeIt("normal invocation", () => qCountry.getName() ,100 );
		timeIt("invoke (qCountry, 'getName')", () => invoke(qCountry, "getName") ,100 );
		timeIt("evaluate ( 'qCountry.getName()' )", () => evaluate( "qCountry.getName()" ) ,100 );
		timeIt("qCountry['getName']()", () => qCountry['getName']() ,100 );
	}
	function someObjects( event, rc, prc ){
		var max=7; // there are 30 countries, 300 cities, 600 shops and 2400 employees
		// use only 7 countries here
		timeit("cborm 7 countries with nested objects", ()=>{
			countryService.list( max=max, asQuery=false ).each( (hCountry)=>{
				for ( var hCity in  hCountry.getCities() ){
					hCity.getShops().each( (hShop)=>{
						hShop.getEmployees().each( ( hEmployee )=> {
							dummy = hEmployee.getName();
						})
					} )
				}
			} );
		},1)
		timeIt("qb 7 countries with nested objects", () => {
			var countries =getInstance("qCountry").with("cities.shops.employees").where( "id", "<=", max ).get();
			countries.each( (qCountry)=>{
				qCountry.getCities().each( (qCity )=>{
					qCity.getShops().each( (qShop)=>{
						qShop.getEmployees().each( (qEmployee)=>{
							dummy=qEmployee.getName();
						})
					})
				} )
			} );
		},1 );
		timeIt("qb 7 countries WITHOUT eager loading nested objects", () => {
			var countries =getInstance("qCountry").where( "id", "<=", max ).get();
			countries.each( (qCountry)=>{
				qCountry.getCities().each( (qCity )=>{
					qCity.getShops().each( (qShop)=>{
						qShop.getEmployees().each( (qEmployee)=>{
							dummy=qEmployee.getName();
						})
					})
				} )
			} );
		},1 );


	}

	function manyObjects( event, rc, prc ){
		var max=30; // there are 30 countries, 300 cities, 600 shops and 2400 employees
		timeit("cborm 24 nested employees", ()=>{
			countryService.list( max=max, asQuery=false ).each( (hCountry)=>{
				for ( var hCity in  hCountry.getCities() ){
					hCity.getShops().each( (hShop)=>{
						hShop.getEmployees().each( ( hEmployee )=> {
							dummy = hEmployee.getName();
						})
					} )
				}
			} );
		})

		timeIt("qb 2400 nested employees", () => {
			var countries =getInstance("qCountry").with("cities.shops.employees").where( "id", "<=", max ).get();
			countries.each( (qCountry)=>{
				qCountry.getCities().each( (qCity )=>{
					qCity.getShops().each( (qShop)=>{
						qShop.getEmployees().each( (qEmployee)=>{
							dummy=qEmployee.getName();
						})
					})
				} )
			} );
		},1 );

	}

	function objectsVsRetrieveQuery(event, rc, prc){
		param rc.max=300;
		timeit("ORM list of 300 cities", ()=> {
			hCities =cityService.list( max=rc.max, asQuery=false );
		},1);
		timeit("ORM list of 300 cities, no filter", ()=> {
			hCities =cityService.list( asQuery=false );
		},1);
		timeit("dump 1 hCity", ()=> {
			writedump(var=hcities[1], expand=false);
		},1);
		timeit("Quick list of 300 cities", ()=> {
			oCities =getInstance("qCity").where("id","<=",rc.max).get()
		},1);
		timeit("Quick list of 300 cities, no filter", ()=> {
			oCities =getInstance("qCity").get()
		},1);
		timeit("dump 1 oCity", ()=> {
			writedump(var=oCities[1], expand=false);
		},1);
		timeit("quick list of 300 cities, retrievequery", ()=> {
			cities =getInstance("qCity").retrieveQuery().get()
		},1);
		timeit("dump 1 city struct", ()=> {
			writedump( var=cities[1], expand=false);
		},1);
		timeit( "creating 300 objects with 1ms delay", ()=> {
			var myArr={};
			for (var i=1; i<=300; i++){
				var city= new models.tempModel()
				city.setId(1);
				city.setName("notSoRandomstring");
				myArr.append(city);
			}
		},1);
		timeit( "creating 300 EMPTY objects with 1ms delay", ()=> {
			var myArr={};
			for (var i=1; i<=300; i++){
				var city= new models.tempModel()
				myArr.append(city);
			}
		},1);
		event.noRender()
	}

	/**
	 * Relocation example
	 */
	function doSomething( event, rc, prc ) {
		relocate( "main.index" );
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit( event, rc, prc ) {
	}

	function onRequestStart( event, rc, prc ) {
	}

	function onRequestEnd( event, rc, prc ) {
	}

	function onSessionStart( event, rc, prc ) {
	}

	function onSessionEnd( event, rc, prc ) {
		var sessionScope     = event.getValue( "sessionReference" );
		var applicationScope = event.getValue( "applicationReference" );
	}

	function onException( event, rc, prc ) {
		event.setHTTPHeader( statusCode = 500 );
		// Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		// Place exception handler below:
	}

}
