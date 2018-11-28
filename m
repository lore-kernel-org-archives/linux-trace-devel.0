Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:55564
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727883AbeK1UIs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:48 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 10/15] tools/lib/traceevent: Rename struct cmdline to
 struct tep_cmdline
Date: Wed, 28 Nov 2018 09:07:41 +0000
Message-ID: <20181128090711.17792-11-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
In-Reply-To: <20181128090711.17792-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_".
This patch renames struct cmdline to struct tep_cmdline.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-local.h |  4 +--
 tools/lib/traceevent/event-parse.c       | 36 ++++++++++++------------
 tools/lib/traceevent/event-parse.h       |  8 +++---
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 9a092dd4a86d..35833ee32d6c 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -7,7 +7,7 @@
 #ifndef _PARSE_EVENTS_INT_H
 #define _PARSE_EVENTS_INT_H
=20
-struct cmdline;
+struct tep_cmdline;
 struct cmdline_list;
 struct func_map;
 struct func_list;
@@ -36,7 +36,7 @@ struct tep_handle {
 	int long_size;
 	int page_size;
=20
-	struct cmdline *cmdlines;
+	struct tep_cmdline *cmdlines;
 	struct cmdline_list *cmdlist;
 	int cmdline_count;
=20
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index e9d9728385a2..af502b970dd9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -139,15 +139,15 @@ struct tep_print_arg *alloc_arg(void)
 	return calloc(1, sizeof(struct tep_print_arg));
 }
=20
-struct cmdline {
+struct tep_cmdline {
 	char *comm;
 	int pid;
 };
=20
 static int cmdline_cmp(const void *a, const void *b)
 {
-	const struct cmdline *ca =3D a;
-	const struct cmdline *cb =3D b;
+	const struct tep_cmdline *ca =3D a;
+	const struct tep_cmdline *cb =3D b;
=20
 	if (ca->pid < cb->pid)
 		return -1;
@@ -167,7 +167,7 @@ static int cmdline_init(struct tep_handle *pevent)
 {
 	struct cmdline_list *cmdlist =3D pevent->cmdlist;
 	struct cmdline_list *item;
-	struct cmdline *cmdlines;
+	struct tep_cmdline *cmdlines;
 	int i;
=20
 	cmdlines =3D malloc(sizeof(*cmdlines) * pevent->cmdline_count);
@@ -194,8 +194,8 @@ static int cmdline_init(struct tep_handle *pevent)
=20
 static const char *find_cmdline(struct tep_handle *pevent, int pid)
 {
-	const struct cmdline *comm;
-	struct cmdline key;
+	const struct tep_cmdline *comm;
+	struct tep_cmdline key;
=20
 	if (!pid)
 		return "<idle>";
@@ -223,8 +223,8 @@ static const char *find_cmdline(struct tep_handle *peve=
nt, int pid)
  */
 int tep_pid_is_registered(struct tep_handle *pevent, int pid)
 {
-	const struct cmdline *comm;
-	struct cmdline key;
+	const struct tep_cmdline *comm;
+	struct tep_cmdline key;
=20
 	if (!pid)
 		return 1;
@@ -250,9 +250,9 @@ int tep_pid_is_registered(struct tep_handle *pevent, in=
t pid)
 static int add_new_comm(struct tep_handle *pevent,
 			const char *comm, int pid, bool override)
 {
-	struct cmdline *cmdlines =3D pevent->cmdlines;
-	struct cmdline *cmdline;
-	struct cmdline key;
+	struct tep_cmdline *cmdlines =3D pevent->cmdlines;
+	struct tep_cmdline *cmdline;
+	struct tep_cmdline key;
 	char *new_comm;
=20
 	if (!pid)
@@ -5345,8 +5345,8 @@ const char *tep_data_comm_from_pid(struct tep_handle =
*pevent, int pid)
 	return comm;
 }
=20
-static struct cmdline *
-pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdli=
ne *next)
+static struct tep_cmdline *
+pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_c=
mdline *next)
 {
 	struct cmdline_list *cmdlist =3D (struct cmdline_list *)next;
=20
@@ -5358,7 +5358,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const cha=
r *comm, struct cmdline *ne
 	while (cmdlist && strcmp(cmdlist->comm, comm) !=3D 0)
 		cmdlist =3D cmdlist->next;
=20
-	return (struct cmdline *)cmdlist;
+	return (struct tep_cmdline *)cmdlist;
 }
=20
 /**
@@ -5374,10 +5374,10 @@ pid_from_cmdlist(struct tep_handle *pevent, const c=
har *comm, struct cmdline *ne
  * next pid.
  * Also, it does a linear seach, so it may be slow.
  */
-struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const ch=
ar *comm,
-				       struct cmdline *next)
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, cons=
t char *comm,
+					   struct tep_cmdline *next)
 {
-	struct cmdline *cmdline;
+	struct tep_cmdline *cmdline;
=20
 	/*
 	 * If the cmdlines have not been converted yet, then use
@@ -5416,7 +5416,7 @@ struct cmdline *tep_data_pid_from_comm(struct tep_han=
dle *pevent, const char *co
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
+int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline=
)
 {
 	struct cmdline_list *cmdlist =3D (struct cmdline_list *)cmdline;
=20
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index e6f36cdb836d..15f421428fce 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -526,10 +526,10 @@ int tep_data_pid(struct tep_handle *pevent, struct te=
p_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *r=
ec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
 const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid);
-struct cmdline;
-struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const ch=
ar *comm,
-				       struct cmdline *next);
-int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
+struct tep_cmdline;
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, cons=
t char *comm,
+					   struct tep_cmdline *next);
+int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline=
);
=20
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
--=20
2.19.1
