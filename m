Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EBEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 15:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348675AbiD1PJ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 11:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344429AbiD1PJz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 11:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F78F28E12
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 08:06:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E86E0B82DCD
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 15:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51A9C385B0;
        Thu, 28 Apr 2022 15:06:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nk5j2-003JHC-9y;
        Thu, 28 Apr 2022 11:06:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd: Move find_tasks() into add_guest()
Date:   Thu, 28 Apr 2022 11:06:34 -0400
Message-Id: <20220428150635.789051-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428150635.789051-1-rostedt@goodmis.org>
References: <20220428150635.789051-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In order to simplify the logic a bit, move the find_tasks() code (to find
the PIDs on the host that map to the guest) into the add_guest() function
where the guest is first added.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 35 -----------------------------------
 tracecmd/trace-vm.c     | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d4b5d4d6490f..a4a0d63d907d 100644
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
index f0513950aa26..bf2b0695d09b 100644
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
 static struct trace_guest *add_guest(unsigned int cid, const char *name)
 {
 	struct trace_guest *guest;
@@ -71,6 +103,8 @@ static struct trace_guest *add_guest(unsigned int cid, const char *name)
 	guest->cid = cid;
 	guest->pid = -1;
 
+	find_tasks(guest);
+
 	return guest;
 }
 
-- 
2.35.1

