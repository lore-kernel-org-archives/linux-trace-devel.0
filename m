Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CE9C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8DE21479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfBROzJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:55:09 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51712 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbfBROzJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:55:09 -0500
Received: by mail-wm1-f68.google.com with SMTP id n19so5535477wmi.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:55:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8X22xUNzyBITgd8y0sQOWbINFajpb27+VnnWJtIQNC4=;
        b=AWPR/Fljo0jEz6qW05+jwotejjXUMz79LT/hoqxHq2hLRax9TTKs9nbyVUB7tTOmHc
         hZnsfUcjTHcHiYEJhTBN87IVXGrMOi6HF2PLqrn3MZJC4KLWNgYYwWFfdjO1qopUhjfR
         d0r47ws/MWBqaj1Rxg3ZID24jfWCxvvt/1DoRxj9p815rPaLAb5n9cjXnu4M7mB3pIg6
         FgoDULgRzHCcaIs4bxU+evGuSDi1hhu+qNLA4wDWo7GOlznNmPRVPFmZRg79PiXdI4V4
         PVXmBltvOoHW2pwedDbq+H4HL33pTpcLhJS5vv2lFrgd7ACCUbTNbKbeJC/B5X7t45vF
         e+pQ==
X-Gm-Message-State: AHQUAuawgIw63ouJgBFUigWUkyb/0COou/bmHuuCYdCu3WniAMRIKrGZ
        UOa4rpXDHSo12oTm+b33nQ==
X-Google-Smtp-Source: AHgI3IYkiJsKfgfI+mLQdK3H8CuXA3eSQrXgVsxoOxNJGUSYsL9KXJmBOOYqeLbrXvE0smjU2QdRIw==
X-Received: by 2002:a1c:f509:: with SMTP id t9mr17052007wmh.76.1550501707769;
        Mon, 18 Feb 2019 06:55:07 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.55.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:55:06 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 08/13] trace-cmd: Use splice(2) for vsockets if available
Date:   Mon, 18 Feb 2019 16:54:44 +0200
Message-Id: <20190218145449.13360-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218145449.13360-1-kaslevs@vmware.com>
References: <20190218145449.13360-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Detect if splice(2) reading is supported for vsockets (Linux 4.20 and
later) and use it, or fallback to read/write-ing otherwise.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c |  6 ++--
 tracecmd/trace-record.c        | 56 ++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 1b84bb5..d66f112 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -386,10 +386,8 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	ret = splice(recorder->brass[0], NULL, recorder->fd, NULL,
 		     read, recorder->fd_flags);
 	if (ret < 0) {
-		if (errno != EAGAIN && errno != EINTR) {
-			warning("recorder error in splice output");
-			return -1;
-		}
+		if (errno != EAGAIN && errno != EINTR)
+			return ret;
 		return total_read;
 	} else
 		update_fd(recorder, ret);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b401fd9..ca97758 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2660,12 +2660,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
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
@@ -2870,13 +2919,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
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
2.19.1

