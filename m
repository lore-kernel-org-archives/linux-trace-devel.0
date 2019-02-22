Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D40FC10F0B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57FF82075A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfBVO2q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:46 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38477 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVO2q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:46 -0500
Received: by mail-wm1-f67.google.com with SMTP id v26so2150041wmh.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IIFyUucP7K4v0qLKAqa28gYnIzAYgIFIORZpsMA9ufo=;
        b=HmtU3i+dUowiUsXhDs48yIQ6OWCJD8m1fQ7gJWgn+vQXWqv9QkBXWqquKWoYRQXHGV
         VY9glTToF6bGGWVxaY3NCZ92CAWatAEvfkcAx1+LbTT0H3o/GC2MwcIoS+918z8rObao
         xHLwMpygA7PyEgmvGNInxf5Jcp2A+FD5lTyNoVOTG+V5IqFHP1WzuVeNaMR6mTuQ+oT7
         QPk/5ShfFgwZHkSmAfMJOHTbQ99QBxb6sARYAYJkA+BBfL/M7SPHJZkFevXr4mJ1sNuX
         Ybeut0fwm5YctvW/f51MVvy6hWOin1DsY/HhS0FLIVCkAvXAig3TSAPicnhBgRpSMcr2
         L//A==
X-Gm-Message-State: AHQUAua2OTkkK7JFfPopPEFGjugb+TKPbQcF9C5YAU6bSm3kXaOuuufY
        UhDBAwXKmBHKvbCxTkWgbOWe9QaO
X-Google-Smtp-Source: AHgI3Ia//COswqvEvqtbuj7/yOFEMSCx47NQo7NxAGKFeQpTk3+D2aMNXcJahMu6+gQPifY33WEt9Q==
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr2555800wmh.141.1550845723457;
        Fri, 22 Feb 2019 06:28:43 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:42 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 6/7] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Fri, 22 Feb 2019 16:28:35 +0200
Message-Id: <20190222142836.12596-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222142836.12596-1-tstoyanov@vmware.com>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to match host and guest events, a mapping between guest VCPU
and the host task, running this VCPU is needed. Extended existing
struct guest to hold such mapping and added logic in read_qemu_guests()
function to initialize it. Implemented a new internal API,
get_guest_vcpu_pids(), to retrieve VCPU-task mapping for given VM.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-local.h |  3 ++
 tracecmd/trace-record.c        | 57 +++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d7bdb1f..ef6848f 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -236,6 +236,9 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
 
+#define VCPUS_MAX	256
+int *get_guest_vcpu_pids(int cid);
+
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c57ed6b..59f0197 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2752,6 +2752,7 @@ struct guest {
 	char *name;
 	int cid;
 	int pid;
+	int cpu_pid[VCPUS_MAX];
 };
 
 static struct guest *guests;
@@ -2772,9 +2773,10 @@ static char *get_qemu_guest_name(char *arg)
 static void read_qemu_guests(void)
 {
 	static bool initialized;
+	struct dirent *entry_t;
 	struct dirent *entry;
 	char path[PATH_MAX];
-	DIR *dir;
+	DIR *dir, *dir_t;
 
 	if (initialized)
 		return;
@@ -2830,6 +2832,49 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		snprintf(path, sizeof(path), "/proc/%s/task", entry->d_name);
+		dir_t = opendir(path);
+		if (dir_t) {
+			unsigned int vcpu;
+			char *buf = NULL;
+			char *cpu_str;
+			FILE *ft;
+			size_t n;
+			int j;
+
+			for (entry_t = readdir(dir_t); entry_t; entry_t = readdir(dir_t)) {
+				if (!(entry_t->d_type == DT_DIR &&
+				    is_digits(entry_t->d_name)))
+					continue;
+				snprintf(path, sizeof(path),
+					 "/proc/%s/task/%s/comm",
+					 entry->d_name, entry_t->d_name);
+				ft = fopen(path, "r");
+				if (!ft)
+					continue;
+				getline(&buf, &n, ft);
+				if (buf && strncmp(buf, "CPU ", 4) == 0) {
+					cpu_str = buf;
+					while (*cpu_str != '\0' &&
+						isdigit(*cpu_str) == 0)
+						cpu_str++;
+					if (*cpu_str != '\0') {
+						j = 0;
+						while (cpu_str[j] != '\0' &&
+						       isdigit(cpu_str[j]) != 0)
+							j++;
+						cpu_str[j] = '\0';
+						vcpu = atoi(cpu_str);
+						if (vcpu < VCPUS_MAX)
+							guest.cpu_pid[vcpu] = atoi(entry_t->d_name);
+					}
+				}
+				free(buf);
+				fclose(ft);
+				buf = NULL;
+			}
+		}
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -2875,6 +2920,16 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 	return guest;
 }
 
+int *get_guest_vcpu_pids(int cid)
+{
+	int i;
+
+	for (i = 0; i < guests_len; i++)
+		if (cid == guests[i].cid)
+			return guests[i].cpu_pid;
+	return NULL;
+}
+
 static void set_prio(int prio)
 {
 	struct sched_param sp;
-- 
2.20.1

