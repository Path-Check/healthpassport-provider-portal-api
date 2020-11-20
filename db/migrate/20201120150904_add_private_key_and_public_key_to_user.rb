require 'openssl'

class AddPrivateKeyAndPublicKeyToUser < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :private_key, :string
    add_column :users, :public_key, :string

    User.all.each do |user|
      rsa_key = OpenSSL::PKey::RSA.new(1024)
      user.private_key = rsa_key.to_pem
      user.public_key = rsa_key.public_key.to_pem

      user.save
    end

  end

  def self.down
    remove_column :users, :private_key
    remove_column :users, :public_key
  end
end
