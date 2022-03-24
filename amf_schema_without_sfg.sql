CREATE DATABASE amf;
use amf;
CREATE TABLE amf_action (
	action_id UUID NOT NULL,
	action_name TEXT NOT NULL,
	action_type TEXT NOT NULL,
	parameter JSONB NOT NULL,
	description TEXT NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary" PRIMARY KEY (action_id)
);
CREATE TABLE amf_auditlog (
	id UUID NOT NULL,
	entity_name TEXT NOT NULL,
	action_performed TEXT NOT NULL,
	appuser_id UUID NOT NULL,
	performed_on TIMESTAMPTZ NOT NULL,
	reference_id UUID NOT NULL,
	remarks JSONB NOT NULL,
	CONSTRAINT "primary_auditlog" PRIMARY KEY (id)
);
CREATE TABLE amf_comm_profile (
	protocol_id UUID NOT NULL,
	mailbox_id UUID NOT NULL,
	comm_type TEXT NOT NULL,
	operation TEXT NOT NULL,
	protocol_name TEXT NOT NULL,
	parameter JSONB NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	status_action TEXT NOT NULL,
	profile_name TEXT NOT NULL,
	CONSTRAINT "primary_comm_profile" PRIMARY KEY (protocol_id)
);

CREATE TABLE amf_comm_rule (
	rule_id UUID NOT NULL,
	sender TEXT NOT NULL,
	receiver TEXT NOT NULL,
	msg_type TEXT NOT NULL,
	action_id UUID NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	delivery_type TEXT NULL DEFAULT 'Scheduled',
	communications_workflow TEXT NULL,
	delivery TEXT NULL DEFAULT 'Default Delivery',
	bp_name TEXT NULL,
	schedule_name TEXT NULL,
	schedule_status TEXT NULL DEFAULT 'start schedule',
	CONSTRAINT "primary_commrule_id" PRIMARY KEY (rule_id)
);

CREATE TABLE amf_customer (
	customer_id UUID NOT NULL,
	customer TEXT NOT NULL,
	billing_id TEXT NOT NULL,
	email TEXT NOT NULL,
	phone_number TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	active BOOL NOT NULL,
	CONSTRAINT "primary_customer" PRIMARY KEY (customer_id)
);

CREATE TABLE amf_delivery (
	delivery_id UUID NOT NULL,
	time_queued TIMESTAMPTZ NOT NULL,
	message_id UUID NOT NULL,
	file_name TEXT NOT NULL,
	file_path TEXT NOT NULL,
	message_type TEXT NOT NULL,
	next_time TIMESTAMPTZ NOT NULL,
	sender TEXT NOT NULL,
	receiver TEXT NOT NULL,
	status TEXT NOT NULL,
	orig_file TEXT NULL,
	deleted BOOL NULL DEFAULT false,
    locked BOOL NULL DEFAULT false,
	CONSTRAINT "primary_delivery" PRIMARY KEY (delivery_id)
);
CREATE TABLE amf_event (
	event_id UUID NOT NULL,
	level TEXT NULL,
	message_id UUID NULL,
	session_id UUID NOT NULL,
	action_id UUID NULL,
	text TEXT NULL,
	status TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	created_by TEXT NOT NULL,
	CONSTRAINT "primary_event" PRIMARY KEY (event_id)
);
CREATE INDEX  amf_event_session_id_idx on amf_event (session_id ASC);
CREATE INDEX  amf_event_create_time_idx on amf_event(create_time ASC);

CREATE TABLE amf_feedback (
	fb_id UUID NOT NULL,
	user_id UUID NOT NULL,
	request_type TEXT NOT NULL,
	details TEXT NOT NULL,
	status INT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_feedback" PRIMARY KEY (fb_id)
);

CREATE TABLE amf_file_upload (
	file_id UUID NOT NULL,
	document TEXT NOT NULL,
	document_type TEXT NOT NULL,
	protocol_name TEXT NOT NULL,
	document_name TEXT NOT NULL,
	file_updated BOOL NOT NULL,
	CONSTRAINT "primary_amf_file_upload" PRIMARY KEY (file_id)
);

CREATE TABLE amf_fw_rules (
	fw_rule_id UUID NOT NULL,
	business_need TEXT NOT NULL,
	source_ip TEXT NOT NULL,
	source_server_name TEXT NOT NULL,
	destination_ip TEXT NOT NULL,
	destination_server_name TEXT NOT NULL,
	protocol TEXT NOT NULL,
	port_number TEXT NOT NULL,
	duration TEXT NOT NULL,
	additional_details TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_amf_fw_rules" PRIMARY KEY (fw_rule_id)
);

CREATE TABLE amf_import_document (
	doc_id UUID NOT NULL,
	document_name TEXT NOT NULL,
	file_name TEXT NOT NULL,
	user_audit_info JSONB NOT null,
	CONSTRAINT "primary_amf_import_document" PRIMARY KEY (doc_id)

);

CREATE TABLE amf_import_transactions (
	trans_id UUID NOT NULL,
	reference_id UUID NOT NULL,
	import_type TEXT NOT NULL,
	response_code TEXT NOT NULL,
	notes TEXT NOT NULL,
	raw_data JSONB NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_amf_import_transactions" PRIMARY KEY (trans_id)
);

CREATE TABLE amf_match (
	sender TEXT NOT NULL,
	match_id UUID NOT NULL,
	receiver TEXT NULL,
	message_type TEXT NOT NULL,
	precedence INT NULL,
	regex TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	regular_expression BOOL NULL DEFAULT false,
	CONSTRAINT "primary_amf_match" PRIMARY KEY (match_id)
);

CREATE INDEX  amf_match_sender_idx on amf_match(sender ASC);
CREATE TABLE amf_message (
	sender TEXT NOT NULL,
	receiver TEXT NOT NULL,
	msg_type TEXT NOT NULL,
	control_no TEXT NOT NULL,
	file_name TEXT NOT NULL,
	file_type TEXT NOT NULL,
	file_path TEXT NOT NULL,
	workflow_id TEXT NULL,
	session_id UUID NULL,
	parent_id UUID NULL,
	doc_count INT NULL,
	origin TEXT NOT NULL,
	reference_id JSONB NULL,
	status TEXT NOT NULL,
	status_time TIMESTAMPTZ NOT NULL,
	can_requeue BOOL NOT NULL,
	can_reprocess BOOL NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	created_by TEXT NOT NULL,
	message_id UUID NOT NULL,
	file_size INT8 NOT NULL,
	site_id TEXT NULL,
	node_id TEXT NULL,
	can_req_and_rep BOOL NULL DEFAULT false,
	data_type TEXT NULL DEFAULT 'External',
	contents bytea NULL,
	CONSTRAINT "primary_amf_message" PRIMARY KEY (message_id)
);
CREATE INDEX  amf_message_create_time_idx on amf_message(create_time DESC);
CREATE INDEX  amf_message_sender_idx on amf_message(sender ASC);
CREATE INDEX  amf_message_receiver_idx on amf_message(receiver ASC);
CREATE INDEX  amf_message_msg_type_idx on amf_message(msg_type ASC);
CREATE INDEX  amf_message_file_name_idx on amf_message(file_name ASC);
CREATE INDEX  amf_message_session_id_idx on amf_message(session_id ASC);

CREATE TABLE amf_message_note (
	note_id UUID NOT NULL,
	message_id UUID NOT NULL,
	notes TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	reference_name TEXT NULL,
	CONSTRAINT "primary_amf_message_note" PRIMARY KEY (note_id)
);
CREATE TABLE amf_message_type (
	type_id UUID NOT NULL,
	message_type TEXT NOT NULL,
	description TEXT NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_amf_message_type" PRIMARY KEY (type_id)
);
CREATE INDEX  amf_messagetypes_message_type_idx on amf_message_type(message_type ASC, active ASC);
CREATE TABLE amf_onb_node_status (
	status_id UUID NOT NULL,
	session_id UUID NOT NULL,
	node_id TEXT NOT NULL,
	node_deployed TEXT NOT NULL,
	action_name TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	status TEXT NOT NULL,
	CONSTRAINT "primary_amf_onb_node_status" PRIMARY KEY (status_id)
);
CREATE TABLE amf_onb_status (
	session_id UUID NOT NULL,
	session_name TEXT NOT NULL,
	transaction_id UUID NOT NULL,
	node_list TEXT NOT NULL,
	start_time TIMESTAMPTZ NOT NULL,
	end_time TIMESTAMPTZ NULL,
	status TEXT NOT NULL,
	CONSTRAINT "primary_amf_onb_status" PRIMARY KEY (session_id)
);
CREATE TABLE amf_privileges (
	privilege_id UUID NOT NULL,
	privilege_name TEXT NOT NULL,
	uri TEXT NOT NULL,
	method TEXT NOT NULL,
	active_status BOOL NOT NULL,
	created_by TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	order_no INT NULL,
	action TEXT NOT NULL,
	component_type TEXT NOT NULL,
	CONSTRAINT "primary_amf_privileges" PRIMARY KEY (privilege_id)
);
CREATE TABLE amf_property (
	property_id UUID NOT NULL,
	service VARCHAR NOT NULL,
	key VARCHAR(20) NOT NULL,
	value VARCHAR(100) NULL,
	CONSTRAINT amf_property_pk PRIMARY KEY (property_id)
);
CREATE INDEX  amf_property_service_idx on amf_property(service ASC);

CREATE TABLE amf_rule (
	rule_id UUID NOT NULL,
	sender TEXT NOT NULL,
	receiver TEXT NOT NULL,
	msg_type TEXT NOT NULL,
	workflow_id UUID NOT NULL,
	active BOOL NOT NULL,
    queue_name TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_amf_rule" PRIMARY KEY (rule_id)
);
CREATE INDEX  amf_rules_sender_idx on amf_rule(sender ASC, receiver ASC, msg_type ASC, active ASC);
CREATE TABLE amf_service_status (
	service_status_id UUID NOT NULL,
	service_name TEXT NOT NULL,
	service_type TEXT NOT NULL,
	status TEXT NOT NULL,
	version TEXT NOT NULL,
	errors TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	created_by TEXT NOT NULL,
	CONSTRAINT "primary_amf_service_status" PRIMARY KEY (service_status_id)
);
CREATE TABLE amf_session (
	session_id UUID NOT NULL,
	session_start TIMESTAMPTZ NOT NULL,
	session_end TIMESTAMPTZ NULL,
	workflow_name TEXT NOT NULL,
	instance_id TEXT NOT NULL,
	username TEXT NOT NULL,
	status TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	created_by TEXT NOT NULL,
	site_id TEXT NULL,
	node_id TEXT NULL,
	CONSTRAINT "primary_amf_session" PRIMARY KEY (session_id)
);
CREATE INDEX  amf_session_session_start_idx on amf_session(session_start DESC);

CREATE TABLE amf_session_rel (
	relation_id UUID NOT NULL,
	session_id UUID NOT NULL,
	message_id UUID NOT NULL,
	rel_type TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	created_by TEXT NOT NULL,
	CONSTRAINT "primary_amf_session_rel" PRIMARY KEY (relation_id)
);

CREATE INDEX  amf_session_rel_message_id_idx on amf_session_rel(message_id ASC);

CREATE TABLE amf_ufagent_downloads (
	ufa_id UUID NOT NULL,
	hostname TEXT NOT NULL,
	os_name TEXT NOT NULL,
	os_type TEXT NOT NULL,
	ufa_home TEXT NOT NULL,
	note TEXT NULL,
	user_audit_info JSONB NOT NULL,
	username TEXT NOT NULL,
	assigned_to TEXT NULL,
	active BOOL NULL DEFAULT true,
	ufa_version TEXT NULL DEFAULT '1.0',
	debug_level TEXT NULL,
	CONSTRAINT "primary_amf_ufagent_downloads" PRIMARY KEY (ufa_id)
);


CREATE TABLE amf_user (
	mailbox_id UUID NOT NULL,
	mailbox TEXT NOT NULL,
	user_name TEXT NOT NULL,
	password TEXT NOT NULL,
	customer_id UUID NOT NULL,
	given_name TEXT NOT NULL,
	surname TEXT NOT NULL,
	phone_number TEXT NOT NULL,
	email TEXT NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	transaction_id UUID NOT NULL,
	updated BOOL NOT NULL,
	attempt_no INT NOT NULL,
	user_type TEXT NOT NULL,
	status_action TEXT NOT NULL,
	use_global_mailbox BOOL NOT NULL,
	provider_details JSONB NOT NULL,
	authentication_type TEXT NOT NULL,
	additional_info TEXT NOT NULL,
	CONSTRAINT "primary_amf_user" PRIMARY KEY (mailbox_id)
);

CREATE INDEX  amf_user_mailbox_idx on amf_user (mailbox ASC);
CREATE TABLE amf_user_alt (
	user_alt_id UUID NOT NULL,
	mailbox_id UUID NOT NULL,
	user_name TEXT NOT NULL,
	user_id UUID NOT NULL,
	created_by TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	CONSTRAINT "primary_amf_user_alt" PRIMARY KEY (user_alt_id)
);

CREATE TABLE amf_wfqueue (
	queue_id UUID NOT NULL,
	queue_name TEXT NOT NULL,
	active BOOL NOT NULL,
	CONSTRAINT "primary_amf_wfqueue" PRIMARY KEY (queue_id)
);

CREATE TABLE amf_workflow (
	workflow_id UUID NOT NULL,
	name TEXT NOT NULL,
	description TEXT NULL,
	user_audit_info JSONB NOT NULL,
	active BOOL NOT NULL,
	communications_workflow BOOL NULL DEFAULT false,
	CONSTRAINT "primary_amf_workflow" PRIMARY KEY (workflow_id)
);
CREATE TABLE amf_workflow_step (
	step_id UUID NOT NULL,
	step_no INT NOT NULL,
	workflow_id UUID NOT NULL,
	action_id UUID NOT NULL,
	description TEXT NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_amf_workflow_step" PRIMARY KEY (step_id)
);
CREATE INDEX  amf_wf_step_workflow_id_idx on amf_workflow_step(workflow_id);
CREATE TABLE amf_mftlinks (
	id UUID NOT NULL,
	datacenter_name TEXT NOT NULL,
	category TEXT NOT NULL,
	nodes JSONB NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_amf_mftlinks" PRIMARY KEY (id)
);


CREATE TABLE amf_queue_definitions (
queue_id UUID NOT NULL,
queue_name TEXT NOT NULL,
description TEXT NULL,
queue_type TEXT NOT NULL,
queue_manager TEXT NOT NULL,
username TEXT NOT NULL,
password TEXT NOT NULL,
channel TEXT NOT NULL,
host TEXT NOT NULL,
port INT NOT NULL,
priority BOOL NULL DEFAULT false,
fifo BOOL NULL DEFAULT false,
warndepth BOOL NULL DEFAULT false,
maxdepth BOOL NULL DEFAULT false,
user_audit_info JSONB NOT NULL,
active BOOL NOT NULL,
CONSTRAINT "primary_amf_queue_definitions" PRIMARY KEY (queue_id)
);


CREATE TABLE amf_providers (
provider_id UUID NOT NULL,
provider_name TEXT NOT NULL,
description TEXT NOT NULL,
provider_type TEXT NOT NULL,
user_audit_info JSONB NOT NULL,
active BOOL NOT NULL,
CONSTRAINT "primary_amf_providers" PRIMARY KEY (provider_id)

);
CREATE TABLE amf_platforms (
platform_id UUID NOT NULL,
provider_id UUID NOT NULL,
platform_name TEXT NOT NULL,
platform_type TEXT NOT NULL,
service_names TEXT NOT NULL,
service_names_prefix TEXT NOT NULL,
user_audit_info JSONB NOT NULL,
configuration JSONB NOT NULL,
CONSTRAINT "primary_amf_platforms" PRIMARY KEY (platform_id)

);

CREATE TABLE amf_role_privileges (
	role_privilege_id UUID NOT NULL,
	role TEXT NOT NULL,
	privilege UUID NOT NULL,
	user_audit_info JSONB NOT NULL,
	group_id UUID NOT NULL,
	CONSTRAINT "primary_role_privileges" PRIMARY KEY (role_privilege_id)
);

CREATE TABLE QT_amf_wf_registration_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_registration_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE QT_amf_wf_input_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_input_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE QT_sfg_wf_output_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_sfg_wf_output_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE QT_amf_wf_comms_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_comms_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE QT_amf_wf_error_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_error_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE QT_amf_wf_commserror_error (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_commserror_error" PRIMARY KEY (queue_id)
);


CREATE TABLE QT_amf_wf_onbregistration_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_onbregistration_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE QT_amf_wf_onbinput_queue (
queue_id UUID NOT NULL,
queue_data text not null,
queued_time TIMESTAMPTZ NOT NULL,
queued_by text not null,
CONSTRAINT "primary_amf_wf_onbinput_queue" PRIMARY KEY (queue_id)
);

CREATE TABLE amf_menu_toggle (
	menu_id UUID NOT NULL,
	user_name TEXT NOT NULL,
	enable_new_menu BOOL NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	created_by TEXT NOT NULL,
	CONSTRAINT "primary_menu_toggle" PRIMARY KEY (menu_id)
);

CREATE TABLE amf_venafi (
	cert_id UUID NOT NULL,
	name TEXT NOT NULL,
	subject TEXT NOT NULL,
	alt_ips TEXT NULL,
	alt_dns TEXT NULL,
	environment TEXT NULL,
	organization TEXT NULL,
	city TEXT NULL,
	state TEXT NULL,
	country TEXT NULL,
	guid TEXT NULL,
	certificatedn TEXT NULL,
	status TEXT NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_cert_id" PRIMARY KEY (cert_id)
);

CREATE TABLE amf_email_templates (
	template_id UUID NOT NULL,
	template_name TEXT NOT NULL,
	subject TEXT NOT NULL,
	body TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	active BOOL NOT NULL,
	CONSTRAINT "primary_amf_email_templates" PRIMARY KEY (template_id)
);

CREATE TABLE amf_ufa_stats (
	ufa_stats_id UUID NOT NULL,
	username TEXT NOT NULL,
	mode TEXT NOT NULL,
	file_name TEXT NOT NULL,
	start_time TIMESTAMPTZ NOT NULL,
	end_time TIMESTAMPTZ NOT NULL,
	time_taken TEXT NOT NULL,
	create_time TIMESTAMPTZ NOT NULL,
	file_size bigint NOT NULL,
	notes TEXT NULL,
	CONSTRAINT "primary_amf_ufa_stats" PRIMARY KEY (ufa_stats_id)
);


CREATE TABLE amf_configuration (
	config_id UUID NOT NULL,
	parameter_type TEXT NOT NULL,
	parameter JSONB NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT "primary_config_id" PRIMARY KEY (config_id)
);

CREATE TABLE amf_schedule_activity (
	schedule_activity_id UUID NOT NULL,
	rule_id UUID NOT NULL,
	schedule_name TEXT NOT NULL,
	create_time TIMESTAMPTZ NULL,
	status TEXT NOT NULL,
	active BOOL NOT NULL,
	response TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT primary_schedule_actcivity_id PRIMARY KEY (schedule_activity_id)
);

CREATE TABLE schedule_monitor (
	instance_id UUID NOT NULL,
	create_time TIMESTAMPTZ NULL,
	update_time TIMESTAMPTZ NULL,
	status TEXT NOT NULL,
	service_type TEXT NOT NULL,
	notes TEXT NOT NULL,
	CONSTRAINT primary_schedule_monitor PRIMARY KEY (instance_id)
);

CREATE TABLE retry_schedules (
	rschedule_id UUID NOT NULL,
	delivery_id TEXT NOT NULL,
	message_id TEXT NOT NULL,
	status TEXT NOT NULL,
	last_interval int,
	CONSTRAINT primary_retry_schedules PRIMARY KEY (rschedule_id)
);

create index concurrently amf_delivery_update_0001_ndx on amf_delivery(next_time,status, sender, receiver,message_type);
create index concurrently ndx_read_delivery on amf_delivery(sender, receiver, message_type,time_queued, file_name,file_path, orig_file, locked, deleted, next_time);

CREATE TABLE amf_providers_config (
	provider_config_id UUID NOT NULL,
	provider_type TEXT NOT NULL,
	providers TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT primary_amf_providers_config PRIMARY KEY (provider_config_id)
);


CREATE TABLE amf_platform_config (
	platform_config_id UUID NOT NULL,
	provider TEXT NOT NULL,
	platforms TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT primary_amf_platforms_config PRIMARY KEY (platform_config_id)
);


CREATE TABLE amf_platform_field_config (
	platform_field_config_id UUID NOT NULL,
	provider TEXT NOT NULL,
	platform TEXT NOT NULL,
	field_config TEXT NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT primary_amf_platform_field_config PRIMARY KEY (platform_field_config_id)
);

ALTER TABLE amf_user ADD approved_by TEXT NULL;
ALTER TABLE amf_user ADD approval_status TEXT NULL;




insert into amf_providers_config(provider_config_id,provider_type,providers,user_audit_info) values (gen_random_uuid(),'Middleware','MFTLABS,Amazon','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
insert into amf_platform_config(platform_config_id,provider,platforms,user_audit_info) values (gen_random_uuid(),'MFTLABS','AMF','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
insert into amf_platform_config(platform_config_id,provider,platforms,user_audit_info) values (gen_random_uuid(),'MFTLABS','SFTP','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
insert into amf_platform_config(platform_config_id,provider,platforms,user_audit_info) values (gen_random_uuid(),'MFTLABS','AMF,SFTP','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
insert into amf_platform_field_config(platform_field_config_id,provider,platform,field_config,user_audit_info) values (gen_random_uuid(),'MFTLABS','AMF','[]','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
insert into amf_platform_field_config(platform_field_config_id,provider,platform,field_config,user_audit_info) values (gen_random_uuid(),'MFTLABS','SFTP','[]','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
insert into amf_providers(provider_id, provider_name, description, provider_type,user_audit_info,active) values ('9f00a89f-4311-4c01-b3d2-5f94a993dda4','MFTLABS','MFTLABS','Middleware','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}',true);
insert into amf_platforms(platform_id, provider_id,platform_name,platform_type,service_names,service_names_prefix,user_audit_info,configuration) values(gen_random_uuid(),'9f00a89f-4311-4c01-b3d2-5f94a993dda4','AMF','AMF','','','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}','{}');
insert into amf_platforms(platform_id, provider_id,platform_name,platform_type,service_names,service_names_prefix,user_audit_info,configuration) values(gen_random_uuid(),'9f00a89f-4311-4c01-b3d2-5f94a993dda4','SFTP','SFTP','','','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}','{}');

insert into amf_customer(customer_id,customer,billing_id,email,phone_number,user_audit_info,active) values (gen_random_uuid(),'MFTLABS','79517706','info@mftlabs.com','9999999999','{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}',true);
INSERT INTO amf_message_type (type_id, message_type, description, active, user_audit_info) VALUES(gen_random_uuid(), 'GENERIC', 'GENERIC', true, '{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
INSERT INTO amf_workflow (workflow_id, name, description, user_audit_info, active) VALUES(gen_random_uuid(), 'NOOP', 'NOOP', '{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}', true);
INSERT INTO amf_workflow (workflow_id, name, description, user_audit_info, active) VALUES('6c9506d6-3e8a-4331-8998-51f734138191', 'Deliver as is', 'Deliver as is', '{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}', true);
INSERT INTO amf_action (action_id, action_name, action_type, parameter, description, active, user_audit_info) VALUES('118f4e81-81bc-448c-8f73-8071fcdc2b27', 'Deliver as is', 'deliver', '{"Filename Format": "", "Message To Process": "Current", "Message Type": "", "Receiver": ""}', 'Deliver as is', true, '{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');
INSERT INTO amf_workflow_step (step_id, step_no, workflow_id, action_id, description, active, user_audit_info) VALUES(gen_random_uuid(), 1, '6c9506d6-3e8a-4331-8998-51f734138191', '118f4e81-81bc-448c-8f73-8071fcdc2b27', 'Deliver as is', true, '{"created_by": "CMD", "created_on": "2021-01-01 00:00:01.000", "last_modified_by": "", "last_modified_on": ""}');

CREATE TABLE sftpd_mgr (
   unique_id UUID NOT NULL,
   message_id UUID NOT NULL,
   file_owner TEXT,
   file_path TEXT,
   upload_path TEXT,
   create_time TIMESTAMPTZ NOT NULL default current_timestamp,
   CONSTRAINT primary_sftpd_mgr PRIMARY KEY (unique_id)
);

CREATE TABLE amf_branding_config (
	branding_config_id UUID NOT NULL,
	client_name TEXT NOT NULL,
	config JSONB NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT primary_branding_config_id PRIMARY KEY (branding_config_id)
);


CREATE TABLE amf_schedule (
	schedule_id UUID NOT NULL,
	schedule_name TEXT NOT NULL,
	schedule_type TEXt NOT NULL,
	parameter JSONB NOT NULL,
	active BOOL NOT NULL,
	user_audit_info JSONB NOT NULL,
	CONSTRAINT primary_schedule_id PRIMARY KEY (schedule_id)
);

CREATE TABLE amf_message_delivery (
transaction_id UUID NOT NULL,
message_id UUID NOT NULL,
sender text not null,
receiver text not null,
msgtype text not null,
filename text not null,
filepath text not null,
updated_at TIMESTAMPTZ NOT NULL,
CONSTRAINT "primary_amf_message_delivery" PRIMARY KEY (transaction_id)
);



CREATE TABLE amf_running_jobs (
transaction_id UUID NOT NULL,
sender text not null,
receiver text not null,
msgtype text not null,
updated_at TIMESTAMPTZ NOT NULL,
CONSTRAINT "primary_amf_running_jobs" PRIMARY KEY (transaction_id)
);

CREATE TABLE delivery_running_status (
scheduler_id UUID NOT NULL,
sender text not null,
receiver text not null,
msgtype text not null,
running boolean not null,
create_time TIMESTAMPTZ NOT NULL,
update_time TIMESTAMPTZ NOT NULL,
CONSTRAINT "primary_scheduler_status" PRIMARY KEY (scheduler_id)
);

CREATE TABLE amf_settings (
setting_id UUID NOT NULL,
config_type TEXT NOT NULL,
config JSONB NOT NULL,
user_audit_info JSONB NOT NULL,
CONSTRAINT "primary_amf_settings" PRIMARY KEY (setting_id)
);


CREATE TABLE scheduler_status (

scheduler_id UUID NOT NULL,
running BOOL NOT NULL,
create_time TIMESTAMPTZ NOT NULL,
update_time TIMESTAMPTZ NOT NULL,
CONSTRAINT "primary_scheduler_status" PRIMARY KEY (scheduler_id)
)
