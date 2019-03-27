require 'rails_helper'

RSpec.describe Studio, type: :model do
  
  describe 'studio' do
    
    context '正しいデータを入れた場合' do
      subject { FactoryBot.build(:studio) }
      it '登録できること' do
        expect(subject.save).to be_truthy
      end
    end
    
    context 'すでにデータがある場合' do
      subject { FactoryBot.create(:studio) }
      it '編集できること' do
        subject.name = "埼玉スタジオ"
        expect(subject.save).to be_truthy
      end
      it '削除できること' do
        expect(subject.destroy).to be_truthy
      end
    end
    
    context '不正なデータを入れた場合' do
      context 'なにも入れない場合' do
        subject { Studio.new }
        it 'エラーになること' do
          expect(subject).not_to be_valid
          expect(subject.errors.messages[:name]).not_to be_empty
          expect(subject.errors.messages[:address]).not_to be_empty
          expect(subject.errors.messages[:created_user_id]).not_to be_empty
        end
      end
      
      context '名前が51文字以上の場合' do
        subject { FactoryBot.build(:studio, name:"a"*51) }
        it 'エラーになること' do
          expect(subject).not_to be_valid
          expect(subject.errors.messages[:name]).not_to be_empty
          expect(subject.errors.messages.count).to eq 1
        end
      end
     
      context '住所が101文字以上の場合' do
        subject { FactoryBot.build(:studio, address:"a"*101) }
          it 'エラーになること' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:address]).not_to be_empty
            expect(subject.errors.messages.count).to eq 1
        end
      end
      
      context 'place_idが重複する場合' do
        before do
          FactoryBot.create(:studio)
        end
        subject { FactoryBot.build(:studio) }
        it 'エラーになること' do
          expect(subject).not_to be_valid
          expect(subject.errors.messages[:place_id]).not_to be_empty
          expect(subject.errors.messages.count).to eq 1
        end
      end
    end
  end    
end