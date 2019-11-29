Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D240FC43215
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2E0217D7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpXKQXoJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfK2KRr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:47 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33510 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfK2KRr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:47 -0500
Received: by mail-lj1-f194.google.com with SMTP id t5so31423851ljk.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1vr5+JkKcuoZVsjx/XbK96E0u7JOyC3v723be9HMndo=;
        b=lpXKQXoJ/ImxNQDY9CjvnD4g51Y7/KYuPuW+uKYffyk3ae9oCpDzktcqPb9p9GMkBQ
         IrYy79l8rOkhX+vNwtHyAoQjxBAMXJD1yFi4BCHqbWvATDZXFJklcpdsWsPZ5/H7mDfE
         n4t2m2BafzpEqvMPb+G/4sCCznPQ11RItK4x0+iBh0Li/fonZlYvaOWl1+EJpwb1m8ko
         QnteNbIyy6T008JPxY9bO7iFbEjNbPPseYinmYcUDmQ4r168qLAK5PRI9s8fRqdkwkSM
         dVJcgKv80FjOsLCe3vA607GlfOS7u6W+7ZjBU97VupIW2lGqYu3Z+DSE9nQqi2MI+h/Q
         cAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vr5+JkKcuoZVsjx/XbK96E0u7JOyC3v723be9HMndo=;
        b=ge1MjAvGYhTeyKSweJx4vAWW0Ac33RNRUiVpk83uQw/DnFHZkmv46fIq0fbv1KJQ+z
         tp61WRyYkrMZ2RHw0n0esjbJyA1sWsUM14IILkGCNbHP4dDlv+ljJFf1NmHP+SXZgeUP
         Nu45WSXffizL2DJ/7NMJ7sGMUAno6/nw79hNYhacbssAzS3qpDlI+pEo6T44+IDCWL38
         u34rMbJ7k+OkJGNhpdL5Zwny+P7xkfJ73wSKwW3TsC2SPR239RyPImprfqd7+Lb/i/q7
         V9G2tz2vRj6OxzaYRxOXAnNNtx9eK4LaxcAdrrSr9gv0cbHR1LO1Nz3NCYflHG8Gacc5
         Xt3Q==
X-Gm-Message-State: APjAAAX919SWqj6lnmKFTnBTaLwHK4x1vYhhlYZt6M9lVVTic3lg7cc4
        ZsmRB//xKPmUD9WKqsueYPE=
X-Google-Smtp-Source: APXvYqzkW+ClWJIHFl/DnRmwpVPoFbfLfq7RszJEh3BslXOE9e4SUtAMr9aEIin4yluikQtUCP3hPg==
X-Received: by 2002:a2e:85c3:: with SMTP id h3mr32531624ljj.122.1575022665092;
        Fri, 29 Nov 2019 02:17:45 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 07/18] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Fri, 29 Nov 2019 12:17:22 +0200
Message-Id: <20191129101733.375808-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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

