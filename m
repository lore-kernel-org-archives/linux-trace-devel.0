Return-Path: <SRS0=hDql=YE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31E5ECE58E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 11:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CBBC2084C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 11:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sf7bho4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfJKLd6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 07:33:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38751 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfJKLd6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 07:33:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id y18so2063088wrn.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2019 04:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gm8wmexRP53SUBkaHahaaST/NA+TrutyjfB0sn4j31Q=;
        b=Sf7bho4dSyJMFlNh4o72qp2Ds/RVEjRBJrr7IX/NTKm/b+Z9pxF5sxF8ZMhlUxj8mF
         usvZGs7Fi0Z7tR3tHHnilIJcLUC3n1XPuclO3tuMSGwGDDSA+wYleW12g7jU6ShtODsC
         ynSpvxdrSigEbzzOm+88F6NzO6LPdO1Pzgi7Boq3Bi4D19ytk1YFqn3H+pSqaTkoPyOp
         TiNeH3UUY1+g4ZatvfrBHAHrFG3XnjoIw4nw3+k83HrX8RZ0ENaQTmuN++NEcaZRgyFi
         PNOZiZUwQeuHk88ZTIkRhaasCJ3VIlnFWXxYpUC28BYaJkyVuJ8VhzyBI8fRep5fPbJA
         gkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gm8wmexRP53SUBkaHahaaST/NA+TrutyjfB0sn4j31Q=;
        b=jeh2blkeB9mOX9W1+/xh04rAZeH+3t6Xyv2mh/2Z3UIDM/faSQivoPE4rbqRT/3kJ5
         lKUQva86jrsbgFBJbWUtaMvcViUZtxjOzqhx0XGSEaXr4Z5oJdHneyLhqTIl8VwjqGmh
         0hhNN2gQTolsRlfBgHnWM5dag34cKQlQ3F/d+LUhwls6GMYXm92Ubf2lhgKfrVsvWyfN
         SRMzdIhNapKOUrXUnbZgBEeVFsHpnkheNK/5i5Z/VnMivXmQrIb2xNU3JI0oPVjznfTu
         ZlkBigx7Z69apIjlqajVwYfhYOoC72pTgyyex+fCWLmljFc3AFz9eaWZBlnuzme8d31O
         fFJg==
X-Gm-Message-State: APjAAAX5//Lmap6lFutELIvxU+yRV+VnjRW8ijecGXwKLMKgB4t6u/qp
        tnfaRBtZbtjHJlAbRGxUfT0=
X-Google-Smtp-Source: APXvYqxpY8tlD6OgMFYhw2APFCFc5zysh1IuAZt8VcnYZ6G/BdlZLkhB9fhlPkv/jcJvaLub/dCbKQ==
X-Received: by 2002:adf:ebd1:: with SMTP id v17mr4559023wrn.204.1570793635190;
        Fri, 11 Oct 2019 04:33:55 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id i7sm11566364wrm.87.2019.10.11.04.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 04:33:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix segmentation fault in tracecmd_read_at() in specific use case
Date:   Fri, 11 Oct 2019 14:33:53 +0300
Message-Id: <20191011113353.11652-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is a segmentation fault in update_page_info() when the requested page
is not loaded, handle->cpu_data[cpu].page is NULL. The problematic flow starts
from tracecmd_read_at() API, when reading offset in the first page (less than 4K),
and this page is still not loaded yet. The problem can be observed randomly -
there is a sporadic KernelShark crash when loading a file, browsing and
zooming events.

https://bugzilla.kernel.org/show_bug.cgi?id=205165
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6102eb3..da77418 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1278,7 +1278,8 @@ tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
 	/* check to see if we have this page already */
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
 		if (handle->cpu_data[cpu].offset == page_offset &&
-		    handle->cpu_data[cpu].file_size)
+		    handle->cpu_data[cpu].file_size &&
+		    handle->cpu_data[cpu].page)
 			break;
 	}
 
-- 
2.21.0

