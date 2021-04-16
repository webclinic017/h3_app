import 'dart:io';

class IdWorkerUtils {
  static const int SEQUENCE_BITS = 12;

  static const int WORKER_ID_BITS = 10;

  static const int SEQUENCE_MASK = (1 << SEQUENCE_BITS) - 1;

  static const int WORKER_ID_LEFT_SHIFT_BITS = SEQUENCE_BITS;

  static const int TIMESTAMP_LEFT_SHIFT_BITS =
      WORKER_ID_LEFT_SHIFT_BITS + WORKER_ID_BITS;

  static const int WORKER_ID_MAX_VALUE = 1 << WORKER_ID_BITS;

  static const int WORKER_ID = 1;

  static const int MAX_TOLERATE_TIME_DIFFERENCE_MILLISECONDS = 10;

  final int epoch;

  int sequenceOffset;
  int sequence;
  int lastMilliseconds;

  ///工厂模式
  factory IdWorkerUtils() => getInstance();
  static IdWorkerUtils _instance;

  static IdWorkerUtils getInstance() {
    if (_instance == null) {
      //2019-10-01 00:00:00  1569859200000
      var epoch = DateTime(2019, 10, 01).millisecondsSinceEpoch;
      _instance = IdWorkerUtils._internal(epoch);
    }
    return _instance;
  }

  IdWorkerUtils._internal(this.epoch) {
    sequenceOffset = 0;
    sequence = 0;
    lastMilliseconds = -1;
  }

  int generate() {
    int currentMilliseconds = this.getCurrentMillis();

    if (waitTolerateTimeDifferenceIfNeed(currentMilliseconds)) {
      currentMilliseconds = this.getCurrentMillis();
    }

    if (lastMilliseconds == currentMilliseconds) {
      if (0 == (sequence = (sequence + 1) & SEQUENCE_MASK)) {
        currentMilliseconds = waitUntilNextTime(currentMilliseconds);
      }
    } else {
      vibrateSequenceOffset();
      sequence = sequenceOffset;
    }
    lastMilliseconds = currentMilliseconds;

    return ((currentMilliseconds - epoch) << TIMESTAMP_LEFT_SHIFT_BITS) |
        (getWorkerId() << WORKER_ID_LEFT_SHIFT_BITS) |
        sequence;
  }

  void vibrateSequenceOffset() {
    sequenceOffset = (~sequenceOffset & 1);
  }

  bool waitTolerateTimeDifferenceIfNeed(final int currentMilliseconds) {
    if (lastMilliseconds <= currentMilliseconds) {
      return false;
    }
    int timeDifferenceMilliseconds = lastMilliseconds - currentMilliseconds;

    if (timeDifferenceMilliseconds >=
        getMaxTolerateTimeDifferenceMilliseconds()) {
      throw Exception(
          "Clock is moving backwards, last time is $lastMilliseconds milliseconds, current time is $currentMilliseconds milliseconds");
    }

    sleep(Duration(milliseconds: timeDifferenceMilliseconds));

    return true;
  }

  int getWorkerId() {
    int result = WORKER_ID;
    if (result < 0 || result > WORKER_ID_MAX_VALUE) {
      throw Exception("workerId is illegal: $WORKER_ID");
    }
    return result;
  }

  int getMaxTolerateTimeDifferenceMilliseconds() {
    return MAX_TOLERATE_TIME_DIFFERENCE_MILLISECONDS;
  }

  int waitUntilNextTime(final int lastTime) {
    int result = this.getCurrentMillis();
    while (result <= lastTime) {
      result = this.getCurrentMillis();
    }
    return result;
  }

  int getCurrentMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
