class PushNotification

	CONFIG = YAML.load_file(Rails.root.join("config/gcm.yml"))[Rails.env]
	def self.send_post_chat_notifications(chat)
        gcm = GCM.new(CONFIG["api_key"])
		chat.chatable.members.each do |mem|
			next if mem == chat.user || mem.is_online?(chat.chatable)
			devices = mem.device_tokens
			tokens = devices.map{|t| t.token}
			if !tokens.blank?
				response = gcm.send(tokens, {:data => chat.chat_notification_json})
				Rails.logger.info "gcm log: notification sent to #{mem.name}(#{mem.id}) with #{tokens.length} devices"
				self.process_gcm_response(response, devices)
			end
		end
	end

	def self.process_gcm_response(response, devices)
		begin
            response = JSON.parse(response[:body])
            puts "failed = ", response["failure"], "out of", devices.length
            response["results"].each_with_index do |res, i|
                if res["message_id"]
                    if res["registration_id"]
                    	ExceptionNotifier.notify_exception(Exception.new("Token not registered"), :data => {:response => response.inspect})
                        devices[i].token = res["registration_id"]
                        devices[i].save!
                    end
                elsif res["error"] == "NotRegistered"
                    devices[i].valid_token = false
                    devices[i].save
                end
            end
        rescue JSON::ParserError => e
            ExceptionNotifier.notify_exception(e)
        end
	end
end