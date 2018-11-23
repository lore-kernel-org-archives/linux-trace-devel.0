Return-Path: <SRS0=YO3e=OC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720041.outbound.protection.outlook.com ([40.107.72.41]:43424
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394909AbeKXAYR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Nov 2018 19:24:17 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/3] tools/lib/traceevent: Remove tep_data_event_from_type()
 API
Date: Fri, 23 Nov 2018 13:40:00 +0000
Message-ID: <20181123133946.16239-2-tstoyanov@vmware.com>
References: <20181123133946.16239-1-tstoyanov@vmware.com>
In-Reply-To: <20181123133946.16239-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. After discussion with Steven Rostedt,
we decided to remove the tep_data_event_from_type() API and to
replace it with tep_find_event(), as it does the same.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Documentation/libtraceevent.txt |  1 -
 tools/lib/traceevent/event-parse.c                   | 12 ------------
 tools/lib/traceevent/event-parse.h                   |  1 -
 3 files changed, 14 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/l=
ib/traceevent/Documentation/libtraceevent.txt
index 1100240a8a29..f2679a055c1a 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -63,7 +63,6 @@ Event finding:
 	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_=
, int _id_);
 	struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:=
[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
 	struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pas=
s:[*]_tep_, struct tep_record pass:[*]_record_);
-	struct tep_event pass:[*]*tep_data_event_from_type*(struct tep_handle pas=
s:[*]_tep_, int _type_);
=20
 Parsing of event files:
 	int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*=
]_buf_, unsigned long _size_, int _long_size_);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 966c4b7fd163..2970358b4c10 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5240,18 +5240,6 @@ int tep_data_type(struct tep_handle *pevent, struct =
tep_record *rec)
 	return trace_parse_common_type(pevent, rec->data);
 }
=20
-/**
- * tep_data_event_from_type - find the event by a given type
- * @pevent: a handle to the pevent
- * @type: the type of the event.
- *
- * This returns the event form a given @type;
- */
-struct tep_event *tep_data_event_from_type(struct tep_handle *pevent, int =
type)
-{
-	return tep_find_event(pevent, type);
-}
-
 /**
  * tep_data_pid - parse the PID from record
  * @pevent: a handle to the pevent
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index 262abe3c6c9e..c6bdebf0a0ed 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -520,7 +520,6 @@ tep_find_event_by_record(struct tep_handle *pevent, str=
uct tep_record *record);
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct tep_event *tep_data_event_from_type(struct tep_handle *pevent, int =
type);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *r=
ec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
--=20
2.19.1
