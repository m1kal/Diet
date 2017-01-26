# encoding: UTF-8
require 'sinatra/base'
require_relative 'diet'
require_relative 'serializer'

class WebApp < Sinatra::Base
  set :port, 3000
  enable :sessions

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end

    def authenticate(params)
      return false if h(params[:user]).nil?
      users = JSON.parse(File.read('users.txt'))
      return true if users[h(params[:user]).chomp] == h(params[:password]).chomp
      if users[h(params[:user]).chomp].nil?
        users[h(params[:user]).chomp] = h(params[:password]).chomp
        File.write('users.txt', users.to_json)
        return true
      end
      false
    end

    def load_diet
      $diets[session[:user]] ||
        Diet.from_storage(FileSerializer, session[:user] + '_diet.txt')
    end
  end

  get '/' do
    return erb :login, :locals => { :session => session } if session[:user].nil?
    erb :index, :locals => { :diet => load_diet, :session => session }
  end

  post '/login' do
    if authenticate(params)
      session[:user] = h(params[:user])
      $diets[session[:user]] = load_diet
    end
    redirect to '/'
  end

  get '/day/:date' do
    $diets[session[:user]].select_day(h(params[:date]))
    redirect to '/'
  end

  post '/' do
    $diets[session[:user]]
      .add_meal(:name => h(params[:name]),
                :calories => h(params[:calories]).to_i)
    redirect to '/'
  end

  post '/add_day' do
    $diets[session[:user]].add_day(Day.new(h(params[:date])))
                          .merge_duplicate_days.select_day(h(params[:date]))
    redirect to '/'
  end

  get '/clear/:date' do
    $diets[session[:user]].clear_day(h(params[:date]))
    redirect to '/'
  end

  get '/logout' do
    $diets[session[:user]] = nil
    session[:user] = nil
    redirect to '/'
  end

  get '/save' do
    $diets[session[:user]]
      .to_storage(FileSerializer, session[:user] + '_diet.txt')
    redirect to '/'
  end
end

$diets = {}
WebApp.run!
