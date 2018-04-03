module Gorgerb
  class Error < StandardError
  end

  class APIError < Error
  end

  class NoSuchPlayerError < Error
  end
end
