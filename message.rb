def messages
  return [
    "moveCard from:zone_a to: zone_b",
    "moveCard from:'zone_a' to:'zone_b'"
  ]
end

def get_type(str)
  #type_match = /^(?:[A-Za-z0-9_-]+)?( [A-Za-z0-9_-]+: ?[A-Za-z0-9"'_-]+)+/
  type_match = /([A-Za-z0-9_-]+)?( [A-Za-z0-9_-]+: ?[A-Za-z0-9"'_-]+)/
  funk_match = /[A-Za-z0-9_-]+: ?(")(?(1)[^\1]|[^\s])*(?(1)\1|) /
  str.scan type_match
end
