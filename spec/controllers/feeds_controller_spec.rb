require 'rails_helper'

describe V1::FeedsController, type: :controller do
  describe 'POST #create' do

    it 'Create feed' do
      user = create(:user)
      feed = create(:feed, user: user)

      request.headers['Authorization'] = user.access_token

      post :create, :params => { :feed => { :title => 'qiita.com', :url => 'http://qiita.com/tags/kubernetes/feed.atom' } }
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)
    end

    it 'Show article from json feed' do
      user = create(:user)
      feed = create(:feed, user: user)

      request.headers['Authorization'] = user.access_token

      post :create, :params => { :feed => { :title => 'qiita.com', :url => 'https://qiita.com/api/v2/items.json' } }
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)

      get :show, :params => {}

      expect(response.content_type).to eq('application/json')
      expect(user.feeds.first.articles.count > 0).to eq true
    end

    it 'Show article from xml feed' do
      user = create(:user)
      feed = create(:feed, user: user)

      request.headers['Authorization'] = user.access_token

      post :create, :params => { :feed => { :title => 'qiita.com', :url => 'http://qiita.com/tags/kubernetes/feed.atom' } }
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)

      get :show, :params => {}

      expect(response.content_type).to eq('application/json')
      expect(user.feeds.first.articles.count > 0).to eq true
    end
  end
end