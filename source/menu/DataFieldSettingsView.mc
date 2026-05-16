import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

var gExitedMenu as Boolean = false;

//! Initial view for the settings
class DataFieldSettingsView extends WatchUi.View {
  //! Constructor
  public function initialize() {
    View.initialize();
  }

  //! Update the view
  //! @param dc Device context
  public function onUpdate(dc as Dc) as Void {
    dc.clearClip();
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    var mySettings = System.getDeviceSettings();
    var version = mySettings.monkeyVersion;
    var versionString = Lang.format("$1$.$2$.$3$", version);

    dc.drawText(
      dc.getWidth() / 2,
      dc.getHeight() / 2 - 30,
      Graphics.FONT_SMALL,
      "Press Menu \nfor settings \nCIQ " + versionString,
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }
}

//! Handle opening the settings menu
class DataFieldSettingsDelegate extends WatchUi.BehaviorDelegate {
  //! Constructor
  public function initialize() {
    BehaviorDelegate.initialize();
  }

  //! Handle the menu event
  //! @return true if handled, false otherwise
  public function onMenu() as Boolean {
    var menu = new $.DataFieldSettingsMenu();
    var value;

    var mi = new WatchUi.MenuItem("Reset options", null, "resetOptions", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Track recording", null, "trackRecording", null);
    value =
      getStorageValue(mi.getId() as String, TrackRecAlways) as
      EnumTrackRecording;
    mi.setSubLabel($.getTrackRecordingAsString(value));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Tire recording", null, "tireRecording", null);
    value =
      getStorageValue(mi.getId() as String, TireRecProfile) as
      EnumTireRecording;
    mi.setSubLabel($.getTireRecordingAsString(value));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Chain recording", null, "chainRecording", null);
    value =
      getStorageValue(mi.getId() as String, ChainRecAsTire) as
      EnumChainRecording;
    mi.setSubLabel($.getChainRecordingAsString(value));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Distance", null, "menuDistance", null);
    mi.setSubLabel("Manage distance settings");
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Large field", null, "show_large_field", null);
    menu.addItem(mi);
    mi = new WatchUi.MenuItem("Wide field", null, "show_wide_field", null);
    menu.addItem(mi);
    mi = new WatchUi.MenuItem("Small field", null, "show_small_field", null);
    menu.addItem(mi);

    var customCounters =
      $.getStorageValue("feat_customCounters", false) as Boolean;
    menu.addItem(
      new WatchUi.ToggleMenuItem(
        "Custom counters",
        null,
        "feat_customCounters",
        customCounters,
        null
      )
    );

    if (customCounters) {
      var custId = $.getProfileId();
      mi = new WatchUi.MenuItem(
        "Custom alert 1",
        null,
        "customAlert1Units" + custId,
        null
      );
      value =
        getStorageValue(mi.getId() as String, CustomAlertDisabled) as
        EnumCustomAlertUnits;
      mi.setSubLabel($.getEnumUnitAsString(value));
      menu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Custom alert 2",
        null,
        "customAlert2Units" + custId,
        null
      );
      value =
        getStorageValue(mi.getId() as String, CustomAlertDisabled) as
        EnumCustomAlertUnits;
      mi.setSubLabel($.getEnumUnitAsString(value));
      menu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Custom alerts",
        null,
        "menuCustomAlerts",
        null
      );
      mi.setSubLabel("Manage custom alerts");
      menu.addItem(mi);
    }

    WatchUi.pushView(
      menu,
      new $.DataFieldSettingsMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
    return true;
  }

  public function onBack() as Boolean {
    $.gExitedMenu = true;
    getApp().onSettingsChanged();
    getApp().triggerResetsTotal();
    return false;
  }
}

// Globals
//Always in km
function getDistanceMenuSubLabel(key as Application.PropertyKeyType) as String {
  return (
    ((getStorageValue(key, 0.0f) as Float) / 1000.0).format("%.2f") + " km"
  );
}
// Always in minutes
function getDurationMenuSubLabel(key as Application.PropertyKeyType) as String {
  return (
    ((getStorageValue(key, 0.0f) as Float) / 1000.0 / 60.0).format("%.2f") +
    " min"
  );
}

function getSecondsMenuSubLabel(key as Application.PropertyKeyType) as String {
  return (
    ((getStorageValue(key, 0) as Number)).format("%.0d") +
    " sec"
  );
}

function getFocusAsString(value as EnumFocus) as String {
  switch (value) {
    case FocusNothing:
      return "Nothing";
    case FocusOdo:
      return "Odo";
    case FocusYear:
      return "Year";
    case FocusMonth:
      return "Month";
    case FocusWeek:
      return "Week";
    case FocusRide:
      return "Ride";
    case FocusFront:
      return "Front";
    case FocusBack:
      return "Back";
    case FocusCourse:
      return "Course";
    case FocusTrack:
      return "Track";
    case FocusChain:
      return "Chain";
    case FocusCustom1:
      return "Custom 1";
    case FocusCustom2:
      return "Custom 2";
    default:
      return "Nothing";
  }
}

function getTrackRecordingAsString(value as EnumTrackRecording) as String {
  switch (value) {
    case TrackRecDisabled:
      return "Disabled";
    case TrackRecAlways:
      return "Always";
    case TrackRecWhenFocus:
      return "When focused";
    case TrackRecWhenVisible:
      return "When visible";
    default:
      return "Disabled";
  }
}

function getTireRecordingAsString(value as EnumTireRecording) as String {
  switch (value) {
    // case TireRecDefault:
    //   return "default";
    case TireRecProfile:
      return $.getProfileName("profile");
    case TireRecSetA:
      return "tire A";
    case TireRecSetB:
      return "tire B";
    case TireRecSetC:
      return "tire C";
    case TireRecSetD:
      return "tire D";
    default:
      return $.getProfileName("profile");
  }
}

function getChainRecordingAsString(value as EnumChainRecording) as String {
  switch (value) {
    // case ChainRecDefault:
    //   return "default";
    case ChainRecProfile:
      return $.getProfileName("profile");
    case ChainRecAsTire:
      return "as tire";
    case ChainRecSetA:
      return "chain A";
    case ChainRecSetB:
      return "chain B";
    case ChainRecSetC:
      return "chain C";
    case ChainRecSetD:
      return "chain D";
    default:
      return $.getProfileName("profile");
  }
}

function getEnumUnitAsString(value as EnumCustomAlertUnits) as String {
  switch (value) {
    case CustomAlertDisabled:
      return "disabled";
    case CustomAlertDistance:
      return "distance";
    case CustomAlertTimer:
      return "timer (skip paused)";
    case CustomAlertElapsed:
      return "elapsed (total activity)";
    default:
      return "disabled";
  }
}
