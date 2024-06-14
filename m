Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E81195961
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jun 2024 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718371316; cv=none; b=qmD/pMY9BzJ/biqnxDbCAcrSTeyNAi7wFVD+q8UwTE3ZDrUUVa6ssAL/UYdP3UP8oVGChqNucarZH5Yeq4HXHXPnaBHL1EZk5qAcf6Kjtrz/Sq6G0PhMxX42mq1O/FKBUuSJrDX76AHgoaZ/uQEYSzhXGr7q3BAC0YI7W4j7iR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718371316; c=relaxed/simple;
	bh=T5lbqSgoUlVJppUDbjWn15sPng7v0TZ5IGuCLjlCj5k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oUknWGIgc5AgHLt0aLjTliHlE7K0+diZVo+1u23BuR68dgVkUI1HNjsxMGhLl/Cu554IP3cc0YovMwnK75GPDZC8x+BTWaUFAqXmoDkTpZ2iA6Z0/q76uVmZshKDOqM1Shravj5PMUOT1FtM2X8qdTWkZQNsQRgDy//gtVSdvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7ZynTh3; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7ZynTh3"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57c714a1e24so2373220a12.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jun 2024 06:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718371313; x=1718976113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xAU0YTaZoG0JqSw7li4ueGU4vL0XevLML6KMFM2FF/k=;
        b=U7ZynTh3qAdfLQsQzF9bNFx9uKMmLNAnfWhkfjgAoKLy1gJbphvXmL3hTQUesvAV9k
         6gkyZn5Ufs2Lbhn2tF2zZxywRrxcPkJj8qHjj7S2g5utRzD7xhb4Olqq5BfseRPdzk8f
         ULHr2SQM1JdqFCbKCan64D9Xsxbnt1k3PSo+h+7HCK88rzItf79HxRqb/s22oR4JIorR
         2jMYnX2Lab8QiDeBAB/yXXIzMQLZHozN6uD+bDbqXMIWis6nJ6VxHki2SL+P7UDTIWKR
         ZPx9Hn+2/oBd+pe6eCmavQyJ1/b/7TgRe14dudIvmOUFJ8n8q1ESw2bWsCvRxIbBM28d
         xESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718371313; x=1718976113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xAU0YTaZoG0JqSw7li4ueGU4vL0XevLML6KMFM2FF/k=;
        b=NQxd6bSCWv1hyvnhEato99GcujJarSqMVwWtAOqd15KvzoH5ZI5dU+Ypdvtl1pLVuF
         QYFGXDF1bhoA2/EgvqwA5Inu2pDfuukdyBiT7Tr8aF5DycoHs3ZdvNUSIp9E+jytnfA9
         Ef4LfJl4rC5A67k/g2kKZdAIEozOfGmJ9Uc8yQ87GUA4NbwSSoKw1wJby6YeFeVxBeGj
         K8YbZDJT4h0oI0/Ug2i/dTeuWI1PVd+5kQuiIomKZOz9KwFY/DkE7nm249FxT/UjxfH1
         YxliB6EEXDLF5GQWqMZUSlehmAKa9JbAUuTwYOomSP7qV+qF5+jdtxc9E3BcfG5DCw75
         yuuA==
X-Gm-Message-State: AOJu0Yy3RGOi9faWFDgASjeSTe2DlMVfnhUMFHxasEFxt+bJg6dnA+b1
	nKzd0qydmmfg4JRakPir+2gM3Ez4yKnIKCSVRCt79o3oUkoL+/Qzm8YlXdoF
X-Google-Smtp-Source: AGHT+IEmr4vMAH2id8Ky4+KazW0x3/Q2iN+RK99PIv/39URfTa5sslk90jSp3bRPFLtRPiFyZX1B9w==
X-Received: by 2002:a17:906:1f0f:b0:a6f:5165:fedd with SMTP id a640c23a62f3a-a6f60d420eamr155208866b.40.1718371312891;
        Fri, 14 Jun 2024 06:21:52 -0700 (PDT)
Received: from danger39.cslcs.technion.ac.il ([132.68.206.104])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb741e879sm2248995a12.66.2024.06.14.06.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 06:21:52 -0700 (PDT)
From: avidanborisov@gmail.com
To: linux-trace-devel@vger.kernel.org
Cc: Avidan Borisov <avidanborisov@gmail.com>
Subject: [PATCH] trace-cmd: ptp-timesync: Turn off Nagle for TCP sockets
Date: Fri, 14 Jun 2024 13:20:20 +0000
Message-Id: <20240614132020.1797502-1-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Avidan Borisov <avidanborisov@gmail.com>

Currently, to establish a tracing session using PTP as a timestamp sync
protocol, trace-cmd sends overall PTP_SYNC_LOOP*NR_CPUS small messages
serially one after another. Due to the effects of the Nagle algorithm [1],
this will in effect send a message every ~200ms, resulting in
PTP_SYNC_LOOP(340)*200ms = ~68 seconds to process a single traced core.

Fix this by setting TCP_NODELAY on any TCP socket created by trace-cmd.

Example on a 32-core machine (host and agent on the same machine for
simplicity):

before:
$ sudo trace-cmd agent -N localhost -p 12345 -D
$ sudo time -p trace-cmd record -p nop -A 127.0.0.1:12345 --name
localhost -p nop -- sleep 0
Negotiated ptp time sync protocol with guest localhost
CPU31 data recorded at offset=0x245000
    0 bytes in size (0 uncompressed)
real 1968.48
user 19.15
sys 73.58

after:
$ sudo trace-cmd agent -N localhost -p 12345 -D
$ sudo time -p trace-cmd record -p nop -A 127.0.0.1:12345 --name
localhost -p nop -- sleep 0
Negotiated ptp time sync protocol with guest localhost
CPU31 data recorded at offset=0x245000
    0 bytes in size (0 uncompressed)
real 16.52
user 1.33
sys 1.52

This patch reduced the tracing time from 32 minutes to 16 seconds.

[1]: https://brooker.co.za/blog/2024/05/09/nagle.html

Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
---
 tracecmd/include/trace-local.h | 10 ++++++++++
 tracecmd/trace-listen.c        |  2 ++
 tracecmd/trace-record.c        |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 55934f98..1515fbbe 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -11,6 +11,8 @@
 #include <ctype.h>	/* for isdigit() */
 #include <errno.h>
 #include <limits.h>
+#include <netinet/tcp.h>
+#include <netinet/in.h>
 
 #include "trace-cmd-private.h"
 #include "event-utils.h"
@@ -470,4 +472,12 @@ void make_pid_name(char *buf, const char *pidfile_basename);
 void remove_pid_file(const char *pidfile_basename);
 void make_pid_file(const char *pidfile_basename);
 
+static inline void set_tcp_no_delay(int sockfd, int socktype)
+{
+	int flag = 1;
+
+	if (socktype == SOCK_STREAM)
+		setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &flag, sizeof(flag));
+}
+
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 5894a92d..308c1d9d 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -268,6 +268,7 @@ int trace_net_make(int port, enum port_type type)
 		if (sd < 0)
 			continue;
 
+		set_tcp_no_delay(sd, rp->ai_socktype);
 		if (bind(sd, rp->ai_addr, rp->ai_addrlen) == 0)
 			break;
 
@@ -1048,6 +1049,7 @@ static int get_network(char *port)
 		if (sfd < 0)
 			continue;
 
+		set_tcp_no_delay(sfd, rp->ai_socktype);
 		if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
 			break;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 91cc90d4..7d03f9d7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3415,6 +3415,8 @@ static int connect_addr(struct addrinfo *results)
 			     rp->ai_protocol);
 		if (sfd == -1)
 			continue;
+
+		set_tcp_no_delay(sfd, rp->ai_socktype);
 		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
 			break;
 		close(sfd);
-- 
2.34.1

