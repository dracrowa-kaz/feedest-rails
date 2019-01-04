require 'net/http'

module V1
  class TagsController < ApplicationController
    # get
    def show
      tags = @current_user.tags
      render json: { tags: tags }
    end

    # POST /v1/tags
    def create
      if tag_name_param = api_params[:tag_name]
        # オリジナルタグ情報を追加
        Tag.register_original_tag(original_tag: tag_name_param, current_user: @current_user)
      else
        # qiita apiからタグ情報を追加
        item_id = api_params[:item_id]
        Tag.register_qiita_tags(item_id: item_id, current_user: @current_user)

        # 既読情報の追加
        Article.mark_as_read(item_id: item_id)
      end

      render json: "ok"
    end

    # , 区切りで名前を複数渡す
    def api_params
      params.require(:tag).permit(:item_id, :tag_name)
    end
  end
end