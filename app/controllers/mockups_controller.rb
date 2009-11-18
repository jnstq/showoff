class MockupsController < ApplicationController
  
  def frameset
    render :layout => false
  end

  def index
    @entries = []
    @directories = ActiveSupport::OrderedHash.new

    Dir.glob File.join(Rails.root, 'app', 'views', 'mockups', '**', '[^_]*.html*') do |template|
      parent_dir = File.dirname(template).split(/[\/]/).last
      template_name = File.basename(template).split('.').first

      if parent_dir == 'mockups'
        @entries << template_name
      else
        (@directories[parent_dir] ||= []) << template_name
      end
    end

    render :layout => false
  end

  def show
    session[:template_name] = params[:template_name]
    session[:parent_dir]    = params[:parent_dir]
    template_full_path = extract_full_path(File.join(['mockups', params[:parent_dir], params[:template_name]].compact))
    render :file => template_full_path, :layout => extract_layout(template_full_path), :content_type => 'text/html'
  end

  private
  
  def extract_full_path(file)
    full_path = File.join(Rails.root, 'app', 'views', file) 
    Dir.glob("#{full_path}*").first
  end
  
  def extract_layout(file)
     parts = File.basename(file).split('.')
     parts.length < 4 || parts.last
  end

end
