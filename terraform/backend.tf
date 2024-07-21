terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-aliferenko91"
   credentials = "/home/set/keys/mygcp-cred.json"
   prefix = "webserver/state"
}
}