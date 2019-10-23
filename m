Return-Path: <SRS0=f3YT=YQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A987CA9EB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D50B12086D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIoM6EN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405265AbfJWMVw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:21:52 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37783 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfJWMVw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 08:21:52 -0400
Received: by mail-lj1-f195.google.com with SMTP id l21so20889898lje.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Oct 2019 05:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQ09iS9SezxlcfT/UoFj0z8eg24q8zumURwutH7h7QU=;
        b=CIoM6EN2Qi0Dp6beh7F2Zj4HqmpeT1MMmpbnuBpGdgaCRe+z1eVW9oyqvmKjYMQ8Gs
         iKPVnQz1bckgFaMBaACOpF8alb0zwfzoTJvYJx7KWI/w6Y64BcgM3QXC8bnZPo9GoKYD
         PumfMnl6IrbrLY9yEmRKdm1Ig6T0Quie2wQuAWlKAJ0PaQmgP8wj+dPRo7PMz9IbEaqB
         BgnM0vO3oEzuWpS7bIn6TGSnBDVFRAfO4jVUvhrOUTEYwvlK2s/m+miNvF93c+CY122N
         6nmZYZqGyMLrB/R6/eL9ZIR1LirhtyNG+nyCw9mDE1R4B/4CFs9MwXt8+ET4pUf+byzP
         vc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQ09iS9SezxlcfT/UoFj0z8eg24q8zumURwutH7h7QU=;
        b=EugptXeEAkJue3efcd7bwVAq1W85PLonX7U0Nwhwl32kWADd7q7r8/0ZSrw12xQrAC
         X/Z1oWaAjQb32aTUg0wbUJ637kCmOKl9tFoHvVrklW+rXIAM86U6c67tiARyCQmqJ+8m
         mS9mXCbgWnpWyjxHIYnHcr2cFgwFVvSYbXYpheJab6HVT7X1ZmS6LvOrs72J67Id+CH5
         yREpryFEKyWMW/0MEBw9i0bP1IPjumlWRPVHNN/a+Ne57hKMnRynblc6YCXiwA2yiapp
         h5LVaID/j71XYF9aGgjDXtVSosWNrgPLRqmIyjEowdZdAb/4SMsXxIX1R5cjaUMF+AfY
         aKKA==
X-Gm-Message-State: APjAAAXj787zA4kpiVLkjKUYQdSeHEYfk/RudIcxhmwpEaUyO8x4Uufj
        fPH2p0i+8iUJdz45obuP+WI=
X-Google-Smtp-Source: APXvYqzFwMueEwh/Nt48a3Ir6fY3fjCsdYkJYSpfkKDO3MbZZjc8Mxd7wBpAklY3+xGqGUNmVNB+zA==
X-Received: by 2002:a2e:29dd:: with SMTP id p90mr22349036ljp.26.1571833310493;
        Wed, 23 Oct 2019 05:21:50 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g26sm10453566lje.80.2019.10.23.05.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:21:49 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark: When running as Root save all config settings in /root/
Date:   Wed, 23 Oct 2019 15:21:45 +0300
Message-Id: <20191023122145.14314-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191023122145.14314-1-y.karadz@gmail.com>
References: <20191023122145.14314-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If KernelShark is running with Root privileges, do not save the settings
in the standard location. Otherwise the configuration files will be owned
by Root and later the normal user will have no access to those files.

The patch seems to do the right thing in all cases that I tested, however
there is definitely something that I do not understand. QDir::homePath()
always returns the path to the home of the normal user, even if I build
and run kernelshark as root (sudo -s).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 3402764..bd6c338 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -69,7 +69,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _contentsAction("Contents", this),
   _bugReportAction("Report a bug", this),
   _deselectShortcut(this),
-  _settings("kernelshark.org", "Kernel Shark") // organization , application
+  _settings(_getCacheDir() + "/setting.ini", QSettings::IniFormat)
 {
 	setWindowTitle("Kernel Shark");
 	_createActions();
@@ -431,6 +431,9 @@ QString KsMainWindow::_getCacheDir()
 		dir = QStandardPaths::writableLocation(appCachePath);
 		dir += "/kernelshark";
 
+		if (geteuid() == 0)
+			dir.replace(QDir::homePath(), "/root");
+
 		if (!QDir(dir).exists())
 			lamMakePath(false);
 	}
-- 
2.20.1

