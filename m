Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39B7C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D1FC20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1baRbfW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFROpL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42786 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfFROpL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so14288070wrl.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m8UNWMrEp+kR42c3wAycq8mWrehDVI+QGPZqqALkLZQ=;
        b=K1baRbfW+nDv/sHk8d8ns+XZG2avhHrRsf3XwtRk9YDM2wBdc3+x4XxqQWHiZFLeSf
         StLfX2FWiBwYrUfT5CgbYMo3QkG+XIgyJdCxHx3cKKsIlaylxCG2BNqwjkCCwA9YH+/z
         U0Ok+sDf3IB5quw1/SwWySmQBGAtFdmlyoYARyaKHuywBr1SfqvneL3tb84vbS64JgZK
         V1JXT3yJI5ek+oxclcmtvs/K07znoYRa7KD24k4ZhQrxWpilKi/nbdToRs7CHPBuftMk
         YnJsxePazyt5V1dpoiXWPAzKrqkLJ0KVfEf7zJqwgNaTbVMCDbXpqG8c1T+Czs4LmG9Z
         YnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m8UNWMrEp+kR42c3wAycq8mWrehDVI+QGPZqqALkLZQ=;
        b=oVJtsALMB3wySaq4+S1A81HD0evMz20LvCsmsj4cvO2/B2FIH4jsnqEFfkmtJPzDeh
         yhw/BFbIwZ8kE4PShmfgGuGoNmVOf1VJpdMuJpbKDV10BSExBolZasLolMxrJPEQUXLa
         XFMerWU3qcaZDHbIhsKCP5kdXOIF8ahSxTwGDIglWZcewUW7pQb75jBNjBzYp3fAT2eh
         2S/izj2UCkLQ5JHRe6I/cQdLjgUNK3kOy/ONR7TjnL1oJ1dCG5caODzuek5pHhEftUVn
         KCyQpC21z4Qj21upVjbHnVe30tDAyhkEXifOqGxVR0FdAczsPX5Ugg9Q+qABU5v34io5
         R0xQ==
X-Gm-Message-State: APjAAAVqAaT84Fm2YhdE+0AObaDH+BpfY9F64A8VoXWKkuN6AZiui8lp
        4e9sBgLNdEWm3/BGZ8AIWgjeLII=
X-Google-Smtp-Source: APXvYqwEj7w3sqSUeDLelvZJ4CUIE8J8CcV6YI1cxZADyT/oxe8b7JC5xlDYYd9k12Qmna7fZyJoog==
X-Received: by 2002:a5d:4489:: with SMTP id j9mr37727327wrq.15.1560869109286;
        Tue, 18 Jun 2019 07:45:09 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:08 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 07/13] trace-cmd: Use splice(2) for vsockets if available
Date:   Tue, 18 Jun 2019 17:44:49 +0300
Message-Id: <20190618144455.3954-8-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Detect if splice(2) reading is supported for vsockets (Linux 4.20 and
later) and use it, or fallback to read/write-ing otherwise.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 56 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index dfad8f2..f6e5c7e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2715,12 +2715,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
 	return sd;
 }
+
+static int try_splice_read_vsock(void)
+{
+	int ret, sd, brass[2];
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return sd;
+
+	ret = pipe(brass);
+	if (ret < 0)
+		goto out_close_sd;
+
+	/*
+	 * On kernels that don't support splice reading from vsockets
+	 * this will fail with EINVAL, or ENOTCONN otherwise.
+	 * Technically, it should never succeed but if it does, claim splice
+	 * reading is supported.
+	 */
+	ret = splice(sd, NULL, brass[1], NULL, 10, 0);
+	if (ret < 0)
+		ret = errno != EINVAL;
+	else
+		ret = 1;
+
+	close(brass[0]);
+	close(brass[1]);
+out_close_sd:
+	close(sd);
+	return ret;
+}
+
+static bool can_splice_read_vsock(void)
+{
+	static bool initialized, res;
+
+	if (initialized)
+		return res;
+
+	res = try_splice_read_vsock() > 0;
+	initialized = true;
+	return res;
+}
+
 #else
 static inline int open_vsock(unsigned int cid, unsigned int port)
 {
 	die("vsock is not supported");
 	return -1;
 }
+
+static bool can_splice_read_vsock(void)
+{
+	return false;
+}
 #endif
 
 static int do_accept(int sd)
@@ -2925,13 +2974,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
 	if (is_guest(instance)) {
 		int fd;
+		unsigned int flags;
 
 		fd = open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
-		return tracecmd_create_recorder_virt(
-			file, cpu, recorder_flags | TRACECMD_RECORD_NOSPLICE, fd);
+		flags = recorder_flags;
+		if (!can_splice_read_vsock())
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
 	}
 
 	if (brass)
-- 
2.20.1

