import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

var gShowCurrentProfile as Boolean = false;
var gTrackRecording as EnumTrackRecording = TrackRecAlways;
var gTireRecording as EnumTireRecording = TireRecProfile;
var gChainRecording as EnumChainRecording = ChainRecAsTire;
var gActivityProfileId as String = "";
var gActivityProfileName as String = "";

var gTireRecPostfix as String = "-";
var gChainRecPostfix as String = "-";
var gCustomProfileId as String = "-";

class whattiredApp extends Application.AppBase {
  var mTotals as Totals = new Totals();

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {}

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {}

  //! Return the initial view of your application here
  function getInitialView() as [WatchUi.Views] or
    [WatchUi.Views, WatchUi.InputDelegates] {
    loadUserSettings();
    return [new whattiredView()];
  }

  //! Return the settings view and delegate for the app
  //! @return Array Pair [View, Delegate]
  public function getSettingsView() as [WatchUi.Views] or
    [WatchUi.Views, WatchUi.InputDelegates] or
    Null {
    return [new $.DataFieldSettingsView(), new $.DataFieldSettingsDelegate()];
  }

  function onSettingsChanged() {
    loadUserSettings();
  }

  function triggerResetsTotal() as Void {
    mTotals.triggerResetsTotal();
  }

  (:typecheck(disableBackgroundCheck))
  function loadUserSettings() as Void {
    try {
      System.println("Load usersettings");

      var version = $.getStorageValue("version", "") as String;
      if (!version.equals("1.10.1")) {
        $.StorageSetValue("version", "1.10.1");
        // Remove first enum entry
        var tr = $.getStorageValue("tireRecording", 0) as Number;
        if (tr > 0) {
          tr = tr - 1;
          $.StorageSetValue("tireRecording", tr);
        }
        var cr = $.getStorageValue("chainRecording", 0) as Number;
        if (cr > 0) {
          cr = cr - 1;
          $.StorageSetValue("chainRecording", cr);
        }
      }
      var conversion = Storage.getValue("show_small_field");
      if (conversion == null) {
        conversionToArrays();
      }
      // TODO
      // var reset = getStorageValue("reset", false) as Boolean;

      $.gTireRecording =
        $.getStorageValue("tireRecording", TireRecProfile) as EnumTireRecording;
      $.gChainRecording =
        $.getStorageValue("chainRecording", ChainRecAsTire) as
        EnumChainRecording;

      // Custom alerts per profile
      var custId = $.getProfileId();
      var customCountersEnabled = $.loadCustomCountersProfileId(custId);

      $.gShow_LargeField =
        $.getStorageValue(
          "show_large_field",
          $.gShow_LargeField as Array<Application.PropertyValueType>
        ) as Array<Number>;
      $.gShow_WideField =
        $.getStorageValue(
          "show_wide_field",
          $.gShow_WideField as Array<Application.PropertyValueType>
        ) as Array<Number>;
      $.gShow_SmallField =
        $.getStorageValue(
          "show_small_field",
          $.gShow_SmallField as Array<Application.PropertyValueType>
        ) as Array<Number>;

      $.gTrackRecording =
        $.getStorageValue("trackRecording", gTrackRecording) as
        EnumTrackRecording;

      // Determine if track recording should be active based on settings
      var hasAnyFieldShowTrack =
        $.gShow_LargeField[6] == true ||
        $.gShow_WideField[6] == true ||
        $.gShow_SmallField[6] == true;
      var hasAnyFieldFocusTrack =
        $.gShow_LargeField[0] == FocusTrack ||
        $.gShow_WideField[0] == FocusTrack ||
        $.gShow_SmallField[0] == FocusTrack;
      var trackRecordingActive =
        $.gTrackRecording == TrackRecAlways ||
        ($.gTrackRecording == TrackRecWhenVisible and hasAnyFieldShowTrack) ||
        ($.gTrackRecording == TrackRecWhenFocus and hasAnyFieldFocusTrack);

      mTotals.SetTrackRecordingEnabled(trackRecordingActive);
      mTotals.SetCustomCountersEnabled(customCountersEnabled);
      mTotals.setResetLoopCustom1($.gCustomAlert1ResetSec > -1);
      mTotals.setResetLoopCustom2($.gCustomAlert2ResetSec > -1);
      mTotals.load(true);

      System.println("loadUserSettings loaded");
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  hidden function conversionToArrays() {
    // Remove not used fields
    Storage.deleteValue("showFocusSmallField");
    Storage.deleteValue("showColors");
    Storage.deleteValue("showValues");
    Storage.deleteValue("showLastDistance");
    Storage.deleteValue("showColorsSmallField");
    Storage.deleteValue("showDateNumbers");
    Storage.deleteValue("showOdo");
    Storage.deleteValue("showYear");
    Storage.deleteValue("showMonth");
    Storage.deleteValue("showWeek");
    Storage.deleteValue("showRide");
    Storage.deleteValue("showTrack");
    Storage.deleteValue("showFront");
    Storage.deleteValue("showBack");
    Storage.deleteValue("showChain");

    $.StorageSetValue("show_large_field", [
      -1, // focus
      true, // odo
      true, // year
      true, // month
      true, // week
      true, // ride
      false, // track
      false, // trackAscDesc
      true, // front
      true, // back
      true, // chain
      true, // custom1
      true, // custom2
      true, // colors
      true, // values
      true, // previous values
      true, // date numbers
    ]);
    $.StorageSetValue("show_wide_field", [
      FocusRide, // focus
      true, // odo
      false, // year
      false, // month
      false, // week
      false, // ride
      false, // track
      false, // trackAscDesc
      false, // front
      false, // back
      false, // chain
      true, // custom1
      true, // custom2
      true, //colors
      true, // values
      false, // previous values
      false, // date numbers
    ]);
    $.StorageSetValue("show_small_field", [
      FocusRide, // focus
      false, // odo
      false, // year
      true, // month
      true, // week
      true, // ride
      false, // track
      false, // trackAscDesc
      false, //front
      false, //back
      false, //chain
      false, // custom1
      false, // custom2
      true, //colors
      false, // values
      false, // previous values
      false, // date numbers
    ]);
  }
}

function getApp() as whattiredApp {
  return Application.getApp() as whattiredApp;
}

var gSizeArrShowOptions as Number = 17;
var gShow_LargeField as Array<Number> = [] as Array<Number>;
var gShow_WideField as Array<Number> = [] as Array<Number>;
var gShow_SmallField as Array<Number> = [] as Array<Number>;

var gCustomAlert1Units as EnumCustomAlertUnits = CustomAlertDisabled;
var gCustomAlert2Units as EnumCustomAlertUnits = CustomAlertDisabled;
var gCustomAlert1Label as String = "Cust1";
var gCustomAlert2Label as String = "Cust2";
var gCustomAlert1ResetSec as Number = -1;
var gCustomAlert2ResetSec as Number = -1;
var gCustomAlert1Alert as Boolean = false;
var gCustomAlert2Alert as Boolean = false;
var gCustomAlert1AlertHandled as Boolean = false;
var gCustomAlert2AlertHandled as Boolean = false;

function loadCustomCountersProfileId(pid as String) as Boolean {
  // Feature switch
  var enabled = $.getStorageValue("feat_customCounters", false) as Boolean;
  if (!enabled) {
    $.gCustomAlert1Units = CustomAlertDisabled;
    $.gCustomAlert2Units = CustomAlertDisabled;
    return false;
  }

  enabled = false;
  $.gCustomAlert1Label = "Cust1";
  $.gCustomAlert1Units =
    $.getStorageValue("customAlert1Units" + pid, $.gCustomAlert1Units) as
    EnumCustomAlertUnits;

  if ($.gCustomAlert1Units != CustomAlertDisabled) {
    enabled = true;
    $.gCustomAlert1Label = maxChars(
      $.getStorageValue("text_customAlertLabel1" + pid, $.gCustomAlert1Label) as
        String,
      10
    );
    $.gCustomAlert1ResetSec =
      $.getStorageValue("autoResetCustom1" + pid, $.gCustomAlert1ResetSec) as
      Number;
    $.gCustomAlert1Alert =
      $.getStorageValue("alertCustom1" + pid, $.gCustomAlert1Alert) as Boolean;
  }

  $.gCustomAlert2Label = "Cust2";
  $.gCustomAlert2Units =
    $.getStorageValue("customAlert2Units" + pid, $.gCustomAlert2Units) as
    EnumCustomAlertUnits;
  if ($.gCustomAlert2Units != CustomAlertDisabled) {
    enabled = true;
    $.gCustomAlert2Label = maxChars(
      $.getStorageValue("text_customAlertLabel2" + pid, $.gCustomAlert2Label) as
        String,
      10
    );

    $.gCustomAlert2ResetSec =
      $.getStorageValue("autoResetCustom2" + pid, $.gCustomAlert2ResetSec) as
      Number;
    $.gCustomAlert2Alert =
      $.getStorageValue("alertCustom2" + pid, $.gCustomAlert2Alert) as Boolean;
  }

  return enabled;
}
