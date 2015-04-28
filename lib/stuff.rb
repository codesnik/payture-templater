require 'yaml'

def unmarshal_config(path)
  YAML.load_file(path)
end

class Hash
  def symbolize_keys!
    each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
  end
end
