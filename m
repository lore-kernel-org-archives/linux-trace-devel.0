Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:11440
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727676AbeKIWib (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 17:38:31 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent, tools/perf: traceevent API cleanup
Date: Fri, 9 Nov 2018 12:57:54 +0000
Message-ID: <20181109125743.22258-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. This patch hides few API functions,
intended for internal usage only:
tep_free_event(), tep_free_format_field(), __tep_data2host2(),
__tep_data2host4() and __tep_data2host8().
The patch also alignes the libtraceevent summary man page with
these API changes.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent.txt           | 125 +++++++++---------
 tools/lib/traceevent/event-parse-api.c        |   6 +-
 tools/lib/traceevent/event-parse-local.h      |   7 +
 tools/lib/traceevent/event-parse.c            |  13 +-
 tools/lib/traceevent/event-parse.h            |  18 ---
 5 files changed, 79 insertions(+), 90 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/l=
ib/traceevent/Documentation/libtraceevent.txt
index bc3d77934ab8..e2b4ca615809 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -13,38 +13,34 @@ SYNOPSIS
=20
 Management of tep handler data structure and access of its members:
 	struct tep_handle pass:[*]*tep_alloc*(void);
-	void *tep_free*(struct tep_handle pass:[*]_pevent_);
-	void *tep_ref*(struct tep_handle pass:[*]_pevent_);
-	void *tep_unref*(struct tep_handle pass:[*]_pevent_);
-	int *tep_ref_get*(struct tep_handle pass:[*]_pevent_);
+	void *tep_free*(struct tep_handle pass:[*]_tep_);
+	void *tep_ref*(struct tep_handle pass:[*]_tep_);
+	void *tep_unref*(struct tep_handle pass:[*]_tep_);
+	int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_flag*(struct tep_handle pass:[*]_tep_, int _flag_);
-	int *tep_get_cpus*(struct tep_handle pass:[*]_pevent_);
-	void *tep_set_cpus*(struct tep_handle pass:[*]_pevent_, int _cpus_);
-	int *tep_get_long_size*(strucqt tep_handle pass:[*]_pevent_);
-	void *tep_set_long_size*(struct tep_handle pass:[*]_pevent_, int _long_si=
ze_);
-	int *tep_get_page_size*(struct tep_handle pass:[*]_pevent_);
-	void *tep_set_page_size*(struct tep_handle pass:[*]_pevent_, int _page_si=
ze_);
-	int *tep_is_file_bigendian*(struct tep_handle pass:[*]_pevent_);
-	void *tep_set_file_bigendian*(struct tep_handle pass:[*]_pevent_, enum te=
p_endian _endian_);
-	int *tep_is_host_bigendian*(struct tep_handle pass:[*]_pevent_);
-	void *tep_set_host_bigendian*(struct tep_handle pass:[*]_pevent_, enum te=
p_endian _endian_);
-	int *tep_is_latency_format*(struct tep_handle pass:[*]_pevent_);
-	void *tep_set_latency_format*(struct tep_handle pass:[*]_pevent_, int _la=
t_);
-	int *tep_get_header_page_size*(struct tep_handle pass:[*]_pevent_);
-	int *tep_strerror*(struct tep_handle pass:[*]_pevent_, enum tep_errno _er=
rnum_, char pass:[*]_buf_, size_t _buflen_);
+	int *tep_get_cpus*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_cpus*(struct tep_handle pass:[*]_tep_, int _cpus_);
+	int *tep_get_long_size*(strucqt tep_handle pass:[*]_tep_);
+	void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_=
);
+	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_=
);
+	int *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_)=
;
+	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
+	int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnu=
m_, char pass:[*]_buf_, size_t _buflen_);
=20
 Register / unregister APIs:
-	int *tep_register_trace_clock*(struct tep_handle pass:[*]_pevent_, const =
char pass:[*]_trace_clock_);
-	int *tep_register_function*(struct tep_handle pass:[*]_pevent_, char pass=
:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
-	int *tep_register_event_handler*(struct tep_handle pass:[*]_pevent_, int =
_id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_e=
vent_handler_func _func_, void pass:[*]_context_);
-	int *tep_unregister_event_handler*(struct tep_handle pass:[*]pevent, int =
id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_h=
andler_func func, void pass:[*]_context_);
-	int *tep_register_print_string*(struct tep_handle pass:[*]_pevent_, const=
 char pass:[*]_fmt_, unsigned long long _addr_);
-	int *tep_register_print_function*(struct tep_handle pass:[*]_pevent_, tep=
_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name=
_, _..._);
-	int *tep_unregister_print_function*(struct tep_handle pass:[*]_pevent_, t=
ep_func_handler _func_, char pass:[*]_name_);
+	int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const cha=
r pass:[*]_trace_clock_);
+	int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*=
]_name_, unsigned long long _addr_, char pass:[*]_mod_);
+	int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id=
_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_even=
t_handler_func _func_, void pass:[*]_context_);
+	int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id,=
 const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_hand=
ler_func func, void pass:[*]_context_);
+	int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const ch=
ar pass:[*]_fmt_, unsigned long long _addr_);
+	int *tep_register_print_function*(struct tep_handle pass:[*]_tep_, tep_fu=
nc_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, =
_..._);
+	int *tep_unregister_print_function*(struct tep_handle pass:[*]_tep_, tep_=
func_handler _func_, char pass:[*]_name_);
=20
 Plugins management:=20
-	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:=
[*]_pevent_);
-	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, s=
truct tep_handle pass:[*]_pevent_);
+	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:=
[*]_tep_);
+	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, s=
truct tep_handle pass:[*]_tep_);
 	char pass:[*]pass:[*]*tep_plugin_list_options*(void);
 	void *tep_plugin_free_options_list*(char pass:[*]pass:[*]_list_);
 	int *tep_plugin_add_options*(const char pass:[*]_name_, struct tep_plugin=
_option pass:[*]_options_);
@@ -54,40 +50,40 @@ Plugins management:
 Event related APIs:
 	struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]=
_tep_);
 	int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
-	void *tep_free_event*(struct tep_event pass:[*]_event_);
-	struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass=
:[*]_pevent_, enum tep_event_sort_type _sort_type_);
+	struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass=
:[*]_tep_, enum tep_event_sort_type _sort_type_);
 	void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass=
:[*]_event_, struct tep_record pass:[*]_record_);
=20
 Event printing:
-	void *tep_print_event_task*(struct tep_handle pass:[*]_pevent_, struct tr=
ace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pa=
ss:[*]_record_);
-	void *tep_print_event_time*(struct tep_handle pass:[*]_pevent_, struct tr=
ace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pa=
ss:[*]record, bool _use_trace_clock_);
-	void *tep_print_event_data*(struct tep_handle pass:[*]_pevent_, struct tr=
ace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pa=
ss:[*]_record_);
-	void *tep_print_event*(struct tep_handle pass:[*]_pevent_, struct trace_s=
eq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_)=
;
+	void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace=
_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:=
[*]_record_);
+	void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace=
_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:=
[*]record, bool _use_trace_clock_);
+	void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace=
_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:=
[*]_record_);
+	void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq =
pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
=20
 Event finding:
-	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_peve=
nt_, int _id_);
-	struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:=
[*]_pevent_, const char pass:[*]_sys_, const char pass:[*]_name_);
-	struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pas=
s:[*]_pevent_, struct tep_record pass:[*]_record_);
-	struct tep_event pass:[*]*tep_data_event_from_type*(struct tep_handle pas=
s:[*]_pevent_, int _type_);
+	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_=
, int _id_);
+	struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:=
[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
+	struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pas=
s:[*]_tep_, struct tep_record pass:[*]_record_);
+	struct tep_event pass:[*]*tep_data_event_from_type*(struct tep_handle pas=
s:[*]_tep_, int _type_);
=20
 Parsing of event files:
-	int *tep_parse_header_page*(struct tep_handle pass:[*]_pevent_, char pass=
:[*]_buf_, unsigned long _size_, int _long_size_);
-	enum *tep_errno tep_parse_event*(struct tep_handle pass:[*]_pevent_, cons=
t char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
-	enum *tep_errno tep_parse_format*(struct tep_handle pass:[*]_pevent_, str=
uct tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned =
long _size_, const char pass:[*]_sys_);
+	int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*=
]_buf_, unsigned long _size_, int _long_size_);
+	enum tep_errno *tep_parse_event*(struct tep_handle pass:[*]_tep_, const c=
har pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+	enum tep_errno *tep_parse_format*(struct tep_handle pass:[*]_tep_, struct=
 tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned lon=
g _size_, const char pass:[*]_sys_);
=20
 APIs related to fields from event's format files:
-	void *tep_free_format_field*(struct tep_format_field pass:[*]_field_);
 	struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct =
tep_event pass:[*]_event_);
 	struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_eve=
nt pass:[*]_event_);
 	void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep=
_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[=
*]_record_, int pass:[*]_len_, int _err_);
 	int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pa=
ss:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record=
_, unsigned long long pass:[*]_val_, int _err_);
 	int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_e=
vent pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]=
_record_, unsigned long long pass:[*]_val_, int _err_);
 	int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_even=
t pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_re=
cord_, unsigned long long pass:[*]_val_, int _err_);=09
+	int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, cons=
t void pass:[*]_data_, unsigned long long pass:[*]_value_);
+=09
+Event fileds printing:
 	void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_,=
 struct tep_format_field pass:[*]_field_);
 	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_=
, int _size_, struct tep_event pass:[*]_event_);
 	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[=
*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struc=
t tep_record pass:[*]_record_, int _err_);
 	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:=
[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, stru=
ct tep_record pass:[*]_record_, int _err_);
-	int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, cons=
t void pass:[*]_data_, unsigned long long pass:[*]_value_);
 =09
 Event fileds finding:
 	struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event =
pass:[*]_event_, const char pass:[*]_name_);
@@ -95,13 +91,13 @@ Event fileds finding:
 	struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event pas=
s:[*]_event_, const char pass:[*]_name_);
=20
 Functions resolver:
-	int *tep_set_function_resolver*(struct tep_handle pass:[*]_pevent_, tep_f=
unc_resolver_t pass:[*]_func_, void pass:[*]_priv_);
-	void *tep_reset_function_resolver*(struct tep_handle pass:[*]_pevent_);
-	const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_pevent_=
, unsigned long long _addr_);
-	unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]=
_pevent_, unsigned long long _addr_);
+	int *tep_set_function_resolver*(struct tep_handle pass:[*]_tep_, tep_func=
_resolver_t pass:[*]_func_, void pass:[*]_priv_);
+	void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
+	const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, u=
nsigned long long _addr_);
+	unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]=
_tep_, unsigned long long _addr_);
=20
 Filter management:
-	struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass=
:[*]_pevent_);
+	struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass=
:[*]_tep_);
 	enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[=
*]_filter_, const char pass:[*]_filter_str_);
 	enum tep_errno *tep_filter_match*(struct tep_event_filter pass:[*]_filter=
_, struct tep_record pass:[*]_record_);
 	int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum =
tep_errno _err_, char pass:[*]buf, size_t _buflen_);
@@ -117,25 +113,26 @@ Filter management:
 	int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struc=
t tep_event_filter pass:[*]_filter2_);
=20
 Parsing various data from the records:
-	void *tep_data_lat_fmt*(struct tep_handle pass:[*]_pevent_, struct trace_=
seq pass:[*]_s_, struct tep_record pass:[*]_record_);
-	int *tep_data_type*(struct tep_handle pass:[*]_pevent_, struct tep_record=
 pass:[*]_rec_);
-	int *tep_data_pid*(struct tep_handle pass:[*]_pevent_, struct tep_record =
pass:[*]_rec_);
-	int *tep_data_preempt_count*(struct tep_handle pass:[*]_pevent_, struct t=
ep_record pass:[*]_rec_);
-	int *tep_data_flags*(struct tep_handle pass:[*]_pevent_, struct tep_recor=
d pass:[*]_rec_);
-	const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_pe=
vent_, int _pid_);
-	struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*=
]_pevent_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
+	void *tep_data_lat_fmt*(struct tep_handle pass:[*]_tep_, struct trace_seq=
 pass:[*]_s_, struct tep_record pass:[*]_record_);
+	int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pa=
ss:[*]_rec_);
+	int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pas=
s:[*]_rec_);
+	int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_=
record pass:[*]_rec_);
+	int *tep_data_flags*(struct tep_handle pass:[*]_tep_, struct tep_record p=
ass:[*]_rec_);
 =09
 Command and task related APIs:
-	int *tep_register_comm*(struct tep_handle pass:[*]_pevent_, const char pa=
ss:[*]_comm_, int _pid_);
-	int *tep_pid_is_registered*(struct tep_handle pass:[*]_pevent_, int _pid_=
);
-	int *tep_cmdline_pid*(struct tep_handle pass:[*]_pevent_, struct cmdline =
pass:[*]_cmdline_);
+	const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_te=
p_, int _pid_);
+	struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*=
]_tep_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
+	int *tep_register_comm*(struct tep_handle pass:[*]_tep_, const char pass:=
[*]_comm_, int _pid_);
+	int *tep_pid_is_registered*(struct tep_handle pass:[*]_tep_, int _pid_);
+	int *tep_cmdline_pid*(struct tep_handle pass:[*]_tep_, struct cmdline pas=
s:[*]_cmdline_);
=20
 Endian related APIs:
-	unsigned short *tep_data2host2*(struct tep_handle pass:[*]_pevent_, unsig=
ned short _data_);
-	unsigned int *tep_data2host4*(struct tep_handle pass:[*]_pevent_, unsigne=
d int _data_);
-	unsigned long long *tep_data2host8*(struct tep_handle pass:[*]_pevent_, u=
nsigned long long _data_);
 	int *tep_host_bigendian*(void);
-	unsigned long long *tep_read_number*(struct tep_handle pass:[*]_pevent_, =
const void pass:[*]_ptr_, int _size_);
+	unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, con=
st void pass:[*]_ptr_, int _size_);
+	int *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_e=
ndian _endian_);
+	int *tep_is_host_bigendian*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_host_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_e=
ndian _endian_);
=20
 Trace sequences:
 *#include <trace-seq.h>*
@@ -168,13 +165,13 @@ FILES
 -----
 [verse]
 --
-event-parse.h
+*event-parse.h*
 	Header file to include in order to have access to the library APIs.
-trace-seq.h
+*trace-seq.h*
 	Header file to include in order to have access to trace sequences related=
 APIs.
 	Trace sequences are used to allow a function to call several other functi=
ons=20
 	to create a string of data to use.
--ltraceevent
+*-ltraceevent*
 	Linker switch to add when building a program that uses the library.
 --
=20
diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index 52188921cfe3..bdefe3c235ad 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -51,7 +51,7 @@ void tep_set_flag(struct tep_handle *tep, int flag)
 		tep->flags |=3D flag;
 }
=20
-unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data)
+unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short da=
ta)
 {
 	unsigned short swap;
=20
@@ -64,7 +64,7 @@ unsigned short __tep_data2host2(struct tep_handle *pevent=
, unsigned short data)
 	return swap;
 }
=20
-unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
)
+unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
 {
 	unsigned int swap;
=20
@@ -80,7 +80,7 @@ unsigned int __tep_data2host4(struct tep_handle *pevent, =
unsigned int data)
 }
=20
 unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
+tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 {
 	unsigned long long swap;
=20
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 94746efef433..9a092dd4a86d 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -89,4 +89,11 @@ struct tep_handle {
 	char *trace_clock;
 };
=20
+void tep_free_event(struct tep_event *event);
+void tep_free_format_field(struct tep_format_field *field);
+
+unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short da=
ta);
+unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
+unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long=
 long data);
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 73347e2ef81d..4e768357a30d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3343,15 +3343,18 @@ tep_find_any_field(struct tep_event *event, const c=
har *name)
 unsigned long long tep_read_number(struct tep_handle *pevent,
 				   const void *ptr, int size)
 {
+	unsigned long long val;
+
 	switch (size) {
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return tep_data2host2(pevent, ptr);
+		return tep_data2host2(pevent, *(unsigned short *)ptr);
 	case 4:
-		return tep_data2host4(pevent, ptr);
+		return tep_data2host4(pevent, *(unsigned int *)ptr);
 	case 8:
-		return tep_data2host8(pevent, ptr);
+		memcpy(&val, (ptr), sizeof(unsigned long long));
+		return tep_data2host8(pevent, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -4077,7 +4080,7 @@ static void print_str_arg(struct trace_seq *s, void *=
data, int size,
 			f =3D tep_find_any_field(event, arg->string.string);
 			arg->string.offset =3D f->offset;
 		}
-		str_offset =3D tep_data2host4(pevent, data + arg->string.offset);
+		str_offset =3D tep_data2host4(pevent, *(unsigned int *)(data + arg->stri=
ng.offset));
 		str_offset &=3D 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4095,7 +4098,7 @@ static void print_str_arg(struct trace_seq *s, void *=
data, int size,
 			f =3D tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset =3D f->offset;
 		}
-		bitmask_offset =3D tep_data2host4(pevent, data + arg->bitmask.offset);
+		bitmask_offset =3D tep_data2host4(pevent, *(unsigned int *)(data + arg->=
bitmask.offset));
 		bitmask_size =3D bitmask_offset >> 16;
 		bitmask_offset &=3D 0xffff;
 		print_bitmask_to_seq(pevent, s, format, len_arg,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index 16131e006cfe..ff74dc392268 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -409,22 +409,6 @@ void tep_print_plugins(struct trace_seq *s,
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
 void tep_set_flag(struct tep_handle *tep, int flag);
-unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data);
-unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
);
-unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data);
-
-#define tep_data2host2(pevent, ptr)	\
-	__tep_data2host2(pevent, *(unsigned short *)(ptr))
-#define tep_data2host4(pevent, ptr)	\
-	__tep_data2host4(pevent, *(unsigned int *)(ptr))
-#define tep_data2host8(pevent, ptr)	\
-({								\
-	unsigned long long __val;				\
-								\
-	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
-	__tep_data2host8(pevent, __val);			\
-})
=20
 static inline int tep_host_bigendian(void)
 {
@@ -477,8 +461,6 @@ enum tep_errno tep_parse_format(struct tep_handle *peve=
nt,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_event(struct tep_event *event);
-void tep_free_format_field(struct tep_format_field *field);
=20
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 			const char *name, struct tep_record *record,
--=20
2.17.2
