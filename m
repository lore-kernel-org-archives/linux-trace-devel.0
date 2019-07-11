Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6605C74A54
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC4D21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJjqxKvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfGKNDT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45507 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbfGKNDT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so6174163wre.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aAo7p3ZHptVoEnld6jMow6wnAnYCwe3AOVgsegP8tZ8=;
        b=QJjqxKvgpGvtX3f9xb50Mj01TVHLenvNOtnWs+DTW7ou1ZDe2tYPsioF0thq8oTCz0
         bCWfpW+waCLXwjuKpO/YrFrfLmj4pLl2/+Og/SzKinvxQ0Vibr7I/LFnxVZEf55jEFdu
         cM2e272cDatbgtBiFgqRF3tUZJMyZIWfMQT50/jYAKax8EqlHZocIde0uetOIU0sxmcs
         KfyF2bPuzyWxphxvj5vqWIDLpK4Bzhob81fLfZ50ovIOB5RzZToq8BK+vYc7XlNFMEBL
         gV27xlXfDfB+sDxKx4kQwY6dj/dP/dICr/548Y5B1iWnBsGDmU2qBq3jMbeffnU4L+q9
         r1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aAo7p3ZHptVoEnld6jMow6wnAnYCwe3AOVgsegP8tZ8=;
        b=j+Q20viigJNcusd4oorQwH6IHTfoPvZJEwdKoSej5SHDmUbTV9YatrYJmD1yL9ibE+
         DnABJkkvwU7unbZDm2Q6guS0BbdMunZzEjyQNZX/UDIXXidvjZy3CM4Sz4CkkbswCeDB
         jIECOnIjVnSPA8o/7WbawF1lNXzLvgrmuqzm20IhJ7ZXJgA0bUFJ3TV6Dcp/Vc+UNAkS
         PUogGJISP7uq1puJ5ij7T0/5EpRElrAeEErLQe6b5Zxi7qflegFTRC3aDDrDE4AEbCab
         tWMdk0XHOaoDE2Z2bVkKPcgJROx28uEfdQmwdEtDPIPxiKPapj+0PlYNA06wC8og+Jib
         VTiA==
X-Gm-Message-State: APjAAAXOStYzoa5CiqWnoF9Uzw+oAHg0t08r+cEb0ZYYPoSBNJfla34z
        yhNu+lRBhJDPPu6P+hmXlYk=
X-Google-Smtp-Source: APXvYqzuf4icdrx5TJ99yMl7Q1+8jCIGd39fReohEj7v9nLNJVtG/1gTJ5IsRivXsC9h6J4zA6bGPg==
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr5051838wrr.252.1562850196973;
        Thu, 11 Jul 2019 06:03:16 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/7] trace-cmd: Move trace-cmd APIs from trace-cmd.h to trace-local.h
Date:   Thu, 11 Jul 2019 16:03:06 +0300
Message-Id: <20190711130307.25041-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
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
index 5cfb028..409a6ab 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -130,8 +130,6 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
-void tracecmd_create_top_instance(char *name);
-void tracecmd_remove_instances(void);
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
@@ -294,14 +292,7 @@ struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file
 
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
index 1dc2383..38dfdee 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -206,6 +206,17 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 
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

