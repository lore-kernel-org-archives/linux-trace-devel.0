Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4F3C10F03
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A345D214AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbfDYLFl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:05:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51919 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730655AbfDYLFl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 07:05:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id 4so8701673wmf.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Apr 2019 04:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eoy1fsBUqinUHdQUdYGsrDJ7SqNLo6asBwqfIWBBVf0=;
        b=WBDL0wLV4daoek4l8zghEdnzWlawHBW7HM6jx64SAfPbQX9EBhL9U+JP3OgfsYK8aZ
         hiLoH32MZCpL/k9CTvbYuOnJrYXQmjAlM/QVCOQqyzm8TUtwj/MaNqFYYdm/WfhmMU0c
         wi9wSoMs1QnUNo0VIrws5QKlL7TmakwmGDJ3R6dk9QFqh20fEzH2jbKpM8QbLirxqQH2
         FKuUJxxat7fc8YjTXrhstRUhCWngmH+wd5lj5lYOZR7DluVrG/oPHpA2Zwdi57q+Y0gT
         m7ScKlqcZxCRm9JkrqSTpPebOHkEEUj1IfWFnuONUqqFVQQwTJeIzOmUiQOKzsRyWgTn
         QZKw==
X-Gm-Message-State: APjAAAWzrKd7yNWEahXuNFgbJpIm6e7gqCvxuIAowjCV2Xtsx+vu7fQF
        fD9ORNuTNT4NbpxUYGNdI/zSKWQo
X-Google-Smtp-Source: APXvYqx6KygnL81AMzafgxmdHX36JKtKWi+4xmNUyjOCAIs1yntxS53qrOba1etIP5uB6o1/lNqKUQ==
X-Received: by 2002:a7b:cc12:: with SMTP id f18mr3205335wmh.40.1556190339451;
        Thu, 25 Apr 2019 04:05:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a6sm23013606wrp.49.2019.04.25.04.05.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 04:05:39 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 6/9] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Thu, 25 Apr 2019 14:05:28 +0300
Message-Id: <20190425110531.8941-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190425110531.8941-1-tstoyanov@vmware.com>
References: <20190425110531.8941-1-tstoyanov@vmware.com>
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
index 554f1a3..7f4d676 100644
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
index 4a82773..59a4170 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2789,10 +2789,12 @@ static bool is_digits(const char *s)
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
@@ -2810,6 +2812,46 @@ static char *get_qemu_guest_name(char *arg)
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
@@ -2871,6 +2913,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -2986,6 +3030,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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

