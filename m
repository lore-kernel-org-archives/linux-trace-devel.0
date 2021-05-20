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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2759BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CDE361184
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhETDVh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhETDVf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:35 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF52C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l1so22954665ejb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cp2xjlaw4uvJnn+MOUAkFZQ+eOSnxvlwG7WEJsSGUdQ=;
        b=YRHZbSVE5pv3lMh0W1IqVJXLYQAEoGd21woEm6KqzEdsli9AsaMzkJU7jEMCwhfiQX
         DzKApOiVZThDhE7IyMOQmTPZBepU1Mkjmr1oIV2QA8De4DsTS8+haIaWvkDeGHUM613e
         fV0gMDssch5O67K/dEZ6dfF0P5fwoIUcbRL53Xt2jPKfXKBUbqEBiWg0ptSacuP1AwFY
         HEGc+05m/YiozWroM1DfVCJVTnNljWXnfWAN8YqZQBwMyyxO7NFgvgWAfVFh/qQRZ8/b
         Y80Vxy23pNfUob5qP48N+IRB3oRc6uy02jt0aLpLYf3sad80Dnf2TcmZAj83G7YLhxrD
         liMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cp2xjlaw4uvJnn+MOUAkFZQ+eOSnxvlwG7WEJsSGUdQ=;
        b=C/0akrn0kaXIJ0cNVkcpn0M1ctZr5R4UOG5j7fydrtDy89J7QdagKncySQRe9GczE+
         i4qb8EhiFfH+e5uiZgUeU52vnEClXuPvdlrqt/tqwOxlQNhkQxPGDFXe1jBubWOYQVBc
         S8+aVYTLbF0Ig4nDC9X9ZxgDGp1dHjaJM+bxkWU2NLKcW/D2GNeo+9xoir1vK+eJBl1o
         H82wDAO0Beu60kym062vMF8DQOhPzDBCJrIC+6q9lAYhrKcoWx91wVOppC+j3MLjVYbx
         nYvxsB9bafdYvm7jxv6t7DO38FMavQ7FX473XH2G5WV8qeY5uFz+9QG4nFv1xxzh4Vbv
         SsEQ==
X-Gm-Message-State: AOAM532HjWLI8vapv9CgFFUYY15DO6usMlfHkY4XuJ8QjZB9qfOatWRv
        ZBjqKAbVqf10lmUtbLF1hBQlttKCc4lbFQ==
X-Google-Smtp-Source: ABdhPJz47slKBZPlPbrzqEU8DLM2rCKZmL/346hjpTfQKxLpFJkau+nvC9m8WV+awo8mFd+HFXfK/Q==
X-Received: by 2002:a17:906:40d1:: with SMTP id a17mr2417042ejk.43.1621480812714;
        Wed, 19 May 2021 20:20:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 09/29] trace-cmd library: Bump the trace file version to 7
Date:   Thu, 20 May 2021 06:19:39 +0300
Message-Id: <20210520031959.346165-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
index 041582c6..3332572b 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -15,7 +15,7 @@ void tracecmd_critical(const char *fmt, ...);
 void tracecmd_info(const char *fmt, ...);
 
 /* trace.dat file format version */
-#define FILE_VERSION 6
+#define FILE_VERSION 7
 
 #define _STR(x)	#x
 #define STR(x)	_STR(x)
-- 
2.31.1

