Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FADCC432C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B88206F0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdZQLAIC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfLCKfh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:37 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34924 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLCKfh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:37 -0500
Received: by mail-lf1-f65.google.com with SMTP id r15so2531036lff.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1vr5+JkKcuoZVsjx/XbK96E0u7JOyC3v723be9HMndo=;
        b=mdZQLAICg0Na9kD7LhvR3LzITosoXHBgrOOYOAPoW4QzQQB9Vm+2fqZjWBlKFjt5vO
         AoZGdnw0m0yYsfI+J3fs3iwUpmJgbwOfzD3G45Bi84n8EhDDhryf14deBX0fNYY++Hk6
         rg+FfDBzhEus/cOSINOA1HJ3vk1dUb+ht/iMyUZE0qP7VisZEY+ZKvXLctg5M5HDbeBf
         6C81dD3ko0E8Vyv+xLEOe7rqudlKLYnkpXQk8aCDrIrw50W5u4EGQYRU1hwX+xzML9kD
         UV2ErBPBvfNxpnpufcllwXjd0zTFVFC9Eubadw2aI+o65nFoVq2YiJyE/Xa7HscDgTKW
         gQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vr5+JkKcuoZVsjx/XbK96E0u7JOyC3v723be9HMndo=;
        b=jalI4z6oWW/yn9BKnGB6I1D1lz3aKrMKsNiCFixhSkxoOioywd0+A0KTNP/KIHZJjT
         JV9Kf6g0o83bwQWBE5q7gS+TkfDJ5iMNe8/lq6T/5+vRzl0+Plg6Mgzq4mUQu16Zau/r
         2H3+jsfa6Jl+JfzLe+e2EL/zcehREytOJmZHq/s8ZGC/vUuaHQlkXFlNPsPFM5HsdyG3
         9bWMjn9JKmw7Edw+HYgs1blSG1Xk46aHa4BzqPTLx0Bh040+kQfuiXz6jv6/3/94/o5q
         hrapSIauNnq/15CRkWB9qfa2z5wVBD11FQSm1nmc+q2CBpP54NhOWmk4TbHfE1ICa1gh
         K1vw==
X-Gm-Message-State: APjAAAWwTI7nXzgaLQNGtZAacKTOV0g7xdMNaow412RwrofPzavmUKwy
        WtBqy+8nUOwG8AZME/yZBEc=
X-Google-Smtp-Source: APXvYqz9JXl8Y5elpedCoMllnHV74RB0jQ7ty2JDpFi22vXy+ObTLsqD4lyweIXjTtRTpUgY1zZviQ==
X-Received: by 2002:ac2:4a91:: with SMTP id l17mr2270005lfp.75.1575369334902;
        Tue, 03 Dec 2019 02:35:34 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 07/18] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Tue,  3 Dec 2019 12:35:11 +0200
Message-Id: <20191203103522.482684-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 57 ++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

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
index 4459c90..fd7ca82 100644
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
@@ -2894,6 +2896,46 @@ static char *get_qemu_guest_name(char *arg)
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
+		if (getline(&buf, &n, f) < 0)
+			goto next;
+		if (strncmp(buf, "CPU ", 4) != 0)
+			goto next;
+
+		vcpu = atoi(buf+4);
+		if (!(vcpu >= 0 && vcpu < VCPUS_MAX))
+			goto next;
+		guest->cpu_pid[vcpu] = atoi(entry->d_name);
+
+next:
+		fclose(f);
+	}
+	free(buf);
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -2957,6 +2999,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -3002,6 +3046,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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

