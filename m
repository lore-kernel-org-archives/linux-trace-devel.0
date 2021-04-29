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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4E8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45E626144E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhD2EDm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 00:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhD2EDl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 00:03:41 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2044DC06138C
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:39 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z13so21706634lft.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHD82sINsZplFbyglii2VDYPeWFtu0uSNBpGrCNlO30=;
        b=Fk55F4/y5KCqs1MIeDgiYqiMBTXfLpNYQkCVqlQYRZ0p/Zs9lV8bN5stShwdwXhWfK
         n/bBc7A8eMVbSYCTVkfpx57KAyCPmfbXbNHti6W7SY3Stty5zLxhkQ2WN/F24ik/z6ql
         J95UXXrzlcZz4UrB1rmmsKovvz2ynN19hcjOCwMkboJ0vg2Y0y7UDgOFXOp9ISSxW/MU
         8sQKg95T6FkD9KmmVk7UGsZ049IhfrVvAQKOZvM7/ZRHfSPeO0g23ln3WcTvlpv3VBly
         qMbN9NCfNwIByjX8dLr3QWqKLkCh3ABQSUeqlx1lgp+m1CzRNy2iu/B34h0vRB8k+1Nd
         hFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHD82sINsZplFbyglii2VDYPeWFtu0uSNBpGrCNlO30=;
        b=fOx0rbU59qDWxHjO31AeIqnax/Ukm+/En7W6bEliBeFdx44KdZZvX5ThjcE3UqsBtu
         G64uumhK1kpo16NuIe9JAeiWzSqUmRHYHaylfDX+K+2AgJDCm1zi5DLwxvki/Jc5De+r
         8EGc7onijlznI+YaNTXDjfJpXrS8R/Ym7TYfrENgXwqelzh6ky3T+GFT8aRBe0O0bSQ8
         UMuluLHIg+Y69cLd676TfFGQuHlcQn+yAYhKesbCJUoSmFPCQjCuFWeQubEHTWSLXSFX
         UywN0fl4SYagN6UXb0B6LEofhaJU5Gc/bhAfuviXZ59hfHhIabr67sqf3sob4kqxF6yh
         F5fQ==
X-Gm-Message-State: AOAM533AzbDO6bUKbA4DgGa6lwNtALDCoHlEy2i3fBuTKx6R5V7cvzHm
        nakRSTFU255RDB1jdiUXZYXPQeo8mAUo0w==
X-Google-Smtp-Source: ABdhPJz3V6z+L489OCS4GbgBMO7ZyuychNfrZQQ883LMmI9wE4pqH4FKC9YXfeM2JE7CoeCwK03R/A==
X-Received: by 2002:a17:907:7634:: with SMTP id jy20mr4888810ejc.553.1619668884598;
        Wed, 28 Apr 2021 21:01:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1040740ejl.38.2021.04.28.21.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 21:01:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/7] trace-cmd library: Bump the trace file version to 7
Date:   Thu, 29 Apr 2021 07:01:15 +0300
Message-Id: <20210429040119.843617-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210429040119.843617-1-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
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

