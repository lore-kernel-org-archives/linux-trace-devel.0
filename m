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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD44C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB93613EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbhD1Hmq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbhD1Hmq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:46 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C992C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:42:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j28so8980949edy.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SPOaWJsxBy9jiR33nKuBm9Gr1I5tVG2vBI5Vhsy4z9Q=;
        b=KjrVx9gddpSZLnWfItyKlj8L3CuaPQhK/c+6KOsWoJcrq561pKCAmV6/Om5krJ+IV2
         aweKn0aF3H20tpQ5H4dnz7jPV+e4JKpYfhCn0ASl4PgAq054s2Td1mvwbILjBVOXtW7H
         8MD5IlAo/hu32wU1hRQdYZPxnFLdXMTi+HFdVaXN+J7JYF/EWVAlxfesHrLBSdI8IqvF
         pYQmv8RSIwVfisZ3SWFvDVV/ibEGWOh7lGJFjlxsJVo4JUMyoXif10KRo7yMHmjHlfsq
         FDw0dBJhOWebcl/sZhZ40DIImi5tOqcKsX8Hm3Ya674GC81uY++mF0WujHZCUsCVmNb4
         D3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SPOaWJsxBy9jiR33nKuBm9Gr1I5tVG2vBI5Vhsy4z9Q=;
        b=JUW77ApP3kMl46Yt6sSeS41n3w5lK5jLx4jyayFeE/Ol4uU55fi8P4cf95ZuIeY3DS
         Eeh3PTXh7m5CXs/1o9HTONkdwhUo6G/rPjM96VRn9EAGOn6I68hdSakymvH6QClA99yU
         Z/Ag0/lsDT6aU0exwsGHF0F35KUdkv4wqEpDPFeLPE44StrW/pWs8lJ5745wLcU5/XRJ
         uNgw47IXs9ndsoKuGe2qAakWbTZKH3LZbvon2QcjMau3y6uctApUXpFGdjzlACUcda64
         Q2P4qB1gPhi/1in/UE8uI5oyAKe8exfUEiX5Dj+ccQ8rsmI+jWmW7pKKqq0LmW3kAP6G
         VHzQ==
X-Gm-Message-State: AOAM5302SnMzFnQjPD2PzpCwkX1wzJbf9uY2RpofrTTSlSGRIzB3pT01
        ZPQlt3WD+B9sY4IW9M0OEnsOX2U80slubA==
X-Google-Smtp-Source: ABdhPJwOsjqhfLMh7HDTR/FAOZwV3+fXS4SVxdcZEWJ+CWKNvBfepMBOFsEvF2BX+nko6TNC+8SKVQ==
X-Received: by 2002:a50:fb82:: with SMTP id e2mr9476227edq.272.1619595719215;
        Wed, 28 Apr 2021 00:41:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/8] trace-cmd report: Set the log level with -V and -q options
Date:   Wed, 28 Apr 2021 10:41:48 +0300
Message-Id: <20210428074149.757163-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report -V" is specified, set the log level to INFO.
When "trace-cmd report -q" is specified, set the log level to NONE.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d962b671..aad57dae 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1679,9 +1679,11 @@ void trace_report (int argc, char **argv)
 			break;
 		case 'V':
 			show_status = 1;
+			tracecmd_set_loglevel(TEP_LOG_INFO);
 			break;
 		case 'q':
 			silence_warnings = 1;
+			tracecmd_set_loglevel(TEP_LOG_NONE);
 			break;
 		case OPT_cpu:
 			parse_cpulist(optarg);
-- 
2.30.2

