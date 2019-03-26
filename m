Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A69C4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17A02070D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfCZPG6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:06:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38291 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731491AbfCZPG6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:06:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id k11so7366758wro.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Mar 2019 08:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=gzY4yG1JId2sc05X9sIZ2MBeLhqxVFYztAzPpv+mW91+l0oVIJdwBvSWFQ2/jK6YPg
         vLyRmlwSbF8tZ4yPX9xYAN8K5i7M/Egk4Bq+QbaH+lB1fdKyHeiJ/9Tk+nyzWTsQyRH3
         l+LpdnKVIKaBEodIHPGSEr/1vqQqPZ47Z8J5QIvN+3VI91si7rLMa7aMGsHjDujW2nyI
         cJINmwBst2pDkZRRk6AzpsifzmD6gByUiFoD7UJiETuOPNaXGsVopvvDCuKEDLRnHL8W
         Q2KW6A4zpFmja0yc3MzshYciijC1UnK/h1fpwifCdFWA5RXxXmQRrs5ZjV5TMwtXaYuy
         ty6w==
X-Gm-Message-State: APjAAAUIgtKcqlL7y+Cve4WFjOuK0LBR1VlD4vy3CFpyHtPQF7SaoZKE
        fY5eRDRXbxxvLF8YA9b6+Jw=
X-Google-Smtp-Source: APXvYqya+t6m1CvzWN3Yx4EY9jpBxgx4++T8UpCGSHQmpZzvcK2IWx9XDG7DcIlNlI9j5Gkis672sA==
X-Received: by 2002:adf:edcf:: with SMTP id v15mr18984933wro.20.1553612816969;
        Tue, 26 Mar 2019 08:06:56 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 13sm6833631wmf.23.2019.03.26.08.06.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:06:56 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Tue, 26 Mar 2019 17:06:45 +0200
Message-Id: <20190326150651.25811-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326150651.25811-1-tstoyanov@vmware.com>
References: <20190326150651.25811-1-tstoyanov@vmware.com>
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

