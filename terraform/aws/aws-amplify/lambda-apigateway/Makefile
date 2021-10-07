# Make terraform commands shorter
domain_name="sillycloudz.com"
hosted_zone_id=$(aws route53 list-hosted-zones-by-name | jq --arg name "sillycloudz.com." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id' | cut -d "/" -f 3)

init: 
	terraform init --upgrade

plan: 
	terraform plan \
		-var "route53_zone_id=$(hosted_zone_id)" \
		-var "domain_name=$(domain_name)"

apply:
	terraform apply \
		-var "route53_zone_id=$(hosted_zone_id)" \
		-var "domain_name=$(domain_name)" \
		-auto-approve

destroy:
	terraform destroy -auto-approve \
		-var "route53_zone_id=$(hosted_zone_id)" \
		-var "domain_name=$(domain_name)" \
		-auto-approve

validate: 
	terraform validate .

fmt:
	terraform fmt .


