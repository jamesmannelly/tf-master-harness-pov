data "template_file" "user_data" {
template = "${file("install.sh")}"
}