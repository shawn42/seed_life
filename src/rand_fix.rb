module Kernel
  def rand_from_range(range)
    min = range.min
    max = range.max
    val = rand(max-min)
    min + val
  end
end
