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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D8EC433C1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A1DF61969
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhC2M67 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 08:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhC2M61 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 08:58:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17BAC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:26 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u9so19279300ejj.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//FH1qVrcYeLLm3XIcmJVkTw6NkOe5FR+5vFfzDuYGQ=;
        b=rBKLYFu/Df0E0FIudH9jllsBAoOUGf8RaC5JSuT0HSJIRYSUAzhVmEWgvBZ5tswaq8
         Gc/7o4MVab1NyLlT3pfLpNmJF5eZ8TGy+wMjZYOE9Q5cd+oSbPRzLKG5Zsx6dwlnlOBg
         TE89fZfZ2dHlHSfyppzD4TZcsGz3y50cBo29BTTsCjC5WJYBSnYdHGRcWXuFZCjq/NbZ
         HfUnXe/Qf8SOihzvUwgTtOJenCFqD/wHW7bcc4/puiWApz3N8BmlB6LochaTJyKd1oGc
         l9rIDc0HOp8Ch9Jdgz0+0nH+5At3VeLNBddOgQgfgpKbgxjzt2FEPM6qMztv3w73Cf0S
         I44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//FH1qVrcYeLLm3XIcmJVkTw6NkOe5FR+5vFfzDuYGQ=;
        b=O0ES0R4ass6ju33vJyadLBtvO0Q2tyt8dsoDxmYMedETvqX+Zfd9sjE389kwtn1pEY
         5Ut1zhtOgxGoRvzzEWI5ypiTDcs/qpZ/X90H3BfHhjdY69OeXwRTOpHUMzmDFW3dAA3O
         nYox7hcrdFPU4CKpG9Y2++MG5sdWfAcFesjdnkmwmkA6gNKAGDPymQIAau7g5oJ67lQw
         bP5CtUuKBzyzl+uHZ7mRjvHE+f5JyVoduzcMdIxE83klTGs5K/YKYKW1QZSFeTV0KidH
         RRaupSl2DsnnzjHl4aifUsgUT4At6CQtLOHn1XIAYaunsLVCxJmP+TySZsEzk5i8sQSO
         XccQ==
X-Gm-Message-State: AOAM531TdKVCpOylS1sc/eXqzg5AVBnqu+sckEs1Te2YpIvPMfH2EkAU
        EC5GXo/Cw00prPQwp2p/prB1d3BhrTq3DA==
X-Google-Smtp-Source: ABdhPJyvUFWSZnT5Q+B8yMVW3MDuwA6q/A1qsV+SgYFqLQY8VskmjldkNpqwNSAwjgjJ+X3Hep6PPA==
X-Received: by 2002:a17:906:5e01:: with SMTP id n1mr28515632eju.359.1617022705743;
        Mon, 29 Mar 2021 05:58:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d19sm8909075edr.45.2021.03.29.05.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:58:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd: Add tsc2nsec clock to "list -C" command
Date:   Mon, 29 Mar 2021 15:58:19 +0300
Message-Id: <20210329125821.97496-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329125821.97496-1-tz.stoyanov@gmail.com>
References: <20210329125821.97496-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extended the "trace-cmd list -C" command to show tsc2nsec clock, if
supported.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-list.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index f017c938..63216b43 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -264,7 +264,21 @@ static void show_options(void)
 
 static void show_clocks(void)
 {
-	show_file("trace_clock");
+	char *clocks;
+	int size;
+
+	clocks = tracefs_instance_file_read(NULL, "trace_clock", &size);
+	if (!clocks)
+		die("getting clocks");
+	if (clocks[size - 1] == '\n')
+		clocks[size - 1] = 0;
+
+	if (trace_tsc2nsec_is_supported())
+		printf("%s %s\n", clocks, TSCNSEC_CLOCK);
+	else
+		printf("%s\n", clocks);
+
+	free(clocks);
 }
 
 
-- 
2.30.2

