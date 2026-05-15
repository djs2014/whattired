import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

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

  function triggerFrontBack() as Void {
    mTotals.triggerFrontBack();
  }

  (:typecheck(disableBackgroundCheck))
  function loadUserSettings() as Void {
    try {
      System.println("Load usersettings");

      var version = getStorageValue("version", "") as String;
      if (!version.equals("1.10.1")) {
        Storage.setValue("version", "1.10.1");
        // Remove first enum entry
        var tr = $.getStorageValue("tireRecording", 0) as Number;
        if (tr > 0) {
          tr = tr - 1;
          Storage.setValue("tireRecording", tr);
        }
        var cr = $.getStorageValue("chainRecording", 0) as Number;
        if (cr > 0) {
          cr = cr - 1;
          Storage.setValue("chainRecording", cr);
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

      $.gCustomAlert1Units =
        $.getStorageValue("customAlert1Units", $.gCustomAlert1Units) as
        EnumCustomAlertUnits;
      $.gCustomAlert2Units =
        $.getStorageValue("customAlert2Units", $.gCustomAlert2Units) as
        EnumCustomAlertUnits;

      $.gCustomCountersEnabled =
        $.gCustomAlert1Units != CustomAlertDisabled ||
        $.gCustomAlert2Units != CustomAlertDisabled;

      if ($.gCustomCountersEnabled) {
        $.gCustomAlert1Label = maxChars(
          $.getStorageValue("text_customAlertLabel1", $.gCustomAlert1Label) as
            String,
          10
        );

        $.gCustomAlert2Label = maxChars(
          $.getStorageValue("text_customAlertLabel2", $.gCustomAlert2Label) as
            String,
          10
        );
      }

      

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
      mTotals.SetCustomCountersEnabled($.gCustomCountersEnabled);
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

    Storage.setValue("show_large_field", [
      -1,
      true,
      true,
      true,
      true,
      true,
      false,
      false,
      true,
      true,
      true,
      false,
      false,
      true,
      true,
      true,
      true,
    ]);
    Storage.setValue("show_wide_field", [
      FocusRide,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      true,
      true,
      true,
      false,
      false,
    ]);
    Storage.setValue("show_small_field", [
      FocusRide,
      false,
      false,
      true,
      true,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      false,
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
var gCustomCountersEnabled as Boolean = false;
var gCustomAlert1Units as EnumCustomAlertUnits = CustomAlertDisabled;
var gCustomAlert2Units as EnumCustomAlertUnits = CustomAlertDisabled;
var gCustomAlert1Label as String = "Cust1";
var gCustomAlert2Label as String = "Cust2";
