Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB99C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 13:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD522077B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 13:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFr0ZEsm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbfLLNqO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 08:46:14 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36265 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbfLLNqO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 08:46:14 -0500
Received: by mail-lf1-f65.google.com with SMTP id n12so1759608lfe.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 05:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m0DVTqUAEE5YxR6rx/ozhv2nZT93fAHOGanlWJ0gJqs=;
        b=MFr0ZEsmoQELK4dduLxJsnITwNnkBVFR7keAcjZQaejwCFPmkocw1oAcRWqQByVf1I
         lBB5QX7Xh7XheeaNWK+bnEHZVgbvMJdp5MSxAoBaLDLPJqbV+lMiUmm4fKAmxW98pb5n
         uLLFBYtoJcaRvrmSU8ytXY60T1upNHhw/lLorvCrDhuF83OIg83a4jIaXICJDzG7Ktdw
         JIDwmQSdj468hpF0+m+GJFEpxT537VCuQjQPlg4e8C3PkLxjPkl50P6WpXaacD1cLWPa
         CvQwoT+AmkDUcjSohJU1EjWMuYiXK/dWxlGhscf73gfY+nnPzDMqsINe9zVJrSyhp3MD
         0qGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m0DVTqUAEE5YxR6rx/ozhv2nZT93fAHOGanlWJ0gJqs=;
        b=XPAz3hG2yQcn4nXnakFcH+x3kwdsL/sgKGPke8Yi/yS23s0cvqY82s2IniHCO4hwr8
         nNIMDLBgv+c6uxwcFRfOkCjMT2zx1RH65aPLfCL5EsAJl7drVh4vV1zgy9KgBqgl/Sht
         Q++nqXpfrj9YySUvO3xZfBvFnI11QsUYx2i6CXV/FW55JxQGx1fP27HEtps6JBZpLQ/S
         bqETrfP1XC0/OJTZ9A7eoAU9+qH9iXTlHRmxpCba5z5GSxH9VhpG4Jr62nlck6usGFvQ
         B0B43AGtQwZG1R+D6xZOTcpoOft7QDIcyX8I1i8efcFzq5JxUAqznzDM0yr6EPV41Mgq
         +Qxg==
X-Gm-Message-State: APjAAAU9zP2/f/x+0FOBKHqudOjVDMrejmh5jGO/2Os3b5jPlGbydBQ+
        TNoyqEqGAxi1I1ZifKJlV9Q=
X-Google-Smtp-Source: APXvYqyh/tYbz+w11e3YSbBLbYnArH9M/JTytpGK7+9IS8PaVZV8cX0ydF42CqvNhn/jkatapZpdpw==
X-Received: by 2002:ac2:4476:: with SMTP id y22mr5717466lfl.169.1576158372337;
        Thu, 12 Dec 2019 05:46:12 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u13sm2952729lfq.19.2019.12.12.05.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 05:46:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v2] kernel-shark: Retrieve the home of root using getpwent()
Date:   Thu, 12 Dec 2019 15:45:08 +0200
Message-Id: <20191212134508.32748-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not assume that root is always at "/root". Instead use getpwent(void)
and searche for user id of 0. Return the home path for that user. On any
error just quietly default back to "/root".

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index bd6c338..31224ed 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -422,6 +422,20 @@ QString KsMainWindow::_getCacheDir()
 		QDir().mkpath(dir);
 	};
 
+	auto lamRootHome = [] () {
+		QString home("/root");
+		struct passwd *pwd;
+
+		while ((pwd = getpwent()) != NULL) {
+			if (pwd->pw_uid == 0) {
+				home = pwd->pw_dir;
+				break;
+			}
+		}
+
+		return home;
+	};
+
 	dir = getenv("KS_USER_CACHE_DIR");
 	if (!dir.isEmpty()) {
 		if (!QDir(dir).exists())
@@ -432,7 +446,7 @@ QString KsMainWindow::_getCacheDir()
 		dir += "/kernelshark";
 
 		if (geteuid() == 0)
-			dir.replace(QDir::homePath(), "/root");
+			dir.replace(QDir::homePath(), lamRootHome());
 
 		if (!QDir(dir).exists())
 			lamMakePath(false);
-- 
2.20.1

