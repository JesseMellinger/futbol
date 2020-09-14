module Groupable

  def group_by(data, key, value)
  hash = {}
  data.each do |object|
    if hash[object.send(key)]
      hash[object.send(key)] << object.send(value)
    else
      hash[object.send(key)] = [object.send(value)]
    end
  end
  hash
end

end
