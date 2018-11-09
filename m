Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:38592
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727676AbeKIWjL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 17:39:11 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent: Introduce new libtracevent API:
 tep_override_comm()
Date: Fri, 9 Nov 2018 12:58:35 +0000
Message-ID: <20181109125824.22371-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds a new API of tracevent library: tep_override_comm()
It registers a pid / command mapping. If a mapping with the same
pid already exists, the entry is updated with the new command.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 69 +++++++++++++++++++++++-------
 tools/lib/traceevent/event-parse.h |  1 +
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 4e768357a30d..9147099d27e5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -247,11 +247,13 @@ int tep_pid_is_registered(struct tep_handle *pevent, =
int pid)
  * we must add this pid. This is much slower than when cmdlines
  * are added before the array is initialized.
  */
-static int add_new_comm(struct tep_handle *pevent, const char *comm, int p=
id)
+static int add_new_comm(struct tep_handle *pevent,
+			const char *comm, int pid, bool override)
 {
 	struct cmdline *cmdlines =3D pevent->cmdlines;
-	const struct cmdline *cmdline;
+	struct cmdline *cmdline;
 	struct cmdline key;
+	char *new_comm;
=20
 	if (!pid)
 		return 0;
@@ -262,8 +264,19 @@ static int add_new_comm(struct tep_handle *pevent, con=
st char *comm, int pid)
 	cmdline =3D bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
 		       sizeof(*pevent->cmdlines), cmdline_cmp);
 	if (cmdline) {
-		errno =3D EEXIST;
-		return -1;
+		if (!override) {
+			errno =3D EEXIST;
+			return -1;
+		}
+		new_comm =3D strdup(comm);
+		if(!new_comm) {
+			errno =3D ENOMEM;
+			return -1;
+		}
+		free(cmdline->comm);
+		cmdline->comm =3D new_comm;
+
+		return 0;
 	}
=20
 	cmdlines =3D realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count=
 + 1));
@@ -290,21 +303,13 @@ static int add_new_comm(struct tep_handle *pevent, co=
nst char *comm, int pid)
 	return 0;
 }
=20
-/**
- * tep_register_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
- * @comm: the command line to register
- * @pid: the pid to map the command line to
- *
- * This adds a mapping to search for command line names with
- * a given pid. The comm is duplicated.
- */
-int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid=
)
+static int _tep_register_comm(struct tep_handle *pevent,
+			      const char *comm, int pid, bool override)
 {
 	struct cmdline_list *item;
=20
 	if (pevent->cmdlines)
-		return add_new_comm(pevent, comm, pid);
+		return add_new_comm(pevent, comm, pid, override);
=20
 	item =3D malloc(sizeof(*item));
 	if (!item)
@@ -327,6 +332,40 @@ int tep_register_comm(struct tep_handle *pevent, const=
 char *comm, int pid)
 	return 0;
 }
=20
+/**
+ * tep_register_comm - register a pid / comm mapping
+ * @pevent: handle for the pevent
+ * @comm: the command line to register
+ * @pid: the pid to map the command line to
+ *
+ * This adds a mapping to search for command line names with
+ * a given pid. The comm is duplicated. If a command with the same pid
+ * already exist, -1 is returned and errno is set to EEXIST
+ */
+int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid=
)
+{
+	return _tep_register_comm(pevent, comm, pid, false);
+}
+
+/**
+ * tep_override_comm - register a pid / comm mapping
+ * @pevent: handle for the pevent
+ * @comm: the command line to register
+ * @pid: the pid to map the command line to
+ *
+ * This adds a mapping to search for command line names with
+ * a given pid. The comm is duplicated. If a command with the same pid
+ * already exist, the command string is udapted with the new one
+ */
+int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid=
)
+{
+	if (!pevent->cmdlines && cmdline_init(pevent)) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	return _tep_register_comm(pevent, comm, pid, true);
+}
+
 int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_=
clock)
 {
 	pevent->trace_clock =3D strdup(trace_clock);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index ff74dc392268..8742cf3bff41 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -432,6 +432,7 @@ int tep_set_function_resolver(struct tep_handle *pevent=
,
 			      tep_func_resolver_t *func, void *priv);
 void tep_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid=
);
+int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid=
);
 int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_=
clock);
 int tep_register_function(struct tep_handle *pevent, char *name,
 			  unsigned long long addr, char *mod);
--=20
2.17.2
