Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF58C433C1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41BDB61927
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCVKA2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCVJ74 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:56 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE94C061756
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bf3so18534976edb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kOJH3HXZvkfc6Wmych7kH3mxO/LHuz9jlLGyUgMKjN4=;
        b=cLoa+aw13LQcwVj7mfmq/bY9Px96CBFDeYAJcLZ+IKLzDdgcnXrgtTfbZ03klSouek
         1cdMPm5BWbA87sHnzUrz84VbKahN/S+RBNfE282lAPM5Tt7Yvv3ptTYB/flSjgfWC3pq
         07gQ/L8k7lgICoBQppQ2P6sCH6oDh2kLsPzGqQbbNimbXcr4bhGTOHt8hQVW2+IbcbqJ
         c3yXXJodSW2rCCWOmCowS6RUV/nqHryo3jUHHqcfp70MG6Qqzcu4OzFbQ3IjTS5pdDUx
         xhFKYbfdgmy0HRXgbMcKeNfLgcmTbsicZ/Q0KSXjY1blB3pKPjbUxDhi4RMVML2xqU0n
         G3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOJH3HXZvkfc6Wmych7kH3mxO/LHuz9jlLGyUgMKjN4=;
        b=N/QvDEpEVAgUDSrmvEa0sMlAQ7UHsRyI26M7gA7K2+Flf6xBjIvvXIu3rOBSrKVYdw
         fh8RtFW0MDyaelZ8tcXj9TxLficOFNdRdoQoOL2+5NKXWa4LXPMTysS4Vd1+yaSZTzhn
         VTzsz3paBERkKAky2qwO5dECiPsxDCxQmU7/afT2SrlR8Tz0URaW4hAWismwBuxLn59I
         YCFDgRbbuPhI81Dnbo53SWD6WbluEGUNTMEKaX3wRkG4+e/2R4vNWrzkPBnuqldvLY+A
         gFgpJ4yHUrJOmgI7TO634C2l8+q9onrEFo5Qz50IjpN6NuVhaLkcf9IATmFdHGa5kP8w
         7xmw==
X-Gm-Message-State: AOAM53253XiA4xJuuiVSjgYFIvNwTHK5B4Em1PD6PPjBf70uA6sQgyrN
        QEfX99gUZM18fAzZOhdWTUn1DAasHNAIww==
X-Google-Smtp-Source: ABdhPJyP/GsR/OyddRN2+30/yUGBihvSOGz+ZJWxlTmRDm9ZNJ35Ty0DKqBp+I1LUpiVNwJFJc/zjQ==
X-Received: by 2002:a05:6402:b41:: with SMTP id bx1mr24824200edb.69.1616407194934;
        Mon, 22 Mar 2021 02:59:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 08/18] trace-cmd: Save tsc2nsec clock in trace.dat file
Date:   Mon, 22 Mar 2021 11:59:35 +0200
Message-Id: <20210322095945.259300-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
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
index 37a0f486..9ae6e032 100644
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

