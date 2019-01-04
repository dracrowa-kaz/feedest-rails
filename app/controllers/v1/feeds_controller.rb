module V1
  class FeedsController < ApplicationController
    # get
    def show
      articles = []
      @current_user.feeds.each do |feed|
        articles << feed.fetchArticle()
      end
      render json: { articles: articles.flatten.sort { |a, b| a[:published] <=> b[:published] }.reverse, feeds: @current_user.feeds }
    end

    # POST /v1/feeds
    def create
      url = api_params[:url]

      # 有効なurlか実際に取得してチェックする
      render json: { error: t('user_create_error') } if Feed.is_valid_url(url: url)

      feed = Feed.new(api_params)
      feed.user = @current_user

      if @current_user.feeds.find_by(url: url).nil? && feed.save
        render json: feed
      else
        render json: { error: t('user_create_error') }
      end
    end

    def destroy
      url = api_params[:url]
      feed = @current_user.feeds.find_by(url: url)

      if feed.destroy
        render json: feed
      else
        render json: { error: t('feed delete error') }
      end
    end

    def api_params
      params.require(:feed).permit(:title, :url)
    end
  end
end