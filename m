Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99A5C282E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87AD720656
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfDVOz1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:55:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36090 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfDVOz1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 10:55:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id h18so14780832wml.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 07:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=StKuM867XgrebhpYN0AB/uVWIi+9iYkIqTDPj4K+w94=;
        b=D/ZDukiFZg3vOu0DZfBQrURBZU3X0MlEXzrHAvbo+/yjHfBt9GPZYD7iZ4cwmPJhkw
         TP3dSN/ROZdx2L+NO3C+Cf8PcVQV9u948P176hBw+lzIve2HH/B9269MJY6yws4odDCl
         ElBYxzmb2Iu2tbuKnz3ckz6kYloLgHXCK7LTtlFSAZF8I1IwXhxg7yhAN5LKZa2gAeaQ
         EAXm0GnR3Lc6HCFzA+3bD6U8iQI+ZeZBOjN3zcOZ5NpC/40IgP2V3wWrkMaBhkPc6xNv
         JjPKoC5isUFzkgfS8UWol+SPsT0DHnwQOOKtKBQ8hK5EMZ73528tZhIxQ3hoyUKwlSHW
         hpDw==
X-Gm-Message-State: APjAAAVO3Qs/6Pkd5jaPosun36gt7JWSGRNRwlLVo+1QM3+MkcLu2Mbf
        Wvn6Tbmqbn+/YHyRSFMZZaYv7DiRZg==
X-Google-Smtp-Source: APXvYqzmAS+8TnUFuq6Z8CSwa97KaJNCCBAa6NxoXRvUT2w25X5g764p49/6kpxTCnxBlpUGnEpo/A==
X-Received: by 2002:a1c:a8d3:: with SMTP id r202mr13135680wme.106.1555944925373;
        Mon, 22 Apr 2019 07:55:25 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f128sm17321087wme.28.2019.04.22.07.55.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 07:55:24 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 01/12] trace-cmd: Make ports unsigned int
Date:   Mon, 22 Apr 2019 17:55:08 +0300
Message-Id: <20190422145519.16146-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422145519.16146-1-kaslevs@vmware.com>
References: <20190422145519.16146-1-kaslevs@vmware.com>
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
 tracecmd/trace-listen.c       | 10 +++++-----
 tracecmd/trace-msg.c          | 32 ++++++++++++++++++++++----------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ceb03f4..98d8933 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -326,7 +326,7 @@ int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
-				 int *ports);
+				 unsigned *ports);
 int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 8bd7bad..ce975c8 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -517,10 +517,10 @@ static int *create_all_readers(const char *node, const char *port,
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
@@ -528,11 +528,11 @@ static int *create_all_readers(const char *node, const char *port,
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
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index e2dd188..74c0bc1 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
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
-- 
2.19.1

