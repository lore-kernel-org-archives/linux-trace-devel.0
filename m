Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66D1C10F00
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFE392133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbfDBNps (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:45:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42829 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732130AbfDBNps (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id g3so16729276wrx.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZarxYjbFS/cswD3mXUJHcLhnIDuxZxE6SxoVEFLaO5w=;
        b=XCKbg/QhjdLbqiW8jLX1dDRGjEKB4hy+YRhwKAY59zqIc2HOBsFLQvy5i8dRvxB4mc
         IJBbCfz7dXLmGiVna8ZUsaAYJ7wIwkkwpoU2mjfliABzwN8PrA77brFZ1A03yabg9n9y
         GfzxoUvMzmLTybr6BzQDg2i5nc+HHcPur28CqvwURyp7XHxv0azQTsN4du01seKOqFSo
         UsmMMXtBEHSCbveUVMrWtPPmsv564O21eADKfLbWCRGyqBSelqBnfGl+25TX/viAfJm7
         wbBwBMxoAP9UrjORsrkydFQddyTTEpgE6fZddQQAqeqnw/X/c/MrXqDapa4iu4sFYlCC
         KVlA==
X-Gm-Message-State: APjAAAVt+xT/6tmnUehZ8zbZR9fnJNH5DvK+B9jVo/+gyzqmiL0zma71
        1AIrmj3BTWYClZyjFc35ag==
X-Google-Smtp-Source: APXvYqwacLlPvEuYflvM5kPZmGSZ6CWTySkqLjIEYWq/uEM8zeKq8nt9NQt7Qzvn9RjjNlNhcye1Ag==
X-Received: by 2002:a5d:52c6:: with SMTP id r6mr20980836wrv.131.1554212746513;
        Tue, 02 Apr 2019 06:45:46 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:45 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 01/11] trace-cmd: Make ports unsigned int
Date:   Tue,  2 Apr 2019 16:45:30 +0300
Message-Id: <20190402134540.32321-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134540.32321-1-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
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
 tracecmd/trace-msg.c          | 28 ++++++++++++++++++++--------
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ca4452b..9cfb987 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -324,7 +324,7 @@ int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
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
index e2dd188..461b6cb 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -161,12 +161,24 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 	return 0;
 }
 
-static int write_ints(char *buf, size_t buf_len, int *arr, int arr_len)
+static unsigned int atou(const char *s)
+{
+	long r;
+
+	r = atol(s);
+	if (r >= 0 && r <= UINT_MAX)
+		return r;
+
+	return 0;
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
 
@@ -184,15 +196,15 @@ static int write_ints(char *buf, size_t buf_len, int *arr, int arr_len)
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
@@ -442,7 +454,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	}
 
 	cpus = ntohl(msg.rinit.cpus);
-	ports = malloc_or_die(sizeof(*ports) * cpus);
+	ports = malloc(sizeof(*ports) * cpus);
 	if (!ports) {
 		ret = -ENOMEM;
 		goto out;
@@ -456,7 +468,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 			goto error;
 		}
 
-		ports[i] = atoi(p);
+		ports[i] = atou(p);
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

