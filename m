Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234E9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbhKWWDN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:03:13 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:43361 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236032AbhKWWDN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 17:03:13 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 23 Nov 2021 14:00:00 -0800
Received: from vypre.local.home (unknown [10.21.245.90])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id DB90520176;
        Tue, 23 Nov 2021 14:00:03 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs/sqlhist: Add -B option to use instances for histograms
Date:   Tue, 23 Nov 2021 16:59:56 -0500
Message-ID: <20211123215958.1091307-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123215958.1091307-1-rostedt@goodmis.org>
References: <20211123215958.1091307-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As sqlhist can also create histograms, it should have a way to pass in an
instance value that would be used to create a histogram for a given
instance.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt       | 28 +++++++++++++++++++++-----
 Documentation/libtracefs-sqlhist.txt.1 |  5 +++++
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 3389090..6297e9a 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -330,7 +330,8 @@ enum action {
 
 #define ACTIONS ((ACTION_MAX - 1))
 
-static int do_sql(const char *buffer, const char *name, const char *var,
+static int do_sql(const char *instance_name,
+		  const char *buffer, const char *name, const char *var,
 		  const char *trace_dir, bool execute, int action,
 		  char **save_fields)
 {
@@ -409,15 +410,28 @@ static int do_sql(const char *buffer, const char *name, const char *var,
 		if (execute)
 			tracefs_synth_create(synth);
 	} else {
+		struct tracefs_instance *instance = NULL;
 		struct tracefs_hist *hist;
+
 		hist = tracefs_synth_get_start_hist(synth);
 		if (!hist) {
 			perror("get_start_hist");
 			exit(-1);
 		}
-		tracefs_hist_echo_cmd(&seq, NULL, hist, 0);
+		if (instance_name) {
+			if (execute)
+				instance = tracefs_instance_create(instance_name);
+			else
+				instance = tracefs_instance_alloc(trace_dir,
+								  instance_name);
+			if (!instance) {
+				perror("Failed to create instance");
+				exit(-1);
+			}
+		}
+		tracefs_hist_echo_cmd(&seq, instance, hist, 0);
 		if (execute)
-			tracefs_hist_start(NULL, hist);
+			tracefs_hist_start(instance, hist);
 	}
 
 	tracefs_synth_free(synth);
@@ -434,6 +448,7 @@ int main (int argc, char **argv)
 	char buf[BUFSIZ];
 	int buffer_size = 0;
 	const char *file = NULL;
+	const char *instance = NULL;
 	bool execute = false;
 	char **save_fields = NULL;
 	const char *name;
@@ -446,7 +461,7 @@ int main (int argc, char **argv)
 	int i;
 
 	for (;;) {
-		c = getopt(argc, argv, "ht:f:en:m:c:sS:T");
+		c = getopt(argc, argv, "ht:f:en:m:c:sS:TB:");
 		if (c == -1)
 			break;
 
@@ -488,6 +503,9 @@ int main (int argc, char **argv)
 		case 'T':
 			action |= ACTION_TRACE | ACTION_SNAPSHOT;
 			break;
+		case 'B':
+			instance = optarg;
+			break;
 		case 'n':
 			name = optarg;
 			break;
@@ -528,7 +546,7 @@ int main (int argc, char **argv)
 		}
 	}
 
-	do_sql(buffer, name, var, trace_dir, execute, action, save_fields);
+	do_sql(instance, buffer, name, var, trace_dir, execute, action, save_fields);
 	free(buffer);
 
 	return 0;
diff --git a/Documentation/libtracefs-sqlhist.txt.1 b/Documentation/libtracefs-sqlhist.txt.1
index 1e94ea4..875b250 100644
--- a/Documentation/libtracefs-sqlhist.txt.1
+++ b/Documentation/libtracefs-sqlhist.txt.1
@@ -88,6 +88,11 @@ OPTIONS
     Save the given fields. The fields must be fields of the "end" event given
     in the *SQL-select-command*
 
+*-B* 'instance'::
+    For simple statements that only produce a histogram, the instance given here
+    will be where the histogram will be created. This is ignored for full synthetic
+    event creation, as sythetic events have a global affect on all tracing instances,
+    where as, histograms only affect a single instance.
 
 EXAMPLES
 --------
-- 
2.31.1

