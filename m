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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0D4ECE58C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 11:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6DFF2084C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 11:30:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0qCbfmm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfJKLaw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 07:30:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39245 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfJKLaw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 07:30:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so11528381wrj.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2019 04:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yRZQ5nDBjUA0rZ4uVF9Or1nvtD246vYQPcKYHvQfA0A=;
        b=C0qCbfmm0OSIIVBFg1q+pkfmC6hA2xb9bvDjzybXszlf7ND1ApWcMfOd/HgJCOIU7T
         35mZze7iCGCgOdq4b+HAVPG79g17F4dPBEf+OYdlbwJoUzRqHXaqDSS29sX/rQrxIVUj
         Q5tREfafE3f7FH7FCY2vY6WRPJbyt7ZmCKhaCMnKjALWc6cQUYAMpPsHfRmtI5NIHSxB
         5io/WOi/3jvuBMwNmUHEN4fOe5JfMsD15PkqmL9CS/ITZpd8M3KESgRLzH/O/f/iAqTc
         jk2Anqic4FvSIQP/mBjXIQVBs427oOrh3+p0e1rhR65bCtV0DJ0kZAwBTDFJhKDNliKl
         6tCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yRZQ5nDBjUA0rZ4uVF9Or1nvtD246vYQPcKYHvQfA0A=;
        b=HtqvX+xq1sdigbgTotPfnk2wWrzPOUjxk/KsiejmPcGDMS53KswgRV5bWzIdMSguXC
         uPsaC/eRm3Rp5dXaB3cUlKCa5Hm+qIgT7vs3eD+US4WDUgBEsMa7Rg8uJy6M+yrMRtkI
         my5X0UeacB1JVQM2ZvJ8NrvcNgr3qW+JhbQg65v/wn9FdTwfA2eP6S/aaeTfVp326pZB
         SlUzlTAZxWVeNm8RnM70PLCX4PUwdb0K/Q0TDpQ1mRkFYoNkJVeDayaRZnSGuYTTZySp
         FfzGX4haBV6VNn3uywuRnVrbBQOU1gRTVa9woKQ1F2Fz9GT+OpF9lW0dcQLeV2GZ6EJM
         VTdw==
X-Gm-Message-State: APjAAAUHsFHBM6Z3+NhsZC5/qu/aHydap5pysnoOROGE31p3OKUo/zHe
        C/RU8Z0CfZmMgAlpbOwvvqwRCNQ3
X-Google-Smtp-Source: APXvYqy9rK1n9940dySvUPRg/y5bjAcINejJOjHvXdmE/mM/fmNP5LOi2C7zW1nEC6e/IoXUS0laag==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr5197173wrx.133.1570793450211;
        Fri, 11 Oct 2019 04:30:50 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2481600wrw.6.2019.10.11.04.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 04:30:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: Fix segmentation fault in tracecmd_read_at() in specific use case
Date:   Fri, 11 Oct 2019 14:30:47 +0300
Message-Id: <20191011113047.11089-1-tz.stoyanov@gmail.com>
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
and this page is still not loaded. The problem can be observed randomly - there is
a sporadic KernelShark crash when loading a file, browsing and zooming events.

https://bugzilla.kernel.org/show_bug.cgi?id=205165
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 60ee2f7..1ae2ab5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1345,7 +1345,8 @@ tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
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

