using Toybox.Application as App;


class PowerPacerApp extends App.AppBase {

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
