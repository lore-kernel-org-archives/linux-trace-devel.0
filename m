Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7467AC10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A17620685
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfDWN2D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:28:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39440 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbfDWN2C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:28:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id a9so2645489wrp.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 06:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TuYWMMZRCJKH6101TCTD2mVPAAihpRZlVB18ai0tumE=;
        b=ZQeojPhPGNSgJyAxOGQy/Sr12EFAYxDi17y8rmrShDlgoOc6+U5ALQ3bNkYLFWCGLt
         O8kVxRsmCNUBgibkULhzPGhmsYkG83Sp2l/N84iQsjDjma6t+eAZvJ38LCsFUrUfHz8B
         5AZ+tmBhEgtV+GGrcxcBNRPv9r18UDhAAYCsWSNb2hMsNE1gcw0v+4XZ0kEpsIjY+wT0
         hj12b99pYPfOpZFpmS9ji/CQx5ryYA7pHccMiNDMvvg2SfMOZCepQ2fOJpaXzQk6aSIi
         dwmQnD56T/RzZ0vM5lM/HBV4g+KWF1QlTgmY2lJct6Fj6fHvYibNVoSzJJdC7m1gnOxY
         5ljg==
X-Gm-Message-State: APjAAAX0xHKXnALDK2ujWdYH9xubf7rl1G+/qCKO2w3FWc1nLACueZLb
        97vdAcXEEx4EB55jVoL/KxORnXwA
X-Google-Smtp-Source: APXvYqydq6RQZdqj1BNbGrEhU1g0D58vvp+2SfrQbYjM3SQxy3bjG1CdxHrvNpUXOLG//lYvIo7YOQ==
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr9314848wrm.263.1556026081193;
        Tue, 23 Apr 2019 06:28:01 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w11sm31222231wre.15.2019.04.23.06.28.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 06:28:00 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/5] kernel-shark: Add INSTALL PREFIX to the Cmake-generated header file.
Date:   Tue, 23 Apr 2019 16:27:37 +0300
Message-Id: <20190423132741.17864-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423132741.17864-1-ykaradzhov@vmware.com>
References: <20190423132741.17864-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To be used to check if the aplication runs from its installation location.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/deff.h.cmake | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index 8041cfc..ba211f4 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -14,6 +14,9 @@
 /** KernelShark source code path. */
 #cmakedefine KS_DIR "@KS_DIR@"
 
+/** KernelShark installation prefix path. */
+#cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
+
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
 
-- 
2.20.1

