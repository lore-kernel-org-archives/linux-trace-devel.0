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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11213C4332D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A3964FA9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhCKIts (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhCKItU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:20 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5195DC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id bx7so1529458edb.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ubW2VtRXk6619zvLvFgs1cmDN0fZDzihD4b6s1f7Hf0=;
        b=qHJM7dHc6asgWAIYlAhgG3pBG4bozJWqaNWGDMG766LKsbrhQNuoM3dR9TGQ2yg8dK
         w9Cts58RJ/Cnbai+bQt4NbeiIVQWk0X0SvgWXJy3YRiH3DffmSmH+EePTRllsCl6gXyF
         lEUL5/wWw1MxAcmy0sfC4f9hDKt1ZM5al85kQj7nBwdL3m/bJW019YxnvWpjE5BhW5cU
         fol7duwdd6zVo87qYXywwceMjBAo3rAb8mQ8wJdwQjmzmhh+kDVGIIsgwjf8219F2Ay8
         pw4UhqGSX8WzawlZKHZM1XrFU/cRWSl0K8azZgz8kN1pIM8iFyC4nDGXgE5m653rn0w5
         LpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubW2VtRXk6619zvLvFgs1cmDN0fZDzihD4b6s1f7Hf0=;
        b=hxSbV25IzHxa3fCH3yrA2ZZ5pa2JYG+jktQylPM5xy/zS3VEkC6++G6CdciupZVHSy
         dv1IVSWGaDwDsy4+sgzYcVQis985knpkSeGptAaxV8h/z/sESrrnXaTdTReXR0ot5E1x
         qJAueM0Oh9VwCuJPJptSNr9Jb5Ihfp32ES53jJeOmePkwhkqeXY8Bj2yHWCE2kVdMJzz
         NbAO8KQAPuRrA4JoFTokVYymYKSLxPWSBQVzqeMiyGuGe6ouHIzNYKU8By1/dgtae4wG
         oKPAbM5sJL6zdltCqD5wFBVT0koUBnP+zrFVHSAfnjG+8PimhWUoIggnx7a1i2rV2FyM
         I/1A==
X-Gm-Message-State: AOAM533BempfmU2kuCBO/+Zg3jwnCga/NCJCDfrJXuzBSoDfmlgDgBTA
        C5GAiOL/FuBzKmSnPuLzjuY=
X-Google-Smtp-Source: ABdhPJygqERIejnjkD5L4l5p6eb1TgZlqV4FPufDmBN2c0hvF4okWrxIWa5yV+6LH1An1AzakKm1Gw==
X-Received: by 2002:a05:6402:3047:: with SMTP id bu7mr7418430edb.227.1615452559115;
        Thu, 11 Mar 2021 00:49:19 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 13/16] trace-cmd: Read information for tsc to nanoseconds conversion from trace file
Date:   Thu, 11 Mar 2021 10:48:54 +0200
Message-Id: <20210311084857.1919805-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
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
index 971a6c01..1a3133e8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -107,6 +107,12 @@ struct host_trace_info {
 	struct timesync_offsets	*ts_offsets;
 };
 
+struct tsc2nsec {
+	int	mult;
+	int	shift;
+	int	offset;
+};
+
 struct tracecmd_input {
 	struct tep_handle	*pevent;
 	unsigned long		file_state;
@@ -126,6 +132,8 @@ struct tracecmd_input {
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
+	struct tsc2nsec		tsc_calc;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -2727,6 +2735,16 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_GUEST:
 			trace_guest_load(handle, buf, size);
 			break;
+		case TRACECMD_OPTION_TSC2NSEC:
+			if (size != 12)
+				break;
+			handle->tsc_calc.mult = tep_read_number(handle->pevent,
+								buf, 4);
+			handle->tsc_calc.shift = tep_read_number(handle->pevent,
+								 buf + 4, 4);
+			handle->tsc_calc.offset = tep_read_number(handle->pevent,
+								  buf + 8, 4);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
-- 
2.29.2

