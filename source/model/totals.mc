import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.System;
import Toybox.Activity;
import Toybox.Math;
import Toybox.StringUtil;
import Toybox.Attention;

class Totals {
  private var elapsedDistanceActivity as Float = 0.0f;
  private var elapsedAscentActivity as Number = 0;
  private var elapsedDescentActivity as Number = 0;
  private var debugElapsedDistance as Float = 0.0f;
  // is the time the timer has been actively running (not paused) in millisec
  private var timerTimeActivity as Number = 0;
  // total time of activity inclusive paused in millisec
  private var elapsedTimeActivity as Number = 0;

  // odo
  private var totalDistance as Float = 0.0f;
  private var maxDistance as Float = 0.0f;

  private var lastYear as Number = 0;
  private var totalDistanceLastYear as Float = 0.0f;
  private var currentYear as Number = 0;
  private var totalDistanceYear as Float = 0.0f;

  private var totalDistanceLastMonth as Float = 0.0f;
  private var currentMonth as Number = 0;
  private var totalDistanceMonth as Float = 0.0f;

  private var currentWeek as Number = 0;
  private var totalDistanceLastWeek as Float = 0.0f;
  private var totalDistanceWeek as Float = 0.0f;

  private var trackRecordingEnabled as Boolean = false;
  private var totalDistanceLastTrack as Float = 0.0f;
  private var totalDistanceTrack as Float = 0.0f;
  private var totalAscentLastTrack as Number = 0;
  private var totalAscentTrack as Number = 0;
  private var totalDescentLastTrack as Number = 0;
  private var totalDescentTrack as Number = 0;

  private var totalDistanceLastRide as Float = 0.0f;
  private var totalDistanceRide as Float = 0.0f;
  private var startDistanceCourse as Float = 0.0f;
  private var totalDistanceToDestination as Float = 0.0f;

  private var rideStarted as Boolean = false;
  private var rideTimerState as Number = Activity.TIMER_STATE_OFF;

  private var totalDistanceFrontTyre as Float = 0.0f;
  private var maxDistanceFrontTyre as Float = 0.0f;
  private var totalDistanceBackTyre as Float = 0.0f;
  private var maxDistanceBackTyre as Float = 0.0f;
  private var totalDistanceChain as Float = 0.0f;
  private var maxDistanceChain as Float = 0.0f;

  // TODO track distance / duration for example:  per profile
  // when to charge DI2 / PowerMeter
  // TODO custom label?
  private var customCountersEnabled as Boolean = false;
  private var totalDistanceCustom1 as Float = 0.0f; // elapseddistance
  private var totalTimerTimeCustom1 as Number = 0; // timertime // msec
  private var totalElapsedTimeCustom1 as Number = 0; // elapsedtime // msec
  private var maxDistanceCustom1 as Float = 0.0f;
  private var maxDurationCustom1 as Number = 0; // msec
  private var hasResetLoopCustom1 as Boolean = false;

  private var totalDistanceCustom2 as Float = 0.0f;
  private var totalTimerTimeCustom2 as Number = 0;
  private var totalElapsedTimeCustom2 as Number = 0;
  private var maxDistanceCustom2 as Float = 0.0f;
  private var maxDurationCustom2 as Number = 0;
  private var hasResetLoopCustom2 as Boolean = false;

  private var currentProfileId as String? = null;

  public function SetTrackRecordingEnabled(enabled as Boolean) as Void {
    trackRecordingEnabled = enabled;
  }
  public function SetCustomCountersEnabled(enabled as Boolean) as Void {
    customCountersEnabled = enabled;
  }
  hidden function GetElapsedDistance() as Float {
    return elapsedDistanceActivity + debugElapsedDistance;
  }

  //
  hidden function GetTimerTime() as Number {
    return timerTimeActivity;
  }
  hidden function GetElapsedTime() as Number {
    return elapsedTimeActivity;
  }

  public function GetTotalDistance() as Float {
    return totalDistance + GetElapsedDistance();
  }
  public function GetMaxDistance() as Float {
    return maxDistance;
  }
  public function GetTotalDistanceYear() as Float {
    return totalDistanceYear + GetElapsedDistance();
  }
  public function GetTotalDistanceMonth() as Float {
    return totalDistanceMonth + GetElapsedDistance();
  }
  public function GetTotalDistanceWeek() as Float {
    return totalDistanceWeek + GetElapsedDistance();
  }
  public function GetTotalDistanceTrack() as Float {
    if (trackRecordingEnabled) {
      return totalDistanceTrack + GetElapsedDistance();
    } else {
      return totalDistanceTrack;
    }
  }
  public function GetTotalAscentTrack() as Number {
    if (trackRecordingEnabled) {
      return totalAscentTrack + elapsedAscentActivity;
    } else {
      return totalAscentTrack;
    }
  }
  public function GetTotalDescentTrack() as Number {
    if (trackRecordingEnabled) {
      return totalDescentTrack + elapsedDescentActivity;
    } else {
      return totalDescentTrack;
    }
  }

  public function GetTotalDistanceRide() as Float {
    if (rideTimerState == Activity.TIMER_STATE_OFF) {
      return totalDistanceRide;
    }
    return GetElapsedDistance();
  }
  public function GetTotalDistanceLastYear() as Float {
    return totalDistanceLastYear;
  }
  public function GetTotalDistanceLastMonth() as Float {
    return totalDistanceLastMonth;
  }
  public function GetTotalDistanceLastWeek() as Float {
    return totalDistanceLastWeek;
  }
  public function GetTotalDistanceLastTrack() as Float {
    return totalDistanceLastTrack;
  }
  public function GetTotalAscentLastTrack() as Number {
    return totalAscentLastTrack;
  }
  public function GetTotalDescentLastTrack() as Number {
    return totalDescentLastTrack;
  }

  public function GetTotalDistanceLastRide() as Float {
    return totalDistanceLastRide;
  }
  public function GetElapsedDistanceToDestination() as Float {
    return GetElapsedDistance() - startDistanceCourse;
  }
  public function GetDistanceToDestination() as Float {
    return totalDistanceToDestination;
  }
  public function IsCourseActive() as Boolean {
    System.println("totalDistanceToDestination:");
    System.println(totalDistanceToDestination / 1000.0);
    System.println("GetElapsedDistanceToDestination()");
    System.println(GetElapsedDistanceToDestination() / 1000.0);
    System.println("startDistanceCourse()");
    System.println(startDistanceCourse / 1000.0);
    System.println("elapsedDistanceActivity");
    System.println(GetElapsedDistance() / 1000.0);

    return totalDistanceToDestination > 0;
  }

  public function IsActivityStopped() as Boolean {
    return rideTimerState == Activity.TIMER_STATE_STOPPED;
  }

  public function GetTotalDistanceFrontTyre() as Float {
    return totalDistanceFrontTyre + GetElapsedDistance();
  }
  public function GetMaxDistanceFrontTyre() as Float {
    return maxDistanceFrontTyre;
  }
  public function GetTotalDistanceBackTyre() as Float {
    return totalDistanceBackTyre + GetElapsedDistance();
  }
  public function GetMaxDistanceBackTyre() as Float {
    return maxDistanceBackTyre;
  }
  public function GetTotalDistanceChain() as Float {
    return totalDistanceChain + GetElapsedDistance();
  }
  public function GetMaxDistanceChain() as Float {
    return maxDistanceChain;
  }

  public function GetTotalDistanceCustom1() as Float {
    // if (hasResetLoopCustom1) {
    //   return $.fmod(
    //     totalDistanceCustom1 + GetElapsedDistance(),
    //     maxDistanceCustom1
    //   );
    // }
    return totalDistanceCustom1 + GetElapsedDistance();
  }
  public function GetTotalTimerTimeCustom1() as Number {
    // if (hasResetLoopCustom1) {
    //   return $.fmod(
    //     totalTimerTimeCustom1 + GetTimerTime(),
    //     maxDurationCustom1
    //   ).toNumber();
    // }
    return totalTimerTimeCustom1 + GetTimerTime();
  }
  public function GetTotalElapsedTimeCustom1() as Number {
    // if (hasResetLoopCustom1) {
    //   return $.fmod(
    //     totalElapsedTimeCustom1 + GetElapsedTime(),
    //     maxDurationCustom1
    //   ).toNumber();
    // }
    return totalElapsedTimeCustom1 + GetElapsedTime();
  }
  public function GetMaxDistanceCustom1() as Float {
    return maxDistanceCustom1;
  }
  public function GetMaxDurationCustom1() as Number {
    return maxDurationCustom1;
  }

  public function GetTotalDistanceCustom2() as Float {
    if (hasResetLoopCustom2) {
      return $.fmod(
        totalDistanceCustom2 + GetElapsedDistance(),
        maxDistanceCustom2
      );
    }
    return totalDistanceCustom2 + GetElapsedDistance();
  }
  public function GetTotalTimerTimeCustom2() as Number {
    if (hasResetLoopCustom2) {
      return $.fmod(
        totalTimerTimeCustom2 + GetTimerTime(),
        maxDurationCustom2
      ).toNumber();
    }
    return totalTimerTimeCustom2 + GetTimerTime();
  }
  public function GetTotalElapsedTimeCustom2() as Number {
    if (hasResetLoopCustom2) {
      return $.fmod(
        totalElapsedTimeCustom2 + GetElapsedTime(),
        maxDurationCustom2
      ).toNumber();
    }
    return totalElapsedTimeCustom2 + GetElapsedTime();
  }
  public function GetMaxDistanceCustom2() as Float {
    return maxDistanceCustom2;
  }
  public function GetMaxDurationCustom2() as Number {
    return maxDurationCustom2;
  }

  public function GetCurrentWeek() as Number {
    return currentWeek;
  }
  public function GetCurrentMonth() as Number {
    return currentMonth;
  }
  public function GetCurrentYear() as Number {
    return currentYear;
  }

  function initialize() {}

  function getCurrentProfile() as String? {
    var info = Activity.getProfileInfo();
    if (info == null) {
      return null;
    }
    var arr = info.uniqueIdentifier;
    if (arr == null) {
      return null;
    }
    return arr.toString();
  }

  function compute(info as Activity.Info) as Void {
    // TODO: if switch profile -> load totals but do not save!
    if (currentProfileId == null) {
      currentProfileId = getCurrentProfile();
    } else {
      var profileId = getCurrentProfile();
      if (profileId != null) {
        if (!profileId.equals(currentProfileId)) {
          System.println("ProfileSwitch");
          currentProfileId = profileId;
          // Profile switch, load totals
          loadTireDistance(true);
          loadChainDistance(true);
          loadCustom(true);
        }
      }
    }

    if (info has :elapsedDistance) {
      if (info.elapsedDistance != null) {
        elapsedDistanceActivity = info.elapsedDistance as Float;
      } else {
        elapsedDistanceActivity = 0.0f;
      }
    }

    if (info has :totalAscent) {
      if (info.totalAscent != null) {
        elapsedAscentActivity = info.totalAscent as Number;
      } else {
        elapsedAscentActivity = 0;
      }
    }
    if (info has :totalDescent) {
      if (info.totalDescent != null) {
        elapsedDescentActivity = info.totalDescent as Number;
      } else {
        elapsedDescentActivity = 0;
      }
    }
    if (info has :timerTime) {
      if (info.timerTime != null) {
        timerTimeActivity = info.timerTime as Number;
      } else {
        timerTimeActivity = 0;
      }
    }
    if (info has :elapsedTime) {
      if (info.elapsedTime != null) {
        elapsedTimeActivity = info.elapsedTime as Number;
      } else {
        elapsedTimeActivity = 0;
      }
    }

    if (info has :timerState) {
      if (info.timerState != null) {
        rideTimerState = info.timerState as Number;
        if (
          rideTimerState == Activity.TIMER_STATE_STOPPED or
          rideTimerState == Activity.TIMER_STATE_OFF
        ) {
          rideStarted = false;
        }
        if (!rideStarted && rideTimerState == Activity.TIMER_STATE_ON) {
          handleRide();
        }
      }
    }

    totalDistanceToDestination = 0.0f;
    if (info has :distanceToDestination) {
      if (info.distanceToDestination != null) {
        totalDistanceToDestination = info.distanceToDestination as Float;
      }
    }
    // Remember the distance, when course is started
    if (totalDistanceToDestination == 0.0f) {
      startDistanceCourse = 0.0f;
    } else if (startDistanceCourse == 0.0f) {
      startDistanceCourse = GetElapsedDistance();
    }
    processCustomCounters();
    // debugCustom1();
  }

  function processCustomCounters() as Void {
    if (!customCountersEnabled) {
      return;
    }
    if (
      hasResetLoopCustom1 &&
      totalDistanceCustom1 + GetElapsedDistance() > maxDistanceCustom1
    ) {
      totalDistanceCustom1 = totalDistanceCustom1 - maxDistanceCustom1;
    }
    if (
      hasResetLoopCustom1 &&
      totalTimerTimeCustom1 + GetTimerTime() > maxDurationCustom1
    ) {
      totalTimerTimeCustom1 = totalTimerTimeCustom1 - maxDurationCustom1;
    }
    if (
      hasResetLoopCustom1 &&
      totalElapsedTimeCustom1 + GetElapsedTime() > maxDurationCustom1
    ) {
      totalElapsedTimeCustom1 = totalElapsedTimeCustom1 - maxDurationCustom1;
    }
  }
  function save(loadValues as Boolean) as Void {
    try {
      setDistanceAsMeters(
        "totalDistance",
        totalDistance + GetElapsedDistance()
      );

      saveYear();
      saveMonth();
      saveWeek();

      loadTireDistance(false);
      var trp = $.getTireRecPostfix();
      setDistanceAsMeters(
        "totalDistanceFrontTyre" + trp,
        totalDistanceFrontTyre + GetElapsedDistance()
      );
      setDistanceAsMeters(
        "totalDistanceBackTyre" + trp,
        totalDistanceBackTyre + GetElapsedDistance()
      );

      loadChainDistance(false);
      var cr = $.getChainRecPostfix();
      setDistanceAsMeters(
        "totalDistanceChain" + cr,
        totalDistanceChain + GetElapsedDistance()
      );

      saveTrack();
      saveCustom();
      loadCustom(false);

      saveRide();
      if (debugElapsedDistance > 0) {
        debugElapsedDistance = 0.0f;
        setDistanceAsMeters("debugElapsedDistance", debugElapsedDistance);
        System.println("debugElapsedDistance reset to 0");
      }
      System.println("save completed");

      if (loadValues) {
        load(false);
      }

      System.println(
        Lang.format(
          "save: rideStarted [$1$] ride [$2$] last ride [$3$] loadValues[$4$]",
          [rideStarted, GetElapsedDistance(), totalDistanceLastRide, loadValues]
        )
      );
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  function saveYear() as Void {
    $.StorageSetValue("lastYear", lastYear);
    setDistanceAsMeters("totalDistanceLastYear", totalDistanceLastYear);

    $.StorageSetValue("currentYear", currentYear);
    setDistanceAsMeters(
      "totalDistanceYear",
      totalDistanceYear + GetElapsedDistance()
    );
  }
  function saveMonth() as Void {
    $.StorageSetValue("currentMonth", currentMonth);
    setDistanceAsMeters("totalDistanceLastMonth", totalDistanceLastMonth);
    setDistanceAsMeters(
      "totalDistanceMonth",
      totalDistanceMonth + GetElapsedDistance()
    );
  }
  function saveWeek() as Void {
    $.StorageSetValue("currentWeek", currentWeek);
    setDistanceAsMeters("totalDistanceLastWeek", totalDistanceLastWeek);
    setDistanceAsMeters(
      "totalDistanceWeek",
      totalDistanceWeek + GetElapsedDistance()
    );
  }
  function saveRide() as Void {
    // if (totalDistanceLastRide > 500.0) {
    //   setDistanceAsMeters("totalDistanceLastRide", totalDistanceLastRide);
    // }
    setDistanceAsMeters("totalDistanceRide", GetElapsedDistance());
    totalDistanceRide = GetElapsedDistance();
  }

  function saveTrack() as Void {
    if (!trackRecordingEnabled) {
      return;
    }
    setDistanceAsMeters("totalDistanceLastTrack", totalDistanceLastTrack);
    setDistanceAsMeters(
      "totalDistanceTrack",
      totalDistanceTrack + GetElapsedDistance()
    );

    $.StorageSetValue("totalAscentLastTrack", totalAscentLastTrack);
    $.StorageSetValue(
      "totalAscentTrack",
      totalAscentTrack + elapsedAscentActivity
    );
    $.StorageSetValue("totalDescentLastTrack", totalDescentLastTrack);
    $.StorageSetValue(
      "totalDescentTrack",
      totalDescentTrack + elapsedDescentActivity
    );
  }

  function saveCustom() as Void {
    if (!customCountersEnabled) {
      return;
    }

    var pid = $.getProfileId();
    setDistanceAsMeters(
      "totalDistanceCustom1" + pid,
      GetTotalDistanceCustom1()
    );

    setDurationAsMillisec(
      "totalTimerTimeCustom1" + pid,
      GetTotalTimerTimeCustom1()
    );

    setDurationAsMillisec(
      "totalElapsedTimeCustom1" + pid,
      GetTotalElapsedTimeCustom1()
    );

    setDistanceAsMeters(
      "totalDistanceCustom2" + pid,
      GetTotalDistanceCustom2()
    );

    setDurationAsMillisec(
      "totalTimerTimeCustom2" + pid,
      GetTotalTimerTimeCustom2()
    );

    setDurationAsMillisec(
      "totalElapsedTimeCustom2" + pid,
      GetTotalElapsedTimeCustom2()
    );
  }

  // Storage values are in meters, (overrule) properties are in kilometers!
  // Save will happen during pause / stop switch to connect iq widget
  // so load values and correct with elapsed distance.
  function load(processDate as Boolean) as Void {
    totalDistance = getDistanceAsMeters("totalDistance");
    maxDistance = getDistanceAsMeters("maxDistance");

    lastYear = $.getStorageValue("lastYear", 0) as Number;
    totalDistanceLastYear = getDistanceAsMeters("totalDistanceLastYear");
    currentYear = $.getStorageValue("currentYear", 0) as Number;
    totalDistanceYear = getDistanceAsMeters("totalDistanceYear");

    currentMonth = $.getStorageValue("currentMonth", 0) as Number;
    totalDistanceLastMonth = getDistanceAsMeters("totalDistanceLastMonth");
    totalDistanceMonth = getDistanceAsMeters("totalDistanceMonth");

    currentWeek = $.getStorageValue("currentWeek", 0) as Number;
    totalDistanceLastWeek = getDistanceAsMeters("totalDistanceLastWeek");
    totalDistanceWeek = getDistanceAsMeters("totalDistanceWeek");

    totalDistanceLastTrack = getDistanceAsMeters("totalDistanceLastTrack");
    totalDistanceTrack = getDistanceAsMeters("totalDistanceTrack");

    totalAscentLastTrack =
      $.getStorageValue("totalAscentLastTrack", 0) as Number;
    totalAscentTrack = $.getStorageValue("totalAscentTrack", 0) as Number;
    totalDescentLastTrack =
      $.getStorageValue("totalDescentLastTrack", 0) as Number;
    totalDescentTrack = $.getStorageValue("totalDescentTrack", 0) as Number;

    totalDistanceLastRide = getDistanceAsMeters("totalDistanceLastRide");
    totalDistanceRide = getDistanceAsMeters("totalDistanceRide");
    debugElapsedDistance = getDistanceAsMeters("debugElapsedDistance");

    System.println(
      Lang.format("load: rideStarted [$1$] ride [$2$] last ride [$3$] ", [
        rideStarted,
        totalDistanceRide,
        totalDistanceLastRide,
      ])
    );

    if (processDate) {
      handleDate();
    }

    // @@ TODO
    // Add prefix , if switch tirerec then load the last values
    // onCompute -> detect profile switch?
    $.gTireRecPostfix = "";
    loadTireDistance(true);
    $.gChainRecPostfix = "";
    loadChainDistance(true);
    $.gCustomProfileId = "";
    loadCustom(true);
  }

  function loadTireDistance(force as Boolean) as Void {
    var trp = $.getTireRecPostfix();
    if (!force and trp.equals($.gTireRecPostfix)) {
      System.println("Tire distance already loaded for: " + $.gTireRecPostfix);
      return;
    }
    // @@ TODO test when connect IQ app started during activity -> save current tr in storage?
    $.gTireRecPostfix = trp;
    totalDistanceFrontTyre = getDistanceAsMeters(
      "totalDistanceFrontTyre" + trp
    );
    maxDistanceFrontTyre = getDistanceAsMeters("maxDistanceFrontTyre" + trp);
    if (maxDistanceFrontTyre == 0.0f) {
      maxDistanceFrontTyre = 5000000.0f;
      setDistanceAsMeters("maxDistanceFrontTyre" + trp, maxDistanceFrontTyre);
    }
    totalDistanceBackTyre = getDistanceAsMeters("totalDistanceBackTyre" + trp);
    maxDistanceBackTyre = getDistanceAsMeters("maxDistanceBackTyre" + trp);
    if (maxDistanceBackTyre == 0.0f) {
      maxDistanceBackTyre = 5000000.0f;
      setDistanceAsMeters("maxDistanceBackTyre" + trp, maxDistanceBackTyre);
    }

    System.println("Tire distance loaded for: " + $.gTireRecPostfix);
  }

  function loadChainDistance(force as Boolean) as Void {
    var cr = $.getChainRecPostfix();
    if (!force and cr.equals($.gChainRecPostfix)) {
      System.println(
        "Chain distance already loaded for: " + $.gChainRecPostfix
      );
      return;
    }
    $.gChainRecPostfix = cr;
    totalDistanceChain = getDistanceAsMeters("totalDistanceChain" + cr);
    maxDistanceChain = getDistanceAsMeters("maxDistanceChain" + cr);
    if (maxDistanceChain == 0.0f) {
      maxDistanceChain = 5000000.0f;
      setDistanceAsMeters("maxDistanceChain" + cr, maxDistanceChain);
    }
    System.println("Chain distance loaded for: " + $.gChainRecPostfix);
  }

  function loadCustom(force as Boolean) as Void {
    if (!customCountersEnabled) {
      return;
    }

    var pid = $.getProfileId();
    if (!force and pid.equals($.gCustomProfileId)) {
      System.println("Custom data already loaded for: " + $.gCustomProfileId);
      return;
    }

    $.gCustomProfileId = pid;

    totalDistanceCustom1 = getDistanceAsMeters("totalDistanceCustom1" + pid);

    totalTimerTimeCustom1 = getDurationAsMillisec(
      "totalTimerTimeCustom1" + pid
    );
    totalElapsedTimeCustom1 = getDurationAsMillisec(
      "totalElapsedTimeCustom1" + pid
    );
    maxDistanceCustom1 = getDistanceAsMeters("maxDistanceCustom1" + pid);
    maxDurationCustom1 = getDurationAsMillisec("maxDurationCustom1" + pid);

    totalDistanceCustom2 = getDistanceAsMeters("totalDistanceCustom2" + pid);
    totalTimerTimeCustom2 = getDurationAsMillisec(
      "totalTimerTimeCustom2" + pid
    );
    totalElapsedTimeCustom2 = getDurationAsMillisec(
      "totalElapsedTimeCustom2" + pid
    );

    maxDistanceCustom2 = getDistanceAsMeters("maxDistanceCustom2" + pid);
    maxDurationCustom2 = getDurationAsMillisec("maxDurationCustom2" + pid);
  }

  function triggerResetsTotal() as Void {
    var trp = $.getTireRecPostfix();
    var switchFB = $.getStorageValue("switch_front_back", false) as Boolean;

    totalDistanceFrontTyre = getDistanceAsMeters(
      "totalDistanceFrontTyre" + trp
    );
    maxDistanceFrontTyre = getDistanceAsMeters("maxDistanceFrontTyre" + trp);
    totalDistanceBackTyre = getDistanceAsMeters("totalDistanceBackTyre" + trp);
    maxDistanceBackTyre = getDistanceAsMeters("maxDistanceBackTyre" + trp);
    maxDistanceChain = getDistanceAsMeters("maxDistanceChain" + trp);

    var reset = $.getStorageValue("reset_front", false) as Boolean;
    if (reset) {
      totalDistanceFrontTyre = 0.0f;
      $.StorageSetValue("reset_front", false);
      if (!switchFB) {
        setDistanceAsMeters(
          "totalDistanceFrontTyre" + trp,
          totalDistanceFrontTyre
        );
      }
    }

    reset = $.getStorageValue("reset_back", false) as Boolean;
    if (reset) {
      totalDistanceBackTyre = 0.0f;
      $.StorageSetValue("reset_back", false);
      if (!switchFB) {
        setDistanceAsMeters(
          "totalDistanceBackTyre" + trp,
          totalDistanceFrontTyre
        );
      }
    }

    if (switchFB) {
      $.StorageSetValue("switch_front_back", false);
      var tmpBack = totalDistanceBackTyre;
      totalDistanceBackTyre = totalDistanceFrontTyre;
      totalDistanceFrontTyre = tmpBack;
      setDistanceAsMeters(
        "totalDistanceFrontTyre" + trp,
        totalDistanceFrontTyre
      );
      setDistanceAsMeters("totalDistanceBackTyre" + trp, totalDistanceBackTyre);
    }

    var cr = $.getChainRecPostfix();
    reset = $.getStorageValue("reset_chain", false) as Boolean;
    if (reset) {
      totalDistanceChain = 0.0f;
      setDistanceAsMeters("totalDistanceChain" + cr, totalDistanceChain);
      $.StorageSetValue("reset_chain", false);
    }

    reset = $.getStorageValue("reset_track", false) as Boolean;
    if (reset) {
      if (totalDistanceTrack > 0.0f) {
        totalDistanceLastTrack = totalDistanceTrack;
        totalAscentLastTrack = totalAscentTrack;
        totalDescentLastTrack = totalDescentTrack;
      }
      totalDistanceTrack = 0.0f;
      totalAscentTrack = 0;
      totalDescentTrack = 0;
      saveTrack();
      $.StorageSetValue("reset_track", false);
    }

    reset = $.getStorageValue("reset_custom1", false) as Boolean;
    if (reset) {
      totalDistanceCustom1 = 0.0f;
      totalTimerTimeCustom1 = 0;
      totalElapsedTimeCustom1 = 0;
      saveCustom();
      $.StorageSetValue("reset_custom1", false);
    }

    reset = $.getStorageValue("reset_custom2", false) as Boolean;
    if (reset) {
      totalDistanceCustom2 = 0.0f;
      totalTimerTimeCustom2 = 0;
      totalElapsedTimeCustom2 = 0;
      saveCustom();
      $.StorageSetValue("reset_custom2", false);
    }
  }

  function setResetLoopCustom1(enabled as Boolean) as Void {
    hasResetLoopCustom1 = enabled;
  }
  function setResetLoopCustom2(enabled as Boolean) as Void {
    hasResetLoopCustom2 = enabled;
  }

  hidden function setDistanceAsMeters(
    key as String,
    distanceMeters as Float
  ) as Void {
    try {
      $.StorageSetValue(key, distanceMeters);
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  hidden function getDistanceAsMeters(key as String) as Float {
    try {
      return $.getStorageValue(key, 0.0f) as Float;
    } catch (ex) {
      ex.printStackTrace();
      return 0.0f;
    }
  }

  hidden function setDurationAsMillisec(
    key as String,
    durationMillisec as Number
  ) as Void {
    try {
      //var minutes = durationMillisec / factorMSecToSec;
      $.StorageSetValue(key, durationMillisec);
    } catch (ex) {
      ex.printStackTrace();
    }
  }
  hidden function getDurationAsMillisec(key as String) as Number {
    try {
      return $.getStorageValue(key, 0) as Number;
    } catch (ex) {
      ex.printStackTrace();
      return 0;
    }
  }

  hidden function handleDate() as Void {
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

    if (currentYear == 0) {
      totalDistanceYear = 0.0f;
      currentYear = today.year;

      currentMonth = today.month as Number;
      totalDistanceLastMonth = 0.0f;
      totalDistanceMonth = 0.0f;

      currentWeek = iso_week_number(
        today.year,
        today.month as Number,
        today.day
      );
      totalDistanceLastWeek = 0.0f;
      totalDistanceWeek = 0.0f;

      totalDistanceLastTrack = 0.0f;
      totalDistanceTrack = 0.0f;

      totalDistanceLastRide = 0.0f;
      totalDistanceRide = 0.0f;

      save(true);
    }

    // year change
    if (currentYear != today.year) {
      totalDistanceLastYear = totalDistanceYear;
      lastYear = currentYear;

      totalDistanceYear = 0.0f;
      currentYear = today.year;
      saveYear();
    }

    // month change
    var month = today.month as Number;
    if (currentMonth != month) {
      currentMonth = month;
      totalDistanceLastMonth = totalDistanceMonth;
      totalDistanceMonth = 0.0f;
      saveMonth();
    }
    // week change
    var week = iso_week_number(today.year, today.month as Number, today.day);
    if (currentWeek != week) {
      currentWeek = week;
      totalDistanceLastWeek = totalDistanceWeek;
      totalDistanceWeek = 0.0f;
      saveWeek();
    }
  }

  hidden function handleRide() as Void {
    // ride started - via activity?
    // if (rideTimerState == Activity.TIMER_STATE_OFF and totalDistanceRide > 0) {
    //   if (totalDistanceRide > 500.0) {
    //     totalDistanceLastRide = totalDistanceRide;
    //   }
    //   totalDistanceRide = 0.0f; // same as elapseddistance
    //   System.println(
    //     Lang.format("handledate: rideStarted [$1$] ride [$2$] last ride [$3$] ", [
    //       rideStarted,
    //       totalDistanceRide,
    //       totalDistanceLastRide,
    //     ])
    //   );
    //   saveRide();
    // } else
    if (!rideStarted && rideTimerState == Activity.TIMER_STATE_ON) {
      // Only valid rides.. totalDistanceRide is current saved ride after activity

      if (totalDistanceRide > 500.0) {
        totalDistanceLastRide = totalDistanceRide;
        setDistanceAsMeters("totalDistanceLastRide", totalDistanceLastRide);
      }

      debugElapsedDistance = 0.0f;
      setDistanceAsMeters("debugElapsedDistance", debugElapsedDistance);

      totalDistanceRide = 0.0f; // same as elapseddistance
      rideStarted = true;
      System.println(
        Lang.format(
          "handleRide: rideStarted [$1$] ride [$2$] last ride [$3$] ",
          [rideStarted, totalDistanceRide, totalDistanceLastRide]
        )
      );
      saveRide();
    }
  }

  // hidden function setProperty(key as PropertyKeyType, value as PropertyValueType) as Void {
  //   Application.Properties.setValue(key, value);
  // }

  function debugCustom1() as Void {
    var timerString = $.secondsToHourMinutesSeconds(
      totalTimerTimeCustom1 / 1000
    );
    var elapsedString = $.secondsToHourMinutesSeconds(
      totalElapsedTimeCustom1 / 1000
    );

    var maxDurationString = $.secondsToHourMinutesSeconds(
      maxDurationCustom1 / 1000
    );

    System.println(
      Lang.format(
        "cust1: totalDist [$1$] reset [$2$] maxDist [$3$] maxDur [$4$] timer [$5$] elapsed [$6$] maxDur [$7$]",
        [
          totalDistanceCustom1,
          hasResetLoopCustom1,
          maxDistanceCustom1,
          maxDurationCustom1,
          timerString,
          elapsedString,
          maxDurationString,
        ]
      )
    );
  }
}

class Total {
  public var title as String = "";
  public var abbreviated as String = "";
  public var distance as Float = 0.0f;
  public var distanceLast as Float = 0.0f;
}

function getTireRecPostfix() as String {
  switch ($.gTireRecording) {
    // case TireRecDefault:
    //   return "";
    case TireRecProfile:
      // var info = Activity.getProfileInfo();
      // if (info == null) {
      //   return $.gActivityProfileId;
      // }
      // var arr = info.uniqueIdentifier;
      // if (arr == null) {
      //   return $.gActivityProfileId;
      // }
      $.gActivityProfileId = $.getProfileId();
      return $.gActivityProfileId;
    case TireRecSetA:
      return "A";
    case TireRecSetB:
      return "B";
    case TireRecSetC:
      return "C";
    case TireRecSetD:
      return "D";
    default:
  }
  return "";
}

function getChainRecPostfix() as String {
  switch ($.gChainRecording) {
    // case ChainRecDefault:
    //   return "";
    case ChainRecProfile:
      // var info = Activity.getProfileInfo();
      // if (info == null) {
      //   return $.gActivityProfileId;
      // }
      // var arr = info.uniqueIdentifier;
      // if (arr == null) {
      //   return $.gActivityProfileId;
      // }
      $.gActivityProfileId = $.getProfileId();
      return $.gActivityProfileId;
    case ChainRecAsTire:
      return getTireRecPostfix();
    case ChainRecSetA:
      return "A";
    case ChainRecSetB:
      return "B";
    case ChainRecSetC:
      return "C";
    case ChainRecSetD:
      return "D";
  }
  $.gActivityProfileId = $.getProfileId();
  return $.gActivityProfileId;
}

function getProfileName(def as String) as String {
  var info = Activity.getProfileInfo();
  if (info == null) {
    return def;
  }
  if (info.name != null) {
    $.gActivityProfileName = info.name as String;
  }
  if ($.gActivityProfileName.length == 0) {
    return def;
  }
  return $.gActivityProfileName;
}

function getProfileId() as String {
  var info = Activity.getProfileInfo();
  if (info == null) {
    return $.gActivityProfileId;
  }
  var arr = info.uniqueIdentifier;
  if (arr == null) {
    return $.gActivityProfileId;
  }
  return arr.toString();
}
