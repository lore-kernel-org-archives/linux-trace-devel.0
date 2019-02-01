Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17C7C282DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF6CD2084C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfBANpm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:45:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45781 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfBANpm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 08:45:42 -0500
Received: by mail-wr1-f67.google.com with SMTP id t6so7093844wrr.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Feb 2019 05:45:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVqANBbnUqsna/+Yf7sqhQIMc9ElEHb2TYLpB8qVIvY=;
        b=Xy3h2fAA88Wumx7FMAgi7kyTWl2Uw9b6TohPNPmX4EatudmUn+WN0lrvnllnQPWefN
         By5CFRpWXdQMDAooch2Ma/dF+p7Ln1ON7m4T+aX3N+VBfEYZQnn8K9u+9l36Lje9RJfa
         ISx8oaLw+iJzX01uqZSg7fvsQdKilXhdma264Oo5HOBQNgqibpkGdYdcTshMvdxVN8rq
         TEIzdqQdjcSILe+5eNX4+pIxbHg2+P4idFje8UfZHx4dlWevLAgqmBqs7vfawLfn36gJ
         LoeAAFxP+adGuOhmvNsx0lHl+/4U52ZkW1Nlm56qDfv6yefX0hZBECZPgGZCuDpiHWXw
         CONw==
X-Gm-Message-State: AJcUukeeKzLoi/hXFta2C1/HtvDTJHdHXZKvVJo+R/LRF5mPFHA++7qg
        FZoJQlRHfLZ63eIYoz8ySFk=
X-Google-Smtp-Source: ALg8bN5yfmcfXxF8bh47M+C/B+HjVr4CcsJVW2mNUMHRmcpQ+bcrx+SpdoqU6fuRvYtlcfM8Smw2Xw==
X-Received: by 2002:adf:d112:: with SMTP id a18mr40519565wri.17.1549028740612;
        Fri, 01 Feb 2019 05:45:40 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v26sm1468732wrv.78.2019.02.01.05.45.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 05:45:39 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/6] trace-cmd: Fixed logic in tracecmd_read_page_record()
Date:   Fri,  1 Feb 2019 15:45:32 +0200
Message-Id: <20190201134535.2979-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201134535.2979-1-tstoyanov@vmware.com>
References: <20190201134535.2979-1-tstoyanov@vmware.com>
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

