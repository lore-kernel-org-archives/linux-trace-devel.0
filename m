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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7DBC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB4D64E51
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhCOGS7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhCOGSn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED637C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id mj10so64193308ejb.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w6avxxa59CWKnEJJRYffo95ueCrWvVZMSAzBPlxpHUI=;
        b=leVek15DA1tfUVN6E0F/UPoJ+3pLD5Aq4Iss9tAZ5nTkoy9F85Fe7KlyMSpROUmquy
         xgMwia1QzfBR6QUjsDnGDOGU13oH6Sabwv8WM8Z3WLJ9Qw24KSP8+XFs+I3iWImj2GcZ
         Phf9fpRqFRXG1bQ19wXL0KnDK6Z5ceWgjRoO6n8qYQG5r9A0ywPd+jk3j3sA4a7rFxe/
         G1dF+2+iuLXUXHFJM6VcTSHH+81yNkiQax0hrcakCHo0jSAJxib7i1A/kfW1YdJyBwYP
         MeOI2xE54oRfaYhsveRLF8cxQ/GntelR1mgz2MNVKn+GOqDCOku6pdUSOIjjocUaG6CX
         RUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w6avxxa59CWKnEJJRYffo95ueCrWvVZMSAzBPlxpHUI=;
        b=Mq63g3rWPjSnStxgIyyh/0bPUuZ9bZDtCko6l+YbRxadZhdVbbr6APViQG0xkATusJ
         zcuP31LPPwXRuqaD5GJagZ3vS++fMISflwsFp/rlnSfKvtguOumbqyRCZThwBxA43XP8
         82ZHOJbol9GhkxgqjxL12Zoi7xM5Tr9b4dnmKbq2Z5mAshGG8Ya+fTL6du9dwPkEt6Kv
         wF7HAddghNDgsoWaRL+/4K2ncByQ6jgdsVDhw58WnjbbWl/FRVfWOvYjt6Hk7QsNTP9G
         4eKJ2jrCLOmfFk0vz6pqYFVhFc6p36jFr2a5jthHKQLOgKjtelJ8TrMGsjxD9/uS6vxF
         0+iA==
X-Gm-Message-State: AOAM530F5rv7dyztPFIcin4SrxpsEb9wr1Mbex9c6NnRyRjBf+WKT7VN
        9eDM3Jy59NmhDzfhqbd0bNo=
X-Google-Smtp-Source: ABdhPJz96JAPSqqV7jI7BD9eUwQWtUcET2ZpE7q5kwC7P1G3dahoc3mE3jtrQT2nGh+2sB7bx8SQHg==
X-Received: by 2002:a17:906:18aa:: with SMTP id c10mr21768763ejf.248.1615789121759;
        Sun, 14 Mar 2021 23:18:41 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/12] trace-cmd: Read information for tsc to nanoseconds conversion from trace file
Date:   Mon, 15 Mar 2021 08:18:26 +0200
Message-Id: <20210315061832.168495-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
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
index 2093a3dc..1e925f45 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -99,6 +99,12 @@ struct host_trace_info {
 	struct ts_offset_sample	*ts_samples;
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

