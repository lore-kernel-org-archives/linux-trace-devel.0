Return-Path: <SRS0=/o8m=AR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186F4C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jul 2020 15:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA4620715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jul 2020 15:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r4FwmzB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgGFPOI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729242AbgGFPOI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jul 2020 11:14:08 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA90C061755
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jul 2020 08:14:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j18so39820800wmi.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jul 2020 08:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UtsR8fgJn1aQT32Y2gqG9XSqWI5oTNdkHEsR2KtxXs4=;
        b=r4FwmzB4PYDuEq2SuJSgJZkMGQMct4Ld+jq0EIqQUfzGZSOU7hmqh2QGtFocLl3okp
         XW4PnXN9DNwkyNUhdUzYxnxp90VKjQKcv8Y0NHlwSzGUuJ0vYwKR05txSuLCmCCasxHi
         yiIyy+dXU4g/vxhEQqjmOA7MQnUkC89MSIooDMEjm3W8gtHP0lyciURtrV1u/OYSLDps
         1I33GZ8NuS76KtSjs9H5cBwrhopz88DPIDZIqJ7oXX3dbTDSAQprb4ETQBlLC5FE03pF
         YcSnjniqss7JkFbg2bKMg95DnwDsOQZ3/KOw70SLV/17QoHPH9m+TSdb26Wz4t4tHyQW
         56KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UtsR8fgJn1aQT32Y2gqG9XSqWI5oTNdkHEsR2KtxXs4=;
        b=CMttTJi/wmtqXKnNVB0cEkeN3XF2c2C0/p9UO/Y55X2VVmmsyN7LxcXZ7sYzzIdA4p
         LxcSOq0Xd+0FIsaCxDvPKp1pgKLLiwATahu3faoTR3nrGPRG8zdRbyTmpEFWNlQ89tei
         DtpUjgfIbt2o6y4Cr2Q8Bm19gXJP3D7LlhK/VLOTLclBOi3IMlmeIyjSjMxN7nX0iGno
         TI0J7/j54PkD1IwIUari2uS1u7n07/qmzQep/+mz1tEDPfsJCaH1S9w+k77vsNBkRHhb
         BEws+FYXAmhFD5lmJ+yYsODLwwqepIvWNuDtjNT935OEaR3YP3lG8v+Zt2NzLGdpOzbc
         Zkeg==
X-Gm-Message-State: AOAM5330RkuGqlrO3yrrvYgvF5hHnds1j8WSYQBRmwF7i4dKrhkmubkc
        vys0dalDzhzuV3gitr3fsZ3TnL07L2k=
X-Google-Smtp-Source: ABdhPJwidDiWoc4xrNtl4O/7FhTbXm3KgC6M4KUefWqUDMFmn9RALsWGLDxgeSESQ2E82tgkmbr62w==
X-Received: by 2002:a7b:ce87:: with SMTP id q7mr52346230wmj.39.1594048446778;
        Mon, 06 Jul 2020 08:14:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c206sm25024856wmf.36.2020.07.06.08.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:14:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add helper function to get the time stamp print format
Date:   Mon,  6 Jul 2020 18:14:04 +0300
Message-Id: <20200706151404.25603-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Printing time stamps depends on:
 - traced data - if we display latency tracing or normal events
 - user defined time precision - up to nanoseconds or microseconds
In few places in the code there is logic to get the print
time stamp format based on these criteria. That code is replaced
with a helper function, to make the implementation more consistent.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c1f840d5..f1ba7835 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -141,13 +141,38 @@ static void print_event_name(struct trace_seq *s, struct tep_event *event)
 		trace_seq_printf(s, "%.*s", 20 - len, spaces);
 }
 
+enum time_fmt {
+	TIME_FMT_LAT		= 1,
+	TIME_FMT_NORMAL		= 2,
+};
+
+static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
+{
+	struct tep_handle *tep = tracecmd_get_pevent(handle);
+
+	switch (tf) {
+	case TIME_FMT_LAT:
+		if (latency_format)
+			return "%8.8s-%-5d %3d";
+		return "%16s-%-5d [%03d]";
+	default:
+		if (tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS) {
+			if (tep_test_flag(tep, TEP_NSEC_OUTPUT))
+				return " %9.1d";
+			else
+				return " %6.1000d";
+		} else
+			return "%12d:";
+	}
+}
+
 static void print_event(struct trace_seq *s, struct tracecmd_input *handle,
 			struct tep_record *record)
 {
 	struct tep_handle *tep = tracecmd_get_pevent(handle);
 	struct tep_event *event;
-	const char *lfmt = latency_format ? "%8.8s-%-5d %3d" : "%16s-%-5d [%03d]";
-	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
+	const char *lfmt = time_format(handle, TIME_FMT_LAT);
+	const char *tfmt = time_format(handle, TIME_FMT_NORMAL);
 
 	event = tep_find_event_by_record(tep, record);
 	tep_print_event(tep, s, record, lfmt, TEP_PRINT_COMM,
@@ -781,7 +806,7 @@ static void finish_wakeup(void)
 void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
-	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
+	const char *tfmt = time_format(handle, TIME_FMT_NORMAL);
 	struct tep_handle *pevent;
 	struct tep_event *event;
 	struct trace_seq s;
-- 
2.26.2

