Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AD0C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4293E61185
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhDZKgS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhDZKgR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 06:36:17 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F4FC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:35:32 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id zg3so2048947ejb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/e+J8Gn67mvIBUWuHCxwTwKma/Pt0S07co0ecyrzo4=;
        b=Sy0ebDTT1TD6P1nXg5wU42qpr4WDfOE7O70zSaQzf22y7yqrmmMXxPJpHYX7k5pqpD
         Lx8geHj9Wp8EiL2zg14off3NsID+K/UH3UYHmg/PKrtee4zoykZPrvLxCxJfr9Eh5kj9
         QZXReGzkkGJtnoC2v2EKCB0h54cMMveKkRiHVLU3fN0A8cZ6kCScy7kicB8pK8Der2qH
         Y/YZBJpGQB18798FcDN/ZpP5jatv12V4RsghbnPyeWnK1MOlbA+dTBx5l/h90mvJkI7c
         UA6nEUA17bg47XzzUc8lq8c66y3HrURyDmqnAWnuomwdSp639PuY5gcgxopdPcPxV/6/
         mw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/e+J8Gn67mvIBUWuHCxwTwKma/Pt0S07co0ecyrzo4=;
        b=BHCcMjZ74yaeAYEdVfAAB/sfK63myBAt3caK3k7oLqCuok+ubWMcL0EUA39p/aub5O
         Fy93iD4eLUY0GpNkr3PpByyIOo1R0b2JiLlcivsKid+nzT2WYCqkujMY6LMFS4ZZCpkh
         ZLoTFw8eTu+pd/Y6sommc8m1aI9R66WirrTlb+941UJBbwXWoi0hsTWjUVX68ggWTAlG
         TdvHEXNrgRj39JRi/yFw2d7/bSWME0gE2pRmU8ASbVgGz2dsSfw1/1H6yDmvOwJpHEuC
         R1TZDIL1LY21j25ADiJ0pqnCXj/lNlgLY/RZMokoDYeMmSTuO0Ym/Rw/0kZgdEfAQjDm
         cNWA==
X-Gm-Message-State: AOAM530/ipbDjbeyoUhOFoJPQkA+2ltukvqo4ZN2kvZDHatJFFnyRdjL
        SjZcwhztMALND5y+KLPQdP0=
X-Google-Smtp-Source: ABdhPJwQuHQmhOSFoO/mtV9CuFeXkjiXrRxSRNIx2b99H3uLc+4VIZ11NhqujWbUpgCkgJB26QNCYg==
X-Received: by 2002:a17:906:6d48:: with SMTP id a8mr18252377ejt.92.1619433331103;
        Mon, 26 Apr 2021 03:35:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qu23sm6148077ejb.1.2021.04.26.03.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 03:35:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, joelaf@google.com
Subject: [PATCH] trace-cmd: Add support for non-qemu VMs
Date:   Mon, 26 Apr 2021 13:35:28 +0300
Message-Id: <20210426103528.634418-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Current host-guest tracing implementation assumes that qemu runs the VMs
and uses qemu specific logic to collect various information:
 - PID of the process, running the guest VM. In case of KVM, this PID
   is used  to get the KVM guest TSC clock parameters, needed for better
   host and guest trace timestamps synchronization.
 - PIDs of each thread, running a guest virtual CPU. This is used for
   better trace visualisation. It helps to map the host task to a vCPU
   and to visualise them together.
In case qemu is not used to run the VMs, host-guest tracing fails. As
that information is not mandatory, we can easily support non-qemu VMs.
Changes, proposed by the patch:
 - if PID of the process, running the guest VM, is not available - fail
   back to a PTP-like algorithm for trace timestamps synchronization.
 - if PIDs of the threads, running guest virtual CPUs, are not available
   write -1 in the trace file metadata.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |  4 +--
 tracecmd/trace-record.c        | 36 ++++++++++++-------------
 tracecmd/trace-vm.c            | 48 ++++++++++++++++++++++++++++++++--
 3 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1218de12..04d8f32c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -301,8 +301,8 @@ struct trace_guest {
 	int cpu_max;
 	int *cpu_pid;
 };
-struct trace_guest *get_guest_by_cid(unsigned int guest_cid);
-struct trace_guest *get_guest_by_name(char *name);
+struct trace_guest *trace_get_guest(unsigned int cid, const char *name);
+bool trace_have_guests_pid(void);
 void read_qemu_guests(void);
 int get_guest_pid(unsigned int guest_cid);
 int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fd03a605..4636475f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3251,10 +3251,7 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
 		*cid = atoi(gname);
 
 	read_qemu_guests();
-	if (*cid > 0)
-		guest = get_guest_by_cid(*cid);
-	else
-		guest = get_guest_by_name(gname);
+	guest = trace_get_guest(*cid, gname);
 	if (guest) {
 		*cid = guest->cid;
 		return guest->name;
@@ -3723,14 +3720,14 @@ static int host_tsync(struct common_record_context *ctx,
 
 	if (!proto)
 		return -1;
-	guest = get_guest_by_cid(instance->cid);
+	guest = trace_get_guest(instance->cid, NULL);
 	if (guest == NULL)
 		return -1;
 
 	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
 						    instance->tsync_loop_interval,
 						    instance->cid, tsync_port,
-						    guest->pid, guest->cpu_max,
+						    guest->pid, instance->cpu_count,
 						    proto, ctx->clock);
 	if (!instance->tsync)
 		return -1;
@@ -3792,6 +3789,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 			printf("Negotiated %s time sync protocol with guest %s\n",
 				tsync_protos_reply,
 				instance->name);
+			instance->cpu_count = nr_cpus;
 			host_tsync(ctx, instance, tsync_port, tsync_protos_reply);
 		} else
 			warning("Failed to negotiate timestamps synchronization with the guest");
@@ -3975,21 +3973,19 @@ static void append_buffer(struct tracecmd_output *handle,
 static void
 add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
-	struct trace_guest *guest = get_guest_by_cid(instance->cid);
+	struct trace_guest *guest = trace_get_guest(instance->cid, NULL);
 	char *buf, *p;
 	int size;
+	int pid;
 	int i;
 
 	if (!guest)
 		return;
-	for (i = 0; i < guest->cpu_max; i++)
-		if (!guest->cpu_pid[i])
-			break;
 
 	size = strlen(guest->name) + 1;
-	size +=  sizeof(long long);	/* trace_id */
-	size +=  sizeof(int);		/* cpu count */
-	size += i * 2 * sizeof(int);	/* cpu,pid pair */
+	size += sizeof(long long);	/* trace_id */
+	size += sizeof(int);		/* cpu count */
+	size += instance->cpu_count * 2 * sizeof(int);	/* cpu,pid pair */
 
 	buf = calloc(1, size);
 	if (!buf)
@@ -4001,14 +3997,16 @@ add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 	memcpy(p, &instance->trace_id, sizeof(long long));
 	p += sizeof(long long);
 
-	memcpy(p, &i, sizeof(int));
+	memcpy(p, &instance->cpu_count, sizeof(int));
 	p += sizeof(int);
-	for (i = 0; i < guest->cpu_max; i++) {
-		if (!guest->cpu_pid[i])
-			break;
+	for (i = 0; i < instance->cpu_count; i++) {
+		if (i < guest->cpu_max)
+			pid = guest->cpu_pid[i];
+		else
+			pid = -1;
 		memcpy(p, &i, sizeof(int));
 		p += sizeof(int);
-		memcpy(p, &guest->cpu_pid[i], sizeof(int));
+		memcpy(p, &pid, sizeof(int));
 		p += sizeof(int);
 	}
 
@@ -6553,12 +6551,14 @@ static void set_tsync_params(struct common_record_context *ctx)
 	/*
 	 * If no clock is configured &&
 	 * KVM time sync protocol is available &&
+	 * there is information of each guest PID process &&
 	 * tsc-x86 clock is supported &&
 	 * TSC to nsec multiplier and shift are available:
 	 * force using the x86-tsc clock for this host-guest tracing session
 	 * and store TSC to nsec multiplier and shift.
 	 */
 		if (tsync_proto_is_supported("kvm") &&
+		    trace_have_guests_pid() &&
 		    clock_is_supported(NULL, TSC_CLOCK) &&
 		    !get_tsc_nsec(&shift, &mult) && mult) {
 			clock = strdup(TSC_CLOCK);
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index c8924ece..c0333b67 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -35,7 +35,7 @@ static int set_vcpu_pid_mapping(struct trace_guest *guest, int cpu, int pid)
 	return 0;
 }
 
-struct trace_guest *get_guest_by_cid(unsigned int guest_cid)
+static struct trace_guest *get_guest_by_cid(unsigned int guest_cid)
 {
 	int i;
 
@@ -48,7 +48,7 @@ struct trace_guest *get_guest_by_cid(unsigned int guest_cid)
 	return NULL;
 }
 
-struct trace_guest *get_guest_by_name(char *name)
+static struct trace_guest *get_guest_by_name(const char *name)
 {
 	int i;
 
@@ -61,6 +61,50 @@ struct trace_guest *get_guest_by_name(char *name)
 	return NULL;
 }
 
+bool trace_have_guests_pid(void)
+{
+	for (int i = 0; i < guests_len; i++) {
+		if (guests[i].pid < 0)
+			return false;
+	}
+
+	return true;
+}
+
+static struct trace_guest *add_guest(unsigned int cid, const char *name)
+{
+	guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
+	if (!guests)
+		die("allocating new guest");
+	memset(&guests[guests_len], 0, sizeof(struct trace_guest));
+	guests[guests_len].name = strdup(name);
+	if (!guests[guests_len].name)
+		die("allocating guest name");
+	guests[guests_len].cid = cid;
+	guests[guests_len].pid = -1;
+	guests_len++;
+
+	return &guests[guests_len - 1];
+}
+
+struct trace_guest *trace_get_guest(unsigned int cid, const char *name)
+{
+	struct trace_guest *guest = NULL;
+
+	if (name) {
+		guest = get_guest_by_name(name);
+		if (guest)
+			return guest;
+	}
+
+	if (cid > 0) {
+		guest = get_guest_by_cid(cid);
+		if (!guest && name)
+			guest = add_guest(cid, name);
+	}
+	return guest;
+}
+
 static char *get_qemu_guest_name(char *arg)
 {
 	char *tok, *end = arg;
-- 
2.30.2

