require 'rails_helper'

describe 'ユーザー認証のテスト' do
  describe 'ユーザー新規登録' do
    before do
      visit new_user_registration_path
    end

    context '新規登録画面に遷移' do
      it '新規登録に成功する' do
        fill_in 'user[name]', with: Faker::Internet.username(specifier: 5)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'Create New Account'

        expect(page).to have_content 'Profile'
      end
      it '新規登録に失敗する' do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button 'Create New Account'

        expect(page).to have_content 'error'
      end
    end
  end

  describe 'ユーザーログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context 'ログイン画面に遷移' do
      let(:test_user) { user }

      it 'ログインに成功する' do
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'Log In'
        expect(page).to have_content 'Profile'
      end

      it 'ログインに失敗する' do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log In'

        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe 'ユーザーのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log In'
    end

    describe 'プロフィール画面のテスト' do
      context '表示の確認' do
        it 'Profileと表示される' do
          expect(page).to have_content('Profile')
        end
        it '画像が表示される' do
          expect(page).to have_css('img.profile_image')
        end
        it '名前が表示される' do
          expect(page).to have_content(user.name)
        end
        it '自己紹介が表示される' do
          expect(page).to have_content(user.introduction)
        end
        it '編集リンクが表示される' do
          visit user_path(user)
          expect(page).to have_link 'Edit Profile', href: edit_user_path(user)
        end
      end
    end

    describe '編集のテスト' do
      context '自分の編集画面への遷移' do
        it '遷移できる' do
          visit edit_user_path(user)
          expect(current_path).to eq('/users/' + user.id.to_s + '/edit')
        end
      end

      context '表示の確認' do
        before do
          visit edit_user_path(user)
        end

        it 'Edit Profileと表示される' do
          expect(page).to have_content('Edit Profile')
        end
        it '名前編集フォームに自分の名前が表示される' do
          expect(page).to have_field 'user[name]', with: user.name
        end
        it '画像編集フォームが表示される' do
          expect(page).to have_field 'user[profile_image]'
        end
        it '自己紹介編集フォームに自分の自己紹介が表示される' do
          expect(page).to have_field 'user[introduction]', with: user.introduction
        end
        it '編集に成功する' do
          click_button 'Done'
          expect(page).to have_content 'Profile'
          expect(current_path).to eq('/users/' + user.id.to_s)
        end
      end
    end
  end
end
