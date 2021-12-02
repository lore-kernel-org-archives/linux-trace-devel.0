Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4046C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346948AbhLBMef (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbhLBMef (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:34:35 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11E8C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:31:12 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z5so50346407edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CyGhK1rKr7dRVG5bk87ua4bXrNSMqVKfo5ItuyT1ffc=;
        b=fgB1QWhELyd46Dv3li9zVgRMsRm2EximMru6icDd1dUzOm3q1AVKp1i/3PnwYJLRzC
         Rr1qTQ//r+ViExf35rYfwfqXk5LJaQ7QXNZnYZbH3OPK0NR2rEua0/AhMhANH0o6tbSy
         z31dyzHEKfWfTjKdXQtCx/SvXjFQ4l+iEVRa6kGIrNvwBDUbgEzLtpdEfshDNdteIM56
         OZXZVosPw6mLxQXQTWGRPNCU+Z9UkUdyhKTiIoehOGv6nARI7CIwbeaV0kjCXgfRE9f7
         DEl+JFeBg1E4x37f1ASfuWKu+7WnOcCFMJXYPeBDu1AxcRqyt04+bx7A9TNalQFElAcS
         rYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyGhK1rKr7dRVG5bk87ua4bXrNSMqVKfo5ItuyT1ffc=;
        b=VKfaFAtyIZogUaq+R9oRM56asKOpbXyijJ79Q8tEHCda2EJxaiEG9Yox3v17JvzwDo
         RuJy/px1osg84msfClAAQ1sQ0Wj7B+wj0aMGmkO+NIZt1eSG78HkaZBc2QYu0wLzqOlR
         aeceEyNgTAAkZpaJf+bw8baoZnG+vpsvzHhGPbRboVyHbkPbktPZSQLJFZJI9rAB8o+X
         E6dvuJCS1bb6I6xzxz/wlQbxb2JAjv6s6OWnntbLN3LVgp0EoM2nVYwjbS3tbrOQGUOY
         xr89mibf9oVX8AyOJsImskjfsycJk49aoUwv3yx4ae8Q8Ufd6Ko0hbAk8QccHSgHvmFs
         PSPQ==
X-Gm-Message-State: AOAM533EAiGN8AlW4XnZNyyfhn47r1jy/Q0BzcZfP3UCr80m50FjiTmG
        oh7/3kQSEVTJR9A266plJT10unEOOB8Row==
X-Google-Smtp-Source: ABdhPJxAlo2zRs+8gzLXUALeRURV01+aferc9Naas7LymQyB0LWBMbo8aDrnJWA8xx6++xXOGXrWFg==
X-Received: by 2002:a17:906:b51:: with SMTP id v17mr15459499ejg.262.1638448271497;
        Thu, 02 Dec 2021 04:31:11 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b14sm2120394edw.6.2021.12.02.04.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:31:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 3/4] tarce-cmd: Update record man page
Date:   Thu,  2 Dec 2021 14:31:05 +0200
Message-Id: <20211202123106.44245-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202123106.44245-1-tz.stoyanov@gmail.com>
References: <20211202123106.44245-1-tz.stoyanov@gmail.com>
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
2.33.1

