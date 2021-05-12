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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8078DC43600
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D8C613BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhELGjp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhELGjn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:43 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF4EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:35 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a4so33346232ejk.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=asuuAM/DbFHwoKgAFTzA5hM0EAmoCA+ufY1mLOt9v2I=;
        b=gBIVRftNEQK6KQXU731sb2OR9VjL47FNWWptyluy07GKb0sama5bG8Evk1ReGQfKga
         YdDa9k1d1RXqK9QlFFxWVtrNBWoFh3XRh5kaxT6LlXy3BQ9qGdW1U8VK80sS/f/X9hOH
         NT22yS0cexieVbjsKaqG4oeZ+Xg/sCn6ZlA5TVDymZcJ7s+k9wiG+xD+p5qxYKMSTknD
         M5P1PfFX3LYxlt0wGDEELjvTGaiLB6m66W+vF4aSh5VzNVhq/iLzcH614PPZ5XftB5wi
         857x81hs/eALdC6Gj+//45n/0p8ZIPBE+TbXLVYULuh3rCh4ZC8PzhSmsoJH02uFrwyt
         RfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asuuAM/DbFHwoKgAFTzA5hM0EAmoCA+ufY1mLOt9v2I=;
        b=qGmskjyaqaEo1InJtIFpFY+n6floBex+4YtFV8C2pUU1DWOktW17Ky0CiSO6uTptBy
         6oj70vhEV0VOVsaMzL8FIepLC7aGrT6UIcqfCbq7noNejxpyyF8NYYQk9Ptwo8MzZjah
         ovT6DPPQCMEpJcQPyoim8hGMO1NTA6jAnLL7uDneIgvr1bhxGe/eHxclFVEjMOXmGOqJ
         k+HHVNLZdD+V2rC/MB/G5k4oGk6TP7xVZVxGE2owfKBYlDBmIFOXzHs/CQawq8iPDiIK
         /zBeH9a9e/wOhSWYdGLNMGrDG5FrTPBRKNaw3yh01a9/d0FNE7Ia//kwJorAY0cBe5q6
         VcnA==
X-Gm-Message-State: AOAM530gTfY0PO/bcLKhvrMbmpJXdmmkajSxhqhK7cfuL/X277iCQCuM
        P6G/AXLbletWAurLChPpaPk=
X-Google-Smtp-Source: ABdhPJyHUAci9ZsUmY6k8Yr+H7rZ0A9+pKRR0R9kHSHNb0v3Q6i+Q8ijQ/a7pQnwFTvePsWwrRJQWQ==
X-Received: by 2002:a17:906:fa19:: with SMTP id lo25mr35239957ejb.394.1620801514325;
        Tue, 11 May 2021 23:38:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 09/25] trace-cmd library: Bump the trace file version to 7
Date:   Wed, 12 May 2021 09:38:07 +0300
Message-Id: <20210512063823.324610-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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

