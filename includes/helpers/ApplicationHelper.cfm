<!--- All methods in this helper will be available in all handlers,views & layouts --->
<cfscript>
function timeIt( label, func, repetitions = 100 ) {
	var time = 0;
    for ( var i = 1; i <= arguments.repetitions; i++ ) {
        var start = getMilliSecondsCount();
	    func();
        time += getMilliSecondsCount() - start;
    }
    writeDump( var = time / arguments.repetitions, label = arguments.label );
}

function getMilliSecondsCount() {
    param variables.javaSystem = createObject( "java", "java.lang.System" );
    return variables.javaSystem.nanoTime() / 1000000;
}

</cfscript>