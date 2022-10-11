module vdcclient

pub struct VDC {
pub:
	vdc_name        string
	owner_tname     string
	solution_uuid   string
	identity_tid    int
	s3              S3
	kubernetes      []Kubernetes
	etcd            Etcd
	threebot        Threebot
	created         u64
	last_updated    u64
	is_blocked      bool
	explorer_url    string
	flavor          string
	expiration_days int
	expiration_date f64
	total_capacity  int
	wallet          Wallet
	price           int
	vmachines       VM
}

pub struct S3 {
pub:
	minio      Minio
	zdbs       []ZDB
	domain     string
	domain_wid int
}

pub struct Minio {
pub:
	ip_address string
	wid        int
	node_id    string
	pool_id    int
}

pub struct ZDB {
pub:
	size          int
	port          int
	namespace     string
	proxy_address string
	ip_address    string
	wid           int
	node_id       string
	pool_id       int
}

pub struct Kubernetes {
pub:
	role       string
	public_ip  string
	ip_address string
	wid        int
	node_id    string
	pool_id    int
	size       int
}

pub struct Etcd {
pub:
	ip_address string
}

pub struct Threebot {
pub:
	domain     string
	ip_address string
	wid        int
	node_id    string
	pool_id    int
}

pub struct Wallet {
pub:
	address  string
	network  string
	secret   string
	balances []Balances
}

struct Balances {
pub:
	balance      string
	asset_code   string
	asset_issuer string
}

pub struct Pool {
pub:
	pool_id             int
	cus                 f64
	sus                 f64
	ipv4us              f64
	node_ids            []string
	last_updated        u64
	active_cu           f64
	active_su           f64
	active_ipv4         f32
	empty_at            u64
	customer_tid        int
	active_workload_ids []int
}

pub struct Alert {
pub:
	id               int
	level            int
	app_name         string
	category         string
	message          string
	public_message   string
	count            int
	status           string
	first_occurrence u64
	last_occurrence  u64
	data             string
	event            Event
	tracebacks       []Traceback
mut:
	alert_type string [json: 'type']
}

pub struct Backup {
pub:
	name                 string
	vdc_backup           string
	config_backup        string
	expiration           u64
	status               string
	start_timestamp      u64
	completion_timestamp u64
	errors               int
mut:
	progress BackupProgress
}

struct BackupProgress {
mut:
	total_items   int [json: totalItems]
	item_backedup int [json: itemsBackedUp]
}

struct Event {
}

struct Traceback {
pub:
	raw        string
	stacktrace []Stacktrace
	process_id int
}

struct Stacktrace {
pub:
	filename string
	filepath string
	context  string
	linenr   int
	code     string
}

pub struct DeleteResponse {
pub:
	success bool
}

pub struct Status {
pub:
	running bool
}

struct AddNode {
	capacity int
	farm     string
}

pub struct PublicIP {
	wid     int
	address string
}

pub struct Resources {
pub:
	cru int
	mru int
	sru int
}

pub struct VM {
pub:
	name       string
	wid        int
	resources  Resources
	size       int
	ip_address string
	public_ip  PublicIP
	pool_id    int
	node_id    string
}

pub struct AddVM {
pub:
	name             string
	size             int
	ssh_public_key   string
	enable_public_ip bool
	farm_name        string
}
