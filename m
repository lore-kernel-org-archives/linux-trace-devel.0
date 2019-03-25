Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBFBC10F03
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5B82084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbfCYOYu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:24:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45924 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbfCYOYt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:24:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id s15so10362175wra.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXdZcegVi6UJa6w5kVdIBecWQKNoeZvUZ5CztYC7GEE=;
        b=b9XabFP+JYKshJ4qP2ofN4F68CNqsOAS6Eq1dRg53beytLf1m9C1bT5ANu2ISi0uuA
         jp1bEKbWaZFNIGh28nmWLpXAritorWFyBSGVjEuGUk8VpI6P+4FYKJbkBXfRhLBeUYeq
         PgpAoj9XLDNbYr+pY+ulQG7eqZJ7czek+9C6DOpN+f7eXvdly41sQZUq82IYtaq7Peh5
         Kj6uT3/FgOePcHgtdFR/9g/oJIjmI0pmfcXSToeU0jOA//dv5Dnh9/XIQyEhbzBk6UNl
         gHc/u8QpKqcc9UlYe7RVg2IkyxGsFf0ZEVPtLBzoyYUikpAB5eJped/kzZqjIDXIjgka
         32Cw==
X-Gm-Message-State: APjAAAUUG+UJ1HUnOocCedbd9M/qR7D1tZLWJ7t80CS2NMbltudzB75v
        pZzV643xII7uGkBLWIPxO7I=
X-Google-Smtp-Source: APXvYqyza3TkYVK2dsPnMlFFABo6JCgdYsIgwO7cV9BFKlYW0GRQy6aGfxR6IvUe/7tW6+hNcTXq4A==
X-Received: by 2002:adf:e648:: with SMTP id b8mr11530633wrn.132.1553523887655;
        Mon, 25 Mar 2019 07:24:47 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s2sm1293440wmc.7.2019.03.25.07.24.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:24:46 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v9 6/9] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Mon, 25 Mar 2019 16:24:36 +0200
Message-Id: <20190325142439.22032-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190325142439.22032-1-tstoyanov@vmware.com>
References: <20190325142439.22032-1-tstoyanov@vmware.com>
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
get_guest_vcpu_pid(), to retrieve VCPU-task mapping for given VM.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        | 57 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 8413054..62f5e47 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -245,6 +245,7 @@ int tracecmd_local_cpu_count(void);
 void tracecmd_set_clock(struct buffer_instance *instance);
 void tracecmd_remove_instance(struct buffer_instance *instance);
 
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index eacf7d2..72a8ed3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2746,10 +2746,12 @@ static bool is_digits(const char *s)
 	return true;
 }
 
+#define VCPUS_MAX 256
 struct guest {
 	char *name;
 	int cid;
 	int pid;
+	int cpu_pid[VCPUS_MAX];
 };
 
 static struct guest *guests;
@@ -2767,6 +2769,46 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry_t;
+	char path[PATH_MAX];
+	char *buf = NULL;
+	size_t n = 0;
+	int vcpu;
+	DIR *dir;
+	FILE *ft;
+
+	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	while ((entry_t = readdir(dir))) {
+		if (!(entry_t->d_type == DT_DIR && is_digits(entry_t->d_name)))
+			continue;
+
+		snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
+			 guest_task, entry_t->d_name);
+		ft = fopen(path, "r");
+		if (!ft)
+			continue;
+		if (getline(&buf, &n, ft) < 0)
+			goto next;
+		if (strncmp(buf, "CPU ", 4) != 0)
+			goto next;
+
+		vcpu = atoi(buf+4);
+		if (!(vcpu >= 0 && vcpu < VCPUS_MAX))
+			goto next;
+		guest->cpu_pid[vcpu] = atoi(entry_t->d_name);
+
+next:
+		fclose(ft);
+	}
+	free(buf);
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -2828,6 +2870,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -2873,6 +2917,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 	return guest;
 }
 
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
+{
+	int i;
+
+	if (!guests || guest_vcpu >= VCPUS_MAX)
+		return -1;
+
+	for (i = 0; i < guests_len; i++)
+		if (guest_cid == guests[i].cid)
+			return guests[i].cpu_pid[guest_vcpu];
+	return -1;
+}
+
 static void set_prio(int prio)
 {
 	struct sched_param sp;
-- 
2.20.1

