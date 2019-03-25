Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6EEC10F06
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079412084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfCYOYq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:24:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32865 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbfCYOYq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:24:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id q1so10414864wrp.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=ruwnTp+axRtvEOqrnVMi2c3avfcf220Ry4bs9zzgxK3wDR+EI3CggMfQ6S5PNWB7me
         L1QAVHzO70yB/MUA3V1BzgB66UpKhmxF0BgfIqVyyFOY5wrE3xua6J8eCJssBYef/P9W
         FWI8Y7De+2P7YuYuDDZ6dr1WfTQjjiZ/9PBPPZ6Fw1SwotsUI/uyPtzBQPxw6gGs9Tsc
         mw2qhFZQCwRFV2i/6JMNT1KWYlCRYqWvsU8GrlCoyeX7Gdq9+UNF0rmX9sFGgQ4k3SkC
         arecBEcn7mRsoJG9GuSRP1wGR/0pKdtgqK8pJDwKMSqRFE8K+QKd8Fca7Y23/DYkOxof
         PWMA==
X-Gm-Message-State: APjAAAX7g6+9S8IXF7nkw0x7w7TMGtURS8z4yVoQfMJnf70URqWjNntT
        apQa5v7W2acRWfjSri+wjDrv2ywh
X-Google-Smtp-Source: APXvYqybE7V/XtUchdNRkQjzERfDOHpAp4roXPLcoNeSroP24YMtEQ5DM6Xia0Ybzzx/nxkivnkF0g==
X-Received: by 2002:adf:ce07:: with SMTP id p7mr10638090wrn.148.1553523884810;
        Mon, 25 Mar 2019 07:24:44 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s2sm1293440wmc.7.2019.03.25.07.24.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:24:44 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v9 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Mon, 25 Mar 2019 16:24:33 +0200
Message-Id: <20190325142439.22032-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190325142439.22032-1-tstoyanov@vmware.com>
References: <20190325142439.22032-1-tstoyanov@vmware.com>
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

