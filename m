Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD3BC0650F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 843202084F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rRKJa06a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHNIr0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36057 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNIrZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so3721733wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WWBma2i/7R+AkcFwiG7RkXUxMWv7vVicg0twE9szBsk=;
        b=rRKJa06aLIauT0rnqdXJNRRhvf1vCGWbEcJ9SMZpOsKPPyOgT4wmN/ECOYdIFLkm9B
         Sse5gQpdQsgAtviC2tGSupWhjxSwl+eOX0gFu/BdY/tPMI5VQKZPQO/w6N7QI0l/CPqq
         IulzVw/qvLIU3fwPgsUd3z5qMVfYzGn3mzYo/twZD8i2DEFcjF+6iONw4/5FEI2l/2Xy
         CWtBB8n4jLWU02kM/vvCNHY2imyvS7iviqXp4+L4pJnlxmi4zniUbzV1c9qtbQpm9JUH
         pkVwrWlYn9Cbk0ZqA/XWORueG6Ry+09gaBHkD80fi2b043LopnbjqxKfOjcASMXQ4nMn
         YxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WWBma2i/7R+AkcFwiG7RkXUxMWv7vVicg0twE9szBsk=;
        b=h/1gTJ0G9f/TYQtSEFA8G83XMf/xPfgX2n/FJO+N+JoPEyS7Bc6azriQgl9tChISXR
         KWaIBtGJqeCLWfcmEvuAL+bIAWymRT68qcHbHBm7R1JNZskyXRrt4o8bwAHeU4e0iosp
         D5NnifgIdTX32l36RD7HSIxRSeG0XWAFcsfcWt/EuSy4odNdSiCkohrLQ54w8w9P/hWr
         /UfsTDPrtOn1rYW5pHjEt8go+qwZvixDlXQV5ObZxGH2WUr+IeC35+G+dbrCTgQ69Kwl
         F4awtCCIL61VWXwyyM0z1A2uGXnlLPjDWXYGxpjY/m7GFvcKIZDvseS0MkwoTxJXA4uK
         qr6Q==
X-Gm-Message-State: APjAAAXpLwQbSX5eOsyiA338kShDi2XDccLr7RkaevQfrVKHD/FfHK95
        qfCdGNjlY7Pbdx67MS+KzDg=
X-Google-Smtp-Source: APXvYqwxMTy2jVKFNvOZGa8DSVA4ily89+mzUyTwcdssaAgjQGVLh64hRnNhxSSUnStTZgvF5fjOlQ==
X-Received: by 2002:a05:600c:40f:: with SMTP id q15mr7438174wmb.88.1565772443415;
        Wed, 14 Aug 2019 01:47:23 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 7/8] trace-cmd: Move trace-cmd APIs from trace-cmd.h to trace-local.h
Date:   Wed, 14 Aug 2019 11:47:07 +0300
Message-Id: <20190814084712.28188-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These APIs depend on trace-cmd context and cannot be used standalone:
	tracecmd_create_top_instance()
	tracecmd_remove_instances()
	tracecmd_filter_pid()
	tracecmd_add_event()
	tracecmd_enable_events()
	tracecmd_disable_all_tracing()
	tracecmd_disable_tracing()
	tracecmd_enable_tracing()
	tracecmd_stat_cpu()
They are implemented in trace-cmd application, but declared as APIs in
trace-cmd.h. The declarations are moved from trace-cmd.h to trace-local.h,
local header file visible only to trace-cmd application.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |  9 ---------
 tracecmd/include/trace-local.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 8db0686..2c8d798 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -137,8 +137,6 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
-void tracecmd_create_top_instance(char *name);
-void tracecmd_remove_instances(void);
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
@@ -304,14 +302,7 @@ struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
-void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
-void tracecmd_filter_pid(int pid, int exclude);
-int tracecmd_add_event(const char *event_str, int stack);
-void tracecmd_enable_events(void);
-void tracecmd_disable_all_tracing(int disable_tracer);
-void tracecmd_disable_tracing(void);
-void tracecmd_enable_tracing(void);
 
 enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index e2d5506..05760d8 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -216,6 +216,17 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
 
+/* moved from trace-cmd.h */
+void tracecmd_create_top_instance(char *name);
+void tracecmd_remove_instances(void);
+void tracecmd_filter_pid(int pid, int exclude);
+int tracecmd_add_event(const char *event_str, int stack);
+void tracecmd_enable_events(void);
+void tracecmd_disable_all_tracing(int disable_tracer);
+void tracecmd_disable_tracing(void);
+void tracecmd_enable_tracing(void);
+void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
+
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
-- 
2.21.0

