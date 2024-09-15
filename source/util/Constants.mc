import Toybox.Lang;

typedef FormatDictionary as Dictionary<Number, Dictionary<Number, String>>;

module Constants {

    const MAX_ACCOUNTS = 20;
    const DEFAULT_TOKEN_LIFETIME = 30;

    // storage key const
    const CURRENT_ACC_IDX_KEY = "CurrentAccountIdx";
    // property consts
    const BG_COLOR_PROP = "BackgroundColor";
    const FG_COLOR_PROP = "ForegroundColor";
    const CIRCLE_TIMER_COLOR_PROP = "CircleTimerColor";
    const CIRCLE_TIMER_ARROWS_PROP = "CircleTimerArrows";

    const OTP_FORMAT as FormatDictionary = {
        6 => {
            0 => "$1$$2$$3$$4$$5$$6$",          // TokenFormatFor6_xxxxxx
            1 => "$1$$2$$3$ $4$$5$$6$",         // TokenFormatFor6_xxx_xxx
            2 => "$1$$2$ $3$$4$ $5$$6$"         // TokenFormatFor6_xx_xx_xx
        },
        7 => {
            0 => "$1$$2$$3$$4$$5$$6$$7$",       // TokenFormatFor7_yyyyyyy
            1 => "$1$$2$$3$ $4$$5$$6$$7$",      // TokenFormatFor7_yyy_yyyy
            2 => "$1$$2$$3$$4$ $5$$6$$7$",      // TokenFormatFor7_yyyy_yyy
            3 => "$1$$2$$3$ $4$ $5$$6$$7$",     // TokenFormatFor7_yyy_y_yyy
            4 => "$1$$2$ $3$$4$$5$ $6$$7$"      // TokenFormatFor7_yy_yyy_yy
        },
        8 => {
            0 => "$1$$2$$3$$4$$5$$6$$7$$8$",    // TokenFormatFor8_zzzzzzzz
            1 => "$1$$2$$3$$4$ $5$$6$$7$$8$",   // TokenFormatFor8_zzzz_zzzz
            2 => "$1$$2$$3$ $4$$5$ $6$$7$$8$",  // TokenFormatFor8_zzz_zz_zzz
            3 => "$1$$2$ $3$$4$$5$$6$ $7$$8$",  // TokenFormatFor8_zz_zzzz_zz
            4 => "$1$$2$ $3$$4$ $5$$6$ $7$$8$"  // TokenFormatFor8_zz_zz_zz_zz
        }
    };
}