Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42846C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C203218A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfCUPrW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55191 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbfCUPrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id f3so3306586wmj.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Mar 2019 08:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXdZcegVi6UJa6w5kVdIBecWQKNoeZvUZ5CztYC7GEE=;
        b=Jd2jpfIBdsRW+MeHaqV9BoelqFAXEcFUfrDeH3CLIFxvdyJOmAxmHU2+lw9+6kMq9b
         s8SwcY141zlRdNCfqpngS8NLgpsHFcxLsFr7YT4qFKfHn4+adhY4zZ6u8VWS/8JVMq+v
         TlgCoTDF/5F8zNqbTX2MfGkaQHgoMuS9Tntx7nKiV8VqwUlWsOP+Asxhviy3fc01TnZn
         6EIhnsFussG2Iyao8N8vUNrBFUIMgCVBEIXIwZCin6w/q3sRC72xUmAJ58U5rV1/Iyxy
         uVkBCmOW4Zt1iFsv1LYfj/roApD+RPieNkBAWTBBeymsOEH9w+MClahhqbX/Vselk2oV
         CvxQ==
X-Gm-Message-State: APjAAAW0r23T6q0j+vcCR0i7TS7oqlJ/5hhBwKz5Rpl9FYQjCPdWMh0B
        hGBJ11qpazILSBaiwLtwMm/RxhKw
X-Google-Smtp-Source: APXvYqzcQfbPYtU3iI/yvi5rxOkJ6DwX+osVpol1nPEj8zdwhWDNmEAJ3Gmt16kD9oEQwIZGJTPWWw==
X-Received: by 2002:a1c:9d8f:: with SMTP id g137mr3101350wme.26.1553183238790;
        Thu, 21 Mar 2019 08:47:18 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm8940049wrt.65.2019.03.21.08.47.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 08:47:17 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 6/9] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Thu, 21 Mar 2019 17:47:06 +0200
Message-Id: <20190321154709.24163-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190321154709.24163-1-tstoyanov@vmware.com>
References: <20190321154709.24163-1-tstoyanov@vmware.com>
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

