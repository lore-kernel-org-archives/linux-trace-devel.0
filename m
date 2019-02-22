Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47529C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2076F2075A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbfBVO2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:43 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50926 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfBVO2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id x7so2147046wmj.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=HnuS1SZce2e8Vt/K0vAcYwiqXI05JrMdLulLQvdq6bF0kTywCAH3YKHEiEM25+C3Go
         WPrRkqrkoSfYBNQhHJoPl976b2jZr1Iwikr1DCZSPjNlnAhFzvorUdt0mYWlUP/3iIYo
         QbQA+BaNNNMryutKmfSffouFUAC0yYdx/nYHEUgC03jsqUevhtgybKZhy7F93z355p2W
         2TNWAhSXyr2KaxU+bAaqwT4XCcNsGrW+qo2tpHgbl1jwFn+JcFrLeUR8bTWlVUEN9gVt
         dQlLi/8fUAyss5v+MbKrrFCFZHs3xUigli+HxrF4wGuk8ZrrvtGFcukRW04i/sE2Oo5u
         CTzg==
X-Gm-Message-State: AHQUAuYcF4cbcUr3r7a5XLFU1gHRwhOta5v6tOfh8jl6KUiZMVl3IKMg
        8bY4RRG7UvjibvI4zpzTX0g=
X-Google-Smtp-Source: AHgI3IZ8MG7uey6n/EPR7G2Kg8jIayhMEbgwB9c5XTjxlHrxpHwwAb6t/WOTH92WX7GOi731Kp7QLw==
X-Received: by 2002:a1c:a9d0:: with SMTP id s199mr2642048wme.142.1550845720993;
        Fri, 22 Feb 2019 06:28:40 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:40 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/7] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Fri, 22 Feb 2019 16:28:32 +0200
Message-Id: <20190222142836.12596-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222142836.12596-1-tstoyanov@vmware.com>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The kbuffer_next_event() will return the next event on the sub buffer.
If we pass in the last_record to tracecmd_read_page_record(), it
initializes the sub buffer, and by calling kbuffer_next_event()
(instead of kbuffer_read_event()), the second event on the sub buffer
is returned. This causes the match of the last_record not to match if
the last_record happens to be the first event on the sub buffer.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-input.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index be6720c..0a6e820 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1679,18 +1679,22 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
 			goto out_free;
 		}
 
-		do {
+		ptr = kbuffer_read_event(kbuf, &ts);
+		while (ptr < last_record->data) {
 			ptr = kbuffer_next_event(kbuf, NULL);
 			if (!ptr)
 				break;
-		} while (ptr < last_record->data);
+			if (ptr == last_record->data)
+				break;
+		}
 		if (ptr != last_record->data) {
 			warning("tracecmd_read_page_record: could not find last_record");
 			goto out_free;
 		}
-	}
+		ptr = kbuffer_next_event(kbuf, &ts);
+	} else
+		ptr = kbuffer_read_event(kbuf, &ts);
 
-	ptr = kbuffer_read_event(kbuf, &ts);
 	if (!ptr)
 		goto out_free;
 
-- 
2.20.1

