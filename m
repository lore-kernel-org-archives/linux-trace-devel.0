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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CA0C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B82F5611BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhETDoU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhETDoU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:44:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9579EC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:42:59 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lg14so22983970ejb.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YKF8ktJ3lF1EVddXYkZVPPZRXo5xTsgMtS2SCDMfolc=;
        b=Wm24ljMepdUvR9a2OlX/6WBZmrpIEQ8MppcuwvWLPSxc0aSw9YJHwAarhFelm6hvyf
         IvMNFcvklmN2C3wQRUW8Nnia5hftCKIiVkg7fG5Q274MdfH0wA5goivDOrndXOSsnT0V
         wgIovQ31JubTZPvm69Kxo5i1G+FS1rNy/wpjYVxKP0Byhii1Wh+DskGZO5Sy3tOpK7GJ
         GMpv/q9bPFRLQ+x8YWKArCaf1w2mMpU5qHhFjTUtQpjb7kmvgWFlcxW+lbQQDIwvwBHE
         f0HSEFdy/mhBPBbTry1y0jTpuNK/J2zKD6niG6ieJT1pzLQXGVUppl5OyoYLkVUR1uBS
         GKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YKF8ktJ3lF1EVddXYkZVPPZRXo5xTsgMtS2SCDMfolc=;
        b=are/fo1kd4E6fOSbNK350djd7M7VQI/nk10SFonvktZr10lwRshnB0qNeBdQHvckoz
         sR/5yOqMcBxUVjFtrCcm8zsAwWjZaJQIph4qqQtkaD7GkySXX5Moo/JVlzOL56Ijflh5
         geANr3hgFkbdQquu8Ovb/GUxKS9v7f9TE6bhadaSVdTghbVoZaH3WeTUQCaaF352seN+
         xPEkofxTCAmTofvhZoKMgNt/ZiYbcNX9MxevzA8WunVI8RpGO8tnNvhjv5B7i1PzOOYi
         m8c2KvztjLKRBW7Hg/aK39HDSfzc9U5zF81H449JF37ZoUh+5gXJOOSH31F8OARTxdPA
         lIYg==
X-Gm-Message-State: AOAM531vit8oEbRk85W+Lulu5N3EZXcvC7qNnnKxAFDWkZtrDHbSkNDo
        hXZQ/9UJb3ZCL5XRG6KYl3TDan5TIsVaZQ==
X-Google-Smtp-Source: ABdhPJyT+0PZnUjwR6Wn7U+S/5AatXljY0bZzYOuqzRUhxnG7XFdS1nNm4KCoTygrnReHJp1JzRO3g==
X-Received: by 2002:a17:907:94c3:: with SMTP id dn3mr2482906ejc.26.1621482178264;
        Wed, 19 May 2021 20:42:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p9sm768084edu.79.2021.05.19.20.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:42:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Fix a typo in the log man page
Date:   Thu, 20 May 2021 06:42:56 +0300
Message-Id: <20210520034256.355167-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed a typo in the log man page, in the description of the critical
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtraceevent-log.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-log.txt b/Documentation/libtraceevent-log.txt
index 0aee21d..1ecb4db 100644
--- a/Documentation/libtraceevent-log.txt
+++ b/Documentation/libtraceevent-log.txt
@@ -31,7 +31,7 @@ on the console. Library log levels are:
 [verse]
 --
 	_TEP_LOG_NONE_ - Do not print any logs.
-	_TEP_LOG_CRITICAL_ - Print critical logs, problem that may case a crash.
+	_TEP_LOG_CRITICAL_ - Print critical logs, problem that may cause a crash.
 	_TEP_LOG_ERROR_ - Print error logs, problem that could break the main logic of an API.
 	_TEP_LOG_WARNING_ - Print warnings, problem that could limit the result of an API.
 	_TEP_LOG_INFO_ - Print information about normal execution of an API.
-- 
2.31.1

