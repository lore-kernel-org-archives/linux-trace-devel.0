Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688CBC4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CB621473
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732152AbfDBNp5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:45:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40523 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732144AbfDBNpz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so16715535wre.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pF8lNHju2ICh9CEM/kthrPxNeplJ5k/gj4E/aMvPvs4=;
        b=h0Z2w20Y93iYasn6LzczWlCkWFL14HgFc27ZHeGXF2/WsQ6VAm/QqOlNfe6IEUn8x/
         rf+SBUTy7AOnAVpq0yv9gajxNsIovoDkxB48loQxS1NC3NXBXIVuNadKvccgqQuwhO7z
         P4wzMhjCmmLApREvkLrHW1YZ5Xic81cHhP4CRdgcmj85dd58CToYfgjlHvlqt6Z+wZv0
         On5FxItejxxzOzAVTxL7G9YOYqLDMO11SCnpUscsJQnwZLBahQh1Oh+8HrJjnp5wXiNz
         oMUADsE74D56mKozezXc3r0uc0xSu9JMqA3F7MtC7QDB3wZAMDvWRU3JozJON2Hj8VQ1
         4h9g==
X-Gm-Message-State: APjAAAXIqKonVTQVyKmK1J+dXmMc/quSZGgzLPXK/Qk0aD2y0cPScL8h
        dmNnr+untRCasdLL/RT2EQ==
X-Google-Smtp-Source: APXvYqxdr5gxwYEfqocoWky+1C+UyC2gfi2FHAYaEGDFzGnXm7fWGye0ZXiNr2ZsvTQe1drVe0gu4A==
X-Received: by 2002:adf:afe1:: with SMTP id y33mr24091396wrd.288.1554212753222;
        Tue, 02 Apr 2019 06:45:53 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:52 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 07/11] trace-cmd: Use splice(2) for vsockets if available
Date:   Tue,  2 Apr 2019 16:45:36 +0300
Message-Id: <20190402134540.32321-8-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134540.32321-1-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
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
index 9067811..6c51200 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2654,12 +2654,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
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
@@ -2864,13 +2913,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
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

