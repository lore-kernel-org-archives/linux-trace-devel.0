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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61DEC432C3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14CA60240
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhCOGTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhCOGSs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:48 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50275C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:48 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id j3so15927565edp.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+DImzHaNRqeHyfPwgtYfwWhK2kk5rujc12vxD101mY=;
        b=RfLLRMkr8SluD+zk2QyBW28v5qvdfHPqS0+xCFhurTWTPkRxCHl6nZO7NF85Ito1mo
         L6Vmqha8Cq8m4YN25NEgyVYcyyqE/v5NC9p5qGawVeRRScmBSYi9/8cS9DVn6byoB7f9
         zzxU6ZjZ2MoMWIR6mR63m3TC5viPe/YUAAUO9JuJ5V9GNr4QfvL4dP8NmMUasCSufZxN
         Kr9nAu5j/9DnIJSdziQpAgwX8UP/jM/MdpqCnooh963ZoN6KNDp/rDHIN2aLk+gGFvHS
         fdQ2V2ivsfkGiB0Tnq1WGzDOphi4yX1CmGe8CrkkEbTvXKR0LarurqTqOyqzNPy+KA9l
         SgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+DImzHaNRqeHyfPwgtYfwWhK2kk5rujc12vxD101mY=;
        b=Mst/K4oSxRf80kPMNWiMCoMvIOq92hVlzaj1aWwnBYU+g7818jNcXIkdOvK3RWOHx1
         HVjye95hMvhkHVTTTOlCX5ITGfaqdxfJztdQaeQsR0iFlKb3Kgat3Di8Ilr58nrNmxQ6
         1YQWGx0bZ9mjSBMYE81yyCooUFwl8r6Kux/cPIbzo3FpNSp5wDh3bqsZ8GueX0BgbRIf
         qom32WaeZXd2q2jWwSJRTeno6n59iiv8Yl2FykoIViKeHE5L5T2o9PErbNxoTlqfTvUB
         IWTl6Rl+xD0by3sKidai4R2v76KaN/SOiaTTLd/yKfR+8N+Mp2Mp0HWVpA8bho4AU0B8
         wtHg==
X-Gm-Message-State: AOAM533tAEMhApEeCED9YcT/AOk3jOjhp82w7aTSTxy1E9+MpCcTUp7r
        F5wm4cQ/E7BJtlZ9LtDmND0=
X-Google-Smtp-Source: ABdhPJxJjpl63DB07G5ZBMB+Yf3e5ZwF9FsMdiIgCLYf/6w4T+ajV2/PtQOt7e81HNa80+rN3KcJpQ==
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr28410316edd.79.1615789127024;
        Sun, 14 Mar 2021 23:18:47 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/12] trace-cmd: Add a new flag to disable any timestamp corrections
Date:   Mon, 15 Mar 2021 08:18:31 +0200
Message-Id: <20210315061832.168495-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new flag is added in the trace-cmd library for controlling events
timestamp corrections while reading a trace file. If the flag is set,
all timestamps are displayed as-is from the trace file.
   TRACECMD_FL_RAW_TS
The flag can be modified with these APIs:
  tracecmd_set_flag()
  tracecmd_clear_flag()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 lib/trace-cmd/trace-input.c                       | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index e2ea0dd0..98616c76 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -132,6 +132,7 @@ enum {
 	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
 	TRACECMD_FL_IN_USECS		= (1 << 2),
+	TRACECMD_FL_RAW_TS		= (1 << 3),
 };
 
 struct tracecmd_ftrace {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1cffa0f5..b53c1932 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1288,6 +1288,9 @@ static unsigned long long timestamp_calc(unsigned long long ts,
 {
 	unsigned long long t = ts;
 
+	/* do not modify raw timestamps */
+	if (handle->flags & TRACECMD_FL_RAW_TS)
+		return ts;
 
 	/* Guest trace file, sync with host timestamps */
 	if (handle->host.sync_enable)
@@ -2603,7 +2606,8 @@ static int handle_options(struct tracecmd_input *handle)
 			 * gtod. It is stored as ASCII with '0x'
 			 * appended.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if ((handle->flags & TRACECMD_FL_IGNORE_DATE) ||
+			    (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			offset = strtoll(buf, NULL, 0);
 			/* Convert from micro to nano */
@@ -2615,7 +2619,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * Similar to date option, but just adds an
 			 * offset to the timestamp.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (handle->flags & TRACECMD_FL_RAW_TS)
 				break;
 			offset = strtoll(buf, NULL, 0);
 			handle->ts_offset += offset;
@@ -2630,7 +2634,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * long long array of size [count] of timestamp offsets.
 			 * long long array of size [count] of timestamp scaling ratios.*
 			 */
-			if (size < 16 || handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			handle->host.peer_trace_id = tep_read_number(handle->pevent,
 								     buf, 8);
@@ -2709,7 +2713,7 @@ static int handle_options(struct tracecmd_input *handle)
 			trace_guest_load(handle, buf, size);
 			break;
 		case TRACECMD_OPTION_TSC2NSEC:
-			if (size != 12)
+			if (size != 12 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			handle->tsc_calc.mult = tep_read_number(handle->pevent,
 								buf, 4);
-- 
2.29.2

