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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ABAC04FE3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC9B60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhG1NdP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbhG1NdN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6C1C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id oz16so4625823ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IS4eVyl17/7riV3Ye/VRLCqzkuyENMYHuiXjcl4aEw0=;
        b=qI4g6oPlyem1rH3OjqIWfwOV5ZBBpnjBqU/A3m+NPH9qw8pge6RiRoPTA/xQpWZkxN
         EgJCaKOrbOtcU1P4z2FlQXpETC3KSUj5XMwFhbN4E3kf9np/pkABxmLHYPGiwfZ2XsEj
         w8i7qaZ1Qk7/Pok+HuwdTHhsWJSfcVNdfTJ4OQDm5gkgZt667vhjo+FpehDNzMxvfN0w
         sNWPGke349p2cE0F2yZdWBPBDgVjO9rwthxCpJZC+2FPrKgT90i+DQIVqZ8OeHU02Nyd
         FKUwELK5x5qqSHvG9zrE99CvhduDVSzi5sRRUNFLbaV3f/rI56dDZ6JCoMl+av/l7hei
         I1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IS4eVyl17/7riV3Ye/VRLCqzkuyENMYHuiXjcl4aEw0=;
        b=oOBt282WngAGCq8V8QQIz6E0hnvhKA5COyfn85xQ0flwDy3eTGcK2IDsA3Ji1JXJAW
         yX52o1ptwdNi5UGraOR6T7jRU8ikRMBTnKV1syVTFwVU0E8gAwc5PY+jJfagMTHgRSu8
         zrtNE49YSvsJjuzvYCEV+ppdxykJhuvjTQWrNbRUYDJJ1UyCCkYRGZav/01YOewUCEEG
         mRUmBDb3p8d9XVHDRnBav7+kQF56sNRM1qQu+RMVyqJ5Dctg3WlVfkcAMamrpubTWQrl
         tQk8AneOCtYlbbuV60lOqQ7kPSIam66G8rYzAfW6Ix8NFukRS+EaYln/tf+JU4A1Nnb8
         SQQA==
X-Gm-Message-State: AOAM532GAIzBzD93RTNiXQbM6af5tSalecCcQYrSiknqz29cvKMEg9bf
        FtCwC5NOBDCjAWNHRP+D2f0EjTR8tVIcFg==
X-Google-Smtp-Source: ABdhPJx+U2RY8IX4Wq+Y7+Fe0PQuN4whamEVkA6kc5b+lGPeKR0t0xEg2Lann0t8tRQtDa5T9/uUJg==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr27941263ejm.182.1627479190324;
        Wed, 28 Jul 2021 06:33:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 18/87] trace-cmd record: Add compression to the trace context
Date:   Wed, 28 Jul 2021 16:31:41 +0300
Message-Id: <20210728133250.234140-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the trace-cmd libray supports trace file compression, trace-cmd
record command should have a way to configure this functionality. Trace
context is extended to hold the compression algorithm, used to
compress the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8080d612..295fe633 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -199,6 +199,7 @@ struct common_record_context {
 	char *date2ts;
 	char *user;
 	const char *clock;
+	const char *compression;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
 	int tsync_loop_interval;
@@ -3702,6 +3703,12 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
 		goto error;
 	if (tracecmd_output_set_msg(out, msg_handle))
 		goto error;
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= 7) {
+		tracecmd_output_set_compression(out, "any");
+	}
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -3745,6 +3752,12 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 			goto error;
 		if (tracecmd_output_set_version(network_handle, ctx->file_version))
 			goto error;
+		if (ctx->compression) {
+			if (tracecmd_output_set_compression(network_handle, ctx->compression))
+				goto error;
+		} else if (ctx->file_version >= 7) {
+			tracecmd_output_set_compression(network_handle, "any");
+		}
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4475,6 +4488,12 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 		goto error;
 	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
 		goto error;
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= 7) {
+		tracecmd_output_set_compression(out, "any");
+	}
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 	return out;
-- 
2.31.1

