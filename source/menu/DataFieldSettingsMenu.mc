import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

//! The settings menu
class DataFieldSettingsMenu extends WatchUi.Menu2 {
  //! Constructor
  public function initialize() {
    Menu2.initialize({ :title => "Settings" });
  }
}

//! Handles menu input and stores the menu data
class DataFieldSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
  // private var _currentMenuItem as MenuItem?;
  // private var _view as DataFieldSettingsView;

  //! Constructor
  public function initialize() {
    Menu2InputDelegate.initialize();
    // _view = view;
  }

  //! Handle a menu item selection
  //! @param menuItem The selected menu item
  public function onSelect(item as MenuItem) as Void {
    // _currentMenuItem = item;
    var id = item.getId();
    if (id instanceof String && id.equals("menuDistance")) {
      var distanceMenu = new WatchUi.Menu2({ :title => "Set distance for" });

      var mi = new WatchUi.MenuItem(
        "Odo |. (km/0.001)",
        null,
        "totalDistance",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Year |. (km/0.001)",
        null,
        "totalDistanceYear",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Month |. (km/0.001)",
        null,
        "totalDistanceMonth",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Week |. (km/0.001)",
        null,
        "totalDistanceWeek",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Track |. (km/0.001)",
        null,
        "totalDistanceTrack",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      var tr =
        $.getStorageValue("tireRecording", TireRecProfile) as EnumTireRecording;
      var labelTireRec = $.getTireRecordingAsString(tr);
      // if (labelTireRec.equals("default")) {
      //   labelTireRec = "";
      // } else {
      labelTireRec = " for " + labelTireRec;
      // }
      var trp = $.getTireRecPostfix();
      mi = new WatchUi.MenuItem(
        "Front " + labelTireRec + " |. (km/0.001)",
        null,
        "totalDistanceFrontTyre" + trp,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Back " + labelTireRec + " |. (km/0.001)",
        null,
        "totalDistanceBackTyre" + trp,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      // TODO labelTireRec -> labelChainRec getChainRecordingAsString
      var cr = $.getChainRecPostfix();
      mi = new WatchUi.MenuItem(
        "Chain " + labelTireRec + " |. (km/0.001)",
        null,
        "totalDistanceChain" + cr,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Max Odo |. (km/0.001)",
        null,
        "maxDistance",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Last year |. (km/0.001)",
        null,
        "totalDistanceLastYear",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Last month |. (km/0.001)",
        null,
        "totalDistanceLastMonth",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Last week |. (km/0.001)",
        null,
        "totalDistanceLastWeek",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Last track |. (km/0.001)",
        null,
        "totalDistanceLastTrack",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Last ride |. (km/0.001)",
        null,
        "totalDistanceLastRide",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Max front " + labelTireRec + " |. (km/0.001)",
        null,
        "maxDistanceFrontTyre" + trp,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Max back " + labelTireRec + " |. (km/0.001)",
        null,
        "maxDistanceBackTyre" + trp,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Max chain " + labelTireRec + " |. (km/0.001)",
        null,
        "maxDistanceChain" + trp,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      // Not needed, is actual activity ride
      mi = new WatchUi.MenuItem(
        "Elapsed (debug) |. (km/0.001)",
        null,
        "debugElapsedDistance",
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      WatchUi.pushView(
        distanceMenu,
        new $.GeneralMenuDelegate(self, distanceMenu),
        WatchUi.SLIDE_UP
      );
      return;
    }

    if (id instanceof String && id.equals("menuCustomAlerts")) {
      var customMenu = new WatchUi.Menu2({ :title => "Set counters for" });
      var custId = $.getProfileId();

      var alert1Units =
        $.getStorageValue("customAlert1Units" + custId, CustomAlertDisabled) as
        EnumCustomAlertUnits;
      var alert2Units =
        $.getStorageValue("customAlert2Units" + custId, CustomAlertDisabled) as
        EnumCustomAlertUnits;

      var mi;
      var label;
      var boolean;

      label = $.getStorageValue("text_customAlertLabel1" + custId, "Cust1");
      mi = new WatchUi.MenuItem(
        "Custom 1",
        null,
        "text_customAlertLabel1" + custId,
        null
      );
      mi.setSubLabel(label);
      customMenu.addItem(mi);

      if (alert1Units == CustomAlertDistance) {
        mi = new WatchUi.MenuItem(
          "Tot distance |. (km/0.001)",
          null,
          "totalDistanceCustom1" + custId,
          null
        );
        mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);

        mi = new WatchUi.MenuItem(
          "Max distance |. (km/0.001)",
          null,
          "maxDistanceCustom1" + custId,
          null
        );
        mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }
      if (alert1Units == CustomAlertTimer) {
        mi = new WatchUi.MenuItem(
          "Tot timer |. (min/0.000016667)", // 1/1000/60
          null,
          "totalTimerTimeCustom1" + custId,
          null
        );
        mi.setSubLabel($.getDurationMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }
      if (alert1Units == CustomAlertElapsed) {
        mi = new WatchUi.MenuItem(
          "Tot elapsed |. (min/0.000016667)", // 1/1000/60
          null,
          "totalElapsedTimeCustom1" + custId,
          null
        );
        mi.setSubLabel($.getDurationMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }
      if (
        alert1Units == CustomAlertTimer ||
        alert1Units == CustomAlertElapsed
      ) {
        mi = new WatchUi.MenuItem(
          "Max duration |. (min/0.000016667)", // 1/1000/60
          null,
          "maxDurationCustom1" + custId,
          null
        );
        mi.setSubLabel($.getDurationMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }

      if (alert1Units != CustomAlertDisabled) {
        mi = new WatchUi.MenuItem(
          "Autoreset |-1~ (sec)",
          null,
          "autoResetCustom1" + custId,
          null
        );
        mi.setSubLabel($.getSecondsMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);

        boolean = $.getStorageValue("alertCustom1" + custId, false) as Boolean;
        customMenu.addItem(
          new WatchUi.ToggleMenuItem(
            "Alert ",
            null,
            "alertCustom1" + custId,
            boolean,
            null
          )
        );
      }

      // 2

      label = $.getStorageValue("text_customAlertLabel2" + custId, "Cust2");
      mi = new WatchUi.MenuItem(
        "Custom 2",
        null,
        "text_customAlertLabel2" + custId,
        null
      );
      mi.setSubLabel(label);
      customMenu.addItem(mi);

      if (alert2Units == CustomAlertDistance) {
        mi = new WatchUi.MenuItem(
          "Tot distance |. (km/0.001)",
          null,
          "totalDistanceCustom2" + custId,
          null
        );
        mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);

        mi = new WatchUi.MenuItem(
          "Max distance |. (km/0.001)",
          null,
          "maxDistanceCustom2" + custId,
          null
        );
        mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }

      if (alert2Units == CustomAlertTimer) {
        mi = new WatchUi.MenuItem(
          "Tot timer |. (min/0.000016667)", // 1/1000/60
          null,
          "totalTimerTimeCustom2" + custId,
          null
        );
        mi.setSubLabel($.getDurationMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }
      if (alert2Units == CustomAlertElapsed) {
        mi = new WatchUi.MenuItem(
          "Tot elapsed |. (min/0.000016667)", // 1/1000/60
          null,
          "totalElapsedTimeCustom2" + custId,
          null
        );
        mi.setSubLabel($.getDurationMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }

      if (
        alert2Units == CustomAlertTimer ||
        alert2Units == CustomAlertElapsed
      ) {
        mi = new WatchUi.MenuItem(
          "Max duration |. (min/0.000016667)", // 1/1000/60
          null,
          "maxDurationCustom2" + custId,
          null
        );
        mi.setSubLabel($.getDurationMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);
      }

if (alert2Units != CustomAlertDisabled) {
        mi = new WatchUi.MenuItem(
          "Autoreset |-1~ (sec)",
          null,
          "autoResetCustom2" + custId,
          null
        );
        mi.setSubLabel($.getSecondsMenuSubLabel(mi.getId() as String));
        customMenu.addItem(mi);

        boolean = $.getStorageValue("alertCustom2" + custId, false) as Boolean;
        customMenu.addItem(
          new WatchUi.ToggleMenuItem(
            "Alert ",
            null,
            "alertCustom2" + custId,
            boolean,
            null
          )
        );
      }

      WatchUi.pushView(
        customMenu,
        new $.GeneralMenuDelegate(self, customMenu),
        WatchUi.SLIDE_UP
      );
      return;
    }

    if (id instanceof String && id.equals("resetOptions")) {
      var resetMenu = new WatchUi.Menu2({ :title => "Reset options" });
      var boolean = $.getStorageValue("reset_front", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Reset front",
          null,
          "reset_front",
          boolean,
          null
        )
      );

      boolean = $.getStorageValue("reset_back", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Reset back",
          null,
          "reset_back",
          boolean,
          null
        )
      );

      boolean = $.getStorageValue("switch_front_back", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Front <-> back",
          null,
          "switch_front_back",
          boolean,
          null
        )
      );

      boolean = $.getStorageValue("reset_chain", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Reset chain",
          null,
          "reset_chain",
          boolean,
          null
        )
      );

      boolean = $.getStorageValue("reset_track", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Reset track",
          null,
          "reset_track",
          boolean,
          null
        )
      );

      boolean = $.getStorageValue("reset_custom1", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Reset custom 1",
          null,
          "reset_custom1",
          boolean,
          null
        )
      );

      boolean = $.getStorageValue("reset_custom2", false) as Boolean;
      resetMenu.addItem(
        new WatchUi.ToggleMenuItem(
          "Reset custom 2",
          null,
          "reset_custom2",
          boolean,
          null
        )
      );

      WatchUi.pushView(
        resetMenu,
        new $.GeneralMenuDelegate(self, resetMenu),
        WatchUi.SLIDE_UP
      );
      return;
    }

    if (id instanceof String && id.equals("trackRecording")) {
      var sp = new selectionMenuPicker("Track recording active", id as String);

      for (var i = 0; i < 4; i++) {
        sp.add($.getTrackRecordingAsString(i as EnumTrackRecording), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && id.equals("tireRecording")) {
      var sp = new selectionMenuPicker("Tire recording f/b", id as String);

      for (var i = 0; i < 5; i++) {
        sp.add($.getTireRecordingAsString(i as EnumTireRecording), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && id.equals("chainRecording")) {
      var sp = new selectionMenuPicker("Chain recording", id as String);

      for (var i = 0; i < 6; i++) {
        sp.add($.getChainRecordingAsString(i as EnumChainRecording), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (
      // Custom Alerts per profile, the profileid is already appended to the menu id!
      id instanceof String &&
      (id.find("customAlert1Units") != null ||
        id.find("customAlert2Units") != null)
    ) {
      var sp = new selectionMenuPicker(item.getLabel(), id as String);

      for (var i = 0; i < 4; i++) {
        sp.add($.getEnumUnitAsString(i as EnumCustomAlertUnits), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (
      id instanceof String &&
      (id.equals("show_large_field") ||
        id.equals("show_wide_field") ||
        id.equals("show_small_field"))
    ) {
      var title = stringReplace(id.toString(), "_", " ");
      var show_menu = new WatchUi.Menu2({ :title => title });

      var storageKey = id.toString();

      var array = $.getStorageValue(storageKey, []) as Array<Number>;
      // Check size
      if (
        ensureArraySize(
          array as Array<Application.PropertyValueType>,
          $.gSizeArrShowOptions,
          -1
        )
      ) {
        $.StorageSetValue(storageKey, array);
      }

      // TODO focus
      var index = 0;
      var mi = new WatchUi.MenuItem(
        "Focus",
        null,
        $.getKeyAndIndex(storageKey, index),
        null
      );
      mi.setSubLabel($.getFocusAsString(array[0] as EnumFocus));
      show_menu.addItem(mi);

      // Toggle items
      index = 1;
      addToggleMenuItem(
        show_menu,
        "Show odo",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 2;
      addToggleMenuItem(
        show_menu,
        "Show year",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 3;
      addToggleMenuItem(
        show_menu,
        "Show month",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 4;
      addToggleMenuItem(
        show_menu,
        "Show week",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 5;
      addToggleMenuItem(
        show_menu,
        "Show ride",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 6;
      addToggleMenuItem(
        show_menu,
        "Show track",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 7;
      addToggleMenuItem(
        show_menu,
        "Show track asc/desc",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 8;
      addToggleMenuItem(
        show_menu,
        "Show front tire",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 9;
      addToggleMenuItem(
        show_menu,
        "Show back tire",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 10;
      addToggleMenuItem(
        show_menu,
        "Show chain",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 11;
      addToggleMenuItem(
        show_menu,
        "Show custom 1",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 12;
      addToggleMenuItem(
        show_menu,
        "Show custom 2",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 13;
      addToggleMenuItem(
        show_menu,
        "Show colors",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 14;
      addToggleMenuItem(
        show_menu,
        "Show values",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 15;
      addToggleMenuItem(
        show_menu,
        "Show previous",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );
      index = 16;
      addToggleMenuItem(
        show_menu,
        "Show date",
        null,
        $.getKeyAndIndex(storageKey, index),
        array[index] == true
      );

      WatchUi.pushView(
        show_menu,
        new $.GeneralMenuDelegate(self, show_menu),
        WatchUi.SLIDE_UP
      );
      return;
    }

    if (id instanceof String && item instanceof ToggleMenuItem) {
      $.StorageSetValue(id as String, item.isEnabled());
      return;
    }
    // if (WatchUi has :TextPicker) {
    //   WatchUi.pushView(
    //     new WatchUi.TextPicker(currentDistanceInKm.format("%d")),
    //     new $.KeyboardListener(_view, self),
    //     WatchUi.SLIDE_DOWN
    //   );
    // }
  }

  function onSelectedSelection(
    storageKey as String,
    value as Application.PropertyValueType
  ) as Void {
    $.StorageSetValue(storageKey, value);
  }

  hidden function addToggleMenuItem(
    menu as WatchUi.Menu2,
    label as String,
    subLabel as String?,
    id as String,
    enabled as Boolean
  ) {
    var tmi = new WatchUi.ToggleMenuItem(label, subLabel, id, enabled, null);
    menu.addItem(tmi);
  }
}

//--
class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _delegate as DataFieldSettingsMenuDelegate;
  hidden var _item as MenuItem?;
  hidden var _debug as Boolean = false;
  hidden var _storageKey as String = "";
  hidden var _arrayIndex as Number = -1;

  function initialize(
    delegate as DataFieldSettingsMenuDelegate,
    menu as WatchUi.Menu2
  ) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  function onSelect(item as MenuItem) as Void {
    _item = item;
    var id = item.getId() as String;

    // Extract selected storage key and index
    _storageKey = stringLeft(id, "|", id);
    var idx = stringRight(id, "|", "").toNumber();
    if (idx == null) {
      _arrayIndex = -1;
    } else {
      _arrayIndex = idx;
    }

    System.println([
      "GeneralMenuDelegate onSelect:",
      id,
      _storageKey,
      _arrayIndex,
    ]);

    if (id instanceof String && item instanceof ToggleMenuItem) {
      $.setStorageValueOrArray(id, item.isEnabled());
      // $.StorageSetValue(id as String, item.isEnabled());
      return;
    }

    if (
      id instanceof String &&
      (id.equals("show_large_field|0") ||
        id.equals("show_wide_field|0") ||
        id.equals("show_small_field|0"))
    ) {
      var sp = new selectionMenuPicker("Show focus on", id as String);

      for (var i = 0; i < $.TotalEnumFocus; i++) {
        var ft = i as EnumFocus;
        if (ft != FocusFront && ft != FocusBack) {
          sp.add($.getFocusAsString(ft), null, i);
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    // Text input: for storage keys starting with `text_`
    if (id instanceof String && id.find("text_") != null) {
      if (WatchUi has :TextPicker) {
        var lastText = $.getStorageValue(id, "");
        System.println([
          "Opening TextPicker storagekey",
          id,
          "lastText",
          lastText,
        ]);
        WatchUi.pushView(
          new WatchUi.TextPicker(lastText),
          new CustomTextPickerDelegate(_item, id),
          WatchUi.SLIDE_DOWN
        );
      }
      return;
    }

    // Numeric input
    var prompt = item.getLabel();
    var value = $.getStorageValue(id as String, 0) as Numeric;
    var view = $.getNumericInputView(prompt, value);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(
      view,
      new $.NumericInputDelegate(view),
      WatchUi.SLIDE_RIGHT
    );
  }

  function onSelectTextinput(value as String, subLabel as String) as Void {
    try {
      if (_item != null) {
        var storageKey = _item.getId() as String;

        $.StorageSetValue(storageKey, value);
        (_item as MenuItem).setSubLabel(subLabel);
      }
    } catch (ex) {
      ex.printStackTrace();
    }
  }
  function onAcceptNumericinput(value as Numeric, subLabel as String) as Void {
    try {
      if (_item != null) {
        var storageKey = _item.getId() as String;

        $.StorageSetValue(storageKey, value);
        (_item as MenuItem).setSubLabel(subLabel);
      }
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  function onNumericinput(
    editData as Array<Char>,
    cursorPos as Number,
    insert as Boolean,
    negative as Boolean,
    opt as NumericOptions
  ) as Void {
    // Hack to refresh screen
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    var view = new $.NumericInputView("", 0);
    view.processOptions(opt);
    view.setEditData(editData, cursorPos, insert, negative);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(
      view,
      new $.NumericInputDelegate(view),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  //! Handle the back key being pressed

  function onBack() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected

  function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  function onSelectedSelection(
    storageKey as String,
    value as Application.PropertyValueType
  ) as Void {
    $.setStorageValueOrArray(storageKey, value);
    //$.StorageSetValue(storageKey, value);
  }
}
