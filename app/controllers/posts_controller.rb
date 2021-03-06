class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def search
    univ = Univ.find(params[:id])
    @q = univ.posts.ransack(params[:q])
    @posts = @q.result
    if params[:q]
      @query = params[:q][:subject_cont]
    elsif params[:subject]
      @query = params[:subject]
      @posts = univ.posts.where(subject: @query)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @komento = Comment.where(post_id: params[:id])
    @comments = @post.comments
    @comment = Comment.new(post_id: @post.id, user_id: current_user.try(:id))
    @is_own_post = false
    if user_signed_in?
      @like = Like.where(user_id: current_user.id)
      if @post.user.id == current_user.id
        @is_own_post = true
      end
    end
  end

  # GET /posts/new
  def new
    # univ = Univ.find()
    @post = Post.new(univ_id: params[:id], user_id:current_user.id)
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    redirect_to univ_path(@post.univ_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :univ_id, :subject, :body, :title)
    end
end
