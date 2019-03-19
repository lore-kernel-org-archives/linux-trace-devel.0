Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2885C10F03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE0B620857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfCSPzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39492 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSPzq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id t124so16985885wma.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wzYnvragE5PrN9Qvgw9Bz1HvcghnIr8mcIUuex4vmIU=;
        b=AnZwIr56/l23SMkbRrDZf+rgWMsT39B+O0EdEnGRWi/RpZ404cxqKBxpGq2KtrXke6
         BHpgtL+AqMm8SG8mdI7u/f9ysIL6B6ghVi46UltY+67ULS0Mt8S0YUa9lDsUTMszf6Bv
         LOvIoaIieAhUXORgIwiTiv9CrEcWLGImjPZbaqHSLJnXweMtyPZbKMo2fhYbnxzwip3O
         lp2FeXUB3OSKnNgUyCd1fSXRxjhdF+poId/YJ6J1cJWj80eRy7MO+7izgQO/GkGcTk1C
         L809IvOVKPPwn0CubyGnG5pVanAHD4jKG1gq0t2LXSPHiWFyIrPM8M1n7T/c78r2at8Y
         hgHg==
X-Gm-Message-State: APjAAAXRWkqX4IB98pNul416ScOuLCzMuPPUnwYw/u32wl203kP2koLT
        rFpL2VzZtHVrPNb62VJ4keI=
X-Google-Smtp-Source: APXvYqw5iZBreMScK3D+f/v8NxTlYwjmagF3Jwv3qHI65YeDXMrRBddkFUGBEZxPdSGSFiWSEbBp0A==
X-Received: by 2002:a1c:3845:: with SMTP id f66mr3934452wma.41.1553010944512;
        Tue, 19 Mar 2019 08:55:44 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:43 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 6/9] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Tue, 19 Mar 2019 17:55:33 +0200
Message-Id: <20190319155536.19381-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319155536.19381-1-tstoyanov@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
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
 tracecmd/trace-record.c        | 56 ++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

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
index 3950242..8c8e46f 100644
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
@@ -2767,6 +2769,45 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry_t;
+	char path[PATH_MAX];
+	unsigned int vcpu;
+	char *buf = NULL;
+	DIR *dir;
+	FILE *ft;
+	size_t n;
+
+	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	for (entry_t = readdir(dir); entry_t; entry_t = readdir(dir)) {
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
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -2828,6 +2869,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -2873,6 +2916,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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

