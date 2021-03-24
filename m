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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A648C433F1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBD861A19
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhCXNFe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbhCXNEw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:52 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A37C0613DE
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id d191so12850912wmd.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=msOfs+6fUUPf4h8RyhdwB8/EjZwtgK5XFO+5ApYFmuY=;
        b=rtxCMiI8IG1dfZCSKfma1bcwEAMzNxI64w00UtBU58Lh1eeOZFhRDPFyTgPkcyibW6
         lkR9W4Su1P4N1v8VOxOKtHzeaW2SLXvp7THIWyNINIKE9dQnnxms7r8sO/msnxzAU+Io
         G1c3MFJRy0izk6Hkyx/QfEwARq1Aw9A25MPeOUcSQANf8YqCzd6DeKMmU1vkii30Cq/X
         PPm79i/lhsRFak8FKzBpA8amWFS83u7z+DvX1jAOuyyIOnYU3Gw3eDiBgoUYNOdRO2GL
         U6HKwRWicae15pzYB3W0E/OEAkcTCzsxAwVHFx08SwMpro4yckxnovM1X0+SIwXJu3zD
         Th9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=msOfs+6fUUPf4h8RyhdwB8/EjZwtgK5XFO+5ApYFmuY=;
        b=YKBVPWEpbRk/HRkqTiqGOv3c00Vbb7NYJ8VaO8uV5yd/N9X3eQkVanxFD30aPDXOi9
         ifL/OR1nqLsm4SVgdz5Fhcmeslwwe71wed+EAIlQiCaIK9d8s0LN5GiRtP7bWmZcc6SY
         ZIoWRoFZ4PE00Lm+HIdlRVOluaz84s583zArcFLO3YIZaLYGbhlgXGOG4E7G1lKrq/wC
         3um8RNN0oL9HmIpjPxclsh7kysXFKKIgs12z+s6M4gRWv7C3rCRqVqC8ynl1YIwUzu2O
         lNIh3Ml40JzWIX+F/0R4SEcuQIro8KWxDhB1w5INVHHxSrUcbm3pD0YiiJxuJGspn42N
         SJrg==
X-Gm-Message-State: AOAM531tlcZbBvA66R3XGj39iXvIyKLnuXJG1MPK2ir1wWIpiEWMJ7Sq
        qOJoOneZ8B3omCrpLGKW6RXTL19AxSLRLQ==
X-Google-Smtp-Source: ABdhPJxlk0pNc6IOZRcAYaJmFpFGuN5yPemR3J0Z5iQw6FH/j/5HJx/c9caSLtJq5KlX0rfLGh1Zug==
X-Received: by 2002:a05:600c:289:: with SMTP id 9mr2887636wmk.135.1616591090506;
        Wed, 24 Mar 2021 06:04:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 22/23] trace-cmd: Save the trace clocks in TRACECLOCK option
Date:   Wed, 24 Mar 2021 15:04:17 +0200
Message-Id: <20210324130418.436206-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
index 2fc6723a..f4c27ef1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4138,6 +4138,7 @@ enum {
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
 {
 	int type = 0;
+	char *clocks;
 
 	if (ctx->date2ts) {
 		if (ctx->data_flags & DATA_FL_DATE)
@@ -4149,12 +4150,15 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	if (type)
 		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
 
-	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
+	clocks = tracefs_instance_file_read(NULL, "trace_clock", NULL);
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

