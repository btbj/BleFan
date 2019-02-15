import '../models/FanState.dart';

class SeqNumber {
  int high = 0;
  int low = 0;

  void increase() {
    this.low++;
    if (this.low > 255) {
      this.low = 0;
      this.high++;
      if (this.high > 255) {
        this.high = 0;
      }
    }
  }
}

class BleCode {
  final int headerA = 0x5a;
  final int headerB = 0x5b;
  final int ver = 0x01;
  final int codeLength = 11;
  final SeqNumber seq = SeqNumber();

  List<int> getCheckStateCode() {
    final int messageType = 0x04;
    final int checkCodeLength = 5;

    final List<int> result = [
      headerA,
      ver,
      checkCodeLength,
      seq.high,
      seq.low,
      messageType,
    ];
    final int sum = getSum(result);
    result.add(sum);
    seq.increase();
    return result;
  }

  List<int> getFanStateCode(FanState state) {
    final int messageType = 0x05;
    final int power = state.power ? 1 : 0;
    final int swing = state.swing ? 1 : 0;
    final int cool = state.cool ? 1 : 0;
    final int hasWater = state.hasWater ? 1 : 0;
    final int level = state.level;
    final int offTimer = state.offTimer;

    final List<int> result = [
      headerA,
      ver,
      codeLength,
      seq.high,
      seq.low,
      messageType,
      power,
      swing,
      cool,
      hasWater,
      level,
      offTimer,
    ];
    final int sum = getSum(result);
    result.add(sum);
    seq.increase();
    return result;
  }

  FanState analyseCode(List<int> code) {
    print('analysing code: $code');
    FanState state = FanState(
      power: code[6] == 1,
      swing: code[7] == 1,
      cool: code[8] == 1,
      hasWater: code[9] == 1,
      level: code[10],
      offTimer: code[11]
    );
    return state;
  }

  int getSum(List<int> code) {
    int sum = 0;
    for (int i = 1; i < code.length; i++) {
      sum = sum ^ code[i];
    }
    return sum;
  }
}
