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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19361C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 07:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F916144F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 07:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhENHx5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 03:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhENHx5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 03:53:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FD6C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 00:52:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c22so15310778ejd.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 00:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMSWXITp5Vu4UAHcCZhQoRGQsqYorZFN7KbfKRVjhoA=;
        b=ZCNvgqvK+gI1B/OsXuDRG7bFDx+YXMTRmLktYpKKGolQtIPqCEMRyar7lg66B9HWjr
         YNmXdQenbKiHgRdDjvd4I6ekChBqb8NCiwly3Zkz9h7tCuHlwLFcfHO0tBi9OGg9WtUZ
         9aNTbJLI00/og4QLbE8cgMrXDFxjd0rIqDULrt8YiHN9L+zQvocc4dqP2Bz8gf07WmwL
         jW5i0xh59l84r1w8zii7Nnztyyp+BDa3N8Z2TnL2dRfpbvCcRyDb1cSuNRoGWlTikZF1
         d3fOjvA5hY1YoCnCdN0UnaU/ekX9dSF1TIyzyRXoekzmkeMwIBN8ktrIyn+XYs4vn2xP
         FqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMSWXITp5Vu4UAHcCZhQoRGQsqYorZFN7KbfKRVjhoA=;
        b=aTFOhRhi3BXPHU1oIxe5/LHdKq9fnff0hZTAQXgV1jqk/J8u9eYmUFuFqDayJdBwcP
         452D9/3MCQCzBQLSrhH6J/D2iTuSDdJ+dr85BrAQ9nl2twO1qKC99UPFfhDjmRsgofow
         TomC8NpqHParATYtgi1CU3UZ8XLAwDxSRgBznPhSCiqeelmc31/K50ysd7kMBY+8AF5c
         eurpS53sAPP74uiLUCuMZnICrFzKUb7Eeyu5PfTBccby8fMVMt4GfTd6RerNA5DLdSZw
         tg8Pm70ejzNEUQHsZYCSj3KsJClamPDIHrfYkt+NA9ffw8OUOKckpD77qwrL7Ry6T/Op
         ZI8w==
X-Gm-Message-State: AOAM530gkOA87Vu4f/fbhfmvOpNcieJZKvuuDwSd9rBo4O9iUSyJ1GHZ
        h9YwHLumTgO3lVOpNaDrWZEd/ANvWPZB0A==
X-Google-Smtp-Source: ABdhPJztAmpQU7tXqExUqvqYgxHhq3jS+I0f/ns+FNbH5bYv5zFIWBL/aNvoirN2vLqygJci6sGaxw==
X-Received: by 2002:a17:906:9444:: with SMTP id z4mr47542038ejx.330.1620978763861;
        Fri, 14 May 2021 00:52:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y2sm3109041ejg.123.2021.05.14.00.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 00:52:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, jmarchan@redhat.com
Subject: [PATCH] trace-cmd: Fix broken profile command
Date:   Fri, 14 May 2021 10:52:41 +0300
Message-Id: <20210514075241.65418-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recent changes in creating trace.dat files broke the streams, used
internaly by the trace-cmd profile command.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213045
Reported-by: Jerome Marchand  <jmarchan@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index f503bf77..b47b208c 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -59,7 +59,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		goto fail;
 	}
 
-	if (tracecmd_read_headers(trace_input, 0) < 0)
+	if (tracecmd_read_headers(trace_input, TRACECMD_FILE_PRINTK) < 0)
 		goto fail_free_input;
 
 	if (handle_init)
-- 
2.31.1

