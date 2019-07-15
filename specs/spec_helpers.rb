module SpecHelpers

  def assert(a, b)
    raise AssertionError, "#{a.inspect} != #{b.inspect}" unless a == b
  end

  def it(description='')
    yield
  rescue AssertionError => e
    puts "Failed on \"it #{description}\":"
    puts "  #{e}"
  end

end

class AssertionError < StandardError
end
