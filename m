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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FA5C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C12C660200
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhDVHR6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHR5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:17:57 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D131C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id e7so52075692edu.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHD82sINsZplFbyglii2VDYPeWFtu0uSNBpGrCNlO30=;
        b=jvJ5wajwYbXCsyulcjH74GTkQ+nq2cYxRUDaWSK+fmR3HXAsZfzgfac5pIA6RcgExt
         44mWJfUX3kY1fPk10LcHDkYWb6Cna0UNSHGA7JWz809YfTSgM3sVlYivwObyHSC+UD5x
         jUbXQKsp1WwBoSLiodWeJRYQW2lwQSJdg0HVI+SS6ZDoWi+tiHwGu5wyt5LRULcq44MG
         l664AN6EhaT/iCQ2mhSdUmSqatEVwFCLDq+E2vEhSWUVVfuouEsoTOHLFca7/htieuVu
         2WdknoBY8H1gKRYque9hsMcUevjqf/nPGtq1ev9UZ25jxHsL21F2MvvmggwBfqHxPka9
         mBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHD82sINsZplFbyglii2VDYPeWFtu0uSNBpGrCNlO30=;
        b=GqqjcM9kIn6iYKw2Psb3kDbKS34XIZLPTbnIHCvYlsPVE59B8Jzcf+RAObpLWs9bTy
         OS86I6XzBF31Yw61YbSriWvhDhR1WPvCt6JkAEIXnlpynOaNjiZbQCwLVH4X1q6XF8dj
         uhGiJJQfrp3hvK8XrhKiQULOq6dkJfu5yqLvFOdr/PHe0PJEhnVVurMt+LaXcc7Kz5rT
         yB5mHz+Dj0XnXbR7kNRAzbNebFBenz4LJnbn6eIVX1gaxKkANDlPiyuId4B9vmUQKaYM
         jTeWX7GiW4qdWSr5y+OHCAmnDiz/lm8NFDWCd6SLqGQj2ie8pcM1wHsYizqos4cjy9bR
         E8+g==
X-Gm-Message-State: AOAM533syxzPh3fJ+4o94fCnytdJ4Shea7lQVXMMoTCbguzrxgYBTyuq
        58gt6huPZojfeXpW/4bMp7Lw5m+JYhVU6A==
X-Google-Smtp-Source: ABdhPJy2h+qix53GkG3g4aq8Ve+hjAiUk3rc8AtXQ2qvhD5BFL2dykK9+P0JwwQSWJUrsEu2fmjSjg==
X-Received: by 2002:a05:6402:2054:: with SMTP id bc20mr1966420edb.334.1619075842239;
        Thu, 22 Apr 2021 00:17:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/6] trace-cmd library: Bump the trace file version to 7
Date:   Thu, 22 Apr 2021 10:17:13 +0300
Message-Id: <20210422071718.483383-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422071718.483383-1-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding a compression of the trace.dat file will change its structure.
These changes are not backward compatible, the old trace-cmd binaries
will not be able to read compressed trace files. Bumping the version to
7 will prevent old trace-cmd to read such files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e8533b22..5578f00d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -14,7 +14,7 @@ void tracecmd_warning(const char *fmt, ...);
 void tracecmd_fatal(const char *fmt, ...);
 
 /* trace.dat file format version */
-#define FILE_VERSION 6
+#define FILE_VERSION 7
 
 #define _STR(x)	#x
 #define STR(x)	_STR(x)
-- 
2.30.2

