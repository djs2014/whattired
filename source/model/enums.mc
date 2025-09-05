import Toybox.Lang;
import Toybox.System;

enum EnumFocus {
  FocusNothing = 0,
  FocusOdo = 1,
  FocusYear = 2,
  FocusMonth = 3,
  FocusWeek = 4,
  FocusRide = 5,
  FocusFront = 6,
  FocusBack = 7,
  FocusCourse = 8,
  FocusTrack = 9,
}

enum EnumTrackRecording {
  TrackRecDisabled = 0,
  TrackRecAlways = 1,
  TrackRecWhenVisible = 2,
  TrackRecWhenFocus = 3,
}

enum EnumTireRecording {
  // TireRecDefault = 0,
  TireRecProfile = 0,
  TireRecSetA = 1,
  TireRecSetB = 2,
  TireRecSetC = 3,
  TireRecSetD = 4,
}

enum EnumChainRecording {
  // ChainRecDefault = 0,
  ChainRecProfile = 0,
  ChainRecAsTire = 1,
  ChainRecSetA = 2,
  ChainRecSetB = 3,
  ChainRecSetC = 4,
  ChainRecSetD = 5,
}
