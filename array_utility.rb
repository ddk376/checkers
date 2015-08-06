class Array
  def add(array)
    result = []
    self.length.times do |idx|
      result << self[idx] + array[idx]
    end
    result
  end

  def diff(array)
    result = []
    self.length.times do |idx|
      result << self[idx] - array[idx]
    end
    result
  end

  def multiply(num)
    result = []
    self.length.times do |idx|
      result << self[idx] * num
    end
    result
  end

  def divide(num)
    result = []
    self.length.times do |idx|
      result << self[idx] / num
    end
    result
  end
end
