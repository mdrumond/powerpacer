using Toybox.Application as App;


class PowerPacerApp extends App.AppBase {
    /**
        This is the basic version: will pass config through settings screeen
        Need:
            python script to get paces from gpx. That script will take a gpx map, a time goal, a split value, and a slope effort and spit out
            a total distance and a list of equidistant pace regions (for now use 1km steps).

        Next version:
            python script will be online, this app will access it through some online interface. I will need: the online interface
            and a background service that accesses the online interface when the run begins and stores the total distance/ list of equinditant
            pace regions.
     **/
    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart(state) {
        System.println("onStart() called");
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
        System.println("onStop() called");
    }

    function onSettingsChanged() {
        System.println("onSettingsChanged() called");
    }

    //! Return the initial view of your application here
    function getInitialView() {
        System.println("getInitialView() called");
        return [new PowerPacerView()];
    }

}
