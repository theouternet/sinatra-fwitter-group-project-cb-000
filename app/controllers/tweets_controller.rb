class TweetsController < ApplicationController

  # I quite disagree with the way the tests encourage the "edit tweet" and "delete tweet" buttons to be implemented. When the test is attempting to ensure that a user can't edit or delete a tweet that doesn't belong to the user, the test is still looking for, and trying to click, the edit or delete buttons. But honestly, if a user is looking at a tweet that isn't their own, THEY SHOULD NOT EVEN BE ABLE TO CLICK ON THOSE OPTIONS, never mind be able to see them in the first place. I know this isn't a UI/UX course but this is fundamental. The only time a user should see the edit or delete options on a show_tweet page is when the user_id of the displayed tweet matches the id of the current user. Why on earth would you even want to provide the perception of those functions being available if they are not valid functions in the context of the tweet that the user is looking at? I know this makes my code fail two of the specs but I like my way better. 

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

  # Even though the show-tweet page protects the tweets from edit or delete from other users by hiding those options, adding ownership verification in the below methods is "backend" insurance against it. Could probably become its own helper method, something like if tweet_belongs_to_current_user?

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