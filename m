Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29042C10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00BC9218A1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfCOPdh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:33:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40209 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfCOPdh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 11:33:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id u10so3936828wmj.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 08:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+95ue4h0XF2SQfChggwHPVhivTCCKzgRX9dQqzKrek=;
        b=JJSBhdcb2hqgkm0bzjSKU74cvuUKLPiTJ0Y3AnEh2Q0jJIDAJQxMxYnNokkScsWEyd
         eGSLK1C1LrjoJ3gld5RK+LFpSDhQ4qBVcZOl3TQw67L37WfPSdmpa/AExJeb48irv/o+
         /xXvWMUTWZ7oiNeVNzWcwL9gxQkcu6oUDt4NvY+iyPDoJ0Nm+YSs34O/ka0xnjJEfkov
         h25emBdGx6EsFCMrl9Y18RryCsoG+ZCSxzgEChQGvgon88MRUwJc/U4WMS0eB4Wzj85E
         R5uUphYyXExxm/l7jNPqxZDldX0atlBDOvzvaFpbwOyc9QWMY4piNvMq+LIM4wS8lS8x
         cSWA==
X-Gm-Message-State: APjAAAVa1LvG9C2VCdTLXuglLwEd5e79+sZqv/I0DK2NhRnFhqRWpjsJ
        CiZ86qH1U3K5WItFBybNCA==
X-Google-Smtp-Source: APXvYqw57xeJ2I+FKy/q7qyVlRA85A9ygLOhIeAyvvIlMeTD4Qyg6/9hjKhvPaLPdDFpIlQLegxwDQ==
X-Received: by 2002:a05:600c:2247:: with SMTP id a7mr2564124wmm.67.1552664015677;
        Fri, 15 Mar 2019 08:33:35 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a204sm2654221wmf.12.2019.03.15.08.33.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 08:33:34 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 2/3] trace-cmd: Use text encoding for transmitting ports in protocol V3
Date:   Fri, 15 Mar 2019 17:33:25 +0200
Message-Id: <20190315153326.5602-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190315153326.5602-1-kaslevs@vmware.com>
References: <20190315153326.5602-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ports are now encoded as text in the buffer at the end of protocol V3 messages.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 77 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 16 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 4b43849..48f1eac 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -104,10 +104,7 @@ struct tracecmd_msg {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
 	};
-	union {
-		be32				*port_array;
-		void				*buf;
-	};
+	void					*buf;
 } __attribute__((packed));
 
 static int msg_write(int fd, struct tracecmd_msg *msg)
@@ -159,19 +156,41 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 	return 0;
 }
 
+static int write_ints(char *buf, size_t buf_len, int *arr, int arr_len)
+{
+	int i, ret, tot = 0;
+
+	for (i = 0; i < arr_len; i++) {
+		ret = snprintf(buf, buf_len, "%d", arr[i]);
+		if (ret < 0)
+			return ret;
+
+		/* Count the '\0' byte */
+		ret++;
+		tot += ret;
+		if (buf)
+			buf += ret;
+		if (buf_len >= ret)
+			buf_len -= ret;
+		else
+			buf_len = 0;
+	}
+
+	return tot;
+}
+
 static int make_rinit(struct tracecmd_msg *msg, int cpus, int *ports)
 {
-	int i;
+	int data_size;
 
-	msg->rinit.cpus = htonl(cpus);
-	msg->port_array = malloc(sizeof(*ports) * cpus);
-	if (!msg->port_array)
+	data_size = write_ints(NULL, 0, ports, cpus);
+	msg->buf = malloc(data_size);
+	if (!msg->buf)
 		return -ENOMEM;
+	write_ints(msg->buf, data_size, ports, cpus);
 
-	for (i = 0; i < cpus; i++)
-		msg->port_array[i] = htonl(ports[i]);
-
-	msg->hdr.size = htonl(ntohl(msg->hdr.size) + sizeof(*ports) * cpus);
+	msg->rinit.cpus = htonl(cpus);
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
 
 	return 0;
 }
@@ -380,8 +399,9 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	struct tracecmd_msg msg;
 	int fd = msg_handle->fd;
 	unsigned int *ports;
-	int i, cpus;
-	int ret;
+	int i, cpus, ret;
+	char *p, *buf_end;
+	ssize_t buf_len;
 
 	*client_ports = NULL;
 
@@ -405,10 +425,35 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 		goto error;
 	}
 
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	if (buf_len <= 0) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	if (((char *)msg.buf)[buf_len-1] != '\0') {
+		ret = -EINVAL;
+		goto error;
+	}
+
 	cpus = ntohl(msg.rinit.cpus);
 	ports = malloc_or_die(sizeof(*ports) * cpus);
-	for (i = 0; i < cpus; i++)
-		ports[i] = ntohl(msg.port_array[i]);
+	if (!ports) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	buf_end = (char *)msg.buf + buf_len;
+	for (i = 0, p = msg.buf; i < cpus; i++, p++) {
+		if (p >= buf_end) {
+			free(ports);
+			ret = -EINVAL;
+			goto error;
+		}
+
+		ports[i] = atoi(p);
+		p = strchr(p, '\0');
+	}
 
 	*client_ports = ports;
 
-- 
2.19.1

