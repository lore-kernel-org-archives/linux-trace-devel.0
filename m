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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08385C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C329B611CD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhDVHR7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHR6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:17:58 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87461C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:24 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u17so67256897ejk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eafdULNKZwLB0KdjjvZ2tv7rUD83e8yu6hHRFitnUCo=;
        b=OeyOB7rOgCAwmMajdBkFn9MMvCUstfgc76zzPl1foLEnbx2jzLFxXAZNOe133IIPFI
         brSyQj1yAq8CIICelvasnZz6jh4jQdCT61XYhjADtNpJUJ3bZ48/PHONDhI5dl71uj2t
         qcUqWO8x9c0FC9iZO2wzt3z7YbFKFgWej66as4nCpa60wzqEGJFDL/3ocivo5OpqcrG8
         jxeyhQUoTdjDsYWO8YZaOgGjvm4w9Hhu6/xycMubwQNNtEmgAd6WaviAZJpdTWpLx9Mt
         Y2WI1RMmyaH2BDW4HjHfBBWUAPAso/N42nw3Xbc9SPFUS8UHWSk1tBOD+EQ6ZatYkiKw
         WNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eafdULNKZwLB0KdjjvZ2tv7rUD83e8yu6hHRFitnUCo=;
        b=ntBemxugwf1AAz1iDGviyZxag2TlgwwbVUaMPFx4OhftewT0mWqCx6cganHWt5Lsff
         2PvO+t9SG8HdeaQJeq1kjSjzHFOcUpym0PssQpi4ZmIihqd6U+XBM89FPUCvmLb8Iip8
         m2qLCVGZ879yt2QHD7uj1v9ZR3Wt301ZpCBHH6gFQK97AeSRSkaWezpnyx4rzpuuBVOZ
         GMFVudii1FPl6ESQzVIRW2AvYv1pXUrGwFnUthtj47PkSirk8pE7bPrHNx9Q+/2leAVf
         g3SoVBdPt49q7bkEI+QMG+372e0qIM4vsH5nygRyfLESppinE6OS4ne9wSQJenNSbyHJ
         zi2w==
X-Gm-Message-State: AOAM531+5TQ4q2ff1wBSU4g+fvFB6rkl4xQh4kvW0dbumHmzhUbj6L3Q
        1noTpNC12HAc2aSnEx4CEh8=
X-Google-Smtp-Source: ABdhPJy27IvAqQ8VjTYLhYVWlFUDJ+oTmVTT//UYua7QSCOgk/ujQ2blNKYYT2XqGQqlDzKwTgHavg==
X-Received: by 2002:a17:906:cc9b:: with SMTP id oq27mr1839052ejb.81.1619075843295;
        Thu, 22 Apr 2021 00:17:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] trace-cmd library: Add new API to get file version of input handler
Date:   Thu, 22 Apr 2021 10:17:14 +0300
Message-Id: <20210422071718.483383-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422071718.483383-1-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index dccd8ae5..fa5b8880 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a00fa982..b2a03ab8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4034,6 +4034,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.30.2

