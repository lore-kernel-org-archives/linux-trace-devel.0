Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE46C10F00
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B56532133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbfDBNpu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:45:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50557 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732137AbfDBNpt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id z11so3523021wmi.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebx/6PKF298evGUiQpbCn8tno+rQu+UODpYT6m+zsg0=;
        b=offl6v0zIzzjiDG0sOSSeMF24342htjHKhf4goJFIBKFFMR6BnzVk918XlBZPr1rr9
         sEceoScNtjCqRl1Z62Y3rly+ks3wqJdmIqPjo5h7el2ShLET6QiEo1kmeUH6stTeIwGp
         Jof5XiR79pWQH09NOBI9yVAdv5Lf4K0oE8T1Jyo7Q5e1M57Hn/GzW1xy7HM0wJP9EQiL
         LX27o81AwAncWeDmJKhFOiv33n1WWcnPLSYoj6i6p+crEEl8ni2IDV0IZSDz0UuesyTf
         1kSTpVB9sVjosrqD7xlJG61WnjAiNWP6kR0waQl7Hz00kbOH6dxkNwZl94q4oDKB2Ncg
         QVVw==
X-Gm-Message-State: APjAAAV/J+sqZs/zKNLvdDnbiSaoljA2D/viBDGt9pjVbPQF427mXDiA
        zt2GePALst0BssDfqURqMA==
X-Google-Smtp-Source: APXvYqz73Cxj3AvLoD13HTwfd511uewhXegyxkSyLCl4SfAZ5GWsXAodZ1W3cA/tnRv32YDxG99I3w==
X-Received: by 2002:a1c:6341:: with SMTP id x62mr3369435wmb.11.1554212747756;
        Tue, 02 Apr 2019 06:45:47 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:47 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 02/11] trace-cmd: Detect if vsockets are available
Date:   Tue,  2 Apr 2019 16:45:31 +0300
Message-Id: <20190402134540.32321-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134540.32321-1-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
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
index b780718..99e4f39 100644
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

