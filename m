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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31C6C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856CB619FB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhCXNF0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhCXNEh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED08C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x16so24366512wrn.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dTJIMZfw6bNHyKfjvlkzUKuOnQwAl+BaNIF7uNwURYE=;
        b=IEhy4zzTk7ONYG4cCIGVfQ4y1qKY9DkAY8EBW0HAlQq8y7ZHr4tN/UI+WlxyERQIyP
         Tt2Z3x58eLcgCmCN5U4gsYQcns9oXB0kTFp9z1Bd4l8D3jiqnykKQd7lHCZOJBLJTig+
         Fol9w+XWqunsFtCzUI85dsy1mMXVzfby1iK4YOpBMy4dnmabvXeULdJd8M0aqUL1vwaP
         jUIuiPEJq3HSt1T4mIINzisu+qR6B2Q6jPes/G4gVF30hfWlpFsS+3Nmv7CCkT1DXc2K
         X21vURmMRJIxy5Jf5kbYfhKb2Lwsh4Xh75+ci+u7ci/n41G5bdTMuo/QK9MMXcmGfV7S
         A6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTJIMZfw6bNHyKfjvlkzUKuOnQwAl+BaNIF7uNwURYE=;
        b=W0FlGZ0Ovj9VORECsXkdZ2BAvADmfO2pF185OLPZvMry0hr8YtGCp9CgzAyOFXHMhr
         7LgOzkwRg8gyJhaN2OKCfyC4tx8GkdD4zpGIGCCPu/NqBwRXgc+uOIOqH/oqzRVCeu3Q
         GtanOKuajEy+mP2zgyPzXzg96pLyMlTc0udiQxIkrCsx7Rxpnul7r+poGch0UC4mb5g3
         57AZJNJrEmz+WOZpEMiVRkozmM27VcF2Klyk2oRcWgaf/nsw2s+5uUEXd+klzYzRT+1t
         CLacC0iuDOO+s8SI5zArUC9BN4ZCLVEvGKhgIdpoWXhSVF8/N1RxRrrobUIofBdHkWIv
         8kUQ==
X-Gm-Message-State: AOAM530cqhJWCyPKQyH51QUskpeBJZ/J81RTUnFNbnphZmatCE3u5np+
        2lvzGZF/SkF2FMUY83M+I8KOVw7Xw7uN4Q==
X-Google-Smtp-Source: ABdhPJz7xu6CSUQcawZfaRGAV0QKdWfruDLk/2+LkVTm9ez6wNYuSXHIN0i8rCbIP0md4yecP6jbdQ==
X-Received: by 2002:a5d:6ccb:: with SMTP id c11mr3468458wrc.122.1616591075525;
        Wed, 24 Mar 2021 06:04:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 09/23] trace-cmd: Read information for tsc to nanoseconds conversion from trace file
Date:   Wed, 24 Mar 2021 15:04:04 +0200
Message-Id: <20210324130418.436206-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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

