Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CE2C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFF8F20661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfCHNod (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33030 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfCHNod (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so21418438wrw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c07RBxy3r3sgBU5lzu6Hll8axSgYZtDit0u/zFUdcfM=;
        b=qchbohGAk7P0JJr0zFo9nmsg9qK4IEhP6Twry1RCyqHC+cMBAFrPWx8+DkYIUTVKaD
         KoYNSrSipFJsS3Wifc/Ri4m3IAub4QSNPTUfrtKKfyPazefu7Jqi1v4QODeGo4YBINOu
         XSdkf67PvYjKGuFkMJ4K36XoI0Glvu6cI2XyvOjtu5j8YzIuKX/vo23Rh4LQ3jFhtwwm
         3/l2bQgJpcKZQLOqIYTeR/JkH20jy1cbsaTyEhdUJQ8WDqQNjxmZIOdQdq7de/pwZyS9
         JxdCyurxUBH31TgvTVAr5CITaOhf/fXi59pdoXYbPGlNuYv/HVh88Hi4GZVczOWSZ0cC
         AwtQ==
X-Gm-Message-State: APjAAAUsQtlOzhctqoxSJiboOuNUs53Hvm4b+GEUtnXFDYCNco/wrgyO
        G0XX2Jj/WxjNvkk7NpFcM84=
X-Google-Smtp-Source: APXvYqyBBWmvN0nubcRbQdxNwWBfGmnIzqbuogXFBsTs3g6otKoP5Yhf2BxXq5MuAhu6Cg8DkyuI8w==
X-Received: by 2002:a5d:44c3:: with SMTP id z3mr10702488wrr.329.1552052671273;
        Fri, 08 Mar 2019 05:44:31 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w4sm11631872wmg.8.2019.03.08.05.44.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:30 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 6/9] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Fri,  8 Mar 2019 15:44:20 +0200
Message-Id: <20190308134423.22008-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134423.22008-1-tstoyanov@vmware.com>
References: <20190308134423.22008-1-tstoyanov@vmware.com>
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
 tracecmd/trace-record.c        | 68 ++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

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
index 3950242..d9e9c69 100644
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
@@ -2767,6 +2769,57 @@ static char *get_qemu_guest_name(char *arg)
 	return arg;
 }
 
+static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
+{
+	struct dirent *entry_t;
+	char path[PATH_MAX];
+	unsigned int vcpu;
+	char *buf = NULL;
+	char *cpu_str;
+	DIR *dir;
+	FILE *ft;
+	size_t n;
+	int j;
+
+
+	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	for (entry_t = readdir(dir); entry_t; entry_t = readdir(dir)) {
+		if (!(entry_t->d_type == DT_DIR &&
+		    is_digits(entry_t->d_name)))
+			continue;
+		snprintf(path, sizeof(path),
+			 "/proc/%s/task/%s/comm",
+			 guest_task, entry_t->d_name);
+		ft = fopen(path, "r");
+		if (!ft)
+			continue;
+		getline(&buf, &n, ft);
+		if (buf && strncmp(buf, "CPU ", 4) == 0) {
+			cpu_str = buf;
+			while (*cpu_str != '\0' &&
+				isdigit(*cpu_str) == 0)
+				cpu_str++;
+			if (*cpu_str != '\0') {
+				j = 0;
+				while (cpu_str[j] != '\0' &&
+				       isdigit(cpu_str[j]) != 0)
+					j++;
+				cpu_str[j] = '\0';
+				vcpu = atoi(cpu_str);
+				if (vcpu < VCPUS_MAX)
+					guest->cpu_pid[vcpu] = atoi(entry_t->d_name);
+			}
+		}
+		free(buf);
+		fclose(ft);
+		buf = NULL;
+	}
+}
+
 static void read_qemu_guests(void)
 {
 	static bool initialized;
@@ -2828,6 +2881,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -2873,6 +2928,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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

