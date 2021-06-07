require 'entity'

describe Entity do
  context 'when validating the attributes in the entity construct' do
    it 'returns the error message if some error occurs' do
      class TestWithValidations < Entity
        validate :attr4, -> (attr) { ['Não nula', !attr.nil? ]}
        validate :attr1, -> (attr) { ['não nula', !attr.to_s.nil? ]}
        validate :attr2, -> (attr) { ['Valor não é um numero', attr.is_a?(Integer) ]}
        validate :attr2, -> (attr) { ['Valor é igual 2', attr == 2 ]}
      end

      subject = TestWithValidations.new(attr1: 'attr1', attr2: '3', attr3: Time.now)

      expect(subject).to_not be_valid
      expect(subject.errors).to eq [{attr4: 'Não nula'}, {attr2: 'Valor não é um numero'}, {attr2: 'Valor é igual 2'}]
    end

    it 'returns the attributes if no error occurs' do
      now = Time.now
      class TestWithNoError < Entity
        validate :attr1, -> (attr) { !attr.to_s.nil? }
        validate :attr2, -> (attr) { attr > 1}
        validate :attr3, -> (attr) { attr.is_a? Time}
      end

      subject = TestWithNoError.new(attr1: 'attr1', attr2: 2, attr3: now)


      expect(subject.attr1).to eq 'attr1'
      expect(subject.attr2).to eq 2
      expect(subject.attr3).to eq now
    end

    context 'when updating some attribute' do
      it 'updates the value' do
        now = Time.now
        class TestWithNoError < Entity
          validate :attr1, -> (attr) { !attr.to_s.nil? }
          validate :attr2, -> (attr) { attr > 1}
          validate :attr3, -> (attr) { attr.is_a? Time}
        end

        subject = TestWithNoError.new(attr1: 'attr1', attr2: 2, attr3: now)
        subject.attr1 = '3'


        expect(subject.attr1).to eq '3'
        expect(subject.attr2).to eq 2
        expect(subject.attr3).to eq now
      end
    end
  end
end

