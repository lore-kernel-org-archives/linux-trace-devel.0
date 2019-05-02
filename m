Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDB9C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79032075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfEBMo0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:44:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34792 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEBMo0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:44:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id e9so3175263wrc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yJ3LU9b3ycGuq/+Hd+KuAKwFjTZs+PcwurjzAx/a/RI=;
        b=f5MpclIgxLehc6Fjk+i2kSyMUw44tsqgNYrjWk3XL6hrLZqwtc4J6y0rj40jrdaHgo
         bGGjT/gfdzioP3/TbqSdzgq2PMqkyrpkaKLlc1L/1tw9HP9FJ3OOes/3CelplcMMscVI
         T/0NNbvn+oODOi4Bylv2FA6dIJEJKF+aZYQCH6r+MQsScwY/6P3917lrrvP7T6hn9Jlx
         nWckCFEXTNEU/tA1IoIQOIE6fzosLQqtXzmp875IUAbjHX2yaKW7SXBXDKeiKKL38q1c
         oBVNAyUGiTYgQE8eshiMBYHXt7FhkyCo0QrwlkDQPplckbwZQQKlgvDZa/x74hbaHV9C
         ESnw==
X-Gm-Message-State: APjAAAWzEEW+PDLrAMtWBj9ewk81hOYoa/Mu9sM3N/TIQBF5xETGkO8T
        I0Syddn/eB0ACPfUFn0wvOg=
X-Google-Smtp-Source: APXvYqzfcnWAdaqazgqUaInHdyJK36XvbPFtejOi7DiSZVwVb93yBuRZgoZZ/+M8BD6wBpjW/VehHw==
X-Received: by 2002:a5d:55cc:: with SMTP id i12mr2634005wrw.179.1556800832057;
        Thu, 02 May 2019 05:40:32 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:31 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v2 1/8] kernel-shark: Add INSTALL PREFIX to the Cmake-generated header file.
Date:   Thu,  2 May 2019 15:40:02 +0300
Message-Id: <20190502124009.32208-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To be used to check if the aplication runs from its installation location.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
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

