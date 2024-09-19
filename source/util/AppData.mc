using Toybox.Application as App;
using Toybox.System as Sys;

//! App Data is an abstraction to retrieve properties and storage values
//! for devices with CIQ version >= 2.4
module AppData {

    function readStorageValue(propertyName) {
        return App.Storage.getValue(propertyName);
    }

    function saveStorageValue(propertyName, propertyValue) {
        App.Storage.setValue(propertyName, propertyValue);
    }

    function deleteStorageValue(propertyName) {
        App.Storage.deleteValue(propertyName);
    }

    function readProperty(propertyName) {
        try {
            return App.Properties.getValue(propertyName);
        } catch (ex instanceof App.Properties.InvalidKeyException) {
            // different behaviour on device and simulator:
            // previously stored empty value (OtpDataProvider:89) for given property works correctly on a simulator
            // but deletes the property on a device, thus the exception is thrown
            return null;
        }
    }

    function saveProperty(propertyName, propertyValue) {
        try {
            App.Properties.setValue(propertyName, propertyValue);
        } catch (ex instanceof App.Properties.InvalidKeyException) {
            // if the exception is throw then properties don't have that key
            // return false as indicator the property was not saved
        }
    }
}