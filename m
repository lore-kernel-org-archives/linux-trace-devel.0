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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F3CC433EB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37F561A23
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCYGlh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhCYGlI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:08 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497A7C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:07 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so502375wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dTJIMZfw6bNHyKfjvlkzUKuOnQwAl+BaNIF7uNwURYE=;
        b=jEmUk0KbtzZg53n38VEzA24UZEh2PdPVvLHOaJVW48GA23dvHoVpZkaqvHwYwEKsQE
         7xzx3o8QlBqazY5MmbpLgtcaXkS2udlj/vwTFTlWJANSRWMChaB+pt7WX+kwu3OTJVJf
         o4PIXq9dQ/sDRvWRHty+EVYYY0azmmnzGd8Z+5rWkbun0DtTJuLv5/MAtJt2sRYCRuNI
         COMTYdz0+IKdJ2t3OUn+EKq159kNJVupyP89Jj7EbJoCIhiEsc5ZZd+By1bwQByfCl+l
         BRZY7JIUuTndPemtDcG3WeebarUpYUR5awVnykfOBeLiw6+U3JGIp3gi9okNCjZeMPgu
         N/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTJIMZfw6bNHyKfjvlkzUKuOnQwAl+BaNIF7uNwURYE=;
        b=L0q5LJP0CFdJVmuuygVUvNAAnmhaYycH/JIMK+Sbrz1QX1xwnSJjWoB6p7OZl3G54a
         ObfnpnyXwjN14fTrTBTewdUkMbm0wFC5mq9j3yX5MUA8O3VjWlQMLBGXA2GR6mdjnw+3
         vSQVfzpqXNZLPKIlIF3NnH+HsV23jf2Cwq6Gwg4hfUtjJKCVPROskTFKEoBUr+SV5E64
         G/88UU0VBVVnYCVGnNcJ8ktKdXjG5Fx1psH2ET8Hj7ttKYsYVKHfmFEHLkRXfJU13bU/
         RWk3ywuHTmKaKECd9urDzKoJhXSu6Eb0bDjqlSh7FUI6BZCkV/g3l5mTOUievaVYWoHI
         Quuw==
X-Gm-Message-State: AOAM532x7W6HjCQQgE7vmzneFeJL9Ki87e5JSh8ut4n2moJ+mhaHnPQG
        +1hQBdEaojR9lgDTbSSVOhr3wm4XNOy3/Q==
X-Google-Smtp-Source: ABdhPJwqivHPPyzcP3+ArhVRLgog3TW5iy6G++LM1AUPATAKMPzhKx/ieGOcaEhxn9x57s3jbSgd6Q==
X-Received: by 2002:a1c:e389:: with SMTP id a131mr6314450wmh.78.1616654466057;
        Wed, 24 Mar 2021 23:41:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 09/23] trace-cmd: Read information for tsc to nanoseconds conversion from trace file
Date:   Thu, 25 Mar 2021 08:40:41 +0200
Message-Id: <20210325064055.539554-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
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

