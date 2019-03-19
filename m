Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA526C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9348620857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfCSPzn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35431 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfCSPzn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id f8so2393787wmh.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=RrYgBMtc2ToMhW943OIySPNwnd2JNMvtBspUFygMLKaA5MCRcO8uuly5PYAkXpwbdz
         U7HqA7FMGQl515TRJslvZEJDVvUv3TcAEhjsLfoVwuMUzDThr/Sf7MND72spxteRzPBL
         28c2RI2H5weCiO6JYgE7b0dJGVrympyHJaM37JWZ6dIE67H/b7aqJAp8/H3wTIaq/9Eo
         gYeJe9tnZTAHM8evOeDO1pdqyylNXWZA5wQeYdAfYLjXNm3I8lAJSeMRVFyPjFMIUYFc
         sX+yWwVQIZwAPBktn3Uaw2f2zA3BNqWPhzEMm3ovl/Vf1JzLExWFmNPusNfvlww6iZkb
         cL1Q==
X-Gm-Message-State: APjAAAXc+KQTdGig9pIpRS1FFODGIGCldIAXixR9w0q0sT0c4z/caooj
        6vFev9SBE3bT7e7iiMkFLRk=
X-Google-Smtp-Source: APXvYqwNPLyhuNERIeifubw6T7vGecCzhOTJ9y3rSOldVzgjOO3QnT4HVLIMyMic8Soz+RA+9qjH8Q==
X-Received: by 2002:a7b:c3c5:: with SMTP id t5mr4210152wmj.110.1553010941276;
        Tue, 19 Mar 2019 08:55:41 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:40 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Tue, 19 Mar 2019 17:55:30 +0200
Message-Id: <20190319155536.19381-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319155536.19381-1-tstoyanov@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
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

