
data "aws_route53_zone" "web" {
  #this zone is not managed by AWS
  name = "${var.web_cv_domain}."
}

resource "aws_route53_record" "web_cv_main" {
    zone_id = "${data.aws_route53_zone.web.zone_id}"
    name    = "${var.web_cv_domain}"
    type    = "A"
    records = ["${aws_eip.web_cv.public_ip}"]
    ttl     = "30"
}

resource "aws_route53_record" "web_cv_www" {
    zone_id = "${data.aws_route53_zone.web.zone_id}"
    name    = "www.${var.web_cv_domain}"
    type    = "A"

    alias {
        name    = "${var.web_cv_domain}"
        zone_id = "${data.aws_route53_zone.web.zone_id}"
        evaluate_target_health = false
    }
    #TODO: TF seems to create thse two record sets wihtout dependency by default - am i doing it wrong?
    depends_on = ["aws_route53_record.web_cv_main"]
}

resource "aws_route53_record" "web_cv_beta" {
  zone_id = "${data.aws_route53_zone.web.zone_id}"
  name    = "beta.${var.web_cv_domain}"
  type    = "A"
  records = ["${aws_eip.web_cv_beta.public_ip}"]
  ttl     = "10"
  depends_on = ["aws_route53_record.web_cv_main"]
}
