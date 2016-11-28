/* classImpl : auto generated (Mon Nov 28 14:04:33 2016) */
class InternalSignal : public Signal {
 public:
 InternalSignal() {
   type = (char*)"internal signal";
   rstNum = 0;
 };
};

class InternalTaskSignal : public InternalSignal {
 public:
 InternalTaskSignal() {
   type = (char*)"internal tasking signal";
   rstNum = 1;
 };
};

class InternalSignalsSignal : public InternalSignal {
 public:
 InternalSignalsSignal() {
   type = (char*)"error in signal administration";
   rstNum = 2;
 };
};

class InternalDationSignal : public InternalSignal {
 public:
 InternalDationSignal() {
   type = (char*)"problem in dation";
   rstNum = 3;
 };
};

class InternalDatatypeSignal : public InternalSignal {
 public:
 InternalDatatypeSignal() {
   type = (char*)"Illegal operation in expression";
   rstNum = 4;
 };
};

class StackOverflowSignal : public InternalSignal {
 public:
 StackOverflowSignal() {
   type = (char*)"Stack Overflow occurred";
   rstNum = 0;
 };
};

class TaskSignal : public Signal {
 public:
 TaskSignal() {
   type = (char*)"*** will never be printed ***";
   rstNum = 100;
 };
};

class PrioOutOfRangeSignal : public TaskSignal {
 public:
 PrioOutOfRangeSignal() {
   type = (char*)"priority out of range";
   rstNum = 101;
 };
};

class TaskRunningSignal : public TaskSignal {
 public:
 TaskRunningSignal() {
   type = (char*)"activate an active task";
   rstNum = 102;
 };
};

class TaskSuspendedSignal : public TaskSignal {
 public:
 TaskSuspendedSignal() {
   type = (char*)"Illegal operation on suspended task";
   rstNum = 103;
 };
};

class TaskTerminatedSignal : public TaskSignal {
 public:
 TaskTerminatedSignal() {
   type = (char*)"Illegal operation on terminated task";
   rstNum = 104;
 };
};

class IllegalSchedulingSignal : public TaskSignal {
 public:
 IllegalSchedulingSignal() {
   type = (char*)"illegal scheduling condition";
   rstNum = 106;
 };
};

class ArithmeticSignal : public Signal {
 public:
 ArithmeticSignal() {
   type = (char*)"*** will never be printed ***";
   rstNum = 200;
 };
};

class FixedRangeSignal : public ArithmeticSignal {
 public:
 FixedRangeSignal() {
   type = (char*)"fixed overflow";
   rstNum = 201;
 };
};

class FixedDivideByZeroSignal : public ArithmeticSignal {
 public:
 FixedDivideByZeroSignal() {
   type = (char*)"Fixed divide by zero";
   rstNum = 202;
 };
};

class ArithmeticOverflowSignal : public ArithmeticSignal {
 public:
 ArithmeticOverflowSignal() {
   type = (char*)"arithmetic overflow";
   rstNum = 203;
 };
};

class ArithmeticUnderflowSignal : public ArithmeticSignal {
 public:
 ArithmeticUnderflowSignal() {
   type = (char*)"arithmetic underflow";
   rstNum = 204;
 };
};

class ArithmeticDivideByZeroSignal : public ArithmeticSignal {
 public:
 ArithmeticDivideByZeroSignal() {
   type = (char*)"arithmetic divide by zero";
   rstNum = 205;
 };
};

class SemaOverflowSignal : public ArithmeticSignal {
 public:
 SemaOverflowSignal() {
   type = (char*)"semaphore value overflow";
   rstNum = 206;
 };
};

class DurationDivideByZeroSignal : public ArithmeticSignal {
 public:
 DurationDivideByZeroSignal() {
   type = (char*)"duration div 0";
   rstNum = 207;
 };
};

class DurationRangeSignal : public ArithmeticSignal {
 public:
 DurationRangeSignal() {
   type = (char*)"duration value overflow";
   rstNum = 208;
 };
};

class FloatIsNaNSignal : public ArithmeticSignal {
 public:
 FloatIsNaNSignal() {
   type = (char*)"Float result is NaN";
   rstNum = 209;
 };
};

class FloatIsINFSignal : public ArithmeticSignal {
 public:
 FloatIsINFSignal() {
   type = (char*)"Float result is INF";
   rstNum = 210;
 };
};

class BitSignal : public Signal {
 public:
 BitSignal() {
   type = (char*)"never created";
   rstNum = 301;
 };
};

class BitIndexOutOfRangeSignal : public BitSignal {
 public:
 BitIndexOutOfRangeSignal() {
   type = (char*)"bit index out of range";
   rstNum = 302;
 };
};

class CharacterTooLongSignal : public Signal {
 public:
 CharacterTooLongSignal() {
   type = (char*)"character string too long";
   rstNum = 303;
 };
};

class CharacterIndexOutOfRangeSignal : public Signal {
 public:
 CharacterIndexOutOfRangeSignal() {
   type = (char*)"character index out of range";
   rstNum = 304;
 };
};

class DationSignal : public Signal {
 public:
 DationSignal() {
   type = (char*)"dation";
   rstNum = 305;
 };
};

class IllegalParamSignal : public DationSignal {
 public:
 IllegalParamSignal() {
   type = (char*)"illegal parameter, not permitted operation";
   rstNum = 306;
 };
};

class OpenFailedSignal : public DationSignal {
 public:
 OpenFailedSignal() {
   type = (char*)"device doesn't exist or no permission";
   rstNum = 307;
 };
};

class CloseFailedSignal : public DationSignal {
 public:
 CloseFailedSignal() {
   type = (char*)"invalid file descriptor or i/o error";
   rstNum = 308;
 };
};

class PositioningFailedSignal : public DationSignal {
 public:
 PositioningFailedSignal() {
   type = (char*)"Positioning the Dations failed";
   rstNum = 309;
 };
};

class PositioningForbiddenSignal : public DationSignal {
 public:
 PositioningForbiddenSignal() {
   type = (char*)"Positioning forbidden, because wrong or no dimension";
   rstNum = 310;
 };
};

class ReadingFailedSignal : public DationSignal {
 public:
 ReadingFailedSignal() {
   type = (char*)"reading data from dation failed";
   rstNum = 311;
 };
};

class WritingFailedSignal : public DationSignal {
 public:
 WritingFailedSignal() {
   type = (char*)"writing data to dation failed";
   rstNum = 312;
 };
};

class IllegalPathSignal : public DationSignal {
 public:
 IllegalPathSignal() {
   type = (char*)"Path points to normal file. Not allowed";
   rstNum = 313;
 };
};

class NoFileInfoSignal : public DationSignal {
 public:
 NoFileInfoSignal() {
   type = (char*)"Can't get Fileinfo for given path";
   rstNum = 314;
 };
};

class NotAllowedSignal : public DationSignal {
 public:
 NotAllowedSignal() {
   type = (char*)"This Action is forbidden by specification";
   rstNum = 315;
 };
};

class DationSeekNotRealizedSignal : public DationSignal {
 public:
 DationSeekNotRealizedSignal() {
   type = (char*)"no seek operation available";
   rstNum = 316;
 };
};

class DationIndexBoundSignal : public DationSignal {
 public:
 DationIndexBoundSignal() {
   type = (char*)"Dation position out of bounds";
   rstNum = 317;
 };
};

class DationNotSupportedSignal : public DationSignal {
 public:
 DationNotSupportedSignal() {
   type = (char*)"Dation operation not supported";
   rstNum = 318;
 };
};

class DationEOFSignal : public DationSignal {
 public:
 DationEOFSignal() {
   type = (char*)"EOF encountered";
   rstNum = 319;
 };
};

class ArrayIndexOutOfBoundsSignal : public Signal {
 public:
 ArrayIndexOutOfBoundsSignal() {
   type = (char*)"Array Index out of Bounds";
   rstNum = 320;
 };
};

class FormatSignal : public Signal {
 public:
 FormatSignal() {
   type = (char*)"format";
   rstNum = 400;
 };
};

class NoMoreCharactersSignal : public FormatSignal {
 public:
 NoMoreCharactersSignal() {
   type = (char*)"no more characters found";
   rstNum = 401;
 };
};

class NoDataInFieldSignal : public FormatSignal {
 public:
 NoDataInFieldSignal() {
   type = (char*)"input field is empty";
   rstNum = 402;
 };
};

class DurationFormatSignal : public FormatSignal {
 public:
 DurationFormatSignal() {
   type = (char*)"illegal parameter for D-format";
   rstNum = 403;
 };
};

class ClockFormatSignal : public FormatSignal {
 public:
 ClockFormatSignal() {
   type = (char*)"illegal parameter for T-format";
   rstNum = 404;
 };
};

class FixedFormatSignal : public FormatSignal {
 public:
 FixedFormatSignal() {
   type = (char*)"illegal parameter for F-format";
   rstNum = 405;
 };
};

class CharacterFormatSignal : public FormatSignal {
 public:
 CharacterFormatSignal() {
   type = (char*)"illegal parameter for A-format";
   rstNum = 406;
 };
};

class BitFormatSignal : public FormatSignal {
 public:
 BitFormatSignal() {
   type = (char*)"illegal parameter for B-format";
   rstNum = 407;
 };
};

class ClockValueSignal : public FormatSignal {
 public:
 ClockValueSignal() {
   type = (char*)"illegal value for T-format";
   rstNum = 408;
 };
};

class FixedValueSignal : public FormatSignal {
 public:
 FixedValueSignal() {
   type = (char*)"Illegal value for F-format ";
   rstNum = 409;
 };
};

class BitValueSignal : public FormatSignal {
 public:
 BitValueSignal() {
   type = (char*)"Illegal value for B-format ";
   rstNum = 410;
 };
};

class DurationValueSignal : public FormatSignal {
 public:
 DurationValueSignal() {
   type = (char*)"Illegal value for D-format ";
   rstNum = 411;
 };
};

class ExpFormatSignal : public FormatSignal {
 public:
 ExpFormatSignal() {
   type = (char*)"illegal parameter for E-format";
   rstNum = 412;
 };
};

class ExpValueSignal : public FormatSignal {
 public:
 ExpValueSignal() {
   type = (char*)"Illegal value for E-format ";
   rstNum = 413;
 };
};

/* extList : auto generated (Mon Nov 28 14:04:33 2016) */
extern InternalSignal theInternalSignal;
extern InternalTaskSignal theInternalTaskSignal;
extern InternalSignalsSignal theInternalSignalsSignal;
extern InternalDationSignal theInternalDationSignal;
extern InternalDatatypeSignal theInternalDatatypeSignal;
extern StackOverflowSignal theStackOverflowSignal;
extern TaskSignal theTaskSignal;
extern PrioOutOfRangeSignal thePrioOutOfRangeSignal;
extern TaskRunningSignal theTaskRunningSignal;
extern TaskSuspendedSignal theTaskSuspendedSignal;
extern TaskTerminatedSignal theTaskTerminatedSignal;
extern IllegalSchedulingSignal theIllegalSchedulingSignal;
extern ArithmeticSignal theArithmeticSignal;
extern FixedRangeSignal theFixedRangeSignal;
extern FixedDivideByZeroSignal theFixedDivideByZeroSignal;
extern ArithmeticOverflowSignal theArithmeticOverflowSignal;
extern ArithmeticUnderflowSignal theArithmeticUnderflowSignal;
extern ArithmeticDivideByZeroSignal theArithmeticDivideByZeroSignal;
extern SemaOverflowSignal theSemaOverflowSignal;
extern DurationDivideByZeroSignal theDurationDivideByZeroSignal;
extern DurationRangeSignal theDurationRangeSignal;
extern FloatIsNaNSignal theFloatIsNaNSignal;
extern FloatIsINFSignal theFloatIsINFSignal;
extern BitSignal theBitSignal;
extern BitIndexOutOfRangeSignal theBitIndexOutOfRangeSignal;
extern CharacterTooLongSignal theCharacterTooLongSignal;
extern CharacterIndexOutOfRangeSignal theCharacterIndexOutOfRangeSignal;
extern DationSignal theDationSignal;
extern IllegalParamSignal theIllegalParamSignal;
extern OpenFailedSignal theOpenFailedSignal;
extern CloseFailedSignal theCloseFailedSignal;
extern PositioningFailedSignal thePositioningFailedSignal;
extern PositioningForbiddenSignal thePositioningForbiddenSignal;
extern ReadingFailedSignal theReadingFailedSignal;
extern WritingFailedSignal theWritingFailedSignal;
extern IllegalPathSignal theIllegalPathSignal;
extern NoFileInfoSignal theNoFileInfoSignal;
extern NotAllowedSignal theNotAllowedSignal;
extern DationSeekNotRealizedSignal theDationSeekNotRealizedSignal;
extern DationIndexBoundSignal theDationIndexBoundSignal;
extern DationNotSupportedSignal theDationNotSupportedSignal;
extern DationEOFSignal theDationEOFSignal;
extern ArrayIndexOutOfBoundsSignal theArrayIndexOutOfBoundsSignal;
extern FormatSignal theFormatSignal;
extern NoMoreCharactersSignal theNoMoreCharactersSignal;
extern NoDataInFieldSignal theNoDataInFieldSignal;
extern DurationFormatSignal theDurationFormatSignal;
extern ClockFormatSignal theClockFormatSignal;
extern FixedFormatSignal theFixedFormatSignal;
extern CharacterFormatSignal theCharacterFormatSignal;
extern BitFormatSignal theBitFormatSignal;
extern ClockValueSignal theClockValueSignal;
extern FixedValueSignal theFixedValueSignal;
extern BitValueSignal theBitValueSignal;
extern DurationValueSignal theDurationValueSignal;
extern ExpFormatSignal theExpFormatSignal;
extern ExpValueSignal theExpValueSignal;
