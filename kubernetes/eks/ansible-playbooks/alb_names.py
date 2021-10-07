#!/usr/bin/env python3

import binascii
import hashlib
import re


def generate_alb_name_prefix(cluster):
    hash = binascii.crc32(cluster.encode("utf-8"))
    return "{:#010x}".format(hash)[2:]


def name_lb(cluster, namespace, ingress):
    hash = hashlib.md5((namespace + ingress).encode("utf-8")).hexdigest()[:4]
    alb_name_prefix = generate_alb_name_prefix(cluster)

    name = "{0}-{1}-{2}".format(
        re.sub("[\\W]", "-", alb_name_prefix),
        re.sub("[\\W]", "", namespace),
        re.sub("[\\W]", "", ingress)
    )

    if len(name) > 26:
        name = name[:26]

    name = name + "-" + hash

    return name


def name_lbsg(cluster, namespace, ingress):
    return name_lb(cluster, namespace, ingress)


def name_tg(cluster, namespace, ingress, service, service_port, protocol, target_type):
    alb_name_prefix = generate_alb_name_prefix(cluster)
    lb_name = name_lb(cluster, namespace, ingress)

    hash = hashlib.md5((lb_name + service + service_port + protocol + target_type).encode("utf-8")).hexdigest()
    return "{0}-{1}".format(alb_name_prefix[:12], hash[:19])


if __name__ == "__main__":
    print("Enter the input values")
    cluster = input("cluster: ")
    namespace = input("namespace: ")
    ingress = input("ingress: ")
    service = input("service: ")
    service_port = input("service port: ")
    protocol = input("protocol: ")
    target_type = input("target type: ")

    print("\nOutput names to use")
    print("alb name: " + name_lb(cluster, namespace, ingress))
    print("sg name: " + name_lbsg(cluster, namespace, ingress))
    print("tg name: " + name_tg(cluster, namespace, ingress, service, service_port, protocol, target_type))


