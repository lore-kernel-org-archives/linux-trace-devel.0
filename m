Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A8FC10F03
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADFD9214AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfDYLFi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:05:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39283 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbfDYLFi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 07:05:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id n25so9937396wmk.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Apr 2019 04:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdXKbGWqMAYQpUILfeeGn2z07RlCeVs6XoT6MgNnKnc=;
        b=b6e/JJqEkES21aoMG0wPFrbDy96ex6zwqNR+/prHktZsQXboxqtgTC0NMMJvMANzni
         v0D4+PUoqojpDHaG7fgFu8vG+LTVYYZq/dDAfN3uADYAwgjyCaC2U/kce6XnY5K1LybW
         pf/paD05xK5RO4I89o3D/L6zldV37LaRxX0bMKMqdYa2RxyJvOv5FF55AkbJO6J4iqBx
         DazRnmqFHull3EGsJpcGF9POaEzV7XVN7DT8h7L+176XE0YQgnC5tsehgTk/6UfkCNW9
         QxpTzzom3wJjokceTMJGa/xlYlv1AmQH5wOjtmnku1zhh7uauQzl+TSrfJHh9lAnwzOU
         TClw==
X-Gm-Message-State: APjAAAXf8QxfF8OJuevlL6Qwnr2nfpz5IMcA1K+LK+dDf3krZYXullgv
        WY7uHc4J0O5rVr1Xbxb6+jXI9ijd
X-Google-Smtp-Source: APXvYqzpRPECNCzxhPoyXSdHrc9+jcax3jZc0WFpfLCgwsKrRt7gCVaDKDBr1Aelh8oZQLXoTPVMBQ==
X-Received: by 2002:a1c:2348:: with SMTP id j69mr3092744wmj.35.1556190336694;
        Thu, 25 Apr 2019 04:05:36 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a6sm23013606wrp.49.2019.04.25.04.05.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 04:05:35 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Thu, 25 Apr 2019 14:05:25 +0300
Message-Id: <20190425110531.8941-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190425110531.8941-1-tstoyanov@vmware.com>
References: <20190425110531.8941-1-tstoyanov@vmware.com>
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
index 6624932..ea11d62 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1695,18 +1695,22 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
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

