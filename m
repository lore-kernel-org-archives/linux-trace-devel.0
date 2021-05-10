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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A588C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C4B610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhEJGRy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:53 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A2C061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:48 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id m12so22748941eja.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=asuuAM/DbFHwoKgAFTzA5hM0EAmoCA+ufY1mLOt9v2I=;
        b=kx5BH418tLXdACZgAIhi8joFoSSPbptS87AHj+WfQCV7ieBVIc4aNpBWsl7gr6HwHi
         p0dMFjmXj17ClmvNcxfOq0mRypVHkJePrHFSGZ2bca5wam7n52Kx9jUMz2OIdhyZBOK3
         5dUaNwiL4GsSD+5I5+4hoO4+V7vgTBOA+n0X6xxpHOzegTi41jbKgH+yAdfwNm+ZaUXY
         dn4OxHLSqyAPHpK5D3YEIS4B/vhr1DRsJxmOOezWt/WsDorm83efGic5X4+r4g8lIt+Z
         95ys4Ii8l0Mtze5qCf8CtJEh5WcPmwr+7VvFntP+WXtuMf5BTCw8FVBq+dBi0pbcafJB
         Awqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asuuAM/DbFHwoKgAFTzA5hM0EAmoCA+ufY1mLOt9v2I=;
        b=iUVEgLlpDNZLA5nrLKOKyUgDT/9TPfhNKjFgGqcBMlv9XXzbj8ajpwAKAL7RhoNQkY
         bPQbCPLQUEDVCqxqCiwWA/vG2PhwDDlu+VG5PAinCuJU8TAIVukiO1WwPhGUVPbXBY06
         BdJIgnkeP5ftGBanFd8zp+9TYiO82rn+Xb1rfV06aHW80NSaBwbTIdLIjHXf03XnoDHs
         Kqfp6nYfnBSWLU3+32ku8P9wyCVbXnSfR6Feo49SYR5VSUFpOkxSe8IrFxHdPVMXPpJW
         jtL4BwxH20ip+x1AqsxG1Bi94oa9mL4zhjO7bA/S/4q0XxP9Gu4LomV/caOMd47AYfQf
         YZvg==
X-Gm-Message-State: AOAM533McD6cf07s3E6HVRW+BaUujbl5Od1zmmur1TuKjNOrqExKmet3
        CkPOW+GirTFZts4vIHFRzKA8iXZAxKpghA==
X-Google-Smtp-Source: ABdhPJzetg+EmoE3X3xyvGkWajkrkqF0E+TE1h3FMwU738UpT3m+6YsRJahZBfsXkdmaqEBZwmTXzw==
X-Received: by 2002:a17:906:f9d7:: with SMTP id lj23mr24210254ejb.392.1620627407337;
        Sun, 09 May 2021 23:16:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/21] trace-cmd library: Bump the trace file version to 7
Date:   Mon, 10 May 2021 09:16:24 +0300
Message-Id: <20210510061636.1794357-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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
index 862283fc..c8c51ff0 100644
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
2.31.1

