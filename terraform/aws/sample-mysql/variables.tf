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
        "Cost Center" = "0023"
    }
}
 
variable "additonal_sg_cidrs" {
    type = list(string)
    description = "additional cidrs allowed to access rds cluster"
    default = []
}
 


