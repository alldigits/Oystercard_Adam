require 'oystercard'

describe OysterCard do

  let(:station){ double :station }

    it 'has a balance of zero' do
      expect(subject.balance).to eq(0)
    end

  describe '#top_up' do

    it 'can top up the balance' do
      expect { subject.top_up(1) }.to change{ subject.balance }.by(1)
    end

    it 'raises an error when maximum balance exceeded' do
      maximum_balance = OysterCard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect { subject.top_up(1) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe '#deduct' do

    it 'deducts fare' do
      subject.top_up(20)
      expect{ subject.deduct(3) }.to change{ subject.balance }.by(-3)
    end
  end

  describe '#touch_in' do


    it 'stores entry station' do
      subject.top_up(5)
      subject.touch_in(station)
      expect(subject.entry_station).to eq(station)
    end

    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end

    it "can touch in" do
      subject.top_up(1)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it "can touch out" do
      subject.top_up(1)
      subject.touch_in(station)
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'will not touch in if below minimum balance' do
      expect{ subject.touch_in(station) }.to raise_error "Insufficient balance to touch in"
    end
  end

  describe '#touch_out' do

    it 'deducts fare on touch out' do
      subject.top_up(10)
      subject.touch_in(station)
      expect{ subject.touch_out }.to change{ subject.balance }.by(-OysterCard::MINIMUM_BALANCE)

    end

    it 'changes entry station to nil' do
      subject.top_up(5)
      subject.touch_in(station)
      subject.touch_out
      expect(subject.entry_station).to eq(nil)
    end

    
  end
end
