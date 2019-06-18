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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3A1C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA91921479
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fIA+3wv9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfFROpG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38474 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfFROpG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so3559787wmj.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVphQ4X31C0SFvrwf0AQ8SwPSwp2whzv7Q59vsptiWw=;
        b=fIA+3wv92qC6KaoUTrlB25gctSgC6mZqvq8QpjHtTDYHwGcVpKwsbeyJlJ2lxxHGmX
         mX7Odp2NXbfFJ/crpLxNeROUCLd3f8Mw+GGjROqNyz3JKfkDqtijd7GuIl3vhuxb4LfI
         oNII+wpvMN5cWk2+GfI59xD7FlXua+psqnn9yH88O5ehrcv6zZblepRuYOIZvMlDYay5
         95O1dfASxsGRkg5B9BB8zg+Gn7TK6dlZ3reEZXy0LHMDTyxB8xqjoVPIdjT6dus57N44
         dvqGfXDq4Ni93onDUmV1qYAYdJnp/+6VIoO06cTGk0Pexm9LG5vnyd1N1shiEOuYAJsI
         k51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVphQ4X31C0SFvrwf0AQ8SwPSwp2whzv7Q59vsptiWw=;
        b=GDbdpkUBluBoc+/6jjL5wJjpDzJIN6FWNeP8J955MaVG9xxlCcjYrbhwztZTWdmDuS
         jDsPGFgBf5QzuXoCPwlN3YeylK+dpodH0E0dIuykhxNrHGRnk3Ix5z6z2jPmicyZCNhU
         O1cIMQ3jy8/p2pgSI3eRJh91coioAeXVZhad/r/+JL7Po+d14DPMcc2cUWnReUPY5kqy
         guKuK8r1tUuefvirXuZkYg+LZILWxzcpPEjE3Epugo/zCcB7FKBOK44LpHAU9rbxOdRV
         ehfSvj9AnYIDlhl+CAtT8XOUNsongBIZ3G4up2QbkBLWOXZ23glnuPvcSKMIuEjR/cEk
         gtWA==
X-Gm-Message-State: APjAAAVQkCTFL654CNOXbcQbWv6t8/1bvxOsbtKvpjlOr6S9scIm09D5
        Wu+xmKdq7lPJTHHJ1Kz6GXqqnOc=
X-Google-Smtp-Source: APXvYqyDvV7WkzuonBLQqJN7Pm7WHaT2TfMoqvaXaCQNhjkge+pvt31wjWHrNh0Rz6HyF2lr87glrA==
X-Received: by 2002:a7b:c3d5:: with SMTP id t21mr2601203wmj.87.1560869104286;
        Tue, 18 Jun 2019 07:45:04 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:03 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 02/13] trace-cmd: Detect if vsockets are available
Date:   Tue, 18 Jun 2019 17:44:44 +0300
Message-Id: <20190618144455.3954-3-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
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

