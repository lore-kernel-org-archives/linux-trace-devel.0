Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BACC3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EFA223403
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9aQJmxc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfH1I55 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33756 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1I54 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so1663701wrr.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDK+MrZiBymTI91BeSXyb/ij9m9Dyr5WqrTahcYK5D4=;
        b=E9aQJmxcn7w3w6vBidEYDXOTr4R1t8hEYP9XMmy9WYkfEY8asOhjAlM1RDpMj1IjnU
         MWCxeWfkNb59oPXyurKodHlk7JOlWT21XJn6Qse2XcFn0GJWroOdiAgAobsuFxvN3xLa
         mW8l0N7mU+ORZHXZq+p1vLJtTl2qo963dzDlL0dScruVkyqLxj3pz8OfOU/9HW314TEa
         xuis3iQ0sn1IVPgQgcGzbQJP0iubrQkxsS+ncnKsd0HwbmKKCheWYTNoinYUkCnJZ06t
         2zks91dphj8xPHwDnnJ1QPCDeE8Y1oXlE0MFsr/0tq1riicbiUgKGBa+BHqotoMp34ZK
         u4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDK+MrZiBymTI91BeSXyb/ij9m9Dyr5WqrTahcYK5D4=;
        b=j8xahXRt/npCnSRBqvhV6dqDeSE0JQqIDfuj8LU22NTNtniID6Ac+Ryj2Q8RY/gedn
         +f8Ux2kLSqjyNixWISS4qjqNSY0mzUvycKA1HMAWIj0zhK29LhZjH768jWxukHN++xma
         l3VipWR24dAVQRJGkQMjap6XToxNoOQUlyfBpgIh7GRe7s1R1OW+pT/XJU9WFuOFKYLc
         nAgGUde0cyA4z1GZ5e03GSRy63yuaVrmQbyB12rKd++9tyVh5Q86diyS/kT31TZeqJcA
         fGQz2ad8p5+ze/4bxs1rwgAaQiRvv//MMli9vf6qlgFAxiYjWLutbsUpeVfD9eszlxIt
         2stw==
X-Gm-Message-State: APjAAAXNYzgIh3HrDZR6u3nXGeaHzk21JoscHRH11CgCkjFFFRdFJiiX
        +AQA4dM+joXA5PCsDuiRSRY=
X-Google-Smtp-Source: APXvYqx9malN13MVfv5ig1O6TDndZ9COYb6JpN6i9Hvvdpu6fP566xenAgRlSvJbmXa3p4QxeTLzCQ==
X-Received: by 2002:a5d:4f81:: with SMTP id d1mr3247961wru.177.1566982674489;
        Wed, 28 Aug 2019 01:57:54 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 6/9] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Wed, 28 Aug 2019 11:57:43 +0300
Message-Id: <20190828085746.26231-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828085746.26231-1-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
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
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        | 57 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1d305bf..a4166b8 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -247,6 +247,7 @@ int tracecmd_local_cpu_count(void);
 void tracecmd_set_clock(struct buffer_instance *instance);
 void tracecmd_remove_instance(struct buffer_instance *instance);
 
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index db1d37a..c30a57e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2795,10 +2795,12 @@ static bool is_digits(const char *s)
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
@@ -2816,6 +2818,46 @@ static char *get_qemu_guest_name(char *arg)
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
@@ -2879,6 +2921,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -2996,6 +3040,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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
2.21.0

