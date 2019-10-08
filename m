Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D1BC10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57688206BB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbfJHIPr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53355 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730292AbfJHIPr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so2089617wmd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpu59DDSbKg49cfr43BlsEJYx9NzHxIs9zBJKefjRuk=;
        b=bE5FwPzz+Li6We0F3+boJ0r/hXvUmBrTtqrfAviBioN9L07pzf+5tvK6COz9qzjl5f
         yVgvuN7I1r+Pkf8Nar8hzGHjegBBEMx8lrhTCTsietbffQmqQ9G4t5wtwwjd9T0Wt+38
         swSV8qr0lhp0zLr79eALDqXKLbqJ4XxGnExkEoYktVJBYrXNvwwfhWHetAmZVMsZARHP
         IHRsrPaX+b7hnDjSyUdmiUjS0CpErrWNk1n3dejOwRPHiui4bLy5Y8tExa029gANkOMB
         0STXWTDPgsueiYHIYBtN3n0k6bptMXrOUK1nWngOtyk/f223c16zNpe6tkWVieHRoS8k
         /Qag==
X-Gm-Message-State: APjAAAUFUQ+lFtpMvN5yhqV88+4u7eZzxtASdX/A1SGnsTzZCrppBz3P
        gbc+cy02nKOfPkBAcTurfw==
X-Google-Smtp-Source: APXvYqy1+Y94XbycXM9n/g+vNtDIoLF99LfT2pJ4rdvt64X/gO6GEARoBWjPlaN9vZHJKzwxrLIfmQ==
X-Received: by 2002:a1c:27c5:: with SMTP id n188mr2619198wmn.118.1570522545003;
        Tue, 08 Oct 2019 01:15:45 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:44 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 01/13] trace-cmd: Make ports unsigned int
Date:   Tue,  8 Oct 2019 11:15:25 +0300
Message-Id: <20191008081537.11536-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Switch ports data type to unsigned int since vsocket ports are 32 bit unsigned
integers and sometimes cause overflow when stored in int variables.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  2 +-
 lib/trace-cmd/trace-msg.c     | 32 ++++++++++++++++++++++----------
 tracecmd/trace-listen.c       | 10 +++++-----
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 4090eba..00889fb 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -333,7 +333,7 @@ int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
-				 int *ports);
+				 unsigned *ports);
 int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 74c5254..4def7e6 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -161,12 +161,26 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 	return 0;
 }
 
-static int write_ints(char *buf, size_t buf_len, int *arr, int arr_len)
+/* test a to u */
+static int tatou(const char *s, unsigned int *res)
+{
+        long r;
+
+        r = atol(s);
+        if (r >= 0 && r <= UINT_MAX) {
+                *res = (unsigned int)r;
+                return 0;
+        }
+        return -1;
+}
+
+static int write_uints(char *buf, size_t buf_len,
+		       unsigned int *arr, int arr_len)
 {
 	int i, ret, tot = 0;
 
 	for (i = 0; i < arr_len; i++) {
-		ret = snprintf(buf, buf_len, "%d", arr[i]);
+		ret = snprintf(buf, buf_len, "%u", arr[i]);
 		if (ret < 0)
 			return ret;
 
@@ -184,15 +198,15 @@ static int write_ints(char *buf, size_t buf_len, int *arr, int arr_len)
 	return tot;
 }
 
-static int make_rinit(struct tracecmd_msg *msg, int cpus, int *ports)
+static int make_rinit(struct tracecmd_msg *msg, int cpus, unsigned int *ports)
 {
 	int data_size;
 
-	data_size = write_ints(NULL, 0, ports, cpus);
+	data_size = write_uints(NULL, 0, ports, cpus);
 	msg->buf = malloc(data_size);
 	if (!msg->buf)
 		return -ENOMEM;
-	write_ints(msg->buf, data_size, ports, cpus);
+	write_uints(msg->buf, data_size, ports, cpus);
 
 	msg->rinit.cpus = htonl(cpus);
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
@@ -442,7 +456,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	}
 
 	cpus = ntohl(msg.rinit.cpus);
-	ports = malloc_or_die(sizeof(*ports) * cpus);
+	ports = malloc(sizeof(*ports) * cpus);
 	if (!ports) {
 		ret = -ENOMEM;
 		goto out;
@@ -450,13 +464,11 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 
 	buf_end = msg.buf + buf_len;
 	for (i = 0, p = msg.buf; i < cpus; i++, p++) {
-		if (p >= buf_end) {
+		if (p >= buf_end || tatou(p, &ports[i])) {
 			free(ports);
 			ret = -EINVAL;
 			goto error;
 		}
-
-		ports[i] = atoi(p);
 		p = strchr(p, '\0');
 	}
 
@@ -588,7 +600,7 @@ error:
 }
 
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
-				 int *ports)
+				 unsigned int *ports)
 {
 	struct tracecmd_msg msg;
 	int ret;
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 233d661..7798fe4 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -465,10 +465,10 @@ static int *create_all_readers(const char *node, const char *port,
 {
 	int use_tcp = msg_handle->flags & TRACECMD_MSG_FL_USE_TCP;
 	char buf[BUFSIZ];
-	int *port_array;
+	unsigned int *port_array;
 	int *pid_array;
-	int start_port;
-	int udp_port;
+	unsigned int start_port;
+	unsigned int udp_port;
 	int cpus = msg_handle->cpu_count;
 	int cpu;
 	int pid;
@@ -476,11 +476,11 @@ static int *create_all_readers(const char *node, const char *port,
 	if (!pagesize)
 		return NULL;
 
-	port_array = malloc(sizeof(int) * cpus);
+	port_array = malloc(sizeof(*port_array) * cpus);
 	if (!port_array)
 		return NULL;
 
-	pid_array = malloc(sizeof(int) * cpus);
+	pid_array = malloc(sizeof(*pid_array) * cpus);
 	if (!pid_array) {
 		free(port_array);
 		return NULL;
-- 
2.20.1

