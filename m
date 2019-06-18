Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6702AC31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408F920B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xv3b1Whq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfFROkL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52960 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFROkK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so3599374wms.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=COOWTVQCpqGdT0L9mfdnyqo+LJmZ13WzicSw1A2mcT0=;
        b=Xv3b1WhqrI9jPo84T2PYFLsvlVdm6rliH9wPkxpvy0gOxUYw908B9P42QPt4zc856r
         xcCPGl7Ek2pp76r8MFaEPJ1v4xTgXwtlyXHxa/v74NHCdByMj3eXW1yq640rnRzsPtVP
         3yuFAJe7RNK+VIxOESHR8kYjoFIh54Mkiy3h217UmdKlgf69ugVYujur2vjrAY1E6B16
         fSXLR254U06kLNJ+SS2bYk+PyE/YPtEJtharg816kStbBdO3AMexAA4OsmnK+GtuanmV
         CO9Es3WS0oY3oUxgQoln85dq573WFFF5K1rdF4cbe/ab2v5UBJW1JXdHjL7Ryf14OYIP
         2pzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=COOWTVQCpqGdT0L9mfdnyqo+LJmZ13WzicSw1A2mcT0=;
        b=qG/9Wc6q12odQju/yZ1NxDL7lHHUP3Yt72gAk2+whxXIV028O8iVSVkFMjgV7wCtm5
         XnmSpMBCb0gq8dqPR79EKMJdfHc9OLRmtOwmV5+82+3H2J2bXB8pnM1RWykOpWnbsGci
         UgKJ2ndutEYSEg1BzvW+08pdzT3Ik6CsBB9nMZoWrGn5/IxiCIvheFK3YlW9rBQKeDt1
         wiF2X4esKaseQEdlC7xcsmkpiydBY2BHU5/edU4MkQngjXt1Te18TpdXdgjAzRtuVm0Q
         zop4jw89Sr83+XRgLbXtGQHMWbKuRC0mVXaCiANCeMI4IbofQRogyAgELz5OkhE1Bo6W
         IquA==
X-Gm-Message-State: APjAAAXMSIt56i8e+zREeDtf+DtoOk70MIsnlZs7UhEkET4s4BU6FQly
        y92bfAQJPm4mTuX1rplPHnCmbfI=
X-Google-Smtp-Source: APXvYqxNDN+N8ashxGlMm5HUlMEYFfSdR5kYDE3DZmuYG8u7zHEBYUyUgh4sQuGhrGXjDBko0B92pQ==
X-Received: by 2002:a1c:10f:: with SMTP id 15mr4078773wmb.142.1560868808892;
        Tue, 18 Jun 2019 07:40:08 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:08 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 02/13] trace-cmd: Detect if vsockets are available
Date:   Tue, 18 Jun 2019 17:39:47 +0300
Message-Id: <20190618143958.2865-3-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
References: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
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
Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index d34c615..ba726ee 100644
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
2.20.1

