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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7868EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C83611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhIJNt3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbhIJNt3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:29 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A489C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r7so2590678edd.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RL9NU2QU3eQCBHNiwR5XAbT/oZdzMq72Opi9smJDKmw=;
        b=QtPFo6s6nJZfonX14ru+YUX2cO1DFPe6QZiIwH9IRqVFgaXamZANgTi87wyH6WzdgW
         4jTxqnystGzozBo0luuuLmfwO2YikfwT5HLjMhRbSyFIoYHtzMakX2W202Tes6IPdyIs
         i+a9cJpDQJqqe5QXmagOQZCF6UgnS2g7Qyx/lecRUFqDpMj6QSjvkUcJnpuw5cSKC1Fe
         D9IeSKWvez2hf4c2MRASTE9QJZDivB0H4eCaigN+ISYBXKTvaI6CpRX0SJtasxETP1Oy
         m2x8yweCZD9wKPy3/dU/WdEhL4ZGrj4nApK9fKmMx+XrpqOmMXEj2Xx1uZiEmM3FcCeC
         jR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RL9NU2QU3eQCBHNiwR5XAbT/oZdzMq72Opi9smJDKmw=;
        b=DP5TSTy3g/lo8j01zPcNTB/NGB23vzEVKgkABO0Bdela1qrHySBM/M7YjLrcdcZf7n
         r87uY6lNQyCoPzsAmUtxrNKXfTE9uJM5LDSLoopfsu2QCuHQPO2g9H7nzjAtdN6a1UEm
         x8ys5MlI6By7qt7a2vge3mPkoQaJfvtmhRuCxotkN4HMlAY7ytZNYPphIEHrB/3mvp0w
         cR4jIId8E3uw/0t9jjYjHes8+OIk0BmTG+DLn9g2l/HFwjJiiuSYOQ5nPul1wkjf7Hrq
         4hAl5/9pPk6jz9tgUidlDtoLuy9o+w7tDnDxt02GWuP/Zz+6er46NbCHYNpZUruvcpnY
         dYmw==
X-Gm-Message-State: AOAM531LC8RKtSnPR9/dOh4jat3iCqgSLhZhrVU2JstQPn0Z4fRcZwP3
        rARSSYVCDokDuwMnL5ceNg2Wleivyn4=
X-Google-Smtp-Source: ABdhPJzi0gJHq6mc6cJTtAB/OvtWDtWxBGpYqetlNjvjgpZHYWfZ+PysSh/dVp1/3uBf8BbFXxKUpw==
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr9003655edt.237.1631281696878;
        Fri, 10 Sep 2021 06:48:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 16/21] trace-cmd report: Close input file handlers on exit
Date:   Fri, 10 Sep 2021 16:47:52 +0300
Message-Id: <20210910134757.2863982-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report" is interrupted with "ctrl-c", close the input
handlers to opened trace files, to delete any temporary files used when
reading the trace data. This clean up is needed for the design of the
next version of the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 31724b09..4261088d 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1363,7 +1363,14 @@ struct tracecmd_input *read_trace_header(const char *file, int flags)
 
 static void sig_end(int sig)
 {
+	struct handle_list *handles;
+
 	fprintf(stderr, "trace-cmd: Received SIGINT\n");
+
+	list_for_each_entry(handles, &handle_list, list) {
+		tracecmd_close(handles->handle);
+	}
+
 	exit(0);
 }
 
-- 
2.31.1

