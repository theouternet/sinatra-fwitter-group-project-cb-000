class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            erb :'/tweets/tweets'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'/tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        tweet = current_user.tweets.build(params)
        if tweet.save
            redirect to "/tweets/#{tweet.id}"
        else
            redirect to '/tweets/new'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'/tweets/show_tweet'
        else
            redirect '/login'
        end
    end
    
    
    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user_id == current_user.id
                erb :'/tweets/edit_tweet'
            else
                redirect "/tweets/#{@tweet.id}"
            end
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet.user_id == current_user.id
            if @tweet.update(content: params[:content])
                redirect "/tweets/#{@tweet.id}"
            else
                redirect "/tweets/#{@tweet.id}/edit" #reloads edit form if content blank
            end
        else
            redirect "/tweets/#{@tweet.id}"
        end
        
    end

    delete '/tweets/:id' do
        tweet = Tweet.find_by_id(params[:id])
        if tweet.user_id == current_user.id
            tweet.destroy
            redirect "/tweets"
        else
            redirect "/tweets/#{tweet.id}"
        end
    end

end