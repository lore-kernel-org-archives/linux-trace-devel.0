Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D11FC282DD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF3820685
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfDWN2H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:28:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33998 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfDWN2H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:28:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id c6so14535022wrm.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 06:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wszLKCv0U3ICfQrxFCpczCj5V/Wa3796D+NUgPIEPNI=;
        b=kFExoqHiOakwpyziOO4+FyGQxXIybsZ37s4JyEmylIXul4Kh68c3XknHHPlYbKu0lx
         PFAkL5DsuciKo/Rtf3LiLCYmJDJ249N/lr99Xq+MW6J5kP0zNNhlSth5xH7wtAcUEUA7
         pvnP55bOFrHljXX0iIM851aeUWTNUStM0Is+cZMU7lapZIvpfRKJ7+jftCQs0ADFbMmx
         fvIhVgbriyAmZGc2SQG2NTOWfOzYs0vEOLbcidxLbVCm/dxm3u2wn6dt1TVS3EsOfhSG
         /uIEPJiqrnSGcVcfou8xFWt6C9waj1VsHJv9oX3LGx5lE0a9STIk2BHRLll5NEz3EAZL
         cjcQ==
X-Gm-Message-State: APjAAAWxv3x7bCEG3um6jbD7bH/AgUMBBWfnwH9rbkdYk3hw1dNhjkQf
        uFNWRMkfxAW58+195bKVzA4=
X-Google-Smtp-Source: APXvYqzDm79IyIj6VH1ACVzGGWBFfU2+FiQrIku1IwU9SB7a2VDHHvGnj6oMPjR7xpeY6R1X9Mw9zQ==
X-Received: by 2002:a5d:4e82:: with SMTP id e2mr18009090wru.164.1556026085593;
        Tue, 23 Apr 2019 06:28:05 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w11sm31222231wre.15.2019.04.23.06.28.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 06:28:05 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/5] kernel-shark: Remove the definition of KS_DIR
Date:   Tue, 23 Apr 2019 16:27:40 +0300
Message-Id: <20190423132741.17864-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423132741.17864-1-ykaradzhov@vmware.com>
References: <20190423132741.17864-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KS_DIR is no longer used, so we do not need to define it in the
Cmake-generated header file.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/deff.h.cmake | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index ba211f4..1cf8a80 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -11,9 +11,6 @@
 /** KernelShark Version number. */
 #cmakedefine KS_VERSION_STRING "@KS_VERSION_STRING@"
 
-/** KernelShark source code path. */
-#cmakedefine KS_DIR "@KS_DIR@"
-
 /** KernelShark installation prefix path. */
 #cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
 
-- 
2.20.1

