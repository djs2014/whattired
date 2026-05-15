import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;

class CustomTextPickerDelegate extends WatchUi.TextPickerDelegate {
  hidden var _storageKey as Lang.String;

  function initialize(storageKey as Lang.String) {
    TextPickerDelegate.initialize();
    _storageKey = storageKey;
  }

  function onTextEntered(
    text as Lang.String,
    changed as Lang.Boolean
  ) as Lang.Boolean {
    
    System.println([text, changed]);
    // screenMessage = text + "\n" + "Changed: " + changed;
    // customText_lastText = text;
    Toybox.Application.Storage.setValue(_storageKey, text);
    return true;
  }

  function onCancel() as Lang.Boolean {
    // screenMessage = "Canceled";
    // CustomText_canceled = true;
    return true;
  }
}
