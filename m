Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B0EC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 905FA610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhINNS3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhINNS0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63A9C061764
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u16so20167981wrn.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yao3HSHynO3fw2qebc1cDpu949X61cymkG+rYeq5V9A=;
        b=HgrT/2TETgdp8SrUiZYK5L45+IfAGrMFWL9Zshf6mk9qeOATdvqMJWATrvYq/se27J
         pcrmkXgBwcOd8EGBSAzpvcLV4kC24ZLgy/gbzWntWaiNMJvbwKA8CNe4k4tlGd7ak9sX
         5dvxmv0+91suRNq1dYWm5T8xCvhjrjJyx4Jc1U6TIhcJXl+oQEzNM63hoso4RZCt7VAT
         2RbtiY2nob1/Deu6FUqT8NBZ9j1y0LRdf8mgbC7R+pXnHhb5sou4gjmBZab7wg/guh5G
         pWB2A6Hl8Kr9LHoONx9zHTtXQszGPTIfyL0Wc6+B9wGYS9tlSEtS4Aow1V2j9x9dYvTU
         SIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yao3HSHynO3fw2qebc1cDpu949X61cymkG+rYeq5V9A=;
        b=WKYuEjeFdBjiLLyRtUO2+VXnP7retxVkmmF6WVhJahEmfFpPrbEvztB58mazT8M4Ci
         Fm4Sm44R0P1mlR6a2FPSSlwVo4KgSecxnJ3ZEiPZsagwrYwH2xkIWbkS//b+wuHRiM6Q
         IDrOaWnCc37cW7Nim0wq4jZ2fFT672qYK2rVSQlSVNO0+S4iQKICOzl+4OIEiuVqFNZa
         z+2BEZEsLDNb2d9FBThuCRhH/LqxckPsLlTqmfmz9rY1otKAOxWvG9jcBCUFUx8qZhop
         +38XUVH5oJLIfNqthptjLeIiEBAcagC78T1xpsibVjgq484ZK/U0o33xexvyjt5scCiK
         Ulxw==
X-Gm-Message-State: AOAM5339xR0+O2P9L5c+luNIVDbymyxEAH0X4pqVUn8aPWBgFG7JP8Wl
        LXruPzwnGeS0KOvf9i1ubO1xynak2Dg=
X-Google-Smtp-Source: ABdhPJwEw+gZw5eJKx6Q2TGLbpJAtV5TeNqAIte7YwhaEhMhbr6BoPbZ5cjs2WMFee8mbuoxwonT+g==
X-Received: by 2002:a5d:61c1:: with SMTP id q1mr17100691wrv.154.1631625427285;
        Tue, 14 Sep 2021 06:17:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 19/20] trace-cmd record: Add compression to the trace context
Date:   Tue, 14 Sep 2021 16:16:44 +0300
Message-Id: <20210914131645.3966308-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the trace-cmd library supports trace file compression, trace-cmd
record command should have a way to configure this functionality. Trace
context is extended to hold the compression algorithm, used to
compress the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fb6de81b..72592c60 100644
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
+	} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(out, "any");
+	}
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -3748,6 +3755,12 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 			goto error;
 		if (tracecmd_output_set_version(network_handle, ctx->file_version))
 			goto error;
+		if (ctx->compression) {
+			if (tracecmd_output_set_compression(network_handle, ctx->compression))
+				goto error;
+		} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+			tracecmd_output_set_compression(network_handle, "any");
+		}
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4481,6 +4494,12 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 		goto error;
 	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
 		goto error;
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(out, "any");
+	}
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 	return out;
@@ -4516,7 +4535,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version, NULL);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.31.1

