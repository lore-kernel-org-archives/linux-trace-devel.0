Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A15EC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1A8621744
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNh3YmyX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgAGREP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:15 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36598 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbgAGREP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:15 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so260503lfe.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pv3cuMzzXHVeSjsF/TYB/L8Bdix1X0f7YCKzRcnr/VE=;
        b=mNh3YmyXMoGySb72RmdoWXVdCO8TkrymHdldnNj15AYR7kgGAMBe04B8Zcda+dN4Y3
         eOntxnQi0UIgAYku9lNor8W7hjjZfd9h/S6TJRUA17YftS1/cDrCe+GzYbIicXpudepD
         eVt71kOFZAiQfZiDjA5ADNQZ19Ykm1+E4g20Q1VtStFi7iFPKf/WSk23CUfZqjDXHXFh
         m8mPYGdJC7UcSz6UOzKoi9Vqk8Ypkuxqf8ytqjS5o6E1Oz/C3MjIJ2amljg8ui9eN66q
         DT4tBh3cDW5Cf5V9qXReUrw3ZHMVBG3+2tErhwzpi3P5w9Vef4sTpJnwSl4PMDjj+7+b
         tOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pv3cuMzzXHVeSjsF/TYB/L8Bdix1X0f7YCKzRcnr/VE=;
        b=PNRfwB5tto33IUuP0p1b1TbaUwfuZoUpPXtf/VYp7Ak68nXX2g1mBVzWcZ7QWC6/Sp
         NxclzYa2mPxxq6T1WXcJuR2JWD9kaCbpjJttWVxPOGrpDZUxsGq+EcHnRP02eAE5rT03
         fnI6MM9NWxe510c+7u4z8AZo7IIaG4UindGui7bWRWNLPZwx+4btWF04CA378HXzUKud
         uXTIdYcsYmy8HZpEEEKA3LPTsy9StgoMmy5sYrGx2Lbg4DneHCf6BqzK15Gfwz4r3qpe
         KbsYRMstrQ/QBxJR76NYBz5nwsd0TqSXeZ0uRf8UARWwhwoqHLhU84QJNCn59dBmac+M
         XlNQ==
X-Gm-Message-State: APjAAAXx3tE4x2EbSljZyIdK1tX/lUxF5beXruNb62lSXYIrUHXUOZdq
        LDYkJq0D8fO47kpD7VUTRzWRgwGd
X-Google-Smtp-Source: APXvYqzwA+wUxwIsvBS5oRgHE+yU5IbczMHTz8m4byeoPgNiegovtdOELVWLuNPmiVuze85vQVxWDg==
X-Received: by 2002:ac2:430d:: with SMTP id l13mr297681lfh.112.1578416653386;
        Tue, 07 Jan 2020 09:04:13 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:04:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 12/12] trace-cruncher: Improve Makefile Provide more robust and better looking build process.
Date:   Tue,  7 Jan 2020 19:03:12 +0200
Message-Id: <20200107170312.27116-13-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9f49184..0acd655 100644
--- a/Makefile
+++ b/Makefile
@@ -4,8 +4,17 @@
 # Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
 #
 
+UID := $(shell id -u)
+
+CYAN	:= '\e[36m'
+PURPLE	:= '\e[35m'
+NC	:= '\e[0m'
+
 all:
+	@ echo ${CYAN}Installing third party:${NC};
 	./install_third_party.sh
+	@ echo
+	@ echo ${CYAN}Buildinging trace-cruncher:${NC};
 	python3 setup.py build
 
 clean:
@@ -13,7 +22,15 @@ clean:
 	rm -f src/datawrapper.c
 
 install:
+	@ echo ${CYAN}Installing trace-cruncher:${NC};
 	python3 setup.py install --record install_manifest.txt
 
 uninstall:
-	xargs rm -v < install_manifest.txt
+	@ if [ $(UID) -ne 0 ]; then \
+	echo ${PURPLE}Permission denied${NC} 1>&2; \
+	else \
+	echo ${CYAN}Uninstalling trace-cruncher:${NC}; \
+	xargs rm -v < install_manifest.txt; \
+	rm -rfv dist tracecruncher.egg-info; \
+	rm -fv install_manifest.txt; \
+	fi
-- 
2.20.1

