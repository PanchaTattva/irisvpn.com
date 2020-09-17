module ApplicationHelper
  def openstruct_to_hash(object, hash = {})
    object.each_entry do |key, value|
      hash[key] = value.is_a?(OpenStruct) ? openstruct_to_hash(value) : value.is_a?(Array) ? array_to_hash(value) : value
    end
    hash
  end

  # Utility to convert array of OpenStruct to hash.
  def array_to_hash(array, hash= [])
    array.each do |item|
      x = item.is_a?(OpenStruct) ? openstruct_to_hash(item) : item.is_a?(Array) ? array_to_hash(item) : item
      hash << x
    end
    hash
  end
end
