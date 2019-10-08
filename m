Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC761C4360C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0CA0206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfJHIP4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35638 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730589AbfJHIPx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so2106596wmi.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fp3IgS5/oHTtBic4Cmr2JcrMHQLCyAAXQsbqLFAV7u4=;
        b=rbSfGlA6qfFTOMIyJISWuHXi/n142uMGXC6UboNp71dp1iO4uO+daJQ85FLeE/eSKY
         OH5tux0z7ZzkK8XMSMYmtLVbn5AXLoIJ8Ftmfev4YnLvwacACBIwK90BOOKc9kBz5cg7
         fwu2O8wRx2IeQxMGrG1N/pIjb3OowcpeM7I0HWv2PIqKnu8e2BOgcWHtQNT5H3UnL/Fl
         M4aVBT2SY2Yih6k2oSa23sVg3ZZs1255IQqwuyz7CySTheIKMfIOmTAaZgahXgaZWIV8
         RMlFs6H3DiL1AE0SLLCT4Sdc5tB2ulw9bF3QugP6XEENWmZO553irXMoWkzn/+PWdpRx
         Ve7Q==
X-Gm-Message-State: APjAAAUROq+4NyPPY6gVV3UDAZyUjIX5/rzh3Azq1Bkg5n50vfQkDmM5
        CKnOAW6jLsm5qmvXjsWndg==
X-Google-Smtp-Source: APXvYqzKxU1T1Ei8IQbILjpNzgiy6eRtBClb5ESbwgySK4XpoK8cA482frb4m/xdfsrws6nEXtYZ5w==
X-Received: by 2002:a05:600c:2319:: with SMTP id 25mr2815566wmo.3.1570522550997;
        Tue, 08 Oct 2019 01:15:50 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:50 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 07/13] trace-cmd: Use splice(2) for vsockets if available
Date:   Tue,  8 Oct 2019 11:15:31 +0300
Message-Id: <20191008081537.11536-8-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
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
 tracecmd/trace-record.c | 56 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 79b39af..b974d09 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2916,12 +2916,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
 	return sd;
 }
+
+static int try_splice_read_vsock(void)
+{
+	int ret, sd, brass[2];
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -errno;
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
@@ -3125,13 +3174,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
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

