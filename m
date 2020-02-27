Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F11C3F35B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B951B2468F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uQwBJ9pp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgB0OUO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:14 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42069 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389286AbgB0OUK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id d10so3594407ljl.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yiF6QtTYqc6joapxz43L77Kv6esYCIHA1NtahqXpj5c=;
        b=uQwBJ9ppMU2qlXp5UWyYUiABJpeprj4A8hMPF3IrhEe9q99uA5bFTnX8CcrWRnBlVE
         u6/WAeccqCisKFEjK4fH5Z8H/IeDZ18wWoYCFjLS9uMnwKTmZjq8puyMbEBxCVpCaykC
         52YMDB8gx9Yf/NzE/fig8HHtCqR4mjObRwq+WBsFZBoAysTWnshY/0/JRLBmyUxNaNQr
         xPzYnxKnQIAHc4iHtj5fgJwQ7NsUcpL64V4f320YJ5lMtgcd8NJ8CDVSO7Vpbhvx4WVL
         BN+m8wpF2ch2W5UeQ5eKx+EbxkKkWmEHQW3saOTFcgGbWpN+c6wvQYvCGbD2Ema41yvp
         pzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yiF6QtTYqc6joapxz43L77Kv6esYCIHA1NtahqXpj5c=;
        b=TQbhlcWSY3CCA5kWp/NV6/vvRSjwJMeo4k2jCZBpQa1gjXdTEok3PUkmOljwrPqHea
         dCSNx2FQEROj8q47HXg2Lvaik2y5lMoKsiYSulMAeY2laxK3h/rLd2rgtLQGCL5lxrfe
         o563JPB69F22QlgNi+T3oEEuJGMxKfBAmUMXHmTkbPEd9FKBNBf5rOdWtDG61OlQ/p/D
         Ap1y3o2VAoKHg31KKgwIABQ/On23HhvLOJzq04Mgtbg506c6GqG0yAMQtmgTtO0vSzjD
         ZqnEjwWhXQI8+Q9jCfryhyIQnko87bItOd2IQs22H/GYpz3lZfNxqcwKIjXwuzdOGIAo
         85zQ==
X-Gm-Message-State: ANhLgQ0kExz4qVkhgFPCw42UQsFbHw/ydsOn54tnMFknNNBdKTCbKQVr
        WRFLPcfpRK4tCbCDGG3Py3wTOIBXxlU=
X-Google-Smtp-Source: ADFU+vshd2DCLxc3QIU60l2hb6lX/J54gBxS53Z/HsYBIe9PdKoKLd8/N8Fv0sgi4VZ0+0nQ1mOVdA==
X-Received: by 2002:a2e:9748:: with SMTP id f8mr3213392ljj.178.1582813208499;
        Thu, 27 Feb 2020 06:20:08 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 03/15] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Thu, 27 Feb 2020 16:19:49 +0200
Message-Id: <20200227142001.61577-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 77 ++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

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
index 28fe31b7..4370c964 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3035,11 +3035,30 @@ struct guest {
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
+
+	if (cpu < 0 || pid < 0)
+		return -1;
+	if (cpu >= guest->cpu_max) {
+		cpu_pid = realloc(guest->cpu_pid, (cpu + 1) * sizeof(int));
+		if (!cpu_pid)
+			return -1;
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
@@ -3052,6 +3071,46 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry;
+	char path[PATH_MAX];
+	char *buf = NULL;
+	size_t n = 0;
+	long int vcpu;
+	long int pid;
+	DIR *dir;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
+	dir = opendir(path);
+	if (!dir)
+		return;
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
+			    vcpu >= 0 && pid >= 0)
+				set_vcpu_pid_mapping(guest, vcpu, pid);
+		}
+
+		fclose(f);
+	}
+	free(buf);
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -3115,6 +3174,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -3160,6 +3221,22 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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
+		if (!guests[i].cpu_pid || guest_vcpu >= guests[i].cpu_max)
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

