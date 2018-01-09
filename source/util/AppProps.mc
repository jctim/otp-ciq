using Toybox.Application as App;
using Toybox.System as Sys;

module AppProps {

    function readProperty(propertyName) {
        if (App has :Properties) {
            // Sys.println("getting " + propertyName + " via Properties");
            return App.Properties.getValue(propertyName);
        } else {
            // Sys.println("getting " + propertyName + " via AppBase");
            return App.getApp().getProperty(propertyName);
        }
    }

    function saveProperty(propertyName, propertyValue) {
        if (App has :Properties) {
            // Sys.println("setting " + propertyName + " = " + propertyValue + " via Properties");
            return App.Properties.setValue(propertyName, propertyValue);
        } else {
            // Sys.println("setting " + propertyName + " = " + propertyValue + " via AppBase");
            return App.getApp().setProperty(propertyName, propertyValue);
        }
    }
}