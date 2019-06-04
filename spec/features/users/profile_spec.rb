require 'rails_helper'

RSpec.describe 'user profile', type: :feature do
  before :each do
    @user = create(:user)
    address = create(:address, user: @user)
  end

  describe 'registered user visits their profile' do
    it 'shows user information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      within '#profile-data' do
        expect(page).to have_content("Role: #{@user.role}")
        expect(page).to have_content("Email: #{@user.email}")
        within '.address-details' do
          expect(page).to have_content("#{@user.addresses.first.address}")
          expect(page).to have_content("#{@user.addresses.first.city}")
          expect(page).to have_content("#{@user.addresses.first.state}")
          expect(page).to have_content("#{@user.addresses.first.zip}")
          expect(page).to have_content("#{@user.addresses.first.nickname}")
        end
        expect(page).to have_link('Edit Profile Data')
      end
    end
  end

  describe 'registered user edits their profile' do
    describe 'edit user form' do
      xit 'pre-fills form with all but password information' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit profile_path
        click_link 'Edit'
        expect(current_path).to eq('/profile/edit')
        expect(find_field('Name').value).to eq(@user.name)
        expect(find_field('Email').value).to eq(@user.email)
        expect(find_field("Address").value).to eq(@user.addresses.first.address)
        expect(find_field("City").value).to eq(@user.addresses.first.city)
        expect(find_field("State").value).to eq(@user.addresses.first.state)
        expect(find_field("Zip").value).to eq(@user.addresses.first.state)
        expect(find_field('Password').value).to eq(nil)
        expect(find_field('Password confirmation').value).to eq(nil)
      end
    end

    describe 'user information is updated' do
      before :each do
        @updated_name = 'Updated Name'
        @updated_email = 'updated_email@example.com'
        @updated_address = 'newest address'
        @updated_city = 'new new york'
        @updated_state = 'S. California'
        @updated_zip = '33333'
        @updated_password = 'newandextrasecure'
      end

      describe 'succeeds with allowable updates' do
        xscenario 'all attributes are updated' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email
          fill_in :user_address_address, with: @updated_address
          fill_in :user_address_city, with: @updated_city
          fill_in :user_address_state, with: @updated_state
          fill_in :user_address_zip, with: @updated_zip
          fill_in :user_password, with: @updated_password
          fill_in :user_password_confirmation, with: @updated_password

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
            within '.address-details' do
              expect(page).to have_content("#{@updated_address}")
              expect(page).to have_content("#{@updated_city}, #{@updated_state} #{@updated_zip}")
            end
          end
          expect(updated_user.password_digest).to_not eq(old_digest)
        end
        xscenario 'works if no password is given' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email
          fill_in :user_address_address, with: @updated_address
          fill_in :user_address_city, with: @updated_city
          fill_in :user_address_state, with: @updated_state
          fill_in :user_address_zip, with: @updated_zip

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
            within '.address-details' do
              expect(page).to have_content("#{@updated_address}")
              expect(page).to have_content("#{@updated_city}, #{@updated_state} #{@updated_zip}")
            end
          end
          expect(updated_user.password_digest).to eq(old_digest)
        end
      end
    end

    it 'fails with non-unique email address change' do
      create(:user, email: 'megan@example.com')
      login_as(@user)

      visit edit_profile_path

      fill_in :user_email, with: 'megan@example.com'

      click_button 'Submit'

      expect(page).to have_content("Email has already been taken")
    end
  end 
  describe 'shows button to add address' do 
    it 'button takes them to new address page' do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      
      visit profile_path(@user)

      expect(page).to have_button("Add Address")
      click_button "Add Address"
      expect(current_path).to eq(new_profile_address_path(@user))
    end
    it 'can create new address' do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path(@user)

      click_button "Add Address"

      fill_in "address[nickname]", with: "work" 
      fill_in "address[address]", with: "1223 address"
      fill_in "address[city]", with: "denver"
      fill_in "address[state]", with: "CO"
      fill_in "address[zip]", with: "4444"
      click_on "Create Address" 

      address = Address.last.reload
      address.reload
      @user.reload

      expect(current_path).to eq(profile_path(@user))
      expect(page).to have_content(address.nickname)
      expect(page).to have_content(address.address)
      expect(page).to have_content(address.city)
      expect(page).to have_content(address.state)
      expect(page).to have_content(address.zip)
    end 
  end 
end
