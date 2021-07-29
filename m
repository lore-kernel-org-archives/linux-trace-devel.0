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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93A4C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9CC461053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhG2FKY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbhG2FKY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61A5C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:20 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id go31so8445153ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IS4eVyl17/7riV3Ye/VRLCqzkuyENMYHuiXjcl4aEw0=;
        b=CnGCi/r3btTDa5/DyMXHHepWZMAC4KVPLmJPwTpukzTlA5s1UVsfk/oX5D6FaRxVWk
         gtMkZ4+NQ61fYck08lO8M0n3vO99oDcm5gEIsQJLlRVGQlPkWJ7sUhTR27XjFvTBPXW0
         VyLOdv3odu/rY9bbQhBBkwc/F+ZPcuWnK01ARMF/N875o64aVEayxOanUwfDw3UprCE5
         NE1SUFyeINTawaX0XesUN7Td5Y4BxjZ3B4jpJIiztXVN02X/6C3bDD/cIgRCUCZ2+9bn
         4zumSyNSvUgkGaQnOzMMrtOrFp7Smv605w8RNJdD5pmZS3Lpq/cgdNw0syu+TCZ0o1k5
         z+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IS4eVyl17/7riV3Ye/VRLCqzkuyENMYHuiXjcl4aEw0=;
        b=G1+xv2KBufaZNwcqiHi+eAtLYyyo9xYdywk+j2swNGiulyYU/48JqsY0aqqvouJQCW
         qxNojUl62tTVPYeklLTsGxkgA0jmlubEAyNjTg13xou5by9vE9Vdw+s4iSp6hgq0s60R
         idljxHwGGZyUwuVSK9bWfCLkriGL0efVXwGJVTNqPMH03kJdHjVplS8dajVor51rmS3s
         VjWV1km3kiHuLHi7bbS2ydDcgJrp/4A2/yS5ctGHNRAyxa62h9xu5Yq1fiCGMCnfd9Zm
         hYIpbDBTRWMQSi95ul3h0iQjGjf7QMViC0JAx6T2Ughdc+18wSNHWgLVFJi3kl7Qbyhg
         BI8A==
X-Gm-Message-State: AOAM53382xFsR6fwN/7PHghHxk4UdG3CeCV61Ai+iaJ9WStw6G73a5cL
        bVhmSB6V6jpzN2WIyV/UjzY=
X-Google-Smtp-Source: ABdhPJyoZim5QM4uQfqVzBQlDodsIjj4gbF6M8YJWBNdc046Ldi2iiacBKjt+ibEDu907X4wi6IA5w==
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr2880458ejb.519.1627535419341;
        Wed, 28 Jul 2021 22:10:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 18/87] trace-cmd record: Add compression to the trace context
Date:   Thu, 29 Jul 2021 08:08:50 +0300
Message-Id: <20210729050959.12263-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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

