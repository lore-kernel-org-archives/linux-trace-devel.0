Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85408C31E5E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2F520B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdRbV+/y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbfFROkK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55282 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfFROkK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so3580077wme.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h3zHanV9Lcef9Grtff/alPeCfWAomyQ2iLYAuQfEf6c=;
        b=IdRbV+/y5RCFIMZxcRKdD1zG/oIrZkjeZKcqbUeT1TlYaFLbcfwsev6p7RYbhyyB62
         jfY3lsSCTL9qSa1Y3R40JXNfMkyfQ8phuNA/DHVIk2Ln23KZTrPKMZBsQrTRdEHslpFD
         6Hd10wBTLQ+38WEoNsYsOagF0emL/DQI9f0YqcqgjqGFvUcfo06ezpdlBvwjvaCLqNl9
         gU1mT87DbDsaJy9Pl6XTTWcc5F3r04dpMhsBpXyj898JJe6zhsVD5vSJR+ohEDi1raLY
         iVbmIsAe+zHkd3kqpAnC9Ty/b2/1Diz9BbEvhgyppnlJeab6py/qyqg5K/YvS+Wb9R8Y
         gG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h3zHanV9Lcef9Grtff/alPeCfWAomyQ2iLYAuQfEf6c=;
        b=bpH685thi/yTaxATsnshuAa2B5JC/tEMMpBEGpMg4zk2MuTU88Tka5maJgJI9t5YNZ
         9eHPFP0Nh+hjAIsLCaqzghNRaMsUMMJy4J6Rnkz0LXUIvzqRQ5+6sxiSZxHfbhnjK4fj
         0QwC+mtcSGA3ja8ND4O/ItfvWPEHNurZ58VwkHcCRvo1FdKUaOuYLl68b7hvxueKmf6z
         KaKFuaaAvyKnqj2UOoF3kmhhNl8azcxQwYk7UJ0rvoLozEdkhDhOQX9AVhYiGC7plvSE
         DlALKbRl58+M8WMp5vkRA9ullea4L20hPKO6Z/aINKah7xX0RP6v9dfNF8CxmKcFJea3
         RZ1Q==
X-Gm-Message-State: APjAAAXw6VD1nkNvJPRqFQ3rXQ4+NHvFugXiZj4JHV2F56tM5RFh7ya1
        W91WCzycqm9ly0VGH/QIJQ==
X-Google-Smtp-Source: APXvYqwPpQFpd8zCGo5AvYd2r1AjMYprcCaDQahw/IbVSztRmOFZLkuUDgX0jeGq1FZViWE56g1EJQ==
X-Received: by 2002:a1c:be0a:: with SMTP id o10mr3991578wmf.91.1560868807762;
        Tue, 18 Jun 2019 07:40:07 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:07 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 01/13] trace-cmd: Make ports unsigned int
Date:   Tue, 18 Jun 2019 17:39:46 +0300
Message-Id: <20190618143958.2865-2-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
References: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Switch ports data type to unsigned int since vsocket ports are 32 bit unsigned
integers and sometimes cause overflow when stored in int variables.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 +-
 tracecmd/trace-listen.c       | 10 +++++-----
 tracecmd/trace-msg.c          | 32 ++++++++++++++++++++++----------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f62ab9..923015e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -328,7 +328,7 @@ int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
-				 int *ports);
+				 unsigned *ports);
 int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 3106022..e34df08 100644
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
2.20.1

