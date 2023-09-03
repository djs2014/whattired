import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Graphics;
import Toybox.Application;

const MILE = 1.609344;
const FEET = 3.281;

var gCreateColors as Boolean = false;
var gUseSetFillStroke as Boolean = false;

function getStorageValue(
  key as Application.PropertyKeyType,
  dflt as Application.PropertyValueType
) as Application.PropertyValueType {
  try {
    var val = Toybox.Application.Storage.getValue(key);
    if (val != null) {
      return val;
    }
  } catch (ex) {
    return dflt;
  }
  return dflt;
}

function getApplicationProperty(
  key as Application.PropertyKeyType,
  dflt as Application.PropertyValueType
) as Application.PropertyValueType {
  try {
    var val = Toybox.Application.Properties.getValue(key);
    if (val != null) {
      return val;
    }
  } catch (e) {
    return dflt;
  }
  return dflt;
}

// Same field in properties and storage
// For booleans, and enums
// function getStorageElseApplicationProperty(
//   key as Application.PropertyKeyType,
//   dflt as Application.PropertyValueType
// ) as Application.PropertyValueType {
//   try {
//     var overrule = getStorageValue(key, null);
//     if (overrule == null) {
//       return getApplicationProperty(key, dflt);
//     }

//     Application.Properties.setValue(key, overrule);
//     Toybox.Application.Storage.deleteValue(key);
//     return overrule;
//   } catch (ex) {
//     ex.printStackTrace();
//     return dflt;
//   }
// }

function percentageOf(value as Numeric?, max as Numeric?) as Numeric {
  if (value == null || max == null) {
    return 0.0f;
  }
  if (max <= 0) {
    return 0.0f;
  }
  return value / (max / 100.0);
}

function drawPercentageLine(
  dc as Dc,
  x as Number,
  y as Number,
  maxwidth as Number,
  percentage as Numeric,
  height as Number,
  color as ColorType
) as Void {
  if (percentage > 100.0) { percentage = 100.0; }
  var wPercentage = (maxwidth / 100.0) * percentage;
  dc.setColor(color, Graphics.COLOR_TRANSPARENT);

  dc.fillRectangle(x, y, wPercentage, height);
  dc.drawPoint(x + maxwidth, y);
}

function drawPercentageCircleTarget(
  dc as Dc,
  x as Number,
  y as Number,
  radius as Number,
  perc as Numeric,
  circleWidth as Number
) as Void {
  dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
  dc.drawCircle(x, y, radius);

  if (perc < 100) {
    setColorByPerc(dc, perc, 0);
    drawPercentageCircle(dc, x, y, radius, perc, circleWidth);
  } else {
    setColorByPerc(dc, 100, 0);
    drawPercentageCircle(dc, x, y, radius, 100, circleWidth);
    setColorByPerc(dc, 100, 15);
    dc.drawCircle(x, y, radius - circleWidth / 2);
  }

  var percRemain = perc - 100;
  var radiusInner = radius - circleWidth - 3;
  while (percRemain > 0 && radiusInner > 0) {
    if (percRemain < 100) {
      setColorByPerc(dc, percRemain, 0);
      drawPercentageCircle(dc, x, y, radiusInner, percRemain, circleWidth);
    } else {
      setColorByPerc(dc, 100, 0);
      drawPercentageCircle(dc, x, y, radiusInner, 100, circleWidth);
      setColorByPerc(dc, 100, 15);
      dc.drawCircle(x, y, radiusInner - circleWidth / 2);
    }

    radiusInner = radiusInner - circleWidth - 3;
    percRemain = percRemain - 100;
  }
}

function drawPercentageCircle(
  dc as Dc,
  x as Number,
  y as Number,
  radius as Number,
  perc as Numeric,
  penWidth as Number
) as Void {
  if (perc == null || perc == 0) {
    return;
  }

  if (perc > 100) {
    perc = 100;
  }
  var degrees = 3.6 * perc;

  var degreeStart = 180; // 180deg == 9 o-clock
  var degreeEnd = degreeStart - degrees; // 90deg == 12 o-clock

  dc.setPenWidth(penWidth);
  dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, degreeStart, degreeEnd);
  dc.setPenWidth(1.0);
}

function meterToFeet(meter as Numeric?) as Float {
  if (meter == null) {
    return 0.0f;
  }
  return (meter * FEET) as Float;
}

function kilometerToMile(km as Numeric?) as Float {
  if (km == null) {
    return 0.0f;
  }
  return (km / MILE) as Float;
}

function getMatchingFont(
  dc as Dc,
  fontList as Array,
  maxwidth as Number,
  text as String,
  startIndex as Number
) as FontType {
  var index = startIndex;
  var font = fontList[index] as FontType;
  var widthValue = dc.getTextWidthInPixels(text, font);

  while (widthValue > maxwidth && index > 0) {
    index = index - 1;
    font = fontList[index] as FontType;
    widthValue = dc.getTextWidthInPixels(text, font);
  }
  // System.println("font index: " + index);
  return font;
}

function setColorByPerc(dc as Dc, perc as Numeric, darker as Number) as Void {
  var color = 0;
  if ($.gCreateColors) {
    color = percentageToColorAlt(perc, 180, $.PERC_COLORS_SCHEME, darker);
  } else {
    color = percentageToColor(perc);
  }
  if ($.gUseSetFillStroke) {
    dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    dc.setFill(color);
    dc.setStroke(color);
  } else {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
  }
}

// [perc, R, G, B]
const PERC_COLORS_SCHEME_100 =
  [
    [0, 255, 255, 255],
    [55, 244, 246, 247], // COLOR_WHITE_4
    [65, 174, 214, 241], // COLOR_WHITE_BLUE_3
    [70, 169, 204, 227], // COLOR_WHITE_DK_BLUE_3
    [75, 163, 228, 215], // COLOR_WHITE_LT_GREEN_3
    [80, 169, 223, 191], // COLOR_WHITE_GREEN_3
    [85, 249, 231, 159], // COLOR_WHITE_YELLOW_3
    [95, 250, 215, 160], // COLOR_WHITE_ORANGE_3
    [100, 255, 0, 0],    
  ] as Array<Array<Number> >;

const PERC_COLORS_SCHEME =
  [
    [0, 255, 255, 255],
    [55, 244, 246, 247], // COLOR_WHITE_4
    [65, 174, 214, 241], // COLOR_WHITE_BLUE_3
    [70, 169, 204, 227], // COLOR_WHITE_DK_BLUE_3
    [75, 163, 228, 215], // COLOR_WHITE_LT_GREEN_3
    [80, 169, 223, 191], // COLOR_WHITE_GREEN_3
    [85, 249, 231, 159], // COLOR_WHITE_YELLOW_3
    [95, 250, 215, 160], // COLOR_WHITE_ORANGE_3
    [100, 250, 229, 211], // COLOR_WHITE_ORANGERED_2
    [105, 245, 203, 167], // COLOR_WHITE_ORANGERED_3
    [115, 237, 187, 153], // COLOR_WHITE_ORANGERED2_3
    [125, 245, 183, 177], // COLOR_WHITE_RED_3
    [135, 230, 176, 170], // COLOR_WHITE_DK_RED_3
    [145, 215, 189, 226], // COLOR_WHITE_PURPLE_3
    [155, 210, 180, 222], // COLOR_WHITE_DK_PURPLE_3
    [165, 187, 143, 206], // COLOR_WHITE_DK_PURPLE_4
    [999, 0, 0, 0], 
  ] as Array<Array<Number> >;

// alpha, 255 is solid, 0 is transparent
function percentageToColorAlt(
  percentage as Numeric?,
  alpha as Number,
  colorScheme as Array<Array<Number> >,
  darker as Number
) as ColorType {
  var pcolor = 0;
  var pColors = colorScheme;
  if (percentage == null || percentage == 0) {
    return Graphics.createColor(alpha, 255, 255, 255);
  }
  // else if (percentage >= 100) {
  //   // final entry
  //   pcolor = pColors[pColors.size() - 1] as Array<Number>;
  //   return Graphics.createColor(alpha, pcolor[1], pcolor[2], pcolor[3]);
  // }

  var i = 1;
  while (i < pColors.size()) {
    pcolor = pColors[i] as Array<Number>;
    if (percentage <= pcolor[0]) {
      break;
    }
    i++;
  }
  if (i >= pColors.size()) {
    i = pColors.size() - 1;
  }

  // System.println(percentage);
  // System.println(i);

  var lower = pColors[i - 1];
  var upper = pColors[i];
  var range = upper[0] - lower[0];
  var rangePct = 1;
  if (range != 0) {
    rangePct = (percentage - lower[0]) / range;
  }
  var pctLower = 1 - rangePct;
  var pctUpper = rangePct;

  var red = Math.floor(lower[1] * pctLower + upper[1] * pctUpper);
  var green = Math.floor(lower[2] * pctLower + upper[2] * pctUpper);
  var blue = Math.floor(lower[3] * pctLower + upper[3] * pctUpper);

  if (darker > 0 && darker < 100) {
    red = red - (red / 100) * darker;
    green = green - (green / 100) * darker;
    blue = blue - (blue / 100) * darker;
  }

  return Graphics.createColor(alpha, red.toNumber(), green.toNumber(), blue.toNumber());
}
/* TODO
var percentColors = [
    { pct: 0.0, color: { r: 0xff, g: 0x00, b: 0 } },
    { pct: 0.5, color: { r: 0xff, g: 0xff, b: 0 } },
    { pct: 1.0, color: { r: 0x00, g: 0xff, b: 0 } } ];

var getColorForPercentage = function(pct) {
    for (var i = 1; i < percentColors.length - 1; i++) {
        if (pct < percentColors[i].pct) {
            break;
        }
    }
    var lower = percentColors[i - 1];
    var upper = percentColors[i];
    var range = upper.pct - lower.pct;
    var rangePct = (pct - lower.pct) / range;
    var pctLower = 1 - rangePct;
    var pctUpper = rangePct;
    var color = {
        r: Math.floor(lower.color.r * pctLower + upper.color.r * pctUpper),
        g: Math.floor(lower.color.g * pctLower + upper.color.g * pctUpper),
        b: Math.floor(lower.color.b * pctLower + upper.color.b * pctUpper)
    };
    return 'rgb(' + [color.r, color.g, color.b].join(',') + ')';
    // or output as hex if preferred
};
*/
function percentageToColor(percentage as Numeric?) as ColorType {
  // if (Graphics has :createColor) {

  // }
  if (percentage == null || percentage == 0) {
    return Graphics.COLOR_WHITE;
  }
  if (percentage < 45) {
    return Colors.COLOR_WHITE_GRAY_2;
  }
  if (percentage < 55) {
    return Colors.COLOR_WHITE_GRAY_3;
  }
  if (percentage < 65) {
    return Colors.COLOR_WHITE_BLUE_3;
  }
  if (percentage < 70) {
    return Colors.COLOR_WHITE_DK_BLUE_3;
  }
  if (percentage < 75) {
    return Colors.COLOR_WHITE_LT_GREEN_3;
  }
  if (percentage < 80) {
    return Colors.COLOR_WHITE_GREEN_3;
  }
  if (percentage < 85) {
    return Colors.COLOR_WHITE_YELLOW_3;
  }
  if (percentage < 95) {
    return Colors.COLOR_WHITE_ORANGE_3;
  }
  if (percentage == 100) {
    return Colors.COLOR_WHITE_ORANGERED_2;
  }
  if (percentage < 105) {
    return Colors.COLOR_WHITE_ORANGERED_3;
  }
  if (percentage < 115) {
    return Colors.COLOR_WHITE_ORANGERED2_3;
  }
  if (percentage < 125) {
    return Colors.COLOR_WHITE_RED_3;
  }

  if (percentage < 135) {
    return Colors.COLOR_WHITE_DK_RED_3;
  }

  if (percentage < 145) {
    return Colors.COLOR_WHITE_PURPLE_3;
  }

  if (percentage < 155) {
    return Colors.COLOR_WHITE_DK_PURPLE_3;
  }
  return Colors.COLOR_WHITE_DK_PURPLE_4;
}

// https://htmlcolorcodes.com/  -> use tint 3
module Colors {
  // color scale
  const COLOR_WHITE_1 = 0xfbeee6;
  const COLOR_WHITE_2 = 0xfbfcfc;
  const COLOR_WHITE_3 = 0xf7f9f9;
  const COLOR_WHITE_4 = 0xf4f6f7;

  const COLOR_WHITE_GRAY_1 = 0xf2f4f4;
  const COLOR_WHITE_GRAY_2 = 0xe5e8e8;
  const COLOR_WHITE_GRAY_3 = 0xccd1d1;
  const COLOR_WHITE_GRAY_4 = 0xbfc9ca;

  const COLOR_WHITE_BLUE_1 = 0xebf5fb;
  const COLOR_WHITE_BLUE_2 = 0xd6eaf8;
  const COLOR_WHITE_BLUE_3 = 0xaed6f1;
  const COLOR_WHITE_BLUE_4 = 0x85c1e9;

  const COLOR_WHITE_DK_BLUE_1 = 0xeaf2f8;
  const COLOR_WHITE_DK_BLUE_2 = 0xd4e6f1;
  const COLOR_WHITE_DK_BLUE_3 = 0xa9cce3;
  const COLOR_WHITE_DK_BLUE_4 = 0x7fb3d5;

  const COLOR_WHITE_LT_GREEN_1 = 0xe8f8f5;
  const COLOR_WHITE_LT_GREEN_2 = 0xd1f2eb;
  const COLOR_WHITE_LT_GREEN_3 = 0xa3e4d7;
  const COLOR_WHITE_LT_GREEN_4 = 0x76d7c4;

  const COLOR_WHITE_GREEN_1 = 0xe9f7ef;
  const COLOR_WHITE_GREEN_2 = 0xd4efdf;
  const COLOR_WHITE_GREEN_3 = 0xa9dfbf;
  const COLOR_WHITE_GREEN_4 = 0x7dcea0;

  const COLOR_WHITE_YELLOW_1 = 0xfef9e7;
  const COLOR_WHITE_YELLOW_2 = 0xfcf3cf;
  const COLOR_WHITE_YELLOW_3 = 0xf9e79f;
  const COLOR_WHITE_YELLOW_4 = 0xf7dc6f;

  const COLOR_WHITE_ORANGE_1 = 0xfef5e7;
  const COLOR_WHITE_ORANGE_2 = 0xfdebd0;
  const COLOR_WHITE_ORANGE_3 = 0xfad7a0;
  const COLOR_WHITE_ORANGE_4 = 0xf8c471;

  const COLOR_WHITE_ORANGERED_1 = 0xfdf2e9;
  const COLOR_WHITE_ORANGERED_2 = 0xfae5d3;
  const COLOR_WHITE_ORANGERED_3 = 0xf5cba7;
  const COLOR_WHITE_ORANGERED_4 = 0xf0b27a;

  const COLOR_WHITE_ORANGERED2_1 = 0xfbeee6;
  const COLOR_WHITE_ORANGERED2_2 = 0xf6ddcc;
  const COLOR_WHITE_ORANGERED2_3 = 0xedbb99;
  const COLOR_WHITE_ORANGERED2_4 = 0xe59866;

  const COLOR_WHITE_RED_1 = 0xfdedec;
  const COLOR_WHITE_RED_2 = 0xfadbd8;
  const COLOR_WHITE_RED_3 = 0xf5b7b1;
  const COLOR_WHITE_RED_4 = 0xf1948a;

  const COLOR_WHITE_DK_RED_1 = 0xf9ebea;
  const COLOR_WHITE_DK_RED_2 = 0xf2d7d5;
  const COLOR_WHITE_DK_RED_3 = 0xe6b0aa;
  const COLOR_WHITE_DK_RED_4 = 0xd98880;

  const COLOR_WHITE_PURPLE_1 = 0xf5eef8;
  const COLOR_WHITE_PURPLE_2 = 0xe8daef;
  const COLOR_WHITE_PURPLE_3 = 0xd7bde2;
  const COLOR_WHITE_PURPLE_4 = 0xc39bd3;

  const COLOR_WHITE_DK_PURPLE_1 = 0xf4ecf7;
  const COLOR_WHITE_DK_PURPLE_2 = 0xe8daef;
  const COLOR_WHITE_DK_PURPLE_3 = 0xd2b4de;
  const COLOR_WHITE_DK_PURPLE_4 = 0xbb8fce;

  const COLOR_WHITE_BLACK_1 = 0xeaecee;
  const COLOR_WHITE_BLACK_2 = 0xd5d8dc;
  const COLOR_WHITE_BLACK_3 = 0xabb2b9;
  const COLOR_WHITE_BLACK_4 = 0x808b96;
}

function julian_day(year as Number, month as Number, day as Number) as Number {
  var a = (14 - month) / 12;
  var y = year + 4800 - a;
  var m = month + 12 * a - 3;
  return day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045;
}

function is_leap_year(year as Number) as Boolean {
  if (year % 4 != 0) {
    return false;
  } else if (year % 100 != 0) {
    return true;
  } else if (year % 400 == 0) {
    return true;
  }

  return false;
}

function iso_week_number(year as Number, month as Number, day as Number) as Number {
  var first_day_of_year = julian_day(year, 1, 1);
  var given_day_of_year = julian_day(year, month, day);

  var day_of_week = (first_day_of_year + 3) % 7; // days past thursday
  var week_of_year = (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;

  // week is at end of this year or the beginning of next year
  if (week_of_year == 53) {
    if (day_of_week == 6) {
      return week_of_year;
    } else if (day_of_week == 5 && is_leap_year(year)) {
      return week_of_year;
    } else {
      return 1;
    }
  }

  // week is in previous year, try again under that year
  else if (week_of_year == 0) {
    first_day_of_year = julian_day(year - 1, 1, 1);

    day_of_week = (first_day_of_year + 3) % 7;

    return (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
  }

  // any old week of the year
  else {
    return week_of_year;
  }
}
