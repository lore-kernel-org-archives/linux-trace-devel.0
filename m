Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0076.outbound.protection.outlook.com ([104.47.33.76]:22824
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727554AbeIUSfU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 14:35:20 -0400
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] [virt-server] trace-cmd: Fix a minor bug in `trace-cmd listen`
Date: Fri, 21 Sep 2018 15:46:17 +0300
Message-Id: <20180921124617.31327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

There is a potential bug caused by C's operator precedence when checking
the flags set by `poll` in `trace-cmd listen`:

			if (!fds[i].revents & POLLIN)
				continue;

vs

			if (!(fds[i].revents & POLLIN))
				continue;

Curiously enough, the bug doesn't manifest itself since POLLIN is equal
to 1 and `trace-cmd listen` waits only for read events so no other flags
will be set by `poll`.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-listen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 7bc723e..c05c2d8 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -2020,7 +2020,7 @@ static void do_accept_loop(int nfd, int vfd, int mfd)
 				continue;
 			}
 
-			if (!fds[i].revents & POLLIN)
+			if (!(fds[i].revents & POLLIN))
 				continue;
 
 			if (i < FD_CONNECTED) {
-- 
2.17.1
