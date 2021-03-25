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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049B4C433F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E649961A13
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhCYGlj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhCYGlO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCF4C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:14 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d191so526113wmd.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RSmGXWfU+slAXusEwQl0TevAthvkl1itTESgTOaoVz8=;
        b=CiK4S/DO6RalkcAXaXMjqIl8w74ByjgZ7K15YvcviOnhc/pX3cM39x1IVL9NTGjANM
         ju4UY3ngBFocdmp0E15aEwoEaxYVsf4ITgVbQ+B10Vx5U03xLXRjYfbmuHr5zCyL1qOm
         JIGbtnqPZlVyp30jHNuzOjSWljPPCxdY9BrZYtpWW40AQprDThvid/LgD4dz/bNEo0ZI
         YYwnGHDhd+wvEomfzFWE5oXMyR+vsZEr8v7UmlKHcpCRwCTtdym/Bea7867VPO/Rw7Pc
         DsmfTo/Q9MzPd1ZZ7N7eUpI0WVoTBwZGQSLltFBexL2k9BrYAYxTRBIwMZ5iIk+1xTym
         tSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RSmGXWfU+slAXusEwQl0TevAthvkl1itTESgTOaoVz8=;
        b=ErZ4qhiPvNWluQ6m9oDVf6rHazlEcnDmKWYYr3SSRqHJWquJvW8TAXWwkJ+EeaZ7rp
         pmtzvDif3ARU1WBUZWKcdMdcmOe0Tkt+Fi6m7Xz7dmdlHSOPh9SN1rE6AJqzEJ1U/K9N
         jyMbgHhGMJ4J3AarsGCQxNmkZ/W+geDbTTLh1nmvVIEfw7taAHSVGHctgQ+JGvmzAgIZ
         9yHuCxrowaocLAf48amq1il4JeovP/zfMKVgYXWVDReS5dT8NWuITnVsSg237/Hmv+HN
         EnMRmvjG7NSdCue1IAnbW4Uuh2Et6fYmBjA4Nca8yac5LtrvjYTDBdeOiSJoIC6vS3f7
         1LPw==
X-Gm-Message-State: AOAM533ua6hZ9Sdo+wcOFa1ENMhdeGTheZMFSepa5+QmloOaCK+QJzyy
        OOyIFItrh3taIjKD/GpHCLo=
X-Google-Smtp-Source: ABdhPJzkA2V4LAFZlYZqlCSwnsK/pZU1qppdj5M6MEsA+CjBNVMAFeiUpOGThyyP17FnSgo0Z8uwTw==
X-Received: by 2002:a1c:a745:: with SMTP id q66mr6254698wme.21.1616654472837;
        Wed, 24 Mar 2021 23:41:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 16/23] trace-cmd: Add a new flag to disable any timestamp corrections
Date:   Thu, 25 Mar 2021 08:40:48 +0200
Message-Id: <20210325064055.539554-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 lib/trace-cmd/trace-input.c                       | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c33d067a..fdca7494 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -134,6 +134,7 @@ enum {
 	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
 	TRACECMD_FL_IN_USECS		= (1 << 2),
+	TRACECMD_FL_RAW_TS		= (1 << 3),
 };
 
 struct tracecmd_ftrace {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 696e7bd8..ef2f9678 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1287,6 +1287,10 @@ static unsigned long long timestamp_host_sync(unsigned long long ts,
 static unsigned long long timestamp_calc(unsigned long long ts,
 					 struct tracecmd_input *handle)
 {
+	/* do not modify raw timestamps */
+	if (handle->flags & TRACECMD_FL_RAW_TS)
+		return ts;
+
 	/* Guest trace file, sync with host timestamps */
 	if (handle->host.sync_enable)
 		ts = timestamp_host_sync(ts, handle);
@@ -2601,7 +2605,8 @@ static int handle_options(struct tracecmd_input *handle)
 			 * gtod. It is stored as ASCII with '0x'
 			 * appended.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (handle->flags &
+			    (TRACECMD_FL_IGNORE_DATE | TRACECMD_FL_RAW_TS))
 				break;
 			offset = strtoll(buf, NULL, 0);
 			/* Convert from micro to nano */
@@ -2707,7 +2712,7 @@ static int handle_options(struct tracecmd_input *handle)
 			trace_guest_load(handle, buf, size);
 			break;
 		case TRACECMD_OPTION_TSC2NSEC:
-			if (size < 16)
+			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			handle->tsc_calc.mult = tep_read_number(handle->pevent,
 								buf, 4);
-- 
2.30.2

