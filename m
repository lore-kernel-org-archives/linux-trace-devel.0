Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D872EC7618E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B128C21901
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sr31Yfg9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfGWMwC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:52:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46567 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732442AbfGWMwC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 08:52:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so43025434wru.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2019 05:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dybi/trpqjaTo9oVl4SyfCWKAipl1AwJiIMcpNlAozg=;
        b=Sr31Yfg9/uVinCxCQz4pI69RK8QOnmh5ThZVfA44E/A3TiZ0nhsMmit8cWU/pzOk8k
         g85Q0hocQ86Hu2hhTMr2FzZY5MiAcaUcIYOIloUmwHQEwQu41IkfURKTQ4dxkD5jjOOy
         pYjv5YizmpBG+GkEzFlq2TBhWKt6f8cAvPPMJ+xmf5G6Y+bsqgK8jnS3S6bM0hclE3Hp
         WNASExkYrwlAkgpEUKUS8ium30YfB0D1NeJTBVmHN16WkaTGMglt8FErOWv9CM/1ghKO
         JcMrunSldq0Okz78X1BitKc5nr3zInaLCj5Gwe3wai7gxH4kOblS/UpjPTR/1vZJrVbL
         TO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dybi/trpqjaTo9oVl4SyfCWKAipl1AwJiIMcpNlAozg=;
        b=d/WXZTpYGAiYNqv76VPHBeDBnSBOnbkIf36tMenJxlEw5TP/0d03SSR/nLoJ/ry9JP
         B3wTY1W8TiWJ4DSP6l5PBycvFB84dRG8RCEAf6pARx6Kx/ycAjLQi8gkVL7Y/RXWw04r
         foNms820/OpbLwxHSKO3be6aUVIxsgdHEt++hMjwq5L1w0OwSdbh6nr0Xiqr6LtS4cCA
         6ehtHObVLF6m4jwLtjqj+VFHT3on0Y2iWQvYwGP9xqWfBr3bWZWbOicEHzC+tkX9WV7r
         iq0A2yrZA7NcXCW3bX9wykmVMV8LISL155ZoFqCOl/WFMPs293Qw30bhSJfyC1yMvFyM
         qtBg==
X-Gm-Message-State: APjAAAXHbeS3EoFGsxtigp+afDDqzOZdbQCa1tNRwMcQEcf5bDjgLd3H
        XrzBWTwvEXUXg3MYzYLQQ04=
X-Google-Smtp-Source: APXvYqx1NYb1gjCncQ23ShXSpgge6PJfA5GvjR8AyjKUKSqbIp2yPfJQkyn/z+prEKEozXZDV0dt/A==
X-Received: by 2002:adf:f206:: with SMTP id p6mr8225678wro.216.1563886320296;
        Tue, 23 Jul 2019 05:52:00 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e19sm57423320wra.71.2019.07.23.05.51.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:52:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, howaboutsynergy@pm.me,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Better error message for the constructor of KsCaptureControl
Date:   Tue, 23 Jul 2019 15:52:03 +0300
Message-Id: <20190723125204.22799-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190723125204.22799-1-y.karadz@gmail.com>
References: <20190723125204.22799-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The error message includes the case when the tracing directory cannot be
found or mounted.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 0a29518..2e6e8f9 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -55,13 +55,19 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
 		_topLayout.addWidget(line);
 	};
 
-	if (pluginList.count() == 0) {
+	if (pluginList.count() == 0 || !_localTEP) {
 		/*
-		 * No plugins have been found. Most likely this is because
-		 * the process has no Root privileges.
+		 * No plugins or events have been found. Most likely this is
+		 * because the process has no Root privileges or because
+		 * tracefs cannot be mounted.
 		 */
 		QString message("Error: No events or plugins found.\n");
-		message += "Root privileges are required.";
+
+		if (!_localTEP)
+			message += "Cannot find or mount tracing directory.\n";
+		if (!pluginList.count())
+			message += "Root privileges are required.\n";
+
 		QLabel *errorLabel = new QLabel(message);
 
 		errorLabel->setStyleSheet("QLabel {color : red;}");
-- 
2.20.1

