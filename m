Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953FEC35240
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A08F20705
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ueYrlQ3Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgAaMLW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:22 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44406 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgAaMLW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:22 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so6816730ljj.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lIODTiDkEXxOrAfvI1pJ6/Jb21UP2TAO6H6IWlIM9AE=;
        b=ueYrlQ3Zb/l2VMUm5gv+LUbVoLpOxMVsD92W/oD1oIKxEcIaUBVFbJyBE6cAIVIJJ4
         kWXUUD8AU1JBcGk3J5cER+Z6nWdYYDnOkdUx/qrztSVXAnwB8cojbaBW0yoY+c5V0mQC
         uvCb9WEgD8OSdrpQB2PLh/5zlgdb13slMsto+TaAZU/RQ9WMemkjEhhSs9M/w29PttiO
         SaDMUQuNXuDldkllJMsFJymn3/JKpzXtuQKLjpf0iIlj2rltNXPnhoLhL7rIva8pflco
         bKm6tyzUkLhhbEoMQzUrBCi5Z2n943oX4lSMA/g9qZAT351PoG898FfdTsvDhUcLglje
         oCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIODTiDkEXxOrAfvI1pJ6/Jb21UP2TAO6H6IWlIM9AE=;
        b=ZUBdijuHlOYTjNmEK9y4mMaph7TjHY8lx4PNsJ+7Dr05sxmBKyzgI9Du+5mVfqfGpt
         qznAfcz9eqmtN8Ue4NdEzERd8ERHVkefmAFZv+k9zzNtznYV4ET0l1NOcP6Xq8Fv2OlW
         L1uyRhn0pqYEwkEBcUAmBnE3LiDc5LTot1TYM8zGnsupTBjAeVT/ewGyBw6FNrXx37gW
         v3eQOprHY2roOFIdEpw3k/9fcspSjC5ppKVdnOoZFfJfGlJZI4CkD/1RX8zB4+8r4Q1+
         ufIm4GgB6kL0DhpvzLX4yG3ahBTlkvs4gSPKP9kk4uRV68Qdp9X3F0UNiNnp/y5fUxu+
         6Xzw==
X-Gm-Message-State: APjAAAVwYby5RiGyQawiBL+uNqQnQQOg/jms/rzWTaSz4xq3Y33v3Tgc
        EW4X11aFIiuWQgiUjHRe9Ko=
X-Google-Smtp-Source: APXvYqxnW6ZRBJBTRx2XB8aC9tjLmovk/UCZcvtwIDF/2Mw3nW2LxxJ8ijih4T5AjvcrGKpjgcv3yw==
X-Received: by 2002:a2e:9b05:: with SMTP id u5mr5791569lji.59.1580472678800;
        Fri, 31 Jan 2020 04:11:18 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 03/15] trace-cmd: Find and store pids of tasks, which run virtual CPUs of given VM
Date:   Fri, 31 Jan 2020 14:10:59 +0200
Message-Id: <20200131121111.130355-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
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
index 29f2779..a5cf064 100644
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
index 28fe31b..b479e91 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3031,10 +3031,12 @@ static bool is_digits(const char *s)
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
@@ -3052,6 +3054,43 @@ static char *get_qemu_guest_name(char *arg)
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
@@ -3115,6 +3154,8 @@ static void read_qemu_guests(void)
 		if (!is_qemu)
 			goto next;
 
+		read_qemu_guests_pids(entry->d_name, &guest);
+
 		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 		if (!guests)
 			die("Can not allocate guest buffer");
@@ -3160,6 +3201,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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
2.24.1

