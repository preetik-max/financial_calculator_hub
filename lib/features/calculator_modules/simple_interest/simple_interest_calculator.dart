import 'simple_interest_model.dart';

class SimpleInterestCalculator {
  SimpleInterestCalculator._();

  static SimpleInterestResult calculate(SimpleInterestInput input) {
    final principal = input.principal;
    final rate = input.annualRate;
    final time = input.timeYears;

    if (principal <= 0 || rate < 0 || time <= 0) {
      return SimpleInterestResult(
        principal: principal > 0 ? principal : 0,
        annualRate: rate >= 0 ? rate : 0,
        timeYears: time > 0 ? time : 0,
        interest: 0,
        maturityAmount: principal > 0 ? principal : 0,
      );
    }

    // SI = P × R × T / 100
    final interest = principal * rate * time / 100;

    final maturityAmount = principal + interest;

    return SimpleInterestResult(
      principal: principal,
      annualRate: rate,
      timeYears: time,
      interest: interest,
      maturityAmount: maturityAmount,
    );
  }
}
