define :create_ssl_pem, :domain => "", :subject => "" do
  bash "Create #{params[:domain]} SSL Certificates" do
    # Steps
    # =====
    #   1) Create an SSL private key.
    #   2) Create certificate signing request (CSR).
    #   3) Creates pem file.
    #
    # @param node[:fqdn]: The hostname or fqdn of the server.
    # @param node[:stunnel][:server_ssl_req]
    
    cwd "/etc/ssl"
    code <<-EOH
    umask 077
    openssl genrsa 2048 > private/#{params[:domain]}.key
    openssl req -subj "#{params[:subject]}" -new -x509 -nodes -sha1 -days 3650 -key private/#{params[:domain]}.key > certs/#{params[:domain]}.crt
    cat private/#{params[:domain]}.key certs/#{params[:domain]}.crt > certs/#{params[:domain]}.pem
    EOH
    not_if { File.exists?("/etc/ssl/certs/#{params[:domain]}.pem") }
  end
end