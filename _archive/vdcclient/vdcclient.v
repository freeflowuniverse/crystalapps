module vdcclient

import json
import encoding.base64

pub struct Client {
pub:
	url      string
	vdcname  string
	password string
}

pub fn (client Client) get_vdc_info() (VDC, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/vdc'

	response := get(full_url, auth_cred)
	return json.decode(VDC, response.body) or {}, response.status_code
}

pub fn (client Client) list_kubernetes_nodes() ([]Kubernetes, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/node'

	response := get(full_url, auth_cred)
	return json.decode([]Kubernetes, response.body) or {}, response.status_code
}

pub fn (client Client) add_kubernetes_node(flavor string) ([]int, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode({
		'flavor': flavor
	})
	full_url := client.url + '/api/controller/node'

	response := post(full_url, auth_cred, body)
	return json.decode([]int, response.body) or {}, response.status_code
}

pub fn (client Client) delete_kubernetes_node(wid int) (DeleteResponse, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode({
		'wid': wid
	})
	full_url := client.url + '/api/controller/node'

	response := delete(full_url, auth_cred, body)
	return json.decode(DeleteResponse, response.body) or {}, response.status_code
}

pub fn (client Client) list_storage_nodes() ([]ZDB, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/zdb'

	response := get(full_url, auth_cred)
	return json.decode([]ZDB, response.body) or {}, response.status_code
}

pub fn (client Client) add_storage_node(capacity int, farm string) ([]int, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode(AddNode{
		capacity: capacity
		farm: farm
	})
	full_url := client.url + '/api/controller/zdb'

	response := post(full_url, auth_cred, body)
	return json.decode([]int, response.body) or {}, response.status_code
}

pub fn (client Client) delete_storage_node(wid int) (DeleteResponse, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode({
		'wid': wid
	})
	full_url := client.url + '/api/controller/zdb'

	response := delete(full_url, auth_cred, body)
	return json.decode(DeleteResponse, response.body) or {}, response.status_code
}

pub fn (client Client) get_vdc_wallet() (Wallet, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/wallet'

	response := get(full_url, auth_cred)
	return json.decode(Wallet, response.body) or {}, response.status_code
}

pub fn (client Client) get_used_pools() ([]Pool, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/pools'

	response := get(full_url, auth_cred)
	return json.decode([]Pool, response.body) or {}, response.status_code
}

pub fn (client Client) get_alerts(application string) ([]Alert, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	// body := json.encode({"application": application})
	full_url := client.url + '/api/controller/alerts/' + application

	response := get(full_url, auth_cred)
	return json.decode([]Alert, response.body) or {}, response.status_code
}

pub fn (client Client) get_kubeconfig() (string, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/kubeconfig'
	response := get(full_url, auth_cred)

	return response.body, response.status_code
}

pub fn (client Client) get_zstor_config(ip_version int) (string, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode({
		'ip_version': ip_version
	})
	full_url := client.url + '/api/controller/zstor_config'

	response := get_with_body_param(full_url, auth_cred, body)
	return response.body, response.status_code
}

pub fn (client Client) get_status() (Status, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/status'

	response := get(full_url, auth_cred)
	return json.decode(Status, response.body) or {}, response.status_code
}

pub fn (client Client) get_backup() ([]Backup, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/backup'

	response := get(full_url, auth_cred)
	return json.decode([]Backup, response.body) or {}, response.status_code
}

pub fn (client Client) list_vms() ([]VM, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	full_url := client.url + '/api/controller/vmachine'

	response := get(full_url, auth_cred)
	return json.decode([]VM, response.body) or {}, response.status_code
}

pub fn (client Client) add_vm(add_vm_request_body AddVM) ([]int, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode(add_vm_request_body)
	full_url := client.url + '/api/controller/vmachine'

	response := post(full_url, auth_cred, body)
	return json.decode([]int, response.body) or {}, response.status_code
}

pub fn (client Client) delete_vm(wid int) (DeleteResponse, int) {
	auth_cred := base64.encode_str('$client.vdcname:$client.password')
	body := json.encode({
		'wid': wid
	})
	full_url := client.url + '/api/controller/vmachine'

	response := delete(full_url, auth_cred, body)
	return json.decode(DeleteResponse, response.body) or {}, response.status_code
}
