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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6B2C433E2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7941561927
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCVKA2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhCVJ74 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D32C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:55 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z1so18544879edb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dTJIMZfw6bNHyKfjvlkzUKuOnQwAl+BaNIF7uNwURYE=;
        b=BhgDKhxtkaKy+cvhL4l8eElMllUwd+2dtJcUqxGhsW/KMo8ovIPa6HezEpan8MqSmW
         e+sFPxGyAK+yLYvNnxHTOK+XcNj4YXGeOUvXyGHgTKHFJ7v4tTCIgFSSZK8EGwOEm2t3
         vP5VisRE9L640MAtsKRmBPuH7rRMta2VsQmzJsUMjpOubFyk2czukIg2yWH81Fw6Ciwh
         /4MSpO4bXrcwJpnhQBv/McOp7gZqX7NyggtK072WmH4STEmDn8yfnPsA7hmGfdln+No3
         wLYxjRvmISJjLGs+3czjwPQP3YVAX4m3r9EpzDaY/b4YBP6m11Lca1IMzBVoSCKQnCa3
         YzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTJIMZfw6bNHyKfjvlkzUKuOnQwAl+BaNIF7uNwURYE=;
        b=Nf3Bw5Y4ND6SCXWsXaIHYz3RNnC7V1OmHsooNUlM4JvMMDyD4eUOF1waoAicKA9y5H
         6BlRJNxIS4LDyXm5iZ7w8K3eVRGYThjRjSGh+jlrCQE2TPyC1C8dm6yXKnL+w5uqoIsL
         Bdew/WLmCVUY2lbA5U6aYTRCsVPfdD6GBWQzNSeJzryBk9RnFbNyduM/gYInRuOV0fyM
         IX5hh4PtwJjSwR6Y3An+KZs/i++6ANyToS3qKYGdemWBYhqk3JjyWrkv2BKWM022PLdW
         Dj4m5rulV318EpGAAb6ZCSg44VjOTYLtSTFPduh/B8X7Q6N5RipZCiF6suoHW8aJYUaa
         UkuQ==
X-Gm-Message-State: AOAM5316ogUVMGVqmyk0hwK3OzAnqdiNo5Q9OnR+2FNG4/FDkTIpRi3R
        Knavy+zk3uaoVU3ZPwb1iMZHTz6RrJvOpQ==
X-Google-Smtp-Source: ABdhPJynAC7SnvSDgpnd49RkLGFmThc5d7prVL7NSt2cjGG5KGDHUxOltKvawm1G0R8eN4CJBW+xzw==
X-Received: by 2002:a05:6402:42c9:: with SMTP id i9mr24803447edc.35.1616407194019;
        Mon, 22 Mar 2021 02:59:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/18] trace-cmd: Read information for tsc to nanoseconds conversion from trace file
Date:   Mon, 22 Mar 2021 11:59:34 +0200
Message-Id: <20210322095945.259300-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Read multiplier and shift, required for TSC clock to nanosecond
conversion from the metadata of the trace file and save them in
the tracecmd input file handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2093a3dc..ebc28f7b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -99,6 +99,12 @@ struct host_trace_info {
 	struct ts_offset_sample	*ts_samples;
 };
 
+struct tsc2nsec {
+	int	mult;
+	int	shift;
+	unsigned long long offset;
+};
+
 struct tracecmd_input {
 	struct tep_handle	*pevent;
 	unsigned long		file_state;
@@ -118,6 +124,8 @@ struct tracecmd_input {
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
+	struct tsc2nsec		tsc_calc;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -2674,6 +2682,16 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_GUEST:
 			trace_guest_load(handle, buf, size);
 			break;
+		case TRACECMD_OPTION_TSC2NSEC:
+			if (size < 16)
+				break;
+			handle->tsc_calc.mult = tep_read_number(handle->pevent,
+								buf, 4);
+			handle->tsc_calc.shift = tep_read_number(handle->pevent,
+								 buf + 4, 4);
+			handle->tsc_calc.offset = tep_read_number(handle->pevent,
+								  buf + 8, 8);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
-- 
2.30.2

