# encoding: UTF-8
require 'sinatra/base'
require_relative 'diet'
require_relative 'serializer'
require_relative 'mem_serializer'

# WebApp
class WebApp < Sinatra::Base
  set :port, 3000
  enable :sessions

  helpers do
    def h(key)
      Rack::Utils.escape_html(params[key])
    end

    def authenticate
      return false if h(:user).nil?
      check_user || add_user
    end

    def check_user(check_if_available = false)
      users = JSON.parse(File.read('users.txt'))
      user = h(:user).chomp
      check_if_available ? users[user].nil? : users[user] == h(:password).chomp
    end

    def add_user
      if check_user(true)
        users = JSON.parse(File.read('users.txt'))
        users[h(:user).chomp] = h(:password).chomp
        File.write('users.txt', users.to_json)
        return true
      end
      false
    end

    def load_diet
      Diet.from_storage(FileSerializer, (session[:user] || '') + '_diet.txt')
    end
  end

  before do
    @diet = Diet.from_storage(MemSerializer, session[:session_id])
  end

  after do
    @diet.to_storage(MemSerializer, session[:session_id]) unless @diet.nil?
  end

  get '/' do
    return erb :login, locals: { session: session } if session[:user].nil?
    erb :index, locals: { diet: @diet, session: session }
  end

  post '/login' do
    if authenticate
      session[:user] = h(:user)
      @diet = load_diet
    end
    redirect to '/'
  end

  get '/day/:date' do
    @diet.select_day(h(:date))
    redirect to '/'
  end

  post '/' do
    @diet.add_item(type: h(:type), name: h(:name), calories: h(:calories).to_i)
    redirect to '/'
  end

  post '/add_day' do
    @diet.add_day(Day.new(h(:date)))
         .merge_duplicate_days.select_day(h(:date))
    redirect to '/'
  end

  get '/clear/:date' do
    @diet.clear_day(h(:date))
    redirect to '/'
  end

  get '/logout' do
    @diet = nil
    session[:user] = nil
    MemSerializer.save(nil, session[:session_id])
    redirect to '/'
  end

  get '/save' do
    @diet.to_storage(FileSerializer, session[:user] + '_diet.txt')
    redirect to '/'
  end
end

WebApp.run!
