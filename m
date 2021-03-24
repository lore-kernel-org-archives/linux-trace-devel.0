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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405DDC433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD87619FB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhCXNF0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhCXNEi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:38 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E80C0613DE
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c8so11466335wrq.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IADVNGrRtbQctJbk3TpTPaQERBg+o+o6wvAZztJ3F14=;
        b=bfdNEE6HqOiHBB25NM7eQTcG2HyWQUX42/K7xqvfLkRnpmncMaQntnkvH8PSYEt4By
         SPBoLUH+gbXCHbL3ct/VYw0CCSVDjIr/gl099MwSw5o4epw+zr/tvXXcdTiAfJ3IniuJ
         v3cT2PSF1au7XsGWBFMVj3bFAygFTuc4flNfr/MoLou8WC5Qf+cAFZkLHucXAkfKF+Kd
         Uj+6bRxn186sMVBgWi1/OjZdHhyDcWD0iwNQtCbo3A5mB8bCDBOAVR+0CYL7a4Tai8aJ
         05LYDfuPCLldr8et+jiGXI3i6QqyELvbyEMwe2y0AFeye9ryh9Fm3pEavJS/SIiYyEMV
         0+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IADVNGrRtbQctJbk3TpTPaQERBg+o+o6wvAZztJ3F14=;
        b=JKoCymc/dOKZ4q5PnaaGnGSD6lQU7AKLBhCjqmG8DDLSoaJxBiH5ut6NRjNNYY4mEM
         IUFyl86zWVEQ36yXH029GXaYMS41286T2qxc2DMXawekgZScc1uugPh7wQXyiIr8k4RK
         iD4LYPK30l0OfsvlihGYmMTkxmpaPeRV4HkwuXR9Rx05a7pMIHfkSlznkAhGd1EvovtS
         DjhAEbUfZ68cp91qRhugghipsbS+kWFYWIULICEkNAuV5O0+BSw4MI/aMK4VjSoEfFyD
         93SmxfdLHPH8JLVB+A6daIreFzsmyj64ZSRU0XnbXGXDnEkMlAaeeVcjxpHSUHcsf0jQ
         ao1Q==
X-Gm-Message-State: AOAM531PXDMm0+tCkgBJZiFMmx6JMAbIbT6Pz2xugzQBOik2Bg8Tqk0r
        lNLaCUu5s1rfSe1uKH0fx+SgJU8nXSYjTQ==
X-Google-Smtp-Source: ABdhPJxXa7f07+6eGasrwxpxip+m4nsPQOITdlx34M9lIMY0mJv9Zo/1H6F5fBORbPfH+23MSJn6zw==
X-Received: by 2002:adf:f186:: with SMTP id h6mr3450847wro.290.1616591076391;
        Wed, 24 Mar 2021 06:04:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 10/23] trace-cmd: Save tsc2nsec clock in trace.dat file
Date:   Wed, 24 Mar 2021 15:04:05 +0200
Message-Id: <20210324130418.436206-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When tsc2nsec clock is used, save it as selected clock in the trace.dat
file. When reading the file, in case of tsc2nsec clock show timestamps
in usec / nsec.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 2 +-
 tracecmd/trace-record.c                           | 9 +++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ce3d8dc0..c33d067a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -22,6 +22,8 @@
 #define TRACECMD_ERROR(ret)	((void *)((unsigned long)(ret) | TRACECMD_ERR_MSK))
 #define TRACECMD_PTR2ERR(ptr)	((unisgned long)(ptr) & ~TRACECMD_ERR_MSK)
 
+#define TSCNSEC_CLOCK	"tsc2nsec"
+
 void tracecmd_parse_cmdlines(struct tep_handle *pevent, char *file, int size);
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ebc28f7b..67915f25 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2906,7 +2906,7 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	/* Clear usecs if not one of the specified clocks */
 	if (strcmp(clock, "local") && strcmp(clock, "global") &&
 	    strcmp(clock, "uptime") && strcmp(clock, "perf") &&
-	    strncmp(clock, "mono", 4))
+	    strncmp(clock, "mono", 4) && strcmp(clock, TSCNSEC_CLOCK))
 		handle->flags &= ~TRACECMD_FL_IN_USECS;
 }
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9b652c64..7d2a8013 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -58,7 +58,6 @@
 #define STAMP		"stamp"
 #define FUNC_STACK_TRACE "func_stack_trace"
 #define TSC_CLOCK	"x86-tsc"
-#define TSCNSEC_CLOCK	"tsc2nsec"
 
 enum trace_type {
 	TRACE_TYPE_RECORD	= 1,
@@ -4168,7 +4167,8 @@ static void write_guest_file(struct buffer_instance *instance)
 	handle = tracecmd_get_output_handle_fd(fd);
 	if (!handle)
 		die("error writing to %s", file);
-
+	if (instance->flags & BUFFER_FL_TSC2NSEC)
+		tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
 	temp_files = malloc(sizeof(*temp_files) * cpu_count);
 	if (!temp_files)
 		die("failed to allocate temp_files for %d cpus",
@@ -4290,9 +4290,10 @@ static void record_data(struct common_record_context *ctx)
 				add_guest_info(handle, instance);
 		}
 
-		if (ctx->tsc2nsec.mult)
+		if (ctx->tsc2nsec.mult) {
 			add_tsc2nsec(handle, &ctx->tsc2nsec);
-
+			tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
+		}
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
-- 
2.30.2

