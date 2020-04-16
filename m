Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E2BC2BB85
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23EB21924
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smEsBvPU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442696AbgDPQBX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 12:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636473AbgDPQA4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 12:00:56 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289EDC0610D5
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:56 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j3so7933053ljg.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYrAVMXP/h0tyVGztfhUavARvyYl6uAF2lLyj9cwzAU=;
        b=smEsBvPUTIdsdYZoYnheJ71GtOlvNlMKIuzMqmbrWa4Dcvds8Bjs+/RzN7qwKQxD2v
         Eq9winfVRwwjN2MLKogNqCDePs5zjL0M9hak5p8fNZW8uOcDhhaA7cGZy6aGhX7oQ7pw
         QKAhD8TUyVDX7xWeQR/YL7UF+ZyL4xIeG9bCjZS26Lq0A5URy6LufTyMnRqBbIW6zxk9
         ngDiYEC+1rsiqOUqC2wAEtmZIjtQwYImCIuUyYK7hV1ziUaaE1rYxsT6SGvJXBgx0gBR
         BjIrbRzYWx/WgZSaLsu3s2QXOU22zW2Lj7epXDPudH5VgQJBzqDIDZW/uQLZRcQDQvYg
         bv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYrAVMXP/h0tyVGztfhUavARvyYl6uAF2lLyj9cwzAU=;
        b=nYGODH5IjEnkMR8ubloO16nXbuGm05Y09NWexw2AYZZlIaz1WjcTRc3q/5hY46td5X
         1vMnWnY/fWmqN0LYm3NZBD3H9n2tb3xHAVVeeExIDRozUf091ax1nQH23+XdciHgURxW
         ob7DwXXYsrmzwFj3PxiPbprb2yC3MpuK0UAkdz9S9v+0CcISEubWtUmQ4Et8kqJvaREd
         i2eqP9QlU1k+OcUd6cItMiom3wmp3+5/7Tmz9+AioZXw0aFKBVwOdf6i5iDbYk1nJf9h
         PcauNfA/sPssmtPryUe3ohvCBtiZf6FfJiPxdiTqIlEpNtdck0Qw86kRIuOKdAtlcUR5
         6gtg==
X-Gm-Message-State: AGi0Pubi7Om0f7Z/6G1q7+PBLWgAkjP43MpUMvhNa1XQPpJ9F0K5ZC6D
        yF39jzhhA0cEPIPh2FYPwaOlQo/+Eio=
X-Google-Smtp-Source: APiQypIlqnY/2XWFzRfl0hjGKDGwSnMtHwNBECKcl3NenQIBkZH4VwLdbDyLxaMPAZ2KZcIjpIKXLQ==
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr509999ljm.215.1587052854580;
        Thu, 16 Apr 2020 09:00:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u2sm9030413lfk.67.2020.04.16.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:00:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/5] kernel-shark-2.alpha: Force trace-cmd.h to be used as plain C
Date:   Thu, 16 Apr 2020 19:00:46 +0300
Message-Id: <20200416160047.77118-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416160047.77118-1-tz.stoyanov@gmail.com>
References: <20200416160047.77118-1-tz.stoyanov@gmail.com>
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

