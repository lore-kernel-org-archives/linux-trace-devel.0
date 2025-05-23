Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C302F294A0B
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 May 2025 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748022564; cv=none; b=HCNQYTt25pLknHF1cUgr8nmEaK8k0UWSuoIDZQwZuxcbP9B2pEkB9hHYVYF9s2lxqH8uPYjz/vYJkzb+kdmOEnx2i4sZAmy0I3/xi1J6N6Gp7TJ2CfrgAsUCFnwams9+qAXzYNZNgDCdHNIYU31QYQPDnsKIPPs5BIAnMdBdDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748022564; c=relaxed/simple;
	bh=at2la3Qzac9X3+nKwe17v+DTirMSfUP96I+4dm/irAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pyyg3fubCcS4ggeiB7Ax5YsU5jGnIHHGjZTPVmAfG+X55AO3M6fkS9pL5xcDdyhCE7zBujjV+0TwFWdm5TcsoKsg3BaGaHyZxFIFsK/J9UxVMqUD9G7RyY4ghbnS3Urd5/d7IHzGhszMjldmkZfjCXg+rUmRpcwTL17H4XzPwHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QJvY/y8l; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QJvY/y8l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=WG
	1yCRhkIYHNGCPC10xFbIj1ts+SCdzNGeVLcttB2p0=; b=QJvY/y8lMOVrFRvQoi
	c/RxjEZu90PGGqMmjQyeGOUwlb5O5sVZMMMjKZ1FNhNbw4i6t1VjW9rcrPUmmXDX
	IByS2gKeQYPmT8Q+72XKy6yNF4RLlD1xtbo4ucb25dIN98f7GlxDfdymVALUx7/T
	5Fk6GNIixoOnKP8gSF/rMbk1w=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCXeWUctTBox4kcDg--.15923S2;
	Sat, 24 May 2025 01:49:16 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH v1] libtracefs: Fix the /dev/null redirection compatibility in Makefile
Date: Sat, 24 May 2025 01:47:24 +0800
Message-ID: <20250523174850.471638-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXeWUctTBox4kcDg--.15923S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr4rJFW7tr1DAF1fCF18uFg_yoW8JFy3pw
	18KF4qkas0qay0qFZ7ur1DXr18Aa1kt34jvr9Fq342vFWqqay7WrsF9ry2kF1fKrWYyFWS
	93y8WFWUJryUXwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUga9xUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiShtTa2gstYOYXgABsc

"&> /dev/null" is bash shell syntax, use more compatible syntax to handle
shell null redirection.

/bin/sh: 1: /root/linux/libtracefs/test: not found
In file included from /root/linux/libtracefs/test.c:1:
/usr/local/include/tracefs/tracefs.h:11:10: fatal error: event-parse.h: No such file or directory
   11 | #include <event-parse.h>
      |          ^~~~~~~~~~~~~~~
compilation terminated.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
The same fix as for libtraceevent:
https://lore.kernel.org/linux-trace-devel/20250513102427.36330-1-haiyuewa@163.com/
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index c407589..95bf219 100644
--- a/Makefile
+++ b/Makefile
@@ -274,8 +274,8 @@ define install_ld_config
 	if $(LDCONFIG); then \
 		if ! grep -q "^$(libdir)$$" $(LD_SO_CONF_PATH)/* ; then \
 			$(CC) -o $(objtree)/test $(srctree)/test.c -I $(includedir_SQ) \
-				-L $(libdir_SQ) -ltracefs &> /dev/null; \
-			if ! $(objtree)/test &> /dev/null; then \
+				-L $(libdir_SQ) -ltracefs > /dev/null 2>&1; \
+			if ! $(objtree)/test > /dev/null 2>&1; then \
 				$(call print_install, trace.conf, $(LD_SO_CONF_PATH)) \
 				echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
 				$(LDCONFIG); \
-- 
2.49.0

