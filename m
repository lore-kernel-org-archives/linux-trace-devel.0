Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FBBC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A932080A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393660AbfBNONv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:13:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33561 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387589AbfBNONv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:13:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so6690228wrw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:13:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ajXfUh/mnU+wtU0V6S7mrCQeLCbVutVc/GYt5XQFIvY=;
        b=PXfDbrlhpMV4wek8uyT3xe9kBCUBc7S5dQiAaA2ZP0W3KrdompXczXZ72bwJf5GLt5
         FjkxGqVUARS/ti3rUnaVgcvZTfy9wNAEsZQ9dAPyWvPCbieurN0pqh3ogdKvCgr0Z7LB
         DiHzjqXImEP29wLzqj+QgA7+T9y5Ati60xe+Rm1tYh6hqE/eD/xpbOwI6LiMop+1+A0f
         60gOMlFwrabA3TX3DBZPwho9gPR/No10Q9ngdvesEm2juoKaxhT4fvjp8AflcDZYnewn
         2l8E1dKlsIZiNNsQ0M/kQjbshPUnfZqbUGMvJh7fzsOAbeV6hpwZGdB35BU+w0bS3r/M
         VQqw==
X-Gm-Message-State: AHQUAuYWwVSOjsX2kcrbhWyoL+9xYTcs0EO9prZdJpOvjjgQa87vhgQy
        btTWX9kYdFfEgZ9aCxj3XA==
X-Google-Smtp-Source: AHgI3IbcKzEC/Nq9A8Im1Ldvhquiuz86GEjOqJe6zhYI8Jz2158XNfBkCnf79zZJE3MqFfN2ZoPHkA==
X-Received: by 2002:a5d:6a52:: with SMTP id t18mr3169258wrw.131.1550153630023;
        Thu, 14 Feb 2019 06:13:50 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.13.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:13:49 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 01/11] trace-cmd: Detect if vsockets are available
Date:   Thu, 14 Feb 2019 16:13:25 +0200
Message-Id: <20190214141335.28144-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Detect and define VSOCK if vsockets are available on the system.
This macro is used to disable VM remote tracing features on older kernels.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index f0f7e92..ce16b83 100644
--- a/Makefile
+++ b/Makefile
@@ -204,6 +204,13 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+VSOCK_DEFINED := $(shell if (echo "\#include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+
+export VSOCK_DEFINED
+ifeq ($(VSOCK_DEFINED), 1)
+CFLAGS += -DVSOCK
+endif
+
 export CFLAGS
 export INCLUDES
 
-- 
2.19.1

