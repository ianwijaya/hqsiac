when HTTP_REQUEST {
    binary scan [md5 [HTTP::password]] H* password
    if { [HTTP::username] equals "{{ admin_username }}" && $password equals "{{ admin_password | hash('md5') }}" } {
        log local0. "User [HTTP::username] has been authorized to access virtual server kibana"
    } else {
        log local0. "User [HTTP::username] has been denied access to virtual server kibana"
        HTTP::respond 401 WWW-Authenticate "Basic realm=\"Secured Area\""
    }
}
