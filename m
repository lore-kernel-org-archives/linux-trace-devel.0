Return-Path: <SRS0=eVTZ=YI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC37C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Oct 2019 10:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D528F217F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Oct 2019 10:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QaJSQE6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfJOK4k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:56:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36753 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfJOK4k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 06:56:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so23296241wrd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2019 03:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nmxqQ4XZYzRNTtjqCtIPXxDgM85R0IH/JzA4pna5m7E=;
        b=QaJSQE6bw7b+KU2vfYV0sd2PdvT1PvgtlScH4KsQGxMw/niJ3yAO2dv0gfk+QwGdpB
         u590Zy2WbeH9YYgQaboothqauwSm6UCHzcE8y0es0VzVVFCKMPrkldQrXNtZNDLF9pdQ
         mNZHxXy5INZyCyb6Vw8/H0FtoWtxyZMQaXIpJxGCxjfpaXE87+AF+W/kbrsd5V7pBcuD
         CF5oOPHa46NezeTo0hof1dtjnNsdLuhX1M/Op5IclOgPk3hX/Ph+ymD0bNiBLOucz0Zx
         tJdnWnXJ+Lh2MACZTARhKe3DTycuwInIa1nBrKBqYa/UPUhdZaGpopyYy2006qfmdj/i
         GejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nmxqQ4XZYzRNTtjqCtIPXxDgM85R0IH/JzA4pna5m7E=;
        b=okxI51k7Jo9ecczBm5QMxArVpvYFaq+X6/IzjHDvZJlgCuE8hESyCzjezm5E6+gibc
         hlc++EfEfRi1dgP/QzUDAbXrxOyPpLlG8c4fty9RP4/z+7fHE+Zt/DHIsmbwIOofWa+Y
         7/8tZYA4pyZskDpi+AfCFIiCXmIeB2a+OR72RSOv3JxDs9ETRVRfPSUg6WO5XyYgIK+S
         Y8NM7G7KafbTTesbedFxY+vQiwcNg77yu4zivVKjyUhqZ0GWRHbYn1sJS1QbN/iV6hou
         APAZSaBLdoWuZclJjp2XLSbrX40ceYen8SruoKDGibix7GJojn08uuSRC5dGa05GOR8T
         2ATg==
X-Gm-Message-State: APjAAAVoDxBJLpf2gEx74QQEVprtuIWjbSZ9vBVxJMiKxH5xqHr7guhs
        +msin7qu/HKCfSH6cjTr92qujkKO
X-Google-Smtp-Source: APXvYqwYhbxeHiNoh7H/1InZCt9JZykk/rZqYDNEGDlbe7fSxcpyunDa5yvCWYH9pdodw4yWj3+ssg==
X-Received: by 2002:a5d:6189:: with SMTP id j9mr20560889wru.21.1571136998228;
        Tue, 15 Oct 2019 03:56:38 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v6sm42726305wma.24.2019.10.15.03.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 03:56:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Fix segmentation fault in tracecmd_read_at() in specific use case
Date:   Tue, 15 Oct 2019 13:56:36 +0300
Message-Id: <20191015105636.19254-1-tz.stoyanov@gmail.com>
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
and this page is still not loaded. The problem can be observed randomly -
there is a sporadic KernelShark crash when loading a file, browsing and
zooming events.

https://bugzilla.kernel.org/show_bug.cgi?id=205165
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[ 
  v2 changes:
   - Moved the check for NULL page after the loop, as Steven Rostedt
     suggested.  
]
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6102eb3..43bdf6a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1282,7 +1282,7 @@ tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
 			break;
 	}
 
-	if (cpu < handle->cpus) {
+	if (cpu < handle->cpus && handle->cpu_data[cpu].page) {
 		if (pcpu)
 			*pcpu = cpu;
 		return read_event(handle, offset, cpu);
-- 
2.21.0

