Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752BFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhKVXxT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:19 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7565 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhKVXxR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:17 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:07 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id B28DB20250;
        Mon, 22 Nov 2021 15:50:09 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 09/11] libtracefs/Documentation: Update libtracefs-hist-cont.txt to new API
Date:   Mon, 22 Nov 2021 18:49:54 -0500
Message-ID: <20211122234956.788401-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The histogram API has changed. Update the man page example to reflect
that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist-cont.txt | 27 +++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 778b8ee..5cdcc0a 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -66,6 +66,7 @@ int main (int argc, char **argv, char **env)
 {
 	struct tracefs_instance *instance;
 	struct tracefs_hist *hist;
+	struct tep_handle *tep;
 	enum commands cmd;
 	char *cmd_str;
 	int ret;
@@ -94,22 +95,29 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("Reading tracefs");
+		exit(-1);
+	}
+
 	instance = tracefs_instance_create("hist_test");
 	if (!instance) {
 		fprintf(stderr, "Failed instance create\n");
 		exit(-1);
 	}
 
-	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
-				  "call_site", TRACEFS_HIST_KEY_SYM,
-				  "bytes_req", 0);
+	hist = tracefs_hist2d_alloc(tep, "kmem", "kmalloc",
+				    "call_site",TRACEFS_HIST_KEY_SYM,
+				    "bytes_req", 0);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
 	}
 
 	ret = tracefs_hist_add_value(hist, "bytes_alloc");
-	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
+	ret |= tracefs_hist_add_sort_key(hist, "bytes_req");
+	ret |= tracefs_hist_add_sort_key(hist, "bytes_alloc");
 
 	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
 					       TRACEFS_HIST_SORT_DESCENDING);
@@ -122,7 +130,7 @@ int main (int argc, char **argv, char **env)
 
 	switch (cmd) {
 	case START:
-		ret = tracefs_hist_start(hist);
+		ret = tracefs_hist_start(instance, hist);
 		if (ret) {
 			char *err = tracefs_error_last(instance);
 			if (err)
@@ -130,16 +138,16 @@ int main (int argc, char **argv, char **env)
 		}
 		break;
 	case PAUSE:
-		ret = tracefs_hist_pause(hist);
+		ret = tracefs_hist_pause(instance, hist);
 		break;
 	case CONT:
-		ret = tracefs_hist_continue(hist);
+		ret = tracefs_hist_continue(instance, hist);
 		break;
 	case RESET:
-		ret = tracefs_hist_reset(hist);
+		ret = tracefs_hist_reset(instance, hist);
 		break;
 	case DELETE:
-		ret = tracefs_hist_destroy(hist);
+		ret = tracefs_hist_destroy(instance, hist);
 		break;
 	case SHOW: {
 		char *content;
@@ -157,6 +165,7 @@ int main (int argc, char **argv, char **env)
 		fprintf(stderr, "Failed: command\n");
 	exit(ret);
 }
+
 --
 
 FILES
-- 
2.31.1

