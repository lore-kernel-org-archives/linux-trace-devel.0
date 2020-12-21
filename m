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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24D3C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 07:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EFB222C7E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 07:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgLUHlf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 02:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgLUHlf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 02:41:35 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E5EC0613D3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 23:40:50 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id q22so12097541eja.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 23:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HsYJQk2U2sdWQrCxNLqezriiBOOfX2zxVY9HlEYiMio=;
        b=kLSJumlVbE1eynXvwM8+mEhWpF3qaKnGntNBFWPU/JJJWy7wCgGjaXQFX+4uefAoDE
         zl9UsObcmtxO6ZwaX+KuoaWJqxYOSLRVMf4Acbv13iofDOOWoJ4yOIfQo4tgr0JApm7Z
         /QEbjP4mBnJqTsfYG0fQTscE/mnBWoFlV0THGmcA+pwQHsYFvlXklH55vUqBxwiPEip/
         2wVKRfGiBnaB47trPiq7gc6/xrh4yGoK0rRbZidn4XCNQxSjhh7/tgQNRcYSRFNj8nUX
         DgpfGbA8wxkZdpSke3XZLqnel6yaVcZSi6FR0ZggzqIgfSdOuh6W7ZBwMN8EhU0B7xjS
         cY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HsYJQk2U2sdWQrCxNLqezriiBOOfX2zxVY9HlEYiMio=;
        b=oVNtFhfhVn58rL1e/t05H8FtxxhP3SjEldiMDFJSNtWwd4ZiMmmbhgGLEmNCs6tnOl
         FqCdNFrPvt5Mw9wonRkKWdmqkfdHVgx9216hH5AQcbRcuq3O6V9EkWqJS8T3wy69gdlx
         yQDUSPsmCP+ciBlOnFKYOmk5q943hlksakZ6LajZV+c9MJfJUNJE5JoIrxrrKAHhNPzU
         ROUHjhuyMj3vo95r7NX9/Ss7F8TSoYUiWH+2Zvb+GqfdnX7WxJxKyY2mm2KsqxvvHYev
         VaFstQ24Hc7A/nOLfWQ5t4OWsTytGFBwjA8lzPTX5wmdawUUPdI7H847cVfo0ecnZxoe
         F20g==
X-Gm-Message-State: AOAM5338gR+2H7RAVaqmIPoDf8D6ckX0jhJpjqzxrJm7QHK5kQVm9aa6
        5WYHFmwVX8Dl5gO38sp3F5o=
X-Google-Smtp-Source: ABdhPJzQOAxGSC9OVBFlqbcv9BIqMtZStnfrKHL0uGK8wiMmITyLgr+53R4pqHJU5ncWooCKLvU1dA==
X-Received: by 2002:a17:906:b24c:: with SMTP id ce12mr14162491ejb.89.1608536449297;
        Sun, 20 Dec 2020 23:40:49 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j27sm8814628ejo.61.2020.12.20.23.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 23:40:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Force unit test to use local library
Date:   Mon, 21 Dec 2020 09:40:47 +0200
Message-Id: <20201221074047.213787-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit test must test the library located in the sorce tree, instead the
one installed in the system.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
 - Fixed broken commit description.

 utest/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index 6505a3e..403540a 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	-L$(bdir) -ltracefs
+	-L$(obj)/lib/tracefs -ltracefs
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.28.0

