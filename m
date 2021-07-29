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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47F3C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3E16023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhG2FLD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhG2FLD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DC3C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:59 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y7so4163172eda.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=laAbe1GsKsTa0GiJsFPPpEeHWVvQWL3tIhbHAnbGL3M=;
        b=eJbH8trSlM3uBkfuLb8pPCbpN30UXZ3KbaIbeLJT6svm7GHfQQfkONYZqnuevvlQrE
         VjuO6lHwJTG4Lfy+zfZzlZWu9JIm357PAKmAtSpHIbQRCv39sny/reWBd2Hl9hLwXxF3
         yV8A9rCo1QSBJPlZGtTfHlsDg3UDUxmQDDh7w9GlnimmuIWe3qSbzM+cBQMM7n8b6Wip
         WBF3sX+PbeAWijcLYknbWQfY6awSPhGdKSCZZIeEoQGXUZ31DoUat5X9VkGpH0ncEDEu
         ZhO3b7S1xMxJIBdWVFMv/R43HJqqayxfS5Q/yGzr3qpyUd39139VGircFtaIEFayVcPl
         5VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=laAbe1GsKsTa0GiJsFPPpEeHWVvQWL3tIhbHAnbGL3M=;
        b=YFK4dR8MYjTVYBPZ4rYtaGGZ9I9r4WMmmOmFWIT0l9MMvjvDvWPAhPgH1+y7Efe2cc
         aq5mVlBkqszMrNSwi1vP6dZy9YWAADDDogk3F1xZrtLM31XFkPwOrVE9r/ixkc1i1Xt0
         XcPxh+AR9dT/FJpdH2AlIW6QiMYcqI11DzpZLbQu5KjJpAYeW18fETNEZPBtfQcTZWXf
         pEcmEJzsbMenrQ5AJEyXD/48tnHVL6LNrDxBTRhQeEv789rr6SgQlTK+VPmG+RmU2Xce
         IlRjkHZB2o/tDf2urheSzygOIYZ/0I7lZVJiDG0HcY3aNt4s1iiObfo1/DYJLXAytBgr
         69Dw==
X-Gm-Message-State: AOAM531R85hfiKgbyfKTFes5tLrzozVuKYRvy0MEbVs+wBFdJbdvtJ3i
        XAFjPpTTxNqyBHCM4P5KfMU=
X-Google-Smtp-Source: ABdhPJyqr0sa3KJxY5Uocz30SZvCYnJowfhs2/WzPhkxCAhzNnrNRrdjGbc78RFv67thzOcHa5tzSg==
X-Received: by 2002:a05:6402:b8f:: with SMTP id cf15mr3885912edb.286.1627535458485;
        Wed, 28 Jul 2021 22:10:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 59/87] trace-cmd report: Do not print empty buffer name
Date:   Thu, 29 Jul 2021 08:09:31 +0300
Message-Id: <20210729050959.12263-60-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the top buffer is saved with its empty
file name, string "". When displaying it, filter those empty strings.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index a36d72e4..1868a830 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1175,7 +1175,7 @@ static void print_handle_file(struct handle_list *handles)
 	/* Only print file names if more than one file is read */
 	if (!multi_inputs && !instances)
 		return;
-	if (handles->file)
+	if (handles->file && *handles->file != '\0')
 		printf("%*s: ", max_file_size, handles->file);
 	else
 		printf("%*s  ", max_file_size, "");
-- 
2.31.1

