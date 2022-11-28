Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0682C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Nov 2022 13:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiK1NY0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 08:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiK1NYZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 08:24:25 -0500
X-Greylist: delayed 180 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 05:24:24 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C263CE
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 05:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669641676;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Op+Nt0BUOanvcU64ZoT1WHx7680hKcqnqoppjo0UiuQ=;
    b=O/avQ80YHRDTNaqSspOUpaiJcZ8jL6Dv8Hz/RIP3Aipm5QNMx6hI3wK0MmTd8/abZt
    Jolib0HksG/UpvaF1z5KBAwQr/OtDpBDB4Smi/BMnxGI0+xv3TlR3yWMl0v8C+ZzdABc
    IKCBUsm+f1IVa/7kp4kn99ETQmciWY3sBE1Uy/jurmfNxOFUXXC0CGBc0cf08DPgyMT6
    gH4LjxwfKJo/Y/KrEK8TBdBMCZEFTYAH2XZ22hK8v1KcPYfZqzeP2RKfm8HSTvohyxIH
    FyuF8y5h6ccCgr5YOFaLCPkvLtoEIfry2npXY5DbCOpFv/fkBsQaFaYvcyn/fHu6MZQk
    L4XQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD2QzemV2tdlNlNRZBXiUw="
X-RZG-CLASS-ID: mo00
Received: from blinux.micron.com
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyASDLG44E
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 28 Nov 2022 14:21:16 +0100 (CET)
From:   Bean Huo <beanhuo@iokpp.de>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org,
        tz.stoyanov@gmail.com
Cc:     Bean Huo <beanhuo@micron.com>
Subject: [PATCH] libtracefs: Fix wrong return value in tracefs_tracing_dir_is_mounted()
Date:   Mon, 28 Nov 2022 14:21:06 +0100
Message-Id: <20221128132106.291101-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

If it eventually mounts successfully, it should return 1 instead of
0, otherwise it will make the caller's verification logic more complicated

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 src/tracefs-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 777912e..5d6e977 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -188,7 +188,7 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
 		return -1;
 	if (path)
 		*path = dir;
-	return 0;
+	return 1;
 }
 
 /**
-- 
2.25.1

