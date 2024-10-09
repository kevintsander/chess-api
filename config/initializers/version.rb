VERSION = File.read(Rails.root.join('.version')).strip
Rails.logger.info "Application Version: #{VERSION}"