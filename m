Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE5AC282D7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3786C20811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfBDG7G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:59:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42463 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfBDG7F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:59:05 -0500
Received: by mail-wr1-f68.google.com with SMTP id q18so13122002wrx.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3J/W9wUPHGJUHak9160UZGjCuXyNtQd8t5Pjta35DA=;
        b=aPImPz4bHJ0JqlxsmS6moQ7SAfk5/yPcT1CJRfC51vGPKz4ydDZcIUwzwSyuOCXhoi
         WCx5rdc+YxBe2xum0U6fiyTFDDKIY164RJHH+F5Jui/PWEuKI1t4du9QO8fk8jRDgCaW
         E+q9Vw71YkQ3dJcT/Sg8aAtmgjMoN+8kV3unE3Bbf8GI9Rjs6Oq8u2s9lkXbVZO0jX2I
         hfK5Kuu6A4kGpDsbePlIqUMOAlFXMCEMHndBfrcz2KI/+4ousjGscqjXGz3micaKQZjY
         Ff9uVvRthWKy6H38Yv0qgJdRSX0b9yl3W8Qv16ojJEA5bh0XrjEktbMo//EHLrfPKdns
         OfLQ==
X-Gm-Message-State: AJcUukcNxNC61XMoZWKEnCGykH7xhGZ623p4DmCdr4pWH0h8V6dpTDuP
        p6Bi3Ty5vvYb+ZHIjc6hHfdwcpJRLQ==
X-Google-Smtp-Source: ALg8bN7+nDDmDl7Hk+Rjba0hSVGSn0mgljhQFS+4ayRDN2SAfMtjDay8Ihg9W3bHu9bvM4+sJ+ZdHA==
X-Received: by 2002:a5d:4303:: with SMTP id h3mr48681616wrq.273.1549263543661;
        Sun, 03 Feb 2019 22:59:03 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.59.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:59:03 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 06/11] trace-cmd: Use splice(2) for vsockets if available
Date:   Mon,  4 Feb 2019 08:58:43 +0200
Message-Id: <20190204065848.8248-7-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
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
index 83a12f4..b750935 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -380,10 +380,8 @@ static long splice_data(struct tracecmd_recorder *recorder)
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
index 3c28314..71176d9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2656,12 +2656,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
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
@@ -2866,13 +2915,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
 	if (instance->flags & BUFFER_FL_GUEST) {
 		int sd;
+		unsigned int flags;
 
 		sd = open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (sd < 0)
 			die("Failed to connect to agent");
 
-		return tracecmd_create_recorder_virt(
-			file, cpu, recorder_flags | TRACECMD_RECORD_NOSPLICE, sd);
+		flags = recorder_flags;
+		if (!can_splice_read_vsock())
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		return tracecmd_create_recorder_virt(file, cpu, flags, sd);
 	}
 
 	if (brass)
-- 
2.19.1

