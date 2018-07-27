module Constants {

    const MAX_ACCOUNTS = 20;

    // time consts
    const TIME_STEP_SEC = 30;
    const RED_ZONE_SEC = 25;

    // ui consts
    const ANGEL_MULTIPLIER = 360 / TIME_STEP_SEC;
    const START_ANGEL = 270;
    const ROUND_WIDTH = 12;

    // storage key const
    const CURRENT_ACC_IDX_KEY = "CurrentAccountIdx";
    // property consts
    const BG_COLOR_PROP = "BackgroundColor";
    const FG_COLOR_PROP = "ForegroundColor";
    const CIRCLE_TIMER_COLOR_PROP = "CircleTimerColor";
    const CIRCLE_TIMER_ARROWS_PROP = "CircleTimerArrows";

    const OTP_FORMAT = {
        6 => {
            0 => "$1$$2$$3$$4$$5$$6$",          // OTPFormatFor6_xxxxxx
            1 => "$1$$2$$3$ $4$$5$$6$",         // OTPFormatFor6_xxx_xxx
            2 => "$1$$2$ $3$$4$ $5$$6$"         // OTPFormatFor6_xx_xx_xx
        },
        7 => {
            0 => "$1$$2$$3$$4$$5$$6$$7$",       // OTPFormatFor7_yyyyyyy
            1 => "$1$$2$$3$ $4$$5$$6$$7$",      // OTPFormatFor7_yyy_yyyy
            2 => "$1$$2$$3$$4$ $5$$6$$7$",      // OTPFormatFor7_yyyy_yyy
            3 => "$1$$2$$3$ $4$ $5$$6$$7$",     // OTPFormatFor7_yyy_y_yyy
            4 => "$1$$2$ $3$$4$$5$ $6$$7$"      // OTPFormatFor7_yy_yyy_yy
        },
        8 => {
            0 => "$1$$2$$3$$4$$5$$6$$7$$8$",    // OTPFormatFor8_zzzzzzzz
            1 => "$1$$2$$3$$4$ $5$$6$$7$$8$",   // OTPFormatFor8_zzzz_zzzz
            2 => "$1$$2$$3$ $4$$5$ $6$$7$$8$",  // OTPFormatFor8_zzz_zz_zzz
            3 => "$1$$2$ $3$$4$$5$$6$ $7$$8$",  // OTPFormatFor8_zz_zzzz_zz
            4 => "$1$$2$ $3$$4$ $5$$6$ $7$$8$"  // OTPFormatFor8_zz_zz_zz_zz
        }
    };
}