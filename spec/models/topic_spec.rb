describe Topic do

  let(:topic) {create(:topic)}
  let(:other_topic) {create(:topic)}

  describe 'associations' do
    it {should have_many(:tweet_occurrences)}
    it {should have_many(:hashtag_occurrences)}
    it {should have_many(:url_occurrences)}
    it {should have_many(:username_occurrences)}
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
  end


  describe 'initial state' do
    it 'can be created' do
      expect(topic).to be_persisted
    end

    it 'should have no tweet_occurrences' do
      expect(topic.tweet_occurrences).to be_empty
    end

    it 'should have no username_occurrences' do
      expect(topic.username_occurrences).to be_empty
    end

    it 'should have no hashtag_occurrences' do
      expect(topic.hashtag_occurrences).to be_empty
    end

    it 'should have no url_occurrences' do
      expect(topic.url_occurrences).to be_empty
    end

  end

  describe 'process_tweet!' do

    context 'with a new tweet' do

      let(:tweet_info) {build(:tweet_info)}

      it 'should record a recent tweet occurrence' do
        expect(topic.recent_tweet_count).to eq(0)
        topic.process_tweet!(tweet_info.to_h)
        expect(topic.recent_tweet_count).to eq(1)
      end

      it 'should not record one for another topic' do
        topic.process_tweet!(tweet_info.to_h)
        expect(topic.recent_tweet_count).to eq(1)
        expect(other_topic.recent_tweet_count).to eq(0)
      end

      context 'with no urls, hashtags, or usernames' do

        it 'should not record a recent url occurrence' do
          expect(topic.top_recent_urls).to be_empty
          topic.process_tweet!(tweet_info.to_h)
          expect(topic.top_recent_urls).to be_empty
        end

        it 'should not record a recent hashtag occurrence' do
          expect(topic.top_recent_hashtags).to be_empty
          topic.process_tweet!(tweet_info.to_h)
          expect(topic.top_recent_hashtags).to be_empty
        end

        it 'should not record a recent username occurrence' do
          expect(topic.top_recent_usernames).to be_empty
          topic.process_tweet!(tweet_info.to_h)
          expect(topic.top_recent_usernames).to be_empty
        end

      end

      context 'with urls, hashtags, and usernames' do

        let(:tweet_info) {build(:tweet_info, :with_urls, :with_hashtags, :with_usernames)}

        it 'should record a recent url occurrence' do
          expect(topic.top_recent_urls).to be_empty
          topic.process_tweet!(tweet_info.to_h)
          expect(topic.top_recent_urls).to_not be_empty
        end

        it 'should record a recent hashtag occurrence' do
          expect(topic.top_recent_hashtags).to be_empty
          topic.process_tweet!(tweet_info.to_h)
          expect(topic.top_recent_hashtags).to_not be_empty
        end

        it 'should record a recent username occurrence' do
          expect(topic.top_recent_usernames).to be_empty
          topic.process_tweet!(tweet_info.to_h)
          expect(topic.top_recent_usernames).to_not be_empty
        end

        it 'should not record anything for another topic' do
          topic.process_tweet!(tweet_info.to_h)
          expect(other_topic.top_recent_urls).to be_empty
          expect(other_topic.top_recent_hashtags).to be_empty
          expect(other_topic.top_recent_usernames).to be_empty
        end

      end
    end

    context 'with an old tweet' do
      let(:tweet_info) {build(:tweet_info, :old, :with_urls, :with_usernames, :with_hashtags)}

      it 'should not record a recent tweet occurrence' do
        expect(topic.recent_tweet_count).to eq(0)
        topic.process_tweet!(tweet_info.to_h)
        expect(topic.recent_tweet_count).to eq(0)
      end

      it 'should not record a recent url occurrence' do
        expect(topic.top_recent_urls).to be_empty
        topic.process_tweet!(tweet_info.to_h)
        expect(topic.top_recent_urls).to be_empty
      end

      it 'should not record a recent hashtag occurrence' do
        expect(topic.top_recent_hashtags).to be_empty
        topic.process_tweet!(tweet_info.to_h)
        expect(topic.top_recent_hashtags).to be_empty
      end

      it 'should not record a recent username occurrence' do
        expect(topic.top_recent_usernames).to be_empty
        topic.process_tweet!(tweet_info.to_h)
        expect(topic.top_recent_usernames).to be_empty
      end

    end
  end


  describe 'top_recent_hashtags' do

    it 'returns counts for recent hashtags' do
      tweet_info_1 = build(:tweet_info, :hashtags => ["apple", "berry", "carrot"])
      topic.process_tweet!(tweet_info_1)
      tweet_info_2 = build(:tweet_info, :hashtags => ["apple", "carrot"])
      topic.process_tweet!(tweet_info_2)
      tweet_info_3 = build(:tweet_info, :hashtags => ["carrot"])
      topic.process_tweet!(tweet_info_3)

      tweet_info_3 = build(:tweet_info, :old, :hashtags => ["pear"])
      topic.process_tweet!(tweet_info_3)

      expected = [
        {value: "#carrot", count: 3},
        {value: "#apple", count: 2},
        {value: "#berry", count: 1}
      ]

      actual = topic.top_recent_hashtags.map{|ht| ht.slice(:value, :count)}

      expect(actual).to eq(expected)
    end

  end

  describe 'top_recent_usernames' do

    it 'returns counts for recent usernames' do
      tweet_info_1 = build(:tweet_info, :usernames => ["andy", "brian", "christine"])
      topic.process_tweet!(tweet_info_1)
      tweet_info_2 = build(:tweet_info, :usernames => ["andy", "christine"])
      topic.process_tweet!(tweet_info_2)
      tweet_info_3 = build(:tweet_info, :usernames => ["christine"])
      topic.process_tweet!(tweet_info_3)

      tweet_info_3 = build(:tweet_info, :old, :usernames => ["diane"])
      topic.process_tweet!(tweet_info_3)

      expected = [
        {value: "@christine", count: 3},
        {value: "@andy", count: 2},
        {value: "@brian", count: 1}
      ]

      actual = topic.top_recent_usernames.map{|ht| ht.slice(:value, :count)}

      expect(actual).to eq(expected)
    end

  end

  describe 'top_recent_urls' do

    it 'returns counts for recent urls' do
      tweet_info_1 = build(:tweet_info, :urls => ["http://www.acme.com", "http://www.bus.com", "http://www.cab.com"])
      topic.process_tweet!(tweet_info_1)
      tweet_info_2 = build(:tweet_info, :urls => ["http://www.acme.com", "http://www.cab.com"])
      topic.process_tweet!(tweet_info_2)
      tweet_info_3 = build(:tweet_info, :urls => ["http://www.cab.com"])
      topic.process_tweet!(tweet_info_3)

      tweet_info_3 = build(:tweet_info, :old, :urls => ["http://www.dog.com"])
      topic.process_tweet!(tweet_info_3)

      expected = [
        {value: "http://www.cab.com", count: 3},
        {value: "http://www.acme.com", count: 2},
        {value: "http://www.bus.com", count: 1}
      ]

      actual = topic.top_recent_urls.map{|ht| ht.slice(:value, :count)}

      expect(actual).to eq(expected)
    end

  end


  describe 'as_json' do

    it 'should return a hash of relevent values' do

      expected = {
        id: topic.id,
        value: topic.value,
        link: topic.link,
        image_link: topic.image_link,
        data: {
          mentions: topic.recent_tweet_count,
          topUsernames: topic.top_recent_usernames,
          topHashtags: topic.top_recent_hashtags,
          topUrls: topic.top_recent_urls,
        }
      }

      expect(topic.as_json).to eq(expected)

    end

  end

end