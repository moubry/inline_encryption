module InlineEncryption

  module Base


    # @param [String] data encryption target
    # @return [String] encrypted target
    # @raise [EncryptionFailureError] couldn't encrypt the target
    def encrypt!(data)
      config.check_required_variables

      begin
        encrypted = config.real_key.private_encrypt(data)
        converted = Base64.encode64(encrypted)
      rescue => e
        err = EncryptionFailureError.exception "Target: #{data}"
        raise err
      end
    end


    # @param [String] encryption target
    # @return [String] encrypted target, or fail_text on error (default data)
    def encrypt(data, fail_text=nil)
      config.check_required_variables

      begin
        encrypt!(data)
      rescue EncryptionFailureError => e
        return fail_text.nil? ? data : fail_text.to_s
      end
    end


    # @param [String] data decryption target
    # @return [String] decrypted target
    # @raise [DecryptionFailureError] couldn't decrypt the target
    def decrypt!(data)
      config.check_required_variables

      begin
        converted = Base64.decode64(data)
        decrypted = config.real_key.public_key.public_decrypt(converted)
      rescue => e
        err = DecryptionFailureError.exception "Encrypted: #{data}"
        raise err
      end
    end


    # @param [String] decryption target
    # @param [String] text to be returned in the case of a decryption failure
    # @return [String] decrypted target
    def decrypt(data, fail_text=nil)
      config.check_required_variables

      begin
        decrypt!(data)
      rescue DecryptionFailureError => e
        return fail_text.nil? ? data : fail_text.to_s
      end
    end


    # @return [InlineEncryption::Config] the configuration instance
    def config
      @config ||= Config.new
    end

  end

end