Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C12C10F0B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255412133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbfDBNmm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41016 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731866AbfDBNml (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so16723051wrq.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebx/6PKF298evGUiQpbCn8tno+rQu+UODpYT6m+zsg0=;
        b=OkpgJbfIucN/LgxjpchNpiUSfO3b+t3n5tAJ4Ba5pb0iurkRvQNNNEqgIO47I0P07i
         jIM5PVMPSN4db1gXWselJM38OLOcijvxHUZ2jHo4b1mECVPWfUIH4JI4dIb01zpuD2dG
         6pWT7kAxjvwpd5Ltg85teF/DQKY1x7p2sQIDDdvDwnuSFYuEWVRrUiLZ/IG0wetiKrYP
         5JLzQYsrdzpRYXa59NlRwx1gcfFGDhRh4ou5lrr+7V3ADFG9iBfK31NERM5xzJrCXgqq
         9UVX3Jan6K8/iycaNpc9ZTutLXfMIfon+k5K1RLPE4IWf6HEePGjFpy5vsmzlDG0CLJ7
         HU3w==
X-Gm-Message-State: APjAAAURtIAyM5bTHliHNZ4o8OwTkpRBYgNzB/e9Cx+DC9UO2iR5Q5Fz
        G6w8He0LYfrYxa944MOu0A==
X-Google-Smtp-Source: APXvYqy9KO7g3j7ZXX4/UAogLso9BYL6bRgUBSc36UW6Y5/leSFYwLS61UzpAPnPT6g3f+McW1X06w==
X-Received: by 2002:a5d:52cc:: with SMTP id r12mr40492839wrv.163.1554212559988;
        Tue, 02 Apr 2019 06:42:39 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:39 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 02/11] trace-cmd: Detect if vsockets are available
Date:   Tue,  2 Apr 2019 16:42:09 +0300
Message-Id: <20190402134230.30988-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
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

