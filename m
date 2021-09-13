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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB29C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7BF660FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhIMMnj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbhIMMnj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:39 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4565DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:23 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d6so14455700wrc.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yao3HSHynO3fw2qebc1cDpu949X61cymkG+rYeq5V9A=;
        b=o1bm22BQ8qraueUTGC8UdhCt2XxbzQyxTdyN4WLzw223HcRVJOMlNcFor4oeD0oGrh
         dnZmrVRkBFanLlbQuaNRcFCBwihx/lAE4enrqxdLMUKOsNAYLEkq4aq8jXi4XnpS/tNQ
         UysYXw4j02JBNVg2c7EfG3sFkEbgunzK3XzAn3gUPGShwWHmM31XthB2afK1OHCutawt
         zhsiiezWoFLjqUdN1iz18XYl+Y2K9slDXC+0RjMrbHtgZSa55SJAPhVIDJfH35aYivm4
         PQyofYxGmATWaUOUrfsdh43IXRxcyt+Cx44Hi6S4DDVxQz01TXCMLhoyeOdN06P5jSR9
         TLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yao3HSHynO3fw2qebc1cDpu949X61cymkG+rYeq5V9A=;
        b=FMCBHyfLwARY0e0jsTWiMHgppWNHHaRDFGzMFBwCeWnRqxQb/50o7hWqYYxi1s4SqL
         qidVcESNzSlP1crvtB8JDsbkvBqNwIHh9Si3kAaRTUgDSVg//Bvb8LqL4zJva716rVLd
         FlJCGarLT/GKwT6fVGsNa1pJPL99pmark7DiQIGVdURUGeiOl0RzX69bMsdqlK1rDbJv
         pY9J+hQpBlZcx+JiPPyigC0waI/3qYNtYd+La6vxjp9MDM1wLTz3RgKJXgavYNrRSQmk
         zLdw40HrcbMJ/YSn92yf01NlqTTR4mnubLREewfMe3mBJaU6rYV2OYQBmRc/zQU1CyFC
         J6jw==
X-Gm-Message-State: AOAM53157mKOmNFkusMa5OV3hSSaT1NWfrp6c/2sE51aub/1+V/0TzeJ
        jbnwT/wDj613LCfYycyXY/kQYdVk5Tg=
X-Google-Smtp-Source: ABdhPJyCREIsigpQ04CMTb+BWu09qjCc6gR0YFflL1ZD48M3ntRigh7DHG5jYM91VKaDYuv+F/1y1g==
X-Received: by 2002:adf:82cf:: with SMTP id 73mr12757962wrc.366.1631536941873;
        Mon, 13 Sep 2021 05:42:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 19/20] trace-cmd record: Add compression to the trace context
Date:   Mon, 13 Sep 2021 15:42:02 +0300
Message-Id: <20210913124203.3677760-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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

