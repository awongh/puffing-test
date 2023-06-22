feature 'Article' do
  after(:each) do |example|

    browser = Capybara.current_session.driver.browser

    if example.exception
      byebug
    end

  end

  scenario 'New user loads articles index page' do
      when_new_user_loads_homepage
      they_see_home_page_content
  end

  def when_new_user_loads_homepage
    visit root_path
  end

  def they_see_home_page_content
    page.driver.wait_for_network_idle
    name_hash = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
    page.driver.save_screenshot("tmp/screenshot-#{name_hash}.png", full: true)

    expect(page).to have_content 'Articles#index'
    expect(page).to have_content 'testing!'
  end
end
