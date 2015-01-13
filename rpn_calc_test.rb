require "minitest/autorun"
require_relative "./rpn_calc"

class TestRPNCalc < Minitest::Test

  def test_that_normal_operators_should_pass
    assert_equal RPNCalc.run("1 2 +"), 3
    assert_equal RPNCalc.run("4 2 /"), 2
    assert_equal RPNCalc.run("2 3 4 + *"), 14
    assert_equal RPNCalc.run("3 4 + 5 6 + *"), 77
    assert_equal RPNCalc.run("13 4 -"), 9
  end

  def test_that_negative_numbers_work
    assert_equal RPNCalc.run("-13 4 -"), -17
  end

  def test_that_normal_operators_should_pass_with_floats
    assert_equal RPNCalc.run("1.2 2.3 +"), 3.5
    assert_equal RPNCalc.run("1.2 2 -"), -0.8
  end

  def test_that_other_defined_operators_will_pass
    assert_equal RPNCalc.run("13 4 doubleminus"), 5
  end

  def test_that_should_raise_not_enough_arguments_error
    err = assert_raises(RuntimeError) {RPNCalc.run("1 +")}
    assert_equal "not enough arguments", err.message
  end

  def test_that_should_raise_invalid_number_error
    err = assert_raises(RuntimeError) {RPNCalc.run("a b +")}
    assert_equal "invalid number", err.message
  end

  def test_that_should_raise_invalid_number_error_from_two_decimals
    err = assert_raises(RuntimeError) {RPNCalc.run("1.1.1 2 +")}
    assert_equal "invalid number", err.message
  end

  def test_that_sum_operator_works
    assert_equal 10, RPNCalc.run("1 2 3 4 sum")
    assert_equal 2, RPNCalc.run("1 2 3 sum 4 -")
    assert_equal 24, RPNCalc.run("1 2 - 3 * 10 9 8 sum")
  end

  def test_atof
    calc = RPNCalc.new("")
    assert_equal 1.002, calc.atof("1.002")
  end
end
