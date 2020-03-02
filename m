Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD3FC3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4928F20870
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jm3+Og7t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgCBKON (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:13 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36088 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbgCBKOM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:12 -0500
Received: by mail-lf1-f67.google.com with SMTP id s1so7040117lfd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I+b2zBGjmBqRku6irUNtdhWVk0yViz/UwFkx6VNXX6E=;
        b=jm3+Og7tmob1EW069gkVO/XA0RPXtWiEzlQNHVAlKMOnENDo22MLCJzAsxSkiPgFSc
         bpOzVDsbd6BkvXffnlVp8xkTzRdBDyJyUAC1jq6q33Gx4qqZBYZ/d/PTKfihajSuij8Z
         7rWqyYYVEqvQ9IuO3lb/hkP58Dio5c5HPTSJftrHm4W2fpXQ3tc6cGt0Fe7BnTjU+mSw
         GElKVzXCvzz9POS15iyzPRFGnBjG4PC7nfdNnnSSGdOqCitj2YnKRYnyiCaP4amx9Otv
         eu06XkXkrlxPmc0G7CNDfprn8nWelhZQ4OwN41iVyv7SWZSIN9xjqjpJ80mXbKG9t38U
         uRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I+b2zBGjmBqRku6irUNtdhWVk0yViz/UwFkx6VNXX6E=;
        b=G/mNOsM2AS4+n1HC5RZjyEEcI8lFBT+xmv8Cg1POTs0e5A0NkEDm8EuonwY9qUKmWF
         1/WZTcRNnbJx0slpn3Yl1qxMvw7rHahL3c/NDWhHrP9PDCVQPAPoTsqnmlSH6nlJWO+s
         4bDDdqOCsYKiiJR8EUY1G5FivMKyM2kQWBkY3AtPxK18OatBE0P/o5/3q9Y7bd9j4Yc7
         bGhTrP3nKSY2VFQcvKbh4QQbhj14dlh+4vJ5SmCf0H2ELnqCrmQGDwdIPi7bEDa9fIar
         aKfBqn1zd/7vqwXKjrqLuWwY6BozU+dF1vYz1YFC0PLHK8jA/x77UgLn7mrMQz9TT0IY
         YjQw==
X-Gm-Message-State: ANhLgQ046gUGD3GZI/72NkHZtbRnVBAbor900E6jlvlkX7uU4T8H3e5Z
        ZcKuXQPe532MBVqUVNmjSgM=
X-Google-Smtp-Source: ADFU+vvMpJgaGdzkHTHiNO4Hfzv3hBXoyNIimiu0CauN/BcJkx1JngC5D6Dd47Ej013y9VQx5SFNsg==
X-Received: by 2002:a05:6512:3191:: with SMTP id i17mr8543399lfe.33.1583144048640;
        Mon, 02 Mar 2020 02:14:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 01/13] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Mon,  2 Mar 2020 12:13:52 +0200
Message-Id: <20200302101404.150035-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

In order to match host and guest events, a mapping between guest VCPU
and the host task, running this VCPU is needed. Extended existing
struct guest to hold such mapping and added logic in read_qemu_guests()
function to initialize it. Implemented a new internal API,
get_guest_vcpu_pid(), to retrieve VCPU-task mapping for given VM.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-local.h |  2 +
 tracecmd/trace-record.c        | 84 ++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 29f27793..a5cf0640 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -247,6 +247,8 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
+
 /* moved from trace-cmd.h */
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0a3851ad..3cbc832c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3035,11 +3035,32 @@ struct guest {
 	char *name;
 	int cid;
 	int pid;
+	int cpu_max;
+	int *cpu_pid;
 };
 
 static struct guest *guests;
 static size_t guests_len;
 
+static int set_vcpu_pid_mapping(struct guest *guest, int cpu, int pid)
+{
+	int *cpu_pid;
+	int i;
+
+	if (cpu >= guest->cpu_max) {
+		cpu_pid = realloc(guest->cpu_pid, (cpu + 1) * sizeof(int));
+		if (!cpu_pid)
+			return -1;
+		/* Handle sparse CPU numbers */
+		for (i = guest->cpu_max; i < cpu; i++)
+			guest->cpu_pid[i] = -1;
+		guest->cpu_max = cpu + 1;
+		guest->cpu_pid = cpu_pid;
+	}
+	guest->cpu_pid[cpu] = pid;
+	return 0;
+}
+
 static char *get_qemu_guest_name(char *arg)
 {
 	char *tok, *end = arg;
@@ -3052,6 +3073,49 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static int read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry;
+	char path[PATH_MAX];
+	char *buf = NULL;
+	size_t n = 0;
+	long vcpu;
+	long pid;
+	DIR *dir;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
+	dir = opendir(path);
+	if (!dir)
+		return -1;
+
+	while ((entry = readdir(dir))) {
+		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
+			continue;
+
+		snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
+			 guest_task, entry->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+
+		if (getline(&buf, &n, f) >= 0 &&
+		    strncmp(buf, "CPU ", 4) == 0) {
+			vcpu = strtol(buf + 4, NULL, 10);
+			pid = strtol(entry->d_name, NULL, 10);
+			if (vcpu < INT_MAX && pid < INT_MAX &&
+			    vcpu >= 0 && pid >= 0) {
+				if (set_vcpu_pid_mapping(guest, vcpu, pid))
+					return -1;
+			}
+		}
+
+		fclose(f);
+	}
+	free(buf);
+	return 0;
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -3115,6 +3179,10 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		if (read_qemu_guests_pids(entry->d_name, &guest))
+			warning("Failed to retrieve VPCU - PID mapping for guest %s",
+					guest.name ? guest.name : "Unknown");
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -3160,6 +3228,22 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 	return guest;
 }
 
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
+{
+	int i;
+
+	if (!guests)
+		return -1;
+
+	for (i = 0; i < guests_len; i++) {
+		if (guests[i].cpu_pid < 0 || guest_vcpu >= guests[i].cpu_max)
+			continue;
+		if (guest_cid == guests[i].cid)
+			return guests[i].cpu_pid[guest_vcpu];
+	}
+	return -1;
+}
+
 static void set_prio(int prio)
 {
 	struct sched_param sp;
-- 
2.24.1

