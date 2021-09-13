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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6686EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D08860F8F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhIMMyq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbhIMMyo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:54:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD905C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w29so13760991wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=mMLfyuC+9nyoF82bUAhpbU7pmddxrwjVaoqepygygUg5fx04P1llllRuhVhah8OvDb
         ABENKyoRYQYHMLVny9X45AVRFbZzQZT7H9Hi9HrKEyTAbZ7vzB9ZsK4AF0OuqGxX0U78
         O47tXNodacx91G0dLmw6A4MphmXmu46WXg0vg7dgLUfpJivnC+gnAe3P/fW3VmnoPGiH
         OrijHE2wjmIU42cLOYayKmus1DFMlaHC7ZmTaTqfx/AeVaWymdgnDiXef3MmAOPEsJaF
         gljQ9u0ExYekr7W2b948d52zOfoElqYPJzF0i5KLCewuG5jDjvvvxasXlx2Ud7XwtZaF
         B5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=Z7HEuf7vBbgZ6Yv3FFSNBp6VQhFBc5iwxo9wMrtslZ1JubXPhLmKXZYHl/dQrJT0MP
         3KOWAEc4dyWGk6sAWQXm0dCN/OE1LWW/do3FgfPnIRpBdykTAjPMnYoK8tTPTlMQQGDm
         6qVQa+I8o5iyhQ2AkYlCo3HZ3DrmkU5SH28XiBbJ5eCuIF+LhzCW0eXMXbhl2pEcXp7p
         KWnUwGSW5i3FG1QBzDYAoKjVum/oVaBYvkq1GolGhZR1ao8OhzPkv0ydrKA4qpH2CTzS
         ZYJH2+lRMkdifpaR5ACsljvTo/PIv/tjSk4NSZgpZp6CIpRj6OD5u/VXSwduBfFGLica
         14Ow==
X-Gm-Message-State: AOAM530bE2r6hvA8pO81J2S4uhJHGcEE19hB/agWJ4+zfIXmzA7RXPhA
        Kho079YoqnNoPlW6gRomtQHT2D2xSjQ=
X-Google-Smtp-Source: ABdhPJz4namti8vrN6bPmEQJZdWWswG+F3zfS0O1mK1wmLCpM1bujb83XVKtzlcNB8jsr2UdpcTGwA==
X-Received: by 2002:a5d:6cc2:: with SMTP id c2mr11759041wrc.53.1631537607446;
        Mon, 13 Sep 2021 05:53:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u8sm7280552wmq.45.2021.09.13.05.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:53:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] tarce-cmd: Update record man page
Date:   Mon, 13 Sep 2021 15:53:21 +0300
Message-Id: <20210913125322.3682097-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
References: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new arguments of the "trace-cmd record" subcommand:
 --compression
 --file-version

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 96c27108..b3620474 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -377,6 +377,19 @@ OPTIONS
 
       trace-cmd record --verbose=warning
 
+*--file-version*::
+    Desired version of the output file. Supported versions are 6 or 7.
+
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
 EXAMPLES
 --------
 
-- 
2.31.1

