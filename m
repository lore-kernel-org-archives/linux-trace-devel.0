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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F46C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CE760C3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhG2FLO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhG2FLO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:14 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD2C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j2so6364251edp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2lbA4dZN38akh4DzP6Jp1yJLAlJkBdDhjexsLTpKic=;
        b=sp+CMudc+51Sf3P/QQF5QJNwATyv8qjhZjt6soRNrWcv8HmeDuTyvalrJ+zfkgwWJM
         5uw52waT3EeM17DlKvs+zlx7VJCzuKkkBkVln8PyWTrs0rERSPpSRRZUSal5+oF4wF4j
         WVAYSXRZ52npNcYT8S6B8Umvi5MLMfBOvodnlOYj+p4G78BKl5wxxrceJWY3ovIK5bEH
         dYsAS8fOvDs08/pBAskQLQu0lJC+AL4MtRd4x0QYDPKfcbFMucQYCj51ObTH7VPEWWGp
         jMCIYE1Q0gXPs7p//1NVdcqEkq/1ibH3HU3Wa7lAv4EzVb7wPJsMYaW1kxcR9Wgx0fov
         CdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2lbA4dZN38akh4DzP6Jp1yJLAlJkBdDhjexsLTpKic=;
        b=XxkZLLLAuuxLsZmdXq7dTVl7wFA251st5j9A8S/tv6TzCr+JqlzQ5IoK8ze0dfLs+M
         j5BMppa7EZHCmvXORwL4xbTcPkzlL+vjRIEzCnTDfD4ujUlo0k5bxq5i9kvvrrWKegpv
         GitAYE+jtKGn5k5/JCy2bySxUNSLSwKh/VjqxZaCMXMKvaS1jxFu8C1cv9M0zcM9bc3J
         ARtdmkOcKFhcLPILHWV8+fvG4pSBJynu0QbitzxDQRAET+3a2zhtpuaBxecNpV5HPffB
         S7o19audMoayloAGHfYGrBWkIgs8/wiyP4vQ3Zwn3f7YVPeR6fCWuFFkk16h7n+7zGiH
         HfUw==
X-Gm-Message-State: AOAM531HqbQtrVc7pNYREABuYkYyv7IXOOLjZQbC3JFmvnI3+5K5c/kD
        aIWKOeQ7XqjhNNvbaX7NTzI=
X-Google-Smtp-Source: ABdhPJzeizNHVLUTRILob535Iuahn+5USpMhyKPKxlvsGrFhAGKJWVO3HH/fq+U02OwXIcEVdK18cQ==
X-Received: by 2002:a05:6402:487:: with SMTP id k7mr3821320edv.315.1627535470019;
        Wed, 28 Jul 2021 22:11:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 71/87] trace-cmd dump: Align better the output of flyrecord dump
Date:   Thu, 29 Jul 2021 08:09:43 +0300
Message-Id: <20210729050959.12263-72-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index f966212a..7c390022 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -898,7 +898,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.31.1

