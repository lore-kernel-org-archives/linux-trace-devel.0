Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2CFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiENCzo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiENCzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B6B349934
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2ECC61E05
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D95C3411A;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMB-Bq;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 05/26] trace-cmd: Move find_tasks() into add_guest()
Date:   Fri, 13 May 2022 22:47:35 -0400
Message-Id: <20220514024756.1319681-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In order to simplify the logic a bit, move the find_tasks() code (to find
the PIDs on the host that map to the guest) into the add_guest() function
where the guest is first added.

Link: https://lore.kernel.org/linux-trace-devel/20220428150635.789051-4-rostedt@goodmis.org

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 35 -----------------------------------
 tracecmd/trace-vm.c     | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 67ad1208f90c..5f7ac15dd80a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3215,38 +3215,6 @@ static int do_accept(int sd)
 	return -1;
 }
 
-/* Find all the tasks associated with the guest pid */
-static void find_tasks(struct trace_guest *guest)
-{
-	struct dirent *dent;
-	char *path;
-	DIR *dir;
-	int ret;
-	int tasks = 0;
-
-	ret = asprintf(&path, "/proc/%d/task", guest->pid);
-	if (ret < 0)
-		return;
-
-	dir = opendir(path);
-	free(path);
-	if (!dir)
-		return;
-
-	while ((dent = readdir(dir))) {
-		int *pids;
-		if (!(dent->d_type == DT_DIR && is_digits(dent->d_name)))
-			continue;
-		pids = realloc(guest->task_pids, sizeof(int) * (tasks + 2));
-		if (!pids)
-			break;
-		pids[tasks++] = strtol(dent->d_name, NULL, 0);
-		pids[tasks] = -1;
-		guest->task_pids = pids;
-	}
-	closedir(dir);
-}
-
 static char *parse_guest_name(char *gname, int *cid, int *port,
 			      struct addrinfo **res)
 {
@@ -3287,9 +3255,6 @@ static char *parse_guest_name(char *gname, int *cid, int *port,
 		guest = trace_get_guest(*cid, gname);
 	if (guest) {
 		*cid = guest->cid;
-		/* Mapping not found, search for them */
-		if (!guest->cpu_pid)
-			find_tasks(guest);
 		return guest->name;
 	}
 
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 4b4e039bd2cb..84f28824e3c5 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -54,6 +54,38 @@ bool trace_have_guests_pid(void)
 	return true;
 }
 
+/* Find all the tasks associated with the guest pid */
+static void find_tasks(struct trace_guest *guest)
+{
+	struct dirent *dent;
+	char *path;
+	DIR *dir;
+	int ret;
+	int tasks = 0;
+
+	ret = asprintf(&path, "/proc/%d/task", guest->pid);
+	if (ret < 0)
+		return;
+
+	dir = opendir(path);
+	free(path);
+	if (!dir)
+		return;
+
+	while ((dent = readdir(dir))) {
+		int *pids;
+		if (!(dent->d_type == DT_DIR && is_digits(dent->d_name)))
+			continue;
+		pids = realloc(guest->task_pids, sizeof(int) * (tasks + 2));
+		if (!pids)
+			break;
+		pids[tasks++] = strtol(dent->d_name, NULL, 0);
+		pids[tasks] = -1;
+		guest->task_pids = pids;
+	}
+	closedir(dir);
+}
+
 static void find_pid_by_cid(struct trace_guest *guest);
 
 static struct trace_guest *add_guest(unsigned int cid, const char *name)
@@ -74,6 +106,7 @@ static struct trace_guest *add_guest(unsigned int cid, const char *name)
 	guest->pid = -1;
 
 	find_pid_by_cid(guest);
+	find_tasks(guest);
 
 	return guest;
 }
-- 
2.35.1

