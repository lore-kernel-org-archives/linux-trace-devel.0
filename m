Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B80C169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF18D20869
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfBHNt1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:49:27 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35152 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfBHNt1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 08:49:27 -0500
Received: by mail-wr1-f65.google.com with SMTP id z18so3687098wrh.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 05:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVqANBbnUqsna/+Yf7sqhQIMc9ElEHb2TYLpB8qVIvY=;
        b=XEPONg2r7e2RxK8BvU1lExirhTHuVzUePGDiiG/2SuppZSf5Gqe+IHXAtJHQW1AsDg
         pQq+l3kB7uAPWZbMivGJUiztT9xdL7Ey3bHH8DfqqlTogpxKtEu5cI8Hq+0znRTLRiKV
         Upk8j+D4nTGdab4VDvAof+6m5m//9WK9jpGKh4eAf5a00xvjHNO1yO5QSB4Kch1FjxJT
         FLMDN1h22gmu19Nc6vN/lrvohr5BzbJx5uJI+e1xblMMWl90wS1zl+F+IS74dFYkGgSt
         k8gT7jIl9D8K0r2mdA6/bkCdr8w3ESZP5uJe/j3yLd3ExO9d17eainc0/Ab97QmKTKE+
         xUvw==
X-Gm-Message-State: AHQUAuYYTxIT4o5z8+vaGqc1k3+65gl/nx1KHLBJDkPojkdKmBmwUjcY
        0/oUsocC9B1zc8FrRftgFnw4JJm6
X-Google-Smtp-Source: AHgI3IY+fcflXigpPyf+wmVJ8OZ3mKxvarXZKrZejDPQp8ssdZbCqa8r/8pbW8tMjpW57d79gPruhw==
X-Received: by 2002:adf:9083:: with SMTP id i3mr16535871wri.124.1549633765810;
        Fri, 08 Feb 2019 05:49:25 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a184sm2534796wmh.37.2019.02.08.05.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 05:49:24 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/7] trace-cmd: Fixed logic in tracecmd_read_page_record()
Date:   Fri,  8 Feb 2019 15:49:14 +0200
Message-Id: <20190208134918.5618-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208134918.5618-1-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed the logic in tracecmd_read_page_record() when
searching for the next event in the event from the
ring buffer. In the current logic, in the case when
last_record is not NULL (we are searching for the second one)
the check "if (ptr != last_record->data)" always fails.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-input.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 33ad7d1..5d64ca8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1688,18 +1688,22 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
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

