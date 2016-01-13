require 'test_helper'

class MallTest < ActiveSupport::TestCase
  test "el mall debe tener valores" do
    mall = Mall.create()
    assert_not mall.valid?, "Error: El mall no tiene valores"
  end


end

