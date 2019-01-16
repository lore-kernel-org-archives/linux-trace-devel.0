Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F911C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67642206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393146AbfAPNnZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:43:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39724 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733175AbfAPNnZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 08:43:25 -0500
Received: by mail-wm1-f68.google.com with SMTP id y8so2028355wmi.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 05:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JEXu/pVG/AZlTpO1z3QOm0XGovcYNNOUFX16etekqGU=;
        b=ZL5H6+mBeceXgWOQx7Bp08mueWEQ0bEtAHSzMOnaMiOWOFLbPpdHposljHUWRDv3Sk
         zU3nV+ojgHnW8Q2uJV8VU2RJG2EMnF6ymWZzRNHbFsSZyO/X/E41YhbvajjYVpGgpdBr
         tg4ZAr7l3YXc0rkhuoK91rkqsSLmEn9Jb5OFpw3AMPJdXByZAjOiZQGKejATkKh+aW0U
         KoNPUTY9ZmRxA+dx0kQHbHziYI1TN4dX+z3pz2DQRvPJJwKJpWEja1vyFPr6SOYK86Zl
         sL1JTf1Iu8HVKlp80lnC9qnYv3jBIRvznxKE6Ie079rUSXWrhDF65RT43lW8cO1ZwERO
         7iYw==
X-Gm-Message-State: AJcUukf5szEBhPKq0RoQtSGa/Hk0ke65Nl1qZG/zq1dhj/uRlAC8u/yj
        uzvhVpRBxxd2p2c4tQH71sb4bjBjxnEl
X-Google-Smtp-Source: ALg8bN7WmsL8tYHJWBkyDBNCTxpzrb+kr8gNEjdkTdKdgz6vU1WVdg08OrshyMX+UJFhcYbtgzq4tQ==
X-Received: by 2002:a1c:c44c:: with SMTP id u73mr7957236wmf.45.1547646202854;
        Wed, 16 Jan 2019 05:43:22 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm34636460wme.2.2019.01.16.05.43.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 05:43:22 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 4/8] trace-cmd: Use unsigned int for trace-cmd client ports
Date:   Wed, 16 Jan 2019 15:43:03 +0200
Message-Id: <20190116134307.4185-5-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190116134307.4185-1-kaslevs@vmware.com>
References: <20190116134307.4185-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

By definition, communication ports used by trace-cmd clients
are 32 bit unsigned integers. These ports are generated randomly,
and in some implementations can overlap the signed integer range.
This patch converts all client ports in trace-cmd to be unsigned
32 bit integers.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 2 +-
 tracecmd/trace-msg.c          | 4 ++--
 tracecmd/trace-record.c       | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ff4f0f7..8b43462 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -322,7 +322,7 @@ void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
 
 /* for clients */
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
-				int **client_ports);
+				unsigned int **client_ports);
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index edde582..529ae2a 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -386,12 +386,12 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 }
 
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
-				int **client_ports)
+				unsigned int **client_ports)
 {
 	struct tracecmd_msg send_msg;
 	struct tracecmd_msg recv_msg;
 	int fd = msg_handle->fd;
-	int *ports;
+	unsigned int *ports;
 	int i, cpus;
 	int ret;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a8c3464..3034a4b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -74,7 +74,7 @@ static int buffers;
 static int clear_function_filters;
 
 static char *host;
-static int *client_ports;
+static unsigned int *client_ports;
 static int sfd;
 
 /* Max size to let a per cpu file get */
@@ -2545,7 +2545,7 @@ static void connect_port(int cpu)
 	int s;
 	char buf[BUFSIZ];
 
-	snprintf(buf, BUFSIZ, "%d", client_ports[cpu]);
+	snprintf(buf, BUFSIZ, "%u", client_ports[cpu]);
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
@@ -2755,7 +2755,7 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		/* No options */
 		write(msg_handle->fd, "0", 2);
 
-	client_ports = malloc(sizeof(int) * local_cpu_count);
+	client_ports = malloc(local_cpu_count * sizeof(*client_ports));
 	if (!client_ports)
 		die("Failed to allocate client ports for %d cpus", local_cpu_count);
 
-- 
2.19.1

