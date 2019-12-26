Return-Path: <SRS0=JgPP=2Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB23C2D0C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Dec 2019 22:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F0D020838
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Dec 2019 22:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipGfi56K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfLZWth (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 17:49:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34846 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZWth (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 17:49:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so24682075wro.2;
        Thu, 26 Dec 2019 14:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5at3WDW9T3iSZqzougKhzLZuYlvgfZx4445eolFcJMI=;
        b=ipGfi56KfMvoFQFqCzMpqOAD/XFQyfyWh6PwflY6SeW1Kp4pBeifjBPGnyhZr7em0a
         44rtzBpvmUIjtXe3dEPYYVxzevMSCyPDtbHhKdKNKutRb6LGgwELS2LKxstBAipM9+o0
         bb5NUwZCgVjk+jIglRLrU/DfLF83RIDtzCWmeWCs7SF5Yvjx3iAVMtXZfjTf+S3E9naI
         p6zySolnZ55ISKQxUWPJBOQuRqnOyvxZrvonK8GHwNWl2CAaCJ32oe6B9dxoVBYmpi4i
         gdzTQbGpXNLom2c2zvELUIs5vfnCD+GzQSVHsrm575Ftn1PY92DdJqp6917zegQbVd9Q
         6r3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5at3WDW9T3iSZqzougKhzLZuYlvgfZx4445eolFcJMI=;
        b=gfH9ai8FqolR9MID+9IARjgx+SOXK28okUO5+6vLPQPtUY/awtij7kMBXD9peRh3q9
         AEwiZtbG8fCa1SnACpZATs54CpTDtLp1gnfYF/t5Zn5MJp2tjkBwe4NGcodOqZy/NNbR
         wkvRqUS98YAoAW/tZy7aTQPfQGA50tF0MNfty5GXJjm35haoJp+KvbyGx9+PMdDzC/bH
         HjlerCONe+Z9o1m8v/pjA0/4YSBJd2oD9sRbZv/9uxJ3X2TTNJHrUd4O77j1918mBEtv
         2vHPD4Y8vwcMIg7H4nhVyIM402BCkfZCtMltS8dIKD5/8JwuWf/CwbfObbXxRA/6CnjF
         oOUg==
X-Gm-Message-State: APjAAAWOfMwWa+IDRkJ5+Qfa0i7z4bQlJTV6i6xDrHXYELpL3HnbafiA
        10Kp/pw/8o4+bBBF4n/LolZpEEFdaGM=
X-Google-Smtp-Source: APXvYqxeBLAwP4rgKmx8JG2+a1+YPrmS8JVJ7nqHuki6OV9hCVnrREV1PwVi0u6ZSOwxiSaQVXrj+g==
X-Received: by 2002:a5d:68cf:: with SMTP id p15mr47548774wrw.31.1577400575245;
        Thu, 26 Dec 2019 14:49:35 -0800 (PST)
Received: from debian.office.codethink.co.uk. ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id t81sm9541127wmg.6.2019.12.26.14.49.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Dec 2019 14:49:34 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     rostedt@goodmis.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        arnaldo.melo@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtraceevent: Add dependency on libdl
Date:   Thu, 26 Dec 2019 22:49:31 +0000
Message-Id: <20191226224931.3458-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

event-plugin.c is calling dl_*() functions but it is not linked with
libdl. As a result when we use ldd on the generated libtraceevent.so
file, it does not list libdl as one of its dependencies.
Add -ldl explicitly as done in tools/lib/lockdep.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index c874c017c636..0d0575981cc7 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -143,7 +143,7 @@ $(TE_IN): force
 	$(Q)$(MAKE) $(build)=libtraceevent
 
 $(OUTPUT)libtraceevent.so.$(EVENT_PARSE_VERSION): $(TE_IN)
-	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@
+	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -ldl -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@
 	@ln -sf $(@F) $(OUTPUT)libtraceevent.so
 	@ln -sf $(@F) $(OUTPUT)libtraceevent.so.$(EP_VERSION)
 
-- 
2.11.0

