Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7692C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9253E21872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfCOIiB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:38:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43327 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfCOIiB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:38:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id d17so8606903wre.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=RW/VdN8VbwPgXvXS1va7h044itEA+sOHBwT0Ow300doIMxQfBVMmrRUqReCN7DhTTD
         H+iZ2D7hm/E+kwLykRaQhqQLlDBfEJdrjIqzBcc5sz0UWBUqvOFOr53G8vVd6v5cZKKM
         bVG1xwqld1Blhl77FwPEY6p2UtwY2YWsA2AN5hSAXEvfPqOIDFyC8yECcOBUGNXGdGYt
         di/+IUg0TSf3pTVTdzcqq7ib9whVHf/5VUOZoaZGqyhCGPE0/B5XXYLbZhT7Wyp91jwi
         TiofC851KmzbH3/3IBj4ABJJAM0hrgisKG/GbfoELR2WuQPZnbHAd/qMKVZCmQp1Rg+h
         BdfQ==
X-Gm-Message-State: APjAAAX01Px3Mp+6AezzR+lW5NpO3yv2jVt6ozM9qyvkIwNcggQFVrbd
        4u5AUl1LtYCIe0h5Mi1a9Hs=
X-Google-Smtp-Source: APXvYqzEUYy/ifAr59Sp7HLdQjBi6NoCkypS7UGO2oiiWFp+DrHfi7U1Syj9sC0fAT5ngWrIPhjLbw==
X-Received: by 2002:a5d:6b46:: with SMTP id x6mr1406240wrw.94.1552639079610;
        Fri, 15 Mar 2019 01:37:59 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o5sm979395wmh.12.2019.03.15.01.37.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:37:58 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Fri, 15 Mar 2019 10:37:48 +0200
Message-Id: <20190315083754.27532-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315083754.27532-1-tstoyanov@vmware.com>
References: <20190315083754.27532-1-tstoyanov@vmware.com>
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

