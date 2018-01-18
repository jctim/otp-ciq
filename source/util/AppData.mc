using Toybox.Application as App;
using Toybox.System as Sys;

//! App Data is an abstraction to retrieve settings, properties and storage values
//! for devices with CIQ version before and after 2.4
module AppData {

    function readStorageValue(propertyName) {
        if (App has :Storage && App.Storage has :getValue) {
            return App.Storage.getValue(propertyName);
        } else {
            return App.getApp().getProperty(propertyName);
        }
    }

    function saveStorageValue(propertyName, propertyValue) {
        if (App has :Storage && App.Storage has :setValue) {
            App.Storage.setValue(propertyName, propertyValue);
            return true;
        } else {
            App.getApp().setProperty(propertyName, propertyValue);
            return true;
        }
    }

    function readProperty(propertyName) {
        if (App has :Properties) {
            try {
                return App.Properties.getValue(propertyName);
            } catch (ex instanceof App.Properties.InvalidKeyException) {
                // different behaviour on device and simulator:
                // previously stored empty value (OtpDataProvider:89) for given property works correctly on a simulator
                // but deletes the property on a device, thus the exception is thrown
                return null;
            }
        } else {
            return App.getApp().getProperty(propertyName);
        }
    }

    function saveProperty(propertyName, propertyValue) {
        if (App has :Properties) {
            try {
                App.Properties.setValue(propertyName, propertyValue);
                return true;
            } catch (ex instanceof App.Properties.InvalidKeyException) {
                // if the exception is throw then properties don't have that key
                // return false as indicator the property was not saved
                return false;
            }
        } else {
            App.getApp().setProperty(propertyName, propertyValue);
            return true;
        }
    }
}