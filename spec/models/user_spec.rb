require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'ユーザー登録' do
    it 'ユーザー名が空の時にnot valid' do
      user = User.new(email: "foobar@gmail.com", password: "foobarbaz")
      expect(user).not_to be_valid
    end
    
    it 'パスワードが空の時にnot valid' do
      user = User.new(name: "foobar", email: "foobar@gmail.com")
      expect(user).not_to be_valid
    end
    
    it 'パスワードが6文字未満の時にnot valid' do
      user = User.new(name: "foobar", email: "foobargmailcom", password: "fooba")
      expect(user).not_to be_valid
    end
    
    it 'メアドが空の時にnot valid' do
      user = User.new(name: "foobar", password: "foobarbaz")
      expect(user).not_to be_valid
    end
    
    it 'メアドが不正なフォーマットの時にnot valid' do
      user = User.new(name: "foobar", email: "foobargmailcom", password: "foo")
      expect(user).not_to be_valid
    end
    
    it '名前、メアド、パスワードが存在すればvalid' do
      user = User.new(name: "foobar", email: "foobar@gmail.com", password: "foobar")
      expect(user).to be_valid
    end
    
    describe 'クラスメソッド' do
      
    end
    
  end
  
end
