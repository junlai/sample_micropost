#coding: utf-8
require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have an Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "should have a signup page at '/signup'" do
    get '/sign_up'
    response.should have_selector('title', :content => "Sign up")
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "关于我们"
    response.should have_selector('title', :content => "About")
    click_link "帮助"
    response.should have_selector('title', :content => "Help")
    click_link "联系我们"
    response.should have_selector('title', :content => "Contact")
    click_link "主页"
    response.should have_selector('title', :content => "Home")
    click_link "注 册!"
    response.should have_selector('title', :content => "Sign up")

  end
end
