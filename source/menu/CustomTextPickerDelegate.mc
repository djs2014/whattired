import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;

class CustomTextPickerDelegate extends WatchUi.TextPickerDelegate {
  hidden var _storageKey as Lang.String;
  hidden var _item as MenuItem;
  function initialize(item as MenuItem, storageKey as Lang.String) {
    TextPickerDelegate.initialize();
    _storageKey = storageKey;
    _item = item;
  }

  function onTextEntered(
    text as Lang.String,
    changed as Lang.Boolean
  ) as Lang.Boolean {    
    // System.println([text, changed]);
    // Set max length to 10 characters
    if (text.length() > 10) {
      text = text.substring(0, 10);
    }

    $.StorageSetValue(_storageKey, text);
    // Update menu item sublabel to show the new text
    (_item as MenuItem).setSubLabel(text);
    return true;
  }

  function onCancel() as Lang.Boolean {    
    return true;
  }
}
