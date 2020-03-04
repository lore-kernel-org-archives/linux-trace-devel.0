Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3B2C3F2CD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB332072D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vtq61F8O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgCDJM1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:27 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42511 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCDJM0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:26 -0500
Received: by mail-lf1-f66.google.com with SMTP id t21so862936lfe.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OwW2M4vLJx3K6cWfp/7SWMlbw3i16QmqwaxJCzTzYlE=;
        b=Vtq61F8O1YRQ2Aoh+lnz0OwtJjTfjQTyZ0bz+UwVG8++THM0ihJJccL/coNF0u/uZv
         HC1Fl184q/D5lilWIPJ+SLo8MN2/SaHGvERPE8tO86bWtFK+4e+vA+GJFvWkKpUc3f04
         JFyTQbq7gbnMtl4lSzmYsNhVHQO3FDNtClY6865lhhzAtiYGf3GTAfa62I5LAZIvfiz3
         deKocZi9Nqk9t9xUXH960U8dylpYENZzimOklx69b5xaOPUxxN7tKBfPVSz2u0TKZmd6
         ZqcI1U/BYeWtOW9UVNYdkCHFG1P3vpHwLgNCWJ10wdY1Q1Lp3QMpnM1UeB+Jkc1nM/lN
         SpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OwW2M4vLJx3K6cWfp/7SWMlbw3i16QmqwaxJCzTzYlE=;
        b=Ob/cC+EXeg5RvGzRkDK/wa9ws+Gr95nCJ29kHJfvzUosjfn4g9fsET1bsGCemRpPva
         /nIrnV1urkXn4hAK9rymfrZXJpeluMj9QEG4QNSz+Y8D0GHZEjnQO1xhe+G+WupYx0FJ
         HDh5s7CXUDAiFBox8zVCnbqHnbATswQF79d9GNNK4iWpq/fVF0/TC2uL8bBNX6xM0MXA
         dm82n3GbEawsB7yPr4Aui9ylgzhxgk4osuluyJ33aWTxFZw+EiNDOI3Fdl0js1xC3/v0
         uhH+qRZre5fhIgKCTEzkjrcf3ahhOAvwB7YFyDwofx8KSm1rOUwv4lt+423uyWbwyp+O
         JvcQ==
X-Gm-Message-State: ANhLgQ1imMfIQaPLtnSolegkgpx3e4uZEPAPS3lNSZ3jy5WSZNR8ivMb
        CzHbXIDgHSLb9t+S2eHzMPU=
X-Google-Smtp-Source: ADFU+vvor2NhbIJ9CF7mdExFW/XqvfIjIMVsMQDPrQzgm1scaNP1CYk5HuAWlDPIhQCRu0rzL422Mg==
X-Received: by 2002:a19:ed08:: with SMTP id y8mr1447156lfy.56.1583313143980;
        Wed, 04 Mar 2020 01:12:23 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 01/13] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Wed,  4 Mar 2020 11:12:08 +0200
Message-Id: <20200304091220.30936-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 85 ++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

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
index 0a3851ad..9ed79856 100644
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
+			cpu_pid[i] = -1;
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
@@ -3052,6 +3073,50 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static int read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry;
+	char path[PATH_MAX];
+	char *buf = NULL;
+	size_t n = 0;
+	int ret = 0;
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
+	while (!ret && (entry = readdir(dir))) {
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
+					ret = 1;
+			}
+		}
+
+		fclose(f);
+	}
+	free(buf);
+	return ret;
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -3115,6 +3180,10 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		if (read_qemu_guests_pids(entry->d_name, &guest))
+			warning("Failed to retrieve VPCU - PID mapping for guest %s",
+					guest.name ? guest.name : "Unknown");
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -3160,6 +3229,22 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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

