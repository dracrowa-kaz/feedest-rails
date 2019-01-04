require 'rails_helper'

describe V1::TagsController, type: :controller do
  describe 'POST #create' do
    it 'Create tags' do
      user = create(:user)
      feed = create(:feed, user: user)
      article = create(:article)

      request.headers['Authorization'] = user.access_token
      
      post :create, :params => { :tag => { :item_id => 'b39f8b166b5c5ec86c0e' } }
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)
      
      expect(Tag.find_by(name: '機械学習').present?).to eq true
      expect(Article.find(1).read).to eq true
    end

    it 'Not create tags in same day' do
      user = create(:user)
      request.headers['Authorization'] = user.access_token
      post :create, :params => { :tag => { :item_id => 'b39f8b166b5c5ec86c0e' } }
      expect(response).to have_http_status(:ok)

      post :create, :params => { :tag => { :item_id => 'b39f8b166b5c5ec86c0e' } }
      expect(response).to have_http_status(:ok)
      expect(Tag.find_by(name: '機械学習').present?).to eq true
    end

    it 'Fetch tag' do
      user = create(:user)
      request.headers['Authorization'] = user.access_token
      post :create, :params => { :tag => { :item_id => 'b39f8b166b5c5ec86c0e' } }
      expect(response).to have_http_status(:ok)
      get :show
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json['tags'].count).to eq(5)
    end

    it 'Manual add tag' do
      user = create(:user)
      request.headers['Authorization'] = user.access_token
      post :create, :params => { :tag => { :tag_name => 'テスト' } }
      expect(response).to have_http_status(:ok)
      get :show
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(Tag.find_by(name: 'テスト').present?).to eq true
    end
  end
end