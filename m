Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44372 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbeJCPPP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 11:15:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id 63-v6so5062716wra.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Oct 2018 01:27:54 -0700 (PDT)
From: slavomir.kaslev@gmail.com
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] [virt-server] trace-cmd listen: Use sockaddr_storage for client addresses
Date: Wed,  3 Oct 2018 11:27:43 +0300
Message-Id: <20181003082743.12526-1-slavomir.kaslev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Slavomir Kaslev <kaslevs@vmware.com>

`trace-cmd listen` is passing a pointer to `struct sockaddr` to `accept`
with `addrlen` larger than its size which may corrupt the stack.

Switching it to `struct sockaddr_storage` provides enough space to store
both TCP and UNIX sockets address.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-listen.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index c05c2d8..2f2cecc 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -1956,7 +1956,7 @@ static void release_fds(struct client_list *manager)
 static void do_accept_loop(int nfd, int vfd, int mfd)
 {
 	struct client_list *client;
-	struct sockaddr addr;
+	struct sockaddr_storage addr;
 	socklen_t addrlen;
 	char *domain = NULL;
 	int timeout = -1;
@@ -2024,12 +2024,8 @@ static void do_accept_loop(int nfd, int vfd, int mfd)
 				continue;
 
 			if (i < FD_CONNECTED) {
-				if (i == FD_NET)
-					addrlen = sizeof(struct sockaddr_storage);
-				else
-					addrlen = sizeof(struct sockaddr_un);
-
-				cfd = accept(fds[i].fd, &addr, &addrlen);
+				addrlen = sizeof(addr);
+				cfd = accept(fds[i].fd, (struct sockaddr *)&addr, &addrlen);
 				printf("connected!\n");
 				if (cfd < 0 && errno == EINTR)
 					continue;
@@ -2106,7 +2102,9 @@ static void do_accept_loop(int nfd, int vfd, int mfd)
 			}
 
 			if (i == FD_NET)
-				pid = do_connection(cfd, &addr, addrlen, NULL, 0, NET,
+				pid = do_connection(cfd,
+						    (struct sockaddr *)&addr,
+						    addrlen, NULL, 0, NET,
 						    NULL);
 			else {
 				pid = do_connection(cfd, NULL, 0,
-- 
2.17.1
