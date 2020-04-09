Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAB3C2BB55
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07240208FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DaYt2baX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDIN2F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45639 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDIN2F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id t17so11408656ljc.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jFKQu2UYgSwQ5tt70AIdnHoXHlY+9OlkHHztv6wiLlI=;
        b=DaYt2baXHl6jU1ZEjGqFFoJFeASHiPPrK/bDnyuS3++/JIgTUIf3Krz5YSFH3QDmlN
         T+y6q97IvufFDNYgZoRzp/Gck/ODhQ+0Fk0iC0/mhO6ZnEWGYfWfQnMJY0crMRsT7XGK
         46FkwkO04mBbRZJ0cvKP8bGuH2qrbvORj6LHjo264LJqlwGdLk6AdWyzhCQKWvIPpbq+
         eCyQPT9leSMfwr0U96YDdHwufV8KtAbOOput4DZBLzQrPNs0HhZkyrbxcgh1+miTJ+OL
         qwDCssr2ms3axqII0VoiLLgohS8F3uckbGd4/307DcedSFkGw35mbmcBDlqC2xGJ8Z82
         ZLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jFKQu2UYgSwQ5tt70AIdnHoXHlY+9OlkHHztv6wiLlI=;
        b=NdufFJpKscnjIuaWpbhZ7eHt7HRW7o7ekSHmjnFrrkCds6uOeLVmY9FbbZFY/XIMA+
         Tg8C3ZkXfED1Qoqsw5SeFyficYcXGw8MKlaEWs/zQeuSbjOTogl3M9J98WXSQU0JYYAm
         fGignNyb/0xImdBDNe6QOjwkxh6O7kKg7ngnQHN+l+ymtnMwpQGQaSKLyB8R9eBl+CkO
         Hog9nzKj85/0vb1yBzVXHFu6W7mpUaTYfSanG58JkAcdHsCJySl1mWegI1T2PJNCt7rB
         gVZYcIMgoQG81Yai1FJMwC+OzYSKBmGr6OFPx4bGYv3BL7K8Ez6PtT6i8VG8hf02m7En
         FR4Q==
X-Gm-Message-State: AGi0PubHUTMKLwsC80VCW0ZitqaH9X7XZZUWGRBFkAamzVj+gWgrN7e6
        TQLx+zdpbIoY2KOf4s1efY0=
X-Google-Smtp-Source: APiQypIS791wv7rspkxP8A+idxl772inYFPfje7Z4HFzvLfmLrRIXHcdgTBWCoQsN3Jk/DYEGTBA7A==
X-Received: by 2002:a2e:804a:: with SMTP id p10mr8686505ljg.289.1586438883140;
        Thu, 09 Apr 2020 06:28:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f2sm1067220lfl.18.2020.04.09.06.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Fix reading of the traceid option from trace.dat file
Date:   Thu,  9 Apr 2020 16:27:56 +0300
Message-Id: <20200409132756.79402-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132756.79402-1-tz.stoyanov@gmail.com>
References: <20200409132756.79402-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Due to a copy / paste error, the reading of traceid option from
trace.dat file is broken. There is no impact to the user, as this
option is not used yet.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c1531410..f04528ae 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2554,8 +2554,10 @@ static int handle_options(struct tracecmd_input *handle)
 				trace_pid_map_load(handle, buf);
 			break;
 		case TRACECMD_OPTION_TRACEID:
+			if (size != 8)
+				break;
 			handle->trace_id = tep_read_number(handle->pevent,
-							   &cpus, 8);
+							   buf, 8);
 			break;
 		case TRACECMD_OPTION_GUEST:
 			trace_guest_load(handle, buf, size);
-- 
2.25.1

