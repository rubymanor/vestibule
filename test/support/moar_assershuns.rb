class ActiveSupport::TestCase
  def assert_includes(array, expected_element)
    assert array.include? expected_element
  end

  def assert_in_order(array, *expected_elements_order)
    actual_order = expected_elements_order.map { |e| array.index(e) }
    assert_equal (0...expected_elements_order.size).to_a, actual_order
  end
end