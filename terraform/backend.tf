terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-aliferenko91"
   credentials = "/home/set/keys/new-mygcp-cred.json"
   prefix = "webserver/state"
}
}