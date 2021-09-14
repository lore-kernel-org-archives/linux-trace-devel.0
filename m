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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1CEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E1A610F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhINNOS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNOR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:17 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71656C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:00 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id b21-20020a1c8015000000b003049690d882so2033900wmd.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RL9NU2QU3eQCBHNiwR5XAbT/oZdzMq72Opi9smJDKmw=;
        b=aoAyHoHnzV9YPnQcsKKyNJVwv/Z3UxVNmYzA1f/dnX7+c4nSVV9TCyGPaMcV8lLjso
         WCGxkM0KM5/ahuqde/4UGm3CmH6eeWu0wzH7Wp76uKWtlIncWd2F0O4sCsG9DnnQAfmC
         s/2+hMN5gfFAZMeZb6K/9vClNHq0DoB9I1OmhlibzAIzxz8XbbC/r7tm4RG7ZOYgLDIh
         w1bjMax/z5sohBZrohPnPwa2Qa3ys7NjQZsQRZNCo6nbK3lqpmCkoTon8vO2bNdl4noU
         qNufCiI3pmP2u8W7YpvM2GV0exaHjZRTM8KbHjo9JbN2DPn7vlN/3IxVEv4a2gQ+DBwv
         FQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RL9NU2QU3eQCBHNiwR5XAbT/oZdzMq72Opi9smJDKmw=;
        b=qXCo1V+igM0suHy3IPNyZy+VtJIrPwft79kJjokgIq2kR1S95hHzLpPH9PFyS3HP1D
         /B1am0Nm9mO4RwlxUPSuxq4WQedpQB7mX5KypBCdbHZ6Q36ZQnucoLLfUd6uZn1/QqgV
         Gxq0cMAQpMgicM3YKw6fTXSipD1bW8dtr6OHzIt18wmAuTu0KCQBSwa/A2QysplBY5UZ
         50FHVbdXpmFqhutJzLsEawtlDeOYK9AgWXNZZgaF+XLDZYoDS1HOrQt1erEKeIhYhoHl
         EQoREePj+PG4eNlQgZs85NO8Yn8CC/42sF+KpEZcoo3jjkNU6SC+wEq4kFJ7/AJmDomR
         3Mcg==
X-Gm-Message-State: AOAM531CXfvd576xLOLYUgfPs3BDC9NTdbjAxz5ezAfIyvCZMdhuAtl5
        PHMF16Z/uMJzLwxccOzN7rwyb4Sk5io=
X-Google-Smtp-Source: ABdhPJzewjnWIxTay/PdQRjdK/yy1ydVcHzYCGLTiobhwd7Ren3ulxCGa4UyuNBAYfi53bBSZMfX0w==
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr2144644wmc.43.1631625172905;
        Tue, 14 Sep 2021 06:12:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 16/21] trace-cmd report: Close input file handlers on exit
Date:   Tue, 14 Sep 2021 16:12:27 +0300
Message-Id: <20210914131232.3964615-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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

