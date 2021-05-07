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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2BCC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 17:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02474613ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 17:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhEGR1H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbhEGR1G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 13:27:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B24C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 10:26:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id t4so14825167ejo.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 10:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nt2lw69otq/SNzG5AuO9vP14ebGpehR5Sgq5ppERp/A=;
        b=OIh+GaWcQjs8qXqcQlprP21cutz93/N+6ebjrEXciu0bxUWAAVsZ71s0EFzb44iuvn
         fP/jgPRGNJa2TytBBSM8kzCk6IE/PIppzFr+lat/zMY8XQHx86Oo6GrMRY7cR2eLW34L
         1wtBFQEmvqq5O2l+x9432brSxTkFVsqein+bjyUT6udfkfbtQeOLjEbtLy1XyCnucPGb
         R95ohSuAqsytsgDWrqLqKvS2hH7Tkf+pMjvBfTmThxpk8xS8Kp41Cfc2DOiFPtLHLbke
         VaIkpPf/guoC4+ulSbvZy2b5sL01JkQxNkx37ONbgeaY1GZ9JLHG6u9Uh+sdpiyzBk4h
         iehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nt2lw69otq/SNzG5AuO9vP14ebGpehR5Sgq5ppERp/A=;
        b=d5lbdJkagVelJyXeCYGwgtC82kmAD3XyyFFWyZ0h4ZtbtgeSvS8vBTyxEj2YiMn62c
         LAf+fhUM5HTMGUMxxsG36fZh5QcwFRXH1EZr3keokppBIdJqOrPb03m5lyOrQ5DHx7px
         BEacyyUdZWTUMVJ6y0VgTfDUk/5iUFc6laggo5ChjFOJPxF0URfUoXXTUnOWhM5/RVnl
         RjSrhdwYkDA6jcmIsv8o5ru55GmW8PYu1KPbTz9EP3sSCXuGgmkn0xWfeIn7r1iMr/Z2
         MPi6UUfKSQaD732dfeRq6tZ5CerTx1KajWf5R54Dcd4a6QQsj3wNZA/RE7qtafjIO6wG
         oh1w==
X-Gm-Message-State: AOAM5325sZzYGmNTYZMSznAlzX1mQRufpQDuD4HOaIIHUTHd4lXU540v
        sBnRH/95WEvpxGjVRyJKkW/EHGgP+kqtZw==
X-Google-Smtp-Source: ABdhPJxdedQk/8u9JYFAQd3X9HA9G6nZO/K5GAXsp2t+LTuDsaY54utEhVByv2ARXeig/+rHMWm0pg==
X-Received: by 2002:a17:907:3f28:: with SMTP id hq40mr11054674ejc.283.1620408364459;
        Fri, 07 May 2021 10:26:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z12sm4521391edr.17.2021.05.07.10.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 10:26:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Set user specified clock to all trace instances
Date:   Fri,  7 May 2021 20:26:02 +0300
Message-Id: <20210507172602.1253305-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is a user specified clock with "-C" option, apply it to all
trace instances, if there is no user clock for the instance. This
ensures that by default, all trace instances use the same trace clock.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5dd8be4a..3014f560 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2766,8 +2766,9 @@ void tracecmd_enable_events(void)
 	enable_events(first_instance);
 }
 
-static void set_clock(struct buffer_instance *instance)
+static void set_clock(struct common_record_context *ctx, struct buffer_instance *instance)
 {
+	const char *clock;
 	char *path;
 	char *content;
 	char *str;
@@ -2775,7 +2776,12 @@ static void set_clock(struct buffer_instance *instance)
 	if (is_guest(instance))
 		return;
 
-	if (!instance->clock)
+	if (instance->clock)
+		clock = instance->clock;
+	else
+		clock = ctx->clock;
+
+	if (!clock)
 		return;
 
 	/* The current clock is in brackets, reset it when we are done */
@@ -2798,7 +2804,7 @@ static void set_clock(struct buffer_instance *instance)
 	tracefs_put_tracing_file(path);
 
 	tracefs_instance_file_write(instance->tracefs,
-				    "trace_clock", instance->clock);
+				    "trace_clock", clock);
 }
 
 static void set_max_graph_depth(struct buffer_instance *instance, char *max_graph_depth)
@@ -6633,7 +6639,7 @@ static void record_trace(int argc, char **argv,
 		tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
-		set_clock(instance);
+		set_clock(ctx, instance);
 
 
 	/* Record records the date first */
-- 
2.31.1

