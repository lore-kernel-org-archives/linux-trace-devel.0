Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0419EC43612
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C866A20868
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfAPTSp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38257 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730792AbfAPTSp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id v13so8282664wrw.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0lMhuB62R+55CCbuBOaIeScWB1IMPNOs2GLMiFUgLg=;
        b=k4dnYEu4Nhq81ipWTSyHQAmvAals1x5iT4pVxIyN3vc0o3Q7FMucuJkSyb2IjHYUt1
         oi8Ss+IHTHoKVPtMTEpVRmtdgudGa5koPIp5DVkZZavE11sHVzaNkXAnYNStNk5V5sUz
         nZh0Dpor8/HAn21v2usn92B/6bx9c3n01k0whBNHPDuMhRrvaHDM5CUyrzUqmAEQNSaH
         XI+NBlFrTrDrM+ghbxp48m29U5lsyh4Q0XlcZlyWGLILqg8xJ+Ycq6yRhvLhloLRF0AX
         HhRiPoEcpFhl71p+oI4w3OxIcpR9flHq/xcdYTmgXOgi9iXSxjBcdndVC3O2iHU8jR1L
         Vprw==
X-Gm-Message-State: AJcUukfxu3uHd2FLQKVM2PE/XR12rOzS3+Crfkd6c/yAV7F+1hW3s/++
        Qp5YMurCBVWUhdPkANiDGnMTa092
X-Google-Smtp-Source: ALg8bN62ZEipVCXBEP2adIZ19hAJWlfrPoqREllnoKVtCGbqCJdcbF5aefTb60DvmTPGRVvQrgwkqw==
X-Received: by 2002:adf:ff09:: with SMTP id k9mr8444332wrr.97.1547666323779;
        Wed, 16 Jan 2019 11:18:43 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:43 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/7] trace-cmd: Fixed logic in tracecmd_read_page_record()
Date:   Wed, 16 Jan 2019 21:18:34 +0200
Message-Id: <20190116191838.32127-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116191838.32127-1-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed the logic in tracecmd_read_page_record() when
searching for the next event in the event from the
ring buffer.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-input.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index de15d4b..c2b993a 100644
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

