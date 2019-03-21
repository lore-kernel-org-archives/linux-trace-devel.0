Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9147FC4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 685AE218A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfCUPrR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34149 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbfCUPrQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id o10so2318246wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Mar 2019 08:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=D4fDrnMxcs4iUgFnzkP9Rl/exaCle7rXVuLKA4456RmI+E1kvHxZutq7x7PaY7Kmpe
         ULoXzSSrhza3De2K/zcYuiEl6yyW/J5jekMjzlr37zbv+I3r2hk3egWizpjdpzPCBFp3
         5TRx4DAslDKl6rGKWGC/S8T4zfUn0rwryMo7T/+GydU0S3o9g2/yF/F/TsjmbO198n+Y
         d8CzG9ZDhZSEWH1xY5jJjp1uu5fsGMStLwWwBFlMg0u+d7iAyHhWqBxzbxGRtfWyE4vz
         Mj3y5BK8qch8ZotMt/Zq64VABRVpbljHHTG0jBi0dUBCGXixUZCkbr7+QR2rGr2bRBfT
         wX4w==
X-Gm-Message-State: APjAAAVmTz/FBN5bydc3DIe78DsdXSmBAYptu759Dqy3BoFKoZv0H0Xz
        19GGcWXk5OlZ8CGGwGbADSw=
X-Google-Smtp-Source: APXvYqxtPmZIuKXQDqt2DSiAULpPMUaKGruCF5bcNtryBOG7oLlN4mRHASStgQwQCPLHinIIQStkmg==
X-Received: by 2002:a1c:2d91:: with SMTP id t139mr3178062wmt.102.1553183235124;
        Thu, 21 Mar 2019 08:47:15 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm8940049wrt.65.2019.03.21.08.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 08:47:14 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Thu, 21 Mar 2019 17:47:03 +0200
Message-Id: <20190321154709.24163-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190321154709.24163-1-tstoyanov@vmware.com>
References: <20190321154709.24163-1-tstoyanov@vmware.com>
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

