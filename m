Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr760047.outbound.protection.outlook.com ([40.107.76.47]:47776
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeK1UI0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:26 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 00/15] tools/lib/traceevent,tools/perf: Various changes in
 libtraceevent APIs
Date: Wed, 28 Nov 2018 09:07:27 +0000
Message-ID: <20181128090711.17792-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch series includes changes, related to transformation of=20
traceevent into a library:
 Renamed few libtracevent APIs.=20
 Introduced two new APIs: tep_get_ref() and tep_override_comm().
 Removed tep_data_event_from_type() API.
 Changed return logic of tep_register_event_handler() and trace_seq_printf(=
)
 Added support for pkg-config infrastructure
 Changed describtion of few APIs, to be consistent with the man pages.

v2 combines all recent API related pacthes, which are still not accepted=20
into one series. It also removes any dependencies between them and the
man page related changes.

v3 splits patch
"tools/lib/traceevent: Changed return logic of tep_register_event_handler()=
 API"
into 2 patches:
"tools/lib/traceevent: Changed return logic of tep_register_event_handler()=
 API"
"tools/lib/traceevent: Remove tep_data_event_from_type() API"


Tzvetomir Stoyanov (15):
  tools/lib/traceevent: Implemented new API tep_get_ref()
  tools/lib/traceevent: Added support for pkg-config
  tools/lib/traceevent: Install trace-seq.h API header file
  tools/lib/traceevent, tools/perf: Rename struct tep_event_format to
    struct tep_event
  tools/lib/traceevent: Rename tep_free_format() to tep_free_event()
  tools/perf: traceevent API cleanup, remove __tep_data2host*()
  tools/lib/traceevent: traceevent API cleanup
  tools/lib/traceevent: Introduce new libtracevent API:
    tep_override_comm()
  tools/lib/traceevent: Initialize host_bigendian at tep_handle
    allocation
  tools/lib/traceevent: Rename struct cmdline to struct tep_cmdline
  tools/lib/traceevent: Changed return logic of trace_seq_printf() and
    trace_seq_vprintf() APIs
  tools/lib/traceevent: Changed return logic of
    tep_register_event_handler() API
  tools/lib/traceevent: Rename tep_is_file_bigendian() to
    tep_file_bigendian()
  tools/lib/traceevent: Change description of few APIs
  tools/lib/traceevent: Remove tep_data_event_from_type() API

 tools/lib/traceevent/Makefile                 |  27 +-
 tools/lib/traceevent/event-parse-api.c        |  37 +-
 tools/lib/traceevent/event-parse-local.h      |  17 +-
 tools/lib/traceevent/event-parse.c            | 343 ++++++++++--------
 tools/lib/traceevent/event-parse.h            |  94 +++--
 .../lib/traceevent/libtraceevent.pc.template  |  10 +
 tools/lib/traceevent/parse-filter.c           |  42 +--
 tools/lib/traceevent/plugin_function.c        |   2 +-
 tools/lib/traceevent/plugin_hrtimer.c         |   4 +-
 tools/lib/traceevent/plugin_kmem.c            |   2 +-
 tools/lib/traceevent/plugin_kvm.c             |  16 +-
 tools/lib/traceevent/plugin_mac80211.c        |   4 +-
 tools/lib/traceevent/plugin_sched_switch.c    |   4 +-
 tools/lib/traceevent/trace-seq.c              |  17 +-
 tools/perf/builtin-trace.c                    |   2 +-
 tools/perf/util/evsel.h                       |   4 +-
 tools/perf/util/header.c                      |   2 +-
 tools/perf/util/python.c                      |   4 +-
 .../util/scripting-engines/trace-event-perl.c |   6 +-
 .../scripting-engines/trace-event-python.c    |   8 +-
 tools/perf/util/trace-event-parse.c           |  16 +-
 tools/perf/util/trace-event-read.c            |   4 +-
 tools/perf/util/trace-event.c                 |   8 +-
 tools/perf/util/trace-event.h                 |  16 +-
 24 files changed, 387 insertions(+), 302 deletions(-)
 create mode 100644 tools/lib/traceevent/libtraceevent.pc.template

--=20
2.19.1
