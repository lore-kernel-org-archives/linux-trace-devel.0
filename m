Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7918C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71EED20771
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnvwlzH1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgDIOZP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:25:15 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37834 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgDIOZP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 10:25:15 -0400
Received: by mail-lj1-f194.google.com with SMTP id r24so11665942ljd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 07:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LYrAVMXP/h0tyVGztfhUavARvyYl6uAF2lLyj9cwzAU=;
        b=fnvwlzH1XQe4KDZ5DlGcJcZOPG2gt73rRws2G+sYziXc/3GHPzLgEMDK/hNIXuN1nW
         qKhavDogptAxdLgUnsoHrH7bqGJ8zlrmNeN2+dJlDHgWOkIBgBK9yTdsRPNv7Q9+eVQF
         Vdh2ERTDKJn7CQhYoB5sSyJaAErwcJBqx+/lhCUx5mTWkyIg+ls+9FJjlHceMQmpAlHu
         Rty8eAHJp0EJkQMQziYwuVKe8SnRVWugp7yqcVggAGoJIvGMH2LhTMGMosixVBkhM2/e
         Anj+X0cn3G6fyY9x+FC9f56mrDEnqing4scSGQumSs6ZCZLWsWqUEnI42ufNjC9Rf78h
         zz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LYrAVMXP/h0tyVGztfhUavARvyYl6uAF2lLyj9cwzAU=;
        b=dobusV7Nej8UdnhKh/5zqYJBBLvSBBBYtPCIaxrbxd7jkHoGaeph/tNed/vb6RnuPd
         JyLuYDmWHKBwo6X/wPKPeztGv/It7Xh3+x3Jw8+0oKFwkVXwVpKZxAvCiY0JjDFdlDO4
         KD+yVseH0xYU68n/ZGNt7HOclehVEgm5q/Nu+/OR1xvWgB1VTZeWFxUVzwqp9M5ZkTRI
         myp5dKO+/QajwTnvKHOxJ4i375P/rnrFcyoGigBtoqPUpwALG37+W7AYhyaFcgqDus5g
         NUXIBMG14EzXl+vI0dSOKelGkP7f3HvCGGsUnZ0PX49laoP3nW/54J49SoxJ1CsLr82f
         nM6Q==
X-Gm-Message-State: AGi0PuYclL1SeiIbdwYkteOj6dgdjqj/YIFRxmIAcJcFtW3a15Kv444w
        QR2xnPIBgMyne16tFHe1ef4CsPHObsk=
X-Google-Smtp-Source: APiQypI5WAf3bqxVAwuubVqkuEBgA1/YJZHau4IDTDsLd1NWyd0FO8rEXicHPwW6mZnZ8jKUGo12+w==
X-Received: by 2002:a2e:7606:: with SMTP id r6mr37795ljc.118.1586442314404;
        Thu, 09 Apr 2020 07:25:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm181230lfc.72.2020.04.09.07.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:25:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark-2.alpha: Force trace-cmd.h to be used as plain C
Date:   Thu,  9 Apr 2020 17:25:07 +0300
Message-Id: <20200409142511.82228-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

C++ compiler uses name mangling to handle function overloading. As there is no function overloading in C, function names are not mangled. This breaks the linking of C library into C++ binary.
Declare functions from trace-cmd.h as pure C, so the loader will not mangle the names when resolving them.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/plugins/KVMCombo.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index 3ff9ca5..1ae03aa 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -13,7 +13,9 @@
 #include<iostream>
 
 // trace-cmd
+extern "C" {
 #include "trace-cmd/trace-cmd.h"
+}
 
 // KernelShark
 #include "libkshark.h"
-- 
2.25.1

