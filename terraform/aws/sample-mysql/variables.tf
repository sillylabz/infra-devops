variable "vpc_id" {
    type = string
    description = "vpc id to buil mysql rds resources"
    default = ""
}
variable "tags" {
    type = map(string)
    description = "tags to be applied to resources"
    default = {
        Owner       = "Sam Thompson"
        Environment = "dev"
        "Cost Center" = "1000"
    }
}
 


