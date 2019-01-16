Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2569C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AB61206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390597AbfAPNnb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:43:31 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39732 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393238AbfAPNnb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 08:43:31 -0500
Received: by mail-wm1-f65.google.com with SMTP id y8so2028685wmi.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 05:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O7V6rYXgz87+rMg4j9CZD+X3Wk8alHg55qvqsEDG/MY=;
        b=LpfowkoF4ptlu/48er9GEom8oIvGScb61ccBcMHRQDA8H6M8AgjTl/KXLcFp9XrgAi
         xV0fwGPON+DFvKuaw0oV3bvza3MrDeTi/lxMV4JUaNsUoYxmkUz7fYJPwX8abHrq2YW2
         YJEY/eByyO4djtW8zhQJFdnOfNH2CTzbOW71HuGCy6pvUxCJHVcNuTNoyCq066ZNM2H9
         qJWfAJNiYRjkpbaR4emT2B+CB12tgaWAPtUu/0Ecfg1mwNr/rvwxPKxI9eQpOnW5qqp4
         fZ6MVNRxoHUr4LBdPkOPkPJBJalZ7hzxLp0+Nik/l6teCK5H81xlHgaNP7bv6U92Q13Q
         yGOg==
X-Gm-Message-State: AJcUukeQU2EqziCQhMXeIykPKbUC3Yk+wEgwwO5BP5QfLlKSN8gxZoFA
        57aInlLYJmgrNQFADde4EP/M6cKGLw==
X-Google-Smtp-Source: ALg8bN6e8KVwqNmWuD2+mv6m+i9V/tPt7IIa84QhDbQHy757WAEgnxX53troWneQEumJ7MTM7XBGAw==
X-Received: by 2002:a1c:570d:: with SMTP id l13mr7865560wmb.139.1547646208950;
        Wed, 16 Jan 2019 05:43:28 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm34636460wme.2.2019.01.16.05.43.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 05:43:28 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 8/8] trace-cmd: Use splice(2) for vsock sockets if available
Date:   Wed, 16 Jan 2019 15:43:07 +0200
Message-Id: <20190116134307.4185-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190116134307.4185-1-kaslevs@vmware.com>
References: <20190116134307.4185-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Detect if splice(2) reading is supported for vsock sockets (Linux 4.20 and
later) and use it, or fallback to read/write-ing otherwise.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 59 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1622b5e..cd80462 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2658,12 +2658,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
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
+	 * On kernels that don't support splice reading from vsock sockets
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
@@ -2868,13 +2917,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
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
@@ -2928,7 +2980,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 
 		if (instance->flags & BUFFER_FL_AGENT) {
 			fd = do_accept(instance->fds[cpu]);
-			flags |= TRACECMD_RECORD_NOSPLICE;
+			if (!can_splice_read_vsock())
+				flags |= TRACECMD_RECORD_NOSPLICE;
 		} else {
 			fd = connect_port(host, instance->client_ports[cpu]);
 		}
-- 
2.19.1

