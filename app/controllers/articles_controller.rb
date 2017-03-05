class ArticlesController < UserController
  def index
    @articles = Article.order(created_at: :desc).includes(:user, taggings: [:tag, taggings: [:tag]])

    @articles = @articles.search_for(params[:search]) if params[:search].present?
    @articles = @articles.to_a

    if params[:tag].present?
      article_ids = Article.search_in_tags(params[:tag])
      @articles.select! { |article| article_ids.include?(article.id) }
    end
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      @article.tag_list.add(tag_params[:tag_list],  parser: SubtagParser)
      @article.save

      @article.save_subtags(tag_params[:tag_list])

      redirect_to articles_path
    else
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def tag_params
    params.require(:article).permit(:tag_list)
  end
end