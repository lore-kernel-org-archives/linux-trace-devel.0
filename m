Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EED4C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0472087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfCHNhD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44793 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNhC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id w2so21388042wrt.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h9MiVW5SrsZXPilLHLFVo9fbjYkliDvYY0uGLBPbjk0=;
        b=WvghQ/GjYhPa20IcDHIfq0uLLILZRBJ6oS6/J8E5dUn24VFG85VnqTGKWlmPpuwcaW
         uCul1YNgmjZGDpedVMG+NJFyv5bbK+YNw+eWgCaHMpu4H9eTOfuqQofPXNoVVdLS9Bp9
         0nit036rd2LYGo6jXG3cvqWf2OpGm7M6HGyM0Z60osfa0kWDiNNqngmMpyIUAXYO6okx
         s9SNFrDs+8vvursV3jc8CYI679GVJSWma6Cw6elllMUes/V12iH6/t6xWe6UoMTvbOjS
         1cilWZ54oRuPAVQi8R6FrmdeOz2CMCcCX2otM1zqwL4JyUXXR9onzuo2c4jascob0o6t
         2mUA==
X-Gm-Message-State: APjAAAVZqX5iVmqk4JkgeHHOxeYrVkzKl42+Bh5ullKQRJ8ZbOkPObpa
        201wSv/2iwfeLiaBq25xI2M=
X-Google-Smtp-Source: APXvYqytR2UYZBoe/DMfmfHHpDPXYS/bqmQlCyh4iV6aVuDh8XtPY+dMImPhqsTR1xZ+oETf75sgNw==
X-Received: by 2002:adf:edd1:: with SMTP id v17mr11103648wro.300.1552052221092;
        Fri, 08 Mar 2019 05:37:01 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:00 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/46] tools/lib/traceevent: libtraceevent Makefile "help" target
Date:   Fri,  8 Mar 2019 15:36:12 +0200
Message-Id: <20190308133654.21264-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch adds a new target to the traceevent Makefile - "help".
"make help" prints a description of all targets, supported by
the Makefile.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3764e003d1cc..0853861d0cd2 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -326,6 +326,21 @@ doc-install:
 doc-uninstall:
 	$(call descend,Documentation,uninstall)
 
+help:
+	@echo 'Possible targets:'
+	@echo''
+	@echo '  all                 - default, compile the library and the'\
+	 			      'plugins'
+	@echo '  plugins             - compile the plugins'
+	@echo '  install             - install the library, the plugins,'\
+					'the header and pkgconfig files'
+	@echo '  clean               - clean the library and the plugins object files'
+	@echo '  doc                 - compile the documentation files - man'\
+					'and html pages, in the Documentation directory'
+	@echo '  doc-clean           - clean the documentation files'
+	@echo '  doc-install         - install the man pages'
+	@echo '  doc-uninstall       - uninstall the man pages'
+	@echo''
 PHONY += force plugins
 force:
 
-- 
2.20.1

