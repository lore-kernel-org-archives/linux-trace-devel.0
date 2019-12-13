Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5C1C3B190
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE7422473C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3kYOqYP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfLMPan (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:43 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42382 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbfLMPan (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:43 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so3064619ljo.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ckQhbs4pu9t+HfLoDqwqlAU8S8yQVfnMJvM1Eg0W9GI=;
        b=A3kYOqYP69GBMuNwjnJ56ndEH1OYmlxN4l7IoE4hH4NsnzAMknq2PtWmxiW9GVZ3k5
         ewLRXXXkWDTMhw5ws6PA509RIWgmx/E2Fhu6eCs/T85MU/NJcpGpyxBjlUq2zXOEp6cN
         tlgM4GHb7Qwmq9LDmVXHDxEkqINd9FWoHTsyeNg9NSWiKbGYeiXC9q8l9425lyILqT/2
         HiBIiVZ//IYl6htljWnKmDJw4q5gB5jvmvBfKy4SWzGeNiH3RkpzniAu7OKkmxkoqtGl
         NPttw+5HeWyYh+W5J23ef2Z8s95AA5OmMeVdvtLu1Guv4fZZj/g1CXOCBM0UP8ISHuEx
         0Cyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ckQhbs4pu9t+HfLoDqwqlAU8S8yQVfnMJvM1Eg0W9GI=;
        b=DrhiTaGmBNOi1Jh6IV5qBGrxerWpfSAIpCmkRgtIkDLadbTaxM6b7YQ7g6bulgSTKT
         T8iryoQGAQIyWkZ8W/XkLMnZxTkf+ajbjIEoaKjTeUOFTUdOnjY9bL/rUWDfbtGET52B
         GPnG3afo4cUJ5bqqFr8L2mpCBTZKw1BK9sosXibz57zcODjUL3O1D5RYETVy3sOAEhfP
         HBW7bIoIyl0GxKxR+J0xGhrwPYGF48prW7ozyv6/pzzdGqRJvs2aKEFqGYqQPOYDNOoA
         d4lh3diIZIjDT2GVbF1yVg15VCVjcsFeuW9TwDXfi0BtERmbLHTwkSGyuoxw7QuOvyoh
         PAgg==
X-Gm-Message-State: APjAAAUEyIB/LcMKYGZLWWlHoSu96tlIOZcKkiFiR3PQ0G1Xp91t/CfG
        IMHb5xb6lFumUlUAIsixtsE+li1bdIg=
X-Google-Smtp-Source: APXvYqypADnMyX9uZ5mh8NQkNUy/Nbn0QsdgLUwklv56lCvGdVbLkWqDT8isQq/IK1hURumfIs+Blg==
X-Received: by 2002:a2e:854c:: with SMTP id u12mr9589569ljj.135.1576251040892;
        Fri, 13 Dec 2019 07:30:40 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:40 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 07/18] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Fri, 13 Dec 2019 17:30:18 +0200
Message-Id: <20191213153029.133570-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-record.c        | 54 ++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a51f0d0..51abef1 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -243,6 +243,8 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
+
 /* moved from trace-cmd.h */
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2d95d6f..7a3d687 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2873,10 +2873,12 @@ static bool is_digits(const char *s)
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
@@ -2894,6 +2896,43 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry;
+	char path[PATH_MAX];
+	char *buf = NULL;
+	size_t n = 0;
+	int vcpu;
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
+			vcpu = atoi(buf + 4);
+			if (vcpu >= 0 && vcpu < VCPUS_MAX)
+				guest->cpu_pid[vcpu] = atoi(entry->d_name);
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
@@ -2957,6 +2996,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -3002,6 +3043,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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
2.23.0

