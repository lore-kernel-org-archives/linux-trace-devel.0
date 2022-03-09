Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A47C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Mar 2022 05:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiCIFqD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiCIFqC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 00:46:02 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4405D15B3C1
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Mar 2022 21:45:03 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y12so1428307edt.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Mar 2022 21:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Hn2iAqmDY29jY2vmS6vO7plTCrmxpERj7MhHOHad00=;
        b=bflv0Kt1lKmund4vAZ679Ve+z8pqBLRmjomu/G4NIUi6zobPod/c6A5vjNCroKo2UY
         2+daw/DNO5/runNVPwgd6YDs0atq2eiXaltkSVadDpy0opd4/9hjsORn6U+fCdHGaHnL
         U5//2t4gakUljf2eOKymBWwzaAf8tpaDzD2tqZKakY/h8sB6fuXuSxVruwMIjzVIUmZr
         MhfYjain2eTyJbiD3utNXhhBPIrKiXLd+/EU7cpxOu9pyw+ONoYpfsA4tjNs5IfdgRNs
         54Wv9321GF4XuKASdI868jQqXIplWqsIVI0N3WWN4LV0snTkNo+b2gNpsk9T/pHsLhq8
         Emnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Hn2iAqmDY29jY2vmS6vO7plTCrmxpERj7MhHOHad00=;
        b=1DJyoEYJwDNIIW0XqWcd3NGBp3r9+6AlZILOJRCmdIIu826uxN1QWNTOLnYb1rOzSE
         Crhp8GS2E4aBAIzrVNSfpsHgKdamW2Z1yvR5IsewnWYJr5UMqAuXuYet/hCZyFcfnbAr
         xcawlgfvRKz8f3sLmrF8o7IZ7xzsq5793WMvKYX78pqOiKDq7Jc16kAVVxN1/0VucF//
         pfs1zf4M01fVKWh3X4rTZhnraFo0zfL2ZdxeT5xNE8yS/eUfPr9kQCuqZlpAXk5HWB1Z
         nqcZc6CIXY0MUrnA4jkdwF+L8ds93ISask0Jtl0CZ5IrvDL/wJ9k2XEmZMgKec40Kz3l
         L6RA==
X-Gm-Message-State: AOAM531KWSp+UGr8ikKK9QYYKo1ALhCb4spDmqLmUfW/udLxBfJnOjsy
        hLqZmFhhh1UqWFIic9UZiDWq7B1WJ18=
X-Google-Smtp-Source: ABdhPJxBzCBv5tsKgRwHt9J8zUg4cl7CfOtit2hGjOTlr/mMOdtVMnLT2a0RutvW2tSrkNyFrsuPig==
X-Received: by 2002:a05:6402:4406:b0:410:e24f:91fd with SMTP id y6-20020a056402440600b00410e24f91fdmr1281653eda.99.1646804701648;
        Tue, 08 Mar 2022 21:45:01 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7-20020a17090651c700b006db6a03db3dsm296262ejk.121.2022.03.08.21.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 21:45:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Use the new libtracefs API to address all dynamic events
Date:   Wed,  9 Mar 2022 07:44:58 +0200
Message-Id: <20220309054458.636350-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd reset logic clears all dynamically created ftrace events.
The current implementation lists all events that should be cleared.
That logic is fragile, as when a new type of dynamic event is
introduced the logic should be updated. Instead, the newly introduced
libtracefs define should be used: TRACEFS_DYNEVENT_ALL.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9afc1042..8d9cbac2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5262,12 +5262,7 @@ static void clear_all_dynamic_events(void)
 {
 	/* Clear event probes first, as they may be attached to other dynamic event */
 	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
-	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE |
-				     TRACEFS_DYNEVENT_KRETPROBE |
-				     TRACEFS_DYNEVENT_UPROBE |
-				     TRACEFS_DYNEVENT_URETPROBE |
-				     TRACEFS_DYNEVENT_SYNTH,
-				     true);
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true);
 }
 
 static void clear_func_filters(void)
-- 
2.34.1

