class FanState {
  bool power;
  bool cool;
  bool swing;
  int level;
  int offTimer;
  bool hasWater;

  FanState({
    this.power = false,
    this.cool = false,
    this.swing = false,
    this.level = 0,
    this.offTimer = 0,
    this.hasWater = true
  });

  FanState togglePower() {
    if (level == 0) {
      level = 1;
    }
    offTimer = 0;
    power = !power;
    return this;
  }

  FanState toggleCool() {
    if (power) {
      cool = !cool;
    }
    return this;
  }

  FanState toggleSwing() {
    if (power) {
      swing = !swing;
    }
    return this;
  }

  FanState setLevel(int newLevel) {
    if (!power) return this;
    
    this.level = newLevel;
    return this;
  }

  FanState setOffTimer(int hours) {
    if (!power) return this;

    if (this.offTimer == hours) {
      this.offTimer = 0;
    } else {
      this.offTimer = hours;
    }
    return this;
  }
}
