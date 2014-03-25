require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph do
        subject(:nyu_aleph) do
          NyuAleph.new
        end
        it { should be_an NyuAleph }
      end
    end
  end
end
