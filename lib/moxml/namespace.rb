module Moxml
  class Namespace < Node
    def prefix
      adapter.namespace_prefix(@native)
    end

    def uri
      adapter.namespace_uri(@native)
    end

    def ==(other)
      other.is_a?(Namespace) && prefix == other.prefix && uri == other.uri
    end

    def to_s
      if prefix
        %{xmlns:#{prefix}="#{uri}"}
      else
        %{xmlns="#{uri}"}
      end
    end

    def namespace?
      true
    end
  end
end
