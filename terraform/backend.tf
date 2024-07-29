terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-aliferenko1991"
   credentials = "/home/set/keys/new-mygcp-cred.json"
   prefix = "webserver/state"
}
} 