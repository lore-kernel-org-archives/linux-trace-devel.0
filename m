Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408D9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhKWWDP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:03:15 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:2237 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236032AbhKWWDO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 17:03:14 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 23 Nov 2021 14:00:01 -0800
Received: from vypre.local.home (unknown [10.21.245.90])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 381EE20146;
        Tue, 23 Nov 2021 14:00:05 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs/Documentation: Modify the hist man page example
Date:   Tue, 23 Nov 2021 16:59:58 -0500
Message-ID: <20211123215958.1091307-4-rostedt@goodmis.org>
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

Update the hist man page example to allow modification of a user defined
histogram type.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 288 +++++++++++++++++++++++++-----
 1 file changed, 242 insertions(+), 46 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index ab802cf..c501d5a 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -245,6 +245,7 @@ EXAMPLE
 [source,c]
 --
 #include <stdlib.h>
+#include <unistd.h>
 #include <tracefs.h>
 
 enum commands {
@@ -256,63 +257,184 @@ enum commands {
 	SHOW,
 };
 
-int main (int argc, char **argv, char **env)
+static void parse_system_event(char *group, char **system, char **event)
+{
+	*system = strtok(group, "/");
+	*event = strtok(NULL, "/");
+	if (!*event) {
+		*event = *system;
+		*system = NULL;
+	}
+}
+
+static int parse_keys(char *keys, struct tracefs_hist_axis **axes)
+{
+	char *sav = NULL;
+	char *key;
+	int cnt = 0;
+
+	for (key = strtok_r(keys, ",", &sav); key; key = strtok_r(NULL, ",", &sav)) {
+		struct tracefs_hist_axis *ax;
+		char *att;
+
+		ax = realloc(*axes, sizeof(*ax) * (cnt + 2));
+		if (!ax) {
+			perror("Failed to allocate axes");
+			exit(-1);
+		}
+		ax[cnt].key = key;
+		ax[cnt].type = 0;
+		ax[cnt + 1].key = NULL;
+		ax[cnt + 1].type = 0;
+
+		*axes = ax;
+
+		att = strchr(key, '.');
+		if (att) {
+			*att++ = '\0';
+			if (strcmp(att, "hex") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_HEX;
+			else if (strcmp(att, "sym") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_SYM;
+			else if (strcmp(att, "sym_offset") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_SYM_OFFSET;
+			else if (strcmp(att, "syscall") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_SYSCALL;
+			else if (strcmp(att, "exec") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_EXECNAME;
+			else if (strcmp(att, "log") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_LOG;
+			else if (strcmp(att, "usecs") == 0)
+				ax[cnt].type = TRACEFS_HIST_KEY_USECS;
+			else {
+				fprintf(stderr, "Undefined attribute '%s'\n", att);
+				fprintf(stderr,"  Acceptable attributes:\n");
+				fprintf(stderr,"    hex, sym, sym_offset, syscall, exe, log, usecs\n");
+				exit(-1);
+			}
+		}
+		cnt++;
+	}
+	return cnt;
+}
+
+static void process_hist(enum commands cmd, const char *instance_name,
+			 char *group, char *keys, char *vals, char *sort,
+			 char *ascend, char *desc)
 {
-	struct tracefs_instance *instance;
+	struct tracefs_instance *instance = NULL;
 	struct tracefs_hist *hist;
 	struct tep_handle *tep;
-	enum commands cmd;
-	char *cmd_str;
+	struct tracefs_hist_axis *axes = NULL;
+	char *system;
+	char *event;
+	char *sav;
+	char *val;
 	int ret;
+	int cnt;
 
-	if (argc < 2) {
-		fprintf(stderr, "usage: %s command\n", argv[0]);
+	if (instance_name) {
+		instance = tracefs_instance_create(instance_name);
+		if (!instance) {
+			fprintf(stderr, "Failed instance create\n");
+			exit(-1);
+		}
+	}
+
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("Could not read events");
 		exit(-1);
 	}
 
-	cmd_str = argv[1];
+	parse_system_event(group, &system, &event);
 
-	if (!strcmp(cmd_str, "start"))
-		cmd = START;
-	else if (!strcmp(cmd_str, "pause"))
-		cmd = PAUSE;
-	else if (!strcmp(cmd_str, "cont"))
-		cmd = CONT;
-	else if (!strcmp(cmd_str, "reset"))
-		cmd = RESET;
-	else if (!strcmp(cmd_str, "delete"))
-		cmd = DELETE;
-	else if (!strcmp(cmd_str, "show"))
-		cmd = SHOW;
-	else {
-		fprintf(stderr, "Unknown command %s\n", cmd_str);
+	if (cmd == SHOW) {
+		char *content;
+		content = tracefs_event_file_read(instance, system, event,
+						  "hist", NULL);
+		if (!content) {
+			perror("Reading hist file");
+			exit(-1);
+		}
+		printf("%s\n", content);
+		free(content);
+		return;
+	}
+
+	if (!keys) {
+		fprintf(stderr, "Command needs -k option\n");
 		exit(-1);
 	}
 
-	instance = tracefs_instance_create("hist_test");
-	if (!instance) {
-		fprintf(stderr, "Failed instance create\n");
+	cnt = parse_keys(keys, &axes);
+	if (!cnt) {
+		fprintf(stderr, "No keys??\n");
 		exit(-1);
 	}
 
-	tep = tracefs_local_events(NULL);
-	hist = tracefs_hist2d_alloc(tep, "kmem", "kmalloc",
-				    "call_site", TRACEFS_HIST_KEY_SYM,
-				    "bytes_req", 0);
+	/* Show examples of hist1d and hist2d */
+	switch (cnt) {
+	case 1:
+		hist = tracefs_hist1d_alloc(tep, system, event,
+					    axes[0].key, axes[0].type);
+		break;
+	case 2:
+		hist = tracefs_hist2d_alloc(tep, system, event,
+					    axes[0].key, axes[0].type,
+					    axes[1].key, axes[1].type);
+		break;
+	default:
+		/* Really, 1 and 2 could use this too */
+		hist = tracefs_hist_alloc(tep, system, event, axes);
+	}
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
 	}
 
-	ret = tracefs_hist_add_value(hist, "bytes_alloc");
-	ret |= tracefs_hist_add_sort_key(hist, "bytes_req");
-	ret |= tracefs_hist_add_sort_key(hist, "bytes_alloc");
+	if (vals) {
+		sav = NULL;
+		for (val = strtok_r(vals, ",", &sav); val; val = strtok_r(NULL, ",", &sav)) {
+			ret = tracefs_hist_add_value(hist, val);
+			if (ret) {
+				fprintf(stderr, "Failed to add value %s\n", val);
+				exit(-1);
+			}
+		}
+	}
 
-	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
-					       TRACEFS_HIST_SORT_DESCENDING);
-	if (ret) {
-		fprintf(stderr, "Failed modifying histogram\n");
-		exit(-1);
+	if (sort) {
+		sav = NULL;
+		for (val = strtok_r(sort, ",", &sav); val; val = strtok_r(NULL, ",", &sav)) {
+			ret = tracefs_hist_add_sort_key(hist, val);
+			if (ret) {
+				fprintf(stderr, "Failed to add sort key/val %s\n", val);
+				exit(-1);
+			}
+		}
+	}
+
+	if (ascend) {
+		sav = NULL;
+		for (val = strtok_r(ascend, ",", &sav); val; val = strtok_r(NULL, ",", &sav)) {
+			ret = tracefs_hist_sort_key_direction(hist, val, TRACEFS_HIST_SORT_ASCENDING);
+			if (ret) {
+				fprintf(stderr, "Failed to add ascending key/val %s\n", val);
+				exit(-1);
+			}
+		}
+	}
+
+	if (desc) {
+		sav = NULL;
+		for (val = strtok_r(desc, ",", &sav); val; val = strtok_r(NULL, ",", &sav)) {
+			ret = tracefs_hist_sort_key_direction(hist, val, TRACEFS_HIST_SORT_DESCENDING);
+			if (ret) {
+				fprintf(stderr, "Failed to add descending key/val %s\n", val);
+				exit(-1);
+			}
+		}
 	}
 
 	tracefs_error_clear(instance);
@@ -338,22 +460,96 @@ int main (int argc, char **argv, char **env)
 	case DELETE:
 		ret = tracefs_hist_destroy(instance, hist);
 		break;
-	case SHOW: {
-		char *content;
-		content = tracefs_event_file_read(instance, "kmem", "kmalloc",
-						  "hist", NULL);
-		ret = content ? 0 : -1;
-		if (content) {
-			printf("%s\n", content);
-			free(content);
-		}
+	case SHOW:
+		/* Show was already done */
 		break;
 	}
-	}
 	if (ret)
 		fprintf(stderr, "Failed: command\n");
 	exit(ret);
 }
+
+int main (int argc, char **argv, char **env)
+{
+	enum commands cmd;
+	char *instance = NULL;
+	char *cmd_str;
+	char *event = NULL;
+	char *keys = NULL;
+	char *vals = NULL;
+	char *sort = NULL;
+	char *desc = NULL;
+	char *ascend = NULL;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s command [-B instance][-e [system/]event][-k keys][-v vals][-s sort]\n", argv[0]);
+		fprintf(stderr, "      [-a ascending][-d descending]\n");
+		exit(-1);
+	}
+
+	cmd_str = argv[1];
+
+	if (!strcmp(cmd_str, "start"))
+		cmd = START;
+	else if (!strcmp(cmd_str, "pause"))
+		cmd = PAUSE;
+	else if (!strcmp(cmd_str, "cont"))
+		cmd = CONT;
+	else if (!strcmp(cmd_str, "reset"))
+		cmd = RESET;
+	else if (!strcmp(cmd_str, "delete"))
+		cmd = DELETE;
+	else if (!strcmp(cmd_str, "show"))
+		cmd = SHOW;
+	else {
+		fprintf(stderr, "Unknown command %s\n", cmd_str);
+		exit(-1);
+	}
+
+	for (;;) {
+		int c;
+
+		c = getopt(argc - 1, argv + 1, "e:k:v:B:s:d:a:");
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'e':
+			event = optarg;
+			break;
+		case 'k':
+			keys = optarg;
+			break;
+		case 'v':
+			vals = optarg;
+			break;
+		case 'B':
+			instance = optarg;
+			break;
+		case 's':
+			sort = optarg;
+			break;
+		case 'd':
+			desc = optarg;
+			break;
+		case 'a':
+			ascend = optarg;
+			break;
+		}
+	}
+	if (!event) {
+		event = "kmem/kmalloc";
+		if (!keys)
+			keys = "call_site.sym,bytes_req";
+		if (!vals)
+			vals = "bytes_alloc";
+		if (!sort)
+			sort = "bytes_req,bytes_alloc";
+		if (!desc)
+			desc = "bytes_alloc";
+	}
+	process_hist(cmd, instance, event, keys, vals, sort, ascend, desc);
+}
 --
 
 FILES
-- 
2.31.1

