class ArticlesController < UserController
  def index
    @articles = Article.order(created_at: :desc)
    @articles = @articles.search(params[:search]) if params[:search].present?
    @articles = @articles.tagged_with(params[:tag]) if params[:tag].present?
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path
    else
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :tag_list)
  end
end