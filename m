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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1D0C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497BF61289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhFNHwh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhFNHwg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:36 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB72DC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id ce15so15022752ejb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SL302fTyFfaFnXlErdYp1JrAPy3ZPN35AL5S03E1of4=;
        b=bdy/q1bnSCqvYEu2xN0kjUgIC0obk/BxHsM4DCb2SIOZoyOa63UjW/TgqmuF4COVYq
         XVop6wCl0K2xWMC/jmh3nL6pWheNeD9tQRFPMja8wO7dYgSPk4GtRqxWn2CWVoJ926gD
         jh+yUXVZB01EZE3tX7zB0Tvn/kSYneQ+zfRTcIzcZzVBIBH8kuZZMLHpHeUle14jKFyj
         1jJgmzVz9K0PvsGPLhmi/ZVphUO50k3KhXu71S1gVuh7LPRMgLZXm0xFcwaOjApdswF4
         U4uIFhM5S6i8kNfD6sBTuvlq9f0X6huISp+BVAMxwN7Rc3ryFjdKsqUEmktKOaoOTA8T
         GXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SL302fTyFfaFnXlErdYp1JrAPy3ZPN35AL5S03E1of4=;
        b=fFx0BvJIaDlhcvr+49Sck3HHWYRLtVaWrfP3b1sMtAw1rVCYUAkqUBosBHrz6r5+6U
         1mv+ZAQurw+bnpn5s0H/gHNfeG4ZDrNcZpSEYkTCBvGPEb2g1U55fC8CQpMx2hujf7P/
         VRyOrjiLU4UHzRRu6MOFY4hs+RgjxsOjWVxok4OxbycipUsuPK+CyRi+e63HPm/OCZXZ
         P+FsusTivEBb8CE6yNTS9pMQjXWq+tDY3SNtUFQyXuBQF0D7GSlJDoRWzYRouEelBYg4
         lr8YVEQyv7feqBgyJghxGwAZ0AeBCT+799q703uOCGTxT4P/DnhEZWeA5c3Uuw2XgNDD
         9rBQ==
X-Gm-Message-State: AOAM533ytXBS5kAHlrwE9VEBWQbx0D2ppG4YwK7SIXIfnbvToFx8Nimx
        HIWsWMmY4FYEq1gYvFSyH4Y=
X-Google-Smtp-Source: ABdhPJzjJUnHXVu92nSCciw2QHdtVKJfON1rg+BttDq0ja+AJbl9uN8N3aPTD1ku1rCI4uTbjdc2FQ==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr13606355ejd.171.1623657032572;
        Mon, 14 Jun 2021 00:50:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 01/45] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Mon, 14 Jun 2021 10:49:45 +0300
Message-Id: <20210614075029.598048-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove these unused private trace-cmd library APIs:
  tracecmd_create_file()
  tracecmd_create_file_glob()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  6 ----
 lib/trace-cmd/trace-output.c                  | 29 -------------------
 2 files changed, 35 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 5c2ab4ca..4bd36baa 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -263,12 +263,6 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *tracecmd_create_file(const char *output_file,
-					     int cpus, char * const *cpu_data_files);
-struct tracecmd_output *
-tracecmd_create_file_glob(const char *output_file,
-			  int cpus, char * const *cpu_data_files,
-			  struct tracecmd_event_list *event_globs);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
 			       struct tracecmd_event_list *list);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a4a1eecc..9231c319 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1614,35 +1614,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	return NULL;
 }
 
-struct tracecmd_output *
-tracecmd_create_file_glob(const char *output_file,
-			  int cpus, char * const *cpu_data_files,
-			  struct tracecmd_event_list *list)
-{
-	struct tracecmd_output *handle;
-
-	handle = create_file(output_file, NULL, NULL, NULL, list);
-	if (!handle)
-		return NULL;
-
-	if (tracecmd_write_cmdlines(handle))
-		return NULL;
-
-	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) < 0) {
-		tracecmd_output_close(handle);
-		return NULL;
-	}
-
-	return handle;
-}
-
-struct tracecmd_output *tracecmd_create_file(const char *output_file,
-					     int cpus, char * const *cpu_data_files)
-{
-	return tracecmd_create_file_glob(output_file, cpus,
-					 cpu_data_files, &all_event_list);
-}
-
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
 	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
-- 
2.31.1

