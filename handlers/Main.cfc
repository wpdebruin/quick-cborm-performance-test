component extends="coldbox.system.EventHandler" {

	property name="qb" inject="provider:QueryBuilder@qb";
	property name="countryService" inject="entityService:country";
	property name="cityService" inject="entityService:city";
	property name="debugsettings" inject="coldbox:modulesettings:cbdebugger";
	/**
	 * Default Action
	 */
	function index( event, rc, prc ) {
		param rc.max=7;

/*		var start = gettickcount();
		getInstance("qCountry").with("cities.shops.employees").where( "id", "<=", rc.max ).get().each( (qCountry)=>{
			writeOutput( "A COUNTRIES: " & qCountry.getName() & "<br>" )
			countryCounter +=1;
			qCountry.getCities().each( (qCity )=>{
				cityCounter +=1;
				qCity.getShops().each( (qShop)=>{
					shopCounter +=1;
					qShop.getEmployees().each( (qEmployee)=>{
						employeeCounter +=1;
						dummy=qEmployee.getName();
					})
				})
			} )
		} );
		writedump("countryCounter #countryCounter#");
		writedump("cityCounter #cityCounter#");
		writedump("shopCounter #shopCounter#");
		writedump("employeeCounter #employeeCounter#");
		var TotalCount = countryCounter+cityCounter+shopCounter+employeeCounter;
		writedump( "totalcounter #TotalCount#")
		writedump("TIME quick #gettickcount()-start#");

		var start = gettickcount();
		var tempArr = [];
		for (var i=1; i <= TotalCount ;i=i+1) {
			tempArr.append(new models.tempModel());
		}
		tempArr.each( (item)=>{
			var dummpy = item.getId();
		});
		writedump("generation of #totalcount# simple objects #gettickcount()-start#");

		var start = gettickcount();
//		var city = cityService.get(1);
//		writedump(city);
//		abort;
		var countryCounter=0;
		var cityCounter=0;
		var shopCounter=0;
		var employeeCounter=0;
		countryService.list( max=rc.max, asQuery=false ).each( (hCountry)=>{
			countryCounter +=1;
			writeOutput( "COUNTRIES: " & hCountry.getName() & "<br>" )
			for ( var hCity in  hCountry.getCities() ){
				cityCounter +=1;
				hCity.getShops().each( (hShop)=>{
					shopCounter +=1;
					hShop.getEmployees().each( ( hEmployee )=> {
						employeeCounter +=1;
						dummy = hEmployee.getName();
					})
				} )
			}
		} );
		writedump("countryCounter #countryCounter#");
		writedump("cityCounter #cityCounter#");
		writedump("shopCounter #shopCounter#");
		writedump("employeeCounter #employeeCounter#");
		var TotalCount = countryCounter+cityCounter+shopCounter+employeeCounter;
		writedump( "totalcounter #TotalCount#")
		writedump("TIME CBORM #gettickcount()-start#");
		event.setView( view="main/index", noLayout=true );
***/
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
