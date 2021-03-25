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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9007DC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7D561A10
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCYGll (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhCYGlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9CC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:19 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so502592wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=whyMnEDznYysm82m8ir4n1/f3ymUXiDPfvuizjj6J5M=;
        b=L5zWUy/8nY8fq8B8uhVZENNCz1EA6e4VBclhMEIFcPzB5uwE4KkMJDa69okegsvWTN
         JZ3HcjqiWSp7NOMOq+TKZGzJjWYSrNvsnUyZhc54pE/p2SCGO8kgA0FhcD7HuAgqS09A
         S0hMO37rlE1r2WgPTkV2gVS85WvMLaVmdHs7E0c0hU6ArogTTohiBdwZz6DVEmBOKByG
         XTj1/MSPqbNjTopVo1pHAptnK9tIMwSAfFPIY4HaBPkzG/DmN9mZMFEH4k1yT3eetDta
         DzsrzHplzHheqZvFfj/nUcL+puGh+m8Htb5K/F0yScj6IraltJSm1ZnDf+PcCB+wDctD
         u4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whyMnEDznYysm82m8ir4n1/f3ymUXiDPfvuizjj6J5M=;
        b=gUrvTjd+bKB3aLIh8ly5rJ+ZbsyCcJkWxrIjXDW/ATAcO1kNI8fiNWWnyWX5WvLo6D
         9KQ0NcsN/miywFLWjKPPbXOjIoLBYWHirtBq/kC4fgcOZNChjqw4zG0xm2xJY1mj9QUO
         OGz+8SQXSftx7qPpuVPQTne2+E+W206SHB0LKp3pT1W2MK7WMJ3w8t5bxl3h5Lzsttsn
         QAiWaKkcQfmw3xw7cdeVAs8pCtNIJuKhWlPSDoWtrB2fAAeLQZKL5iYjOV+A1LqCVO6T
         s8RU9o9kXsLwIxy3/z2dye1Hh927kqDjmHxDJPckhDNle7DwzLejn9+HADql3zLut5Bm
         SfrA==
X-Gm-Message-State: AOAM532SFN0NPvLx0Qw5sD4MXA5/fUuEY4TMWk0VuNiqQkXEzhwAjP14
        mGYE6MSxJEkzMdZlf0f3pHA=
X-Google-Smtp-Source: ABdhPJz/G34xyqLoOPyZnDD5zViTfCOzDP3wYABMXuoGKstYowdqr+ZFOian3kgv5gqYhzjLNrPkXg==
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr6295821wmc.74.1616654478334;
        Wed, 24 Mar 2021 23:41:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 22/23] trace-cmd: Save the trace clocks in TRACECLOCK option
Date:   Thu, 25 Mar 2021 08:40:54 +0200
Message-Id: <20210325064055.539554-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Save the content of the trace_clock file in the TRACECLOCK option in
the trace.dat file. The clocks can be printed with "trace-cmd dump
--options" command.
These clocks were saved right before the tracing data in the file, but
this patch set changed that logic. Now only the selected clock is saved
in the file before the tracing data.
Having all supported trace clocks in the file is useful for debug
purposes. Adding clocks in the existing TRACECLOCK option is save and
will not break the older versions of trace-cmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4f412e8d..946bcb4d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4155,6 +4155,7 @@ enum {
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
 {
 	int type = 0;
+	char *clocks;
 
 	if (ctx->date2ts) {
 		if (ctx->data_flags & DATA_FL_DATE)
@@ -4166,12 +4167,15 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	if (type)
 		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
 
-	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
+	clocks = get_trace_clock(false);
+	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK,
+			    clocks ? strlen(clocks)+1 : 0, clocks);
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
 	if (!no_top_instance())
 		add_trace_id(handle, &top_instance);
+	free(clocks);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.30.2

