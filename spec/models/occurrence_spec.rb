describe Occurrence do

  describe 'associations' do
    it {should belong_to :topic}
  end

  describe 'validations' do
    it {should validate_presence_of :topic}
    it {should validate_presence_of :value}
    it {should validate_presence_of :tweeted_at}
  end

  describe 'self.recent' do
    it "should only return recent records" do
      5.times {create(:occurrence)}
      5.times {create(:occurrence, :old)}

      expect(Occurrence.count).to eq(10)
      expect(Occurrence.recent.count).to eq(5)
    end
  end

  describe 'self.top' do
    it "should return counts of records in sorted order" do

      11.times {create(:hashtag_occurrence, value: "apple")}
      10.times {create(:hashtag_occurrence, value: "berry")}
      9.times {create(:hashtag_occurrence, value: "carrot")}

      # add in 20 other random hashtag_occurrences
      20.times { create(:hashtag_occurrence) }

      all_occurrences = HashtagOccurrence.all
      top_occurrences = HashtagOccurrence.top

      expect(all_occurrences.length).to eq(50)
      expect(top_occurrences.length).to eq(10)

      expect(top_occurrences[0][:value]).to eq("#apple")
      expect(top_occurrences[0][:count]).to eq(11)

      expect(top_occurrences[1][:value]).to eq("#berry")
      expect(top_occurrences[1][:count]).to eq(10)

      expect(top_occurrences[2][:value]).to eq("#carrot")
      expect(top_occurrences[2][:count]).to eq(9)
    end
  end

end