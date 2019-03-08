Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF84C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B0D20661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfCHNoa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:30 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54470 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNoa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id f3so12692916wmj.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk3prq7PM5NWRxFeku/sMfCiWVMc5DcibNxNMdyfE4M=;
        b=QrtLXFPuxcnJxv0Ugitvw7ienRs+L/VynXCQiycUy38hw67i3O9HwHBHx63+nu31sE
         XwemZeqIj5WPv/hGQFS4SLjawt/AKlUlwD1lK+KSFoqn5AWszaDZ7Wx7NWeKn0IILPQJ
         6BquTxRu7KqTDoHdmG00+Ud0R9xPpngkBv9htyyJVcrWYnPogL+g/x4934ofolDk9DpO
         5TNc78WZK34dtW0N2CrJFDFRybKCUt7wVvS5pI+kWcdUQjfAiFel0umRS4yVF9PT4Yfv
         zMfIzdA+wOBcy/z25KnTX4F5ewpbpb8SnDRQ4qaYffoPksWVM38Sm86GgFYmw/l6dODd
         Vf6g==
X-Gm-Message-State: APjAAAW28QOU7acHis4yW67Bn9dUHtnWGut2BOh3WnReTCyikjINj8pL
        WgN5Jc4Fng4oFC8YX45vyp2/KWSj
X-Google-Smtp-Source: APXvYqxRxZp/pQFhk1KViG7+htlBxeyEv9IWAAXyZx/8JTbIevjFlA8slWj7eDNr5zDq7qCip5a7xg==
X-Received: by 2002:a7b:c352:: with SMTP id l18mr8920739wmj.127.1552052668375;
        Fri, 08 Mar 2019 05:44:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w4sm11631872wmg.8.2019.03.08.05.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:27 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Fri,  8 Mar 2019 15:44:17 +0200
Message-Id: <20190308134423.22008-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134423.22008-1-tstoyanov@vmware.com>
References: <20190308134423.22008-1-tstoyanov@vmware.com>
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

