Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BD4C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4CF2206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390634AbfAPNnW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:43:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43446 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733175AbfAPNnW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 08:43:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so6946435wrs.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 05:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qAVEmCrwQ7LbzgWl1iLQa+qb+EmOa9tBt+vB6/lwOjI=;
        b=s0ItrsBx7rAOCBngxtaO4giAPjS+q4fw0zyyWqsWxZjj5WpcjE9lly3c+F5IIDlKsC
         nJSHDdn5Op2tBIanFGZhnOv1Fga11Dc1krtFcwyto2L/EWiMadCLEBGYYDIo2Zr6nZ4k
         pQmtO86aebyvn8BFKQZMavc3+MZkSwgeSwCN2apKHMdOrNwkOwLyUG7aneUz0sy4jy52
         KDYst00EpdhHv3RH4rChWOMHZaIkjb8Xtg6iD4AI9RVg5abLTd0k+tF/bOQ8sw6ZqwlN
         u8BsdhCkMjOm5f/cEwUn/N8778ZxP1rCAqLLg2oXuw4/0MG3LjupAV1tJOJf7+M6FXmK
         8QsQ==
X-Gm-Message-State: AJcUukdqH64ZKEwaMWaV1+yppqHvYkOqrVOQljAn+2lXaMJV0aOpRVP7
        bu6Xpi/mD3eMxqTOUltCENcobPxySY1l
X-Google-Smtp-Source: ALg8bN5T1ShX3WzHPMsvAUP1GWnxAc2rjfglmsD13w6XRvdY6yhgcDcA1IeaNcW/Qx5e/TOtGsLUJg==
X-Received: by 2002:adf:b307:: with SMTP id j7mr8146129wrd.46.1547646200335;
        Wed, 16 Jan 2019 05:43:20 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm34636460wme.2.2019.01.16.05.43.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 05:43:19 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 2/8] trace-cmd: Detect if vsock sockets are available
Date:   Wed, 16 Jan 2019 15:43:01 +0200
Message-Id: <20190116134307.4185-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190116134307.4185-1-kaslevs@vmware.com>
References: <20190116134307.4185-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Detect and define VSOCK if vsock sockets are available on the system.
This macro is used to disable VM remote tracing features on older kernels.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index 27d3683..abc4f0c 100644
--- a/Makefile
+++ b/Makefile
@@ -205,6 +205,13 @@ CFLAGS ?= -g -Wall
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

