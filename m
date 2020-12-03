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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FB6C64E7A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FEBE20665
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgLCGDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgLCGDS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 01:03:18 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D629C061A51
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 22:02:32 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id y22so827750edv.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 22:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2jM+ZkjxSNk+PeeKsDZfquvN9ZMFNPXjIJxIqUXgJsU=;
        b=mGbfpHEmsgglvOCxHoWr8hhhpB+P91uP1Nd+cnCkzdu2QtIh5wX/1ZIY7hEHWO3Y5Y
         c6qhouoA//Um/Vkdto9Q2GN2N3ZgA0Y8qdZxknqGgfFKKg2iYgikh9Le52R6Gq8lBct7
         te6oOTTvNkx9Li1EhzTyBdfaLvwY3vEUtlyFvfRad+R5mxKJeNUV1QCgluBcpQAfhjPt
         BCBo6HD28CP2Mg3J33EH9bA19JO8135LUzrF1F5SuoxrsrM9U02ijeHuGVs2LcMVsabM
         14rpBy5e2T8V2626orxh06QBF2AUDZ+a3QSNdWgeLmMgwnSgsPEQN8UJwJjoFE+sTXJN
         KrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2jM+ZkjxSNk+PeeKsDZfquvN9ZMFNPXjIJxIqUXgJsU=;
        b=rO1OiYC8lxp+70YhJN9sTQWfvR9XyuwGTkkQS/dKh4EyDQ02H6PYbCCTYFxlJrVhvp
         rLl3BAwF6Zan/Ka3Kh6IVK896dLUKMmnPdy7KQr/bbSRpJpwccReI02IwOfX6e8bQLRM
         C2NtALzdL3eC2cDJ5BeOwdKKIpatBqpURtq7Aolqlluv++HXX3KJcp/OWGLyjEj3H2gm
         KcH/SCio6eSE0X2vdLytXl/kV2lFT2FpRAuyjIt6nGTJIdoe3y7yhZ3FCzo86TE6FjmT
         UFD3yw5Ha3LuDKplSM2oTQng3v8Ue0SMm94j2P46CiaT03CCYnWM4YzICLLAlNssitoG
         3AQw==
X-Gm-Message-State: AOAM530WvvcCXWyUQioU+EzMQYh0wU57UVa35+I72HeezDVm27a3dN+w
        O6kjmDUnfQaFQMLSLuL3MNgjfuMEneyFVhLT
X-Google-Smtp-Source: ABdhPJwYI+/V2kmiuszjbOxT2p9yRstW1EWR11qVRnQzgiXqwHZMDQm4/pvccmiMukAtniN6Oj22VQ==
X-Received: by 2002:a05:6402:135a:: with SMTP id y26mr1460387edw.330.1606975351065;
        Wed, 02 Dec 2020 22:02:31 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d9sm388629edk.86.2020.12.02.22.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 22:02:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] trace-cmd: Make read_file_string() non static
Date:   Thu,  3 Dec 2020 08:02:23 +0200
Message-Id: <20201203060226.476475-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201203060226.476475-1-tz.stoyanov@gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This helper function is used to read strings from a binary file locally
in trace-dump.c context. The same functionality could be useful for
other trace-cmd logics. Made the function non static and prefix it with
"trace_", so it could be used in trace-cmd application context.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h | 1 +
 tracecmd/trace-dump.c          | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 8b2d4c21..109c3328 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -318,4 +318,5 @@ struct pid_addr_maps {
 int trace_debug_get_filemap(struct pid_addr_maps **file_maps, int pid);
 void trace_debug_free_filemap(struct pid_addr_maps *maps);
 
+int trace_read_file_string(int fd, char *dst, int len);
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 5642f12a..c55e2389 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -49,7 +49,7 @@ enum dump_items verbosity;
 			tracecmd_plog(fmt, ##__VA_ARGS__);	\
 	} while (0)
 
-static int read_file_string(int fd, char *dst, int len)
+int trace_read_file_string(int fd, char *dst, int len)
 {
 	size_t size = 0;
 	int r;
@@ -160,7 +160,7 @@ static void dump_initial_format(int fd)
 		die("wrong tracing string: %s", buf);
 
 	/* get file version */
-	if (read_file_string(fd, buf, DUMP_SIZE))
+	if (trace_read_file_string(fd, buf, DUMP_SIZE))
 		die("no version string");
 
 	do_print(SUMMARY, "\t\t%s\t[Version]\n", buf);
@@ -260,7 +260,7 @@ static void dump_events_format(int fd)
 
 	while (systems) {
 
-		if (read_file_string(fd, buf, DUMP_SIZE))
+		if (trace_read_file_string(fd, buf, DUMP_SIZE))
 			die("cannot read the name of the $dth system", systems);
 		if (read_file_number(fd, &events, 4))
 			die("cannot read the count of the events in system %s",
-- 
2.28.0

