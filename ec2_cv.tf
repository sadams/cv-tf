data "template_file" "web_user_data" {
  template = "${file("web_cv_user_data.sh")}"
  vars = {
    #TODO: is there a way to not do this???
    web_cv_ansible_playbook = "${var.web_cv_ansible_playbook}"
    web_cv_ansible_checkout_dir = "${var.web_cv_ansible_checkout_dir}"
    web_cv_ansible_repo = "${var.web_cv_ansible_repo}"
    web_cv_ansible_branch = "${var.web_cv_ansible_branch}"
  }
}

resource "aws_instance" "web_cv" {
    ami = "${lookup(var.web_cv_region_amis, var.aws_region)}"
    availability_zone = "${var.aws_az}"
    instance_type = "${var.web_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = [
      "${aws_security_group.web.id}",
      "${aws_security_group.ssh.id}"
    ]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    user_data = "${data.template_file.web_user_data.rendered}"
    tags {
        Name = "cv_web_server"
    }
}

resource "aws_eip" "web_cv" {
    instance = "${aws_instance.web_cv.id}"
    vpc = true
}
