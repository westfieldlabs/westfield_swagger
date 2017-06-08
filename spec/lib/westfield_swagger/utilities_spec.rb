require 'rails_helper'

RSpec.describe WestfieldSwagger::Utilities do
  describe '#deeply_sort_hash' do
    it 'deeply sorts a hash' do
      unsorted_hash = { b: { z: 'zed', x: 'xavier'  },
                        f: { t: 'ted', q: 'quixote' },
                        a: { n: 'nancy', l: 'larry', m: 'mike'}}

      sorted_hash = deeply_sort_hash(unsorted_hash)

      expect(sorted_hash.keys).to eql([:a, :b, :f])
      expect(sorted_hash[:a].keys).to eql([:l, :m, :n])
    end
  end
end
