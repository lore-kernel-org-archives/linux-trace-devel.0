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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800F7C43445
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E0A61A1F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCYGlk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCYGlR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:17 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3B6C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:16 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 12so511762wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kHjWAydcKu8G0F9+C84JyWVJgYi15YLDKcGQ3tSKtOg=;
        b=uBP0o5mLSyLH7vCkL4nEVU5+wxnJW1btRQMF1Nfa4JVd/K6bHPgtmtFpF9mBqCPKRI
         +7pfjWCpjiBzllMJ59DDmuE9yYdjbqNnb9uBxTgiBdCrQhv9VlEPHDkOk0hYPWmYbX3/
         BbgIrnGeJAUnp9scByxwnN2cfwR4WbhJ15wto8L9e04c/PC3p2Qsh4mKm0ERCdE/Qv05
         w6H70Xp2ur+POuIGhi4q3SNEeEpDW0LJcCMoCsIL0Qz6jsXhyChAlNU6QEswERJFyct9
         GOgf5zVAqOPgxkGWPE7Ruv0RKIQ2p8d746aPpwHZUKUWAFXRBdqvBarHfaOI9VehBNBL
         /gkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kHjWAydcKu8G0F9+C84JyWVJgYi15YLDKcGQ3tSKtOg=;
        b=FsOfMIs2IBOtwgDQ6/m7Sbl1EHXUlKNBNR1JQHqYzmgpqhAx2+UsTar34NeZmbjkbg
         WArTWQ0QtIep5I5oOw6Njkcn3sZZdudCrRqJ8pasI8dwnGlL/Ctwai7bwq2doXwqn6BC
         4pevV/P9TxSe7fq2G/CuoMWFmfZjLl6Jj+InrXlUEwdoSqn5njtcx+CTUKPYj4lRoMlH
         ggRxTraHFJHhbCl8m7bCYgjJa3/irjJ49CF4cOLOf5riLPRYfWpIAqCy1h1SmDFGd13T
         y1No59qeclBqgCmZaiKWGcEd+Yxe7x6Q8uAc60jY8JH5cgKgILAvWffzZvwGMrKWpVKy
         +2tg==
X-Gm-Message-State: AOAM53026CybLawRihSANUVjY/4RaalYf+KGAk+4B+lA1cZilwWt3x/i
        Ghn8fRh0f4Z6q/Nrvi1ueW0=
X-Google-Smtp-Source: ABdhPJxXT68He0kyTfzKiNxOaeBtK9hSJBLYOiasR2VpfZ2ejUffRD1ylKqtO7Pbz3eu52Qd4AaSmw==
X-Received: by 2002:a1c:2155:: with SMTP id h82mr6351230wmh.169.1616654475651;
        Wed, 24 Mar 2021 23:41:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 19/23] trace-cmd: Print times in TimeShift options as unsigned in trace-cmd dump
Date:   Thu, 25 Mar 2021 08:40:51 +0200
Message-Id: <20210325064055.539554-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed "trace-cmd dump" subcommand to print unsigned times from
Time Shift option in a trace.dat file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 24ec9695..b6ae5638 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -373,7 +373,7 @@ static void dump_option_timeshift(int fd, int size)
 {
 	long long *scalings = NULL;
 	long long *offsets = NULL;
-	long long *times = NULL;
+	unsigned long long *times = NULL;
 	long long trace_id;
 	unsigned int count;
 	unsigned int flags;
@@ -415,7 +415,7 @@ static void dump_option_timeshift(int fd, int size)
 		read_file_number(fd, scalings + i, 8);
 
 	for (i = 0; i < count; i++)
-		do_print(OPTIONS, "\t%lld * %lld %lld [offset * scaling @ time]\n",
+		do_print(OPTIONS, "\t%lld * %lld %llu [offset * scaling @ time]\n",
 			 offsets[i], scalings[1], times[i]);
 
 out:
-- 
2.30.2

