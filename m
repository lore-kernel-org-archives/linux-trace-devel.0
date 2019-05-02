Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105D6C04AA9
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E055C2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEBMJ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:09:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53141 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBMJ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:09:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id j13so2482736wmh.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72uUKgi2Igx5O5RllnfA4/C0lnOX05XfwkmUDwNSm/w=;
        b=pE1asid0iW3qZqG2l3HxKb9Ar2ScmwROVJEH9Hvu5XSMYXOM2R7KC1+XHpe47EHPXr
         83HdgiEkupTNGLGYvsPRYBJSrZaP4hTJQDOeFX+O283ATBRgl8WfSAQ/Tft58IzkZDur
         PSH6kwLo6Fxb0R6y55cs9wXyl50Bxo09lwUNMizhLIao6xJ1IGkBBlS9HMmNRUZXghpI
         ant0hy8/1MYTXWgVj7nlgFLTaDHSm2NaGguaMYdC0p5R1ePnNJAzJYJcHwMtR0U33w5/
         an9cxXGtRdO3AMAUIX17YbZUK7wX5L/Uqq0IwyPMKnEGYJZlJ4OmT3fukbYUVDbwkO1w
         +SGQ==
X-Gm-Message-State: APjAAAXsBkoUhWkdCzrU/kEoIu6b1yWx3YfCxRt9dYFFFLXVMoCKx+ZV
        wbez87WdSrQDkviPd0q7/Nd5di5M
X-Google-Smtp-Source: APXvYqyca5bLZammyAvJv3nXEOelLWSA3fjYvfhCmUueiPVT4Z89b8vFiw72/3pOhM/0VqHXMXnY8g==
X-Received: by 2002:a1c:f70e:: with SMTP id v14mr2238161wmh.74.1556798995528;
        Thu, 02 May 2019 05:09:55 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm42029219wru.36.2019.05.02.05.09.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 05:09:54 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Fix a possible race condition and deadlock in trace-cmd
Date:   Thu,  2 May 2019 15:09:52 +0300
Message-Id: <20190502120952.20449-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502120952.20449-1-tstoyanov@vmware.com>
References: <20190502120952.20449-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When pipes are used for communication between trace-cmd main
thread and per-cpu recorder threads, there is a possible race
condition in stop_threads(), which can cause a deadlock between
the main thread and cpu recorder thread:
   In trace_stream_read(), the select() call can return 0 if threads
   have no data to send. This will force stop_threads() to stop reading
   the thread's pipes and enter a waitpid() loop, to wait for all threads
   to be terminated. However, there is a case when some threads are still
   flushing its data - tracecmd_flush_recording() tries a blocking write()
   to the pipe. A dead lock appears - the cpu thread is blocked in write(),
   as its buffer is full and no one is reading it. The main thread is blocked
   in waitpid(), to wait the same thread to exit.
The deadlock can be (randomly) observed with the command
"trace-cmd profile -p function -F sleep 10"

The proposed fix increases select timeout from 0 to 1 second, to ensure
the threads are flushed its data before going in waitpid() loop.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4523128..9aef5c3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -626,7 +626,7 @@ static void delete_thread_data(void)
 
 static void stop_threads(enum trace_type type)
 {
-	struct timeval tv = { 0, 0 };
+	struct timeval tv = { 1, 0 };
 	int ret;
 	int i;
 
-- 
2.20.1

