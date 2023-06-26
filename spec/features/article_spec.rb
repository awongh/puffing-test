feature 'Article' do

  scenario 'New user loads articles index page' do
      when_new_user_loads_homepage
      they_see_home_page_content
  end

  def when_new_user_loads_homepage
    visit root_path
  end

  def they_see_home_page_content
    page.driver.wait_for_network_idle
    expect(page).to have_content 'Articles#index'
    # expect(page).to have_content 'testing!'
    expect(page).to have_content 'Hydrogen'
    name_hash = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
    page.driver.save_screenshot("tmp/screenshot-#{name_hash}.png", full: true)


  end
end
