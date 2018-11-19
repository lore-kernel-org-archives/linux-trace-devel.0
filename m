Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:61504
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728818AbeKSXR5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:17:57 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 00/34] A lot of libtraceevent man pages
Date: Mon, 19 Nov 2018 12:54:09 +0000
Message-ID: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

34 man pages, describing 71 APIs of the traceevent library

Tzvetomir Stoyanov (34):
  tools/lib/traceevent: Man page for tep_register_trace_clock()
  tools/lib/traceevent: Man pages for tep_register_event_handler() and
    tep_unregister_event_handler()
  tools/lib/traceevent: Man pages for tep_register_function() and
    tep_register_print_string()
  tools/lib/traceevent: Man pages for tep_register_print_function() and
    tep_unregister_print_function()
  tools/lib/traceevent: Man page for tep_read_number()
  tools/lib/traceevent: Man pages for tep_find_event(),
    tep_find_event_by_name() and tep_find_event_by_record()
  tools/lib/traceevent: Man page for tep_list_events()
  tools/lib/traceevent: Man pages for tep_print_event(),
    tep_print_event_data(), tep_event_info(), tep_print_event_task() and
    tep_print_event_time()
  tools/lib/traceevent: Man pages tep_get_first_event() and
    tep_get_events_count()
  tools/lib/traceevent: Man pages tep_find_common_field(),
    tep_find_field() and tep_find_any_field()
  tools/lib/traceevent: Man pages tep_get_any_field_val(),
    tep_get_common_field_val(), tep_get_field_val() and
    tep_get_field_raw()
  tools/lib/traceevent: Man pages for tep_print_field(),
    tep_print_fields(), tep_print_num_field() and tep_print_func_field()
  tools/lib/traceevent: Man page for tep_read_number_field()
  tools/lib/traceevent: Man pages for tep_event_common_fields() and
    tep_event_fields()
  tools/lib/traceevent: Man pages for tep_filter_alloc(),
    tep_filter_free() and tep_filter_reset()
  tools/lib/traceevent: Man page for tep_filter_add_filter_str()
  tools/lib/traceevent: Man page for tep_filter_strerror()
  tools/lib/traceevent: Man pages for tep_event_filtered() and
    tep_filter_remove_event()
  tools/lib/traceevent: Man page for tep_filter_match()
  tools/lib/traceevent: Man pages for tep_filter_copy() and
    tep_filter_compare()
  tools/lib/traceevent: Man page for tep_filter_make_string()
  tools/lib/traceevent: Man pages for tep_filter_event_has_trivial(),
    tep_update_trivial() and tep_filter_clear_trivial()
  tools/lib/traceevent: Man pages for tep_find_function() and
    tep_find_function_address()
  tools/lib/traceevent: Man pages for tep_set_function_resolver() and
    tep_reset_function_resolver()
  tools/lib/traceevent: Man pages for tep_parse_event() and
    tep_parse_format()
  tools/lib/traceevent: Man page for tep_parse_header_page()
  tools/lib/traceevent: Man pages for tep_load_plugins() and
    tep_unload_plugin()
  tools/lib/traceevent: Man page for tep_data_lat_fmt()
  tools/lib/traceevent: Man pages for tep_data_type(), tep_data_pid(),
    tep_data_preempt_count() and tep_data_flags()
  tools/lib/traceevent: Man pages for trace_seq_init() and
    trace_seq_destroy()
  tools/lib/traceevent: Man pages for trace_seq_do_fprintf() and
    trace_seq_do_printf()
  tools/lib/traceevent: Man pages for trace_seq_printf() and
    trace_seq_vprintf()
  tools/lib/traceevent: Man pages for trace_seq_putc() and
    trace_seq_puts()
  tools/lib/traceevent: Man pages for trace_seq_reset() and
    trace_seq_terminate()

 .../libtraceevent-endian_read.txt             |  76 ++++++++++
 .../libtraceevent-event_find.txt              |  99 +++++++++++++
 .../libtraceevent-event_list.txt              |  94 ++++++++++++
 .../libtraceevent-event_print.txt             | 126 ++++++++++++++++
 .../Documentation/libtraceevent-events.txt    |  87 ++++++++++++
 .../libtraceevent-field_find.txt              |  98 +++++++++++++
 .../libtraceevent-field_get_val.txt           | 117 +++++++++++++++
 .../libtraceevent-field_print.txt             | 120 ++++++++++++++++
 .../libtraceevent-field_read.txt              |  80 +++++++++++
 .../Documentation/libtraceevent-fields.txt    |  99 +++++++++++++
 .../Documentation/libtraceevent-filter.txt    |  85 +++++++++++
 .../libtraceevent-filter_add.txt              |  78 ++++++++++
 .../libtraceevent-filter_error.txt            |  78 ++++++++++
 .../libtraceevent-filter_event.txt            |  84 +++++++++++
 .../libtraceevent-filter_match.txt            |  96 +++++++++++++
 .../libtraceevent-filter_oper.txt             |  84 +++++++++++
 .../libtraceevent-filter_show.txt             |  75 ++++++++++
 .../libtraceevent-filter_trivial.txt          | 112 +++++++++++++++
 .../Documentation/libtraceevent-func_find.txt |  88 ++++++++++++
 .../libtraceevent-func_resolve.txt            |  96 +++++++++++++
 .../libtraceevent-parse_event.txt             |  90 ++++++++++++
 .../libtraceevent-parse_head.txt              |  82 +++++++++++
 .../Documentation/libtraceevent-plugins.txt   |  98 +++++++++++++
 .../libtraceevent-record_lat.txt              |  77 ++++++++++
 .../libtraceevent-record_parse.txt            | 134 ++++++++++++++++++
 .../Documentation/libtraceevent-reg_clock.txt |  77 ++++++++++
 .../libtraceevent-reg_event_handler.txt       | 123 ++++++++++++++++
 .../libtraceevent-reg_funcstr.txt             |  89 ++++++++++++
 .../libtraceevent-reg_print_func.txt          | 128 +++++++++++++++++
 .../Documentation/libtraceevent-tseq.txt      |  76 ++++++++++
 .../libtraceevent-tseq_doprint.txt            |  89 ++++++++++++
 .../libtraceevent-tseq_print.txt              |  95 +++++++++++++
 .../Documentation/libtraceevent-tseq_put.txt  |  89 ++++++++++++
 .../libtraceevent-tseq_reset.txt              |  78 ++++++++++
 tools/lib/traceevent/event-parse.c            |   4 +-
 35 files changed, 3199 insertions(+), 2 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian=
_read.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_=
find.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_=
list.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_=
print.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-events=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
find.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
get_val.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
print.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
read.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_add.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_error.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_event.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_match.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_oper.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_show.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_trivial.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_f=
ind.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_r=
esolve.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_=
event.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_=
head.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugin=
s.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record=
_lat.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record=
_parse.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_cl=
ock.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_ev=
ent_handler.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_fu=
ncstr.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_pr=
int_func.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq.t=
xt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_d=
oprint.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_p=
rint.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_p=
ut.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_r=
eset.txt

--=20
2.19.1
