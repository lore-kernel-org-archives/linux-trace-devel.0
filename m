Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21A0C282D7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A50CA20811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfBDG67 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:58:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54223 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBDG67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:58:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so11932966wmb.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ajXfUh/mnU+wtU0V6S7mrCQeLCbVutVc/GYt5XQFIvY=;
        b=oy23V0Qt4KBcAlNmg6nrCYOZL8jvX0bY5hISkXGWjbEy3QMRDU3fOl7EhYefQQ039R
         or/FVOamoltsB4b7U85c0iIyLjuEyPwr55eZzVbtODyWoTmxXSPq4lezYsj7qT3v1M9O
         BmofzzZWi5RXJX8E/DX6js1me6skMFIiwJfQ3vuJwmlbP1MiPW6A8ib9wh6zjcdyaCwG
         Mb/DKk+hbuZqKewz8f/RAG4UXFKWkF2qDVU/yQTgLweIeWqrwfzEnP6XLDWCRpoH3vg1
         E5AN5gB1lHKuDhaaFT/qZ+i//7ZqGVJ8T4UZ5dozoHBtaUplls2qQo3dr1tuQnbxVopW
         wMaQ==
X-Gm-Message-State: AHQUAuatHC74qDplw51v3oKRKjf4g+fYGZfQpn4KAZLSHCk8EiFU+0YZ
        P667EHvumcYEXKcRAERFobDYJ7Wo2g==
X-Google-Smtp-Source: AHgI3IYPOm8vecZl19zjLGH8IHngO82TzpJ9bAmTw5AjYquc34tqbg1Lj9gq6RzAlH+Hz5sXYZeSmw==
X-Received: by 2002:a1c:a70a:: with SMTP id q10mr11138259wme.58.1549263537134;
        Sun, 03 Feb 2019 22:58:57 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.58.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:58:56 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 01/11] trace-cmd: Detect if vsockets are available
Date:   Mon,  4 Feb 2019 08:58:38 +0200
Message-Id: <20190204065848.8248-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
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

