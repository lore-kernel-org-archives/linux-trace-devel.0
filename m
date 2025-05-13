Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD87B26C3B3
	for <linux-trace-devel@vger.kernel.org>; Tue, 13 May 2025 10:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131898; cv=none; b=KyOORlnHtcdAnQzxhGizoAIWA4hfHaPBN9e8NIpaEfJa37p3HDH6IWtokRubsHiWV9B6qeuz3IC+bKgqfbbuQSill5yqwRNauvFTQW+YtvOdq8P7I2dbIkDLPMwoE+uWh0+VggIOQaIqGzdBawwsbQ9rDslnCoN5GVXNWcMs2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131898; c=relaxed/simple;
	bh=zADfGL7DSVSMn7fBTQ2PIsb70DHjg0RQgiBVGAF9GFk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8kBM9UBFSeQZJFyFdsBOSL1oBBAuYNxr3kPdEeAhHPcI2vTprdqJI4PPRpYlI7M2fJM1PuNfGOv3dLAu4eOg+DtZChX8MnTaoBelWz+jEEZ6MVTbDXbsPsqAZOt88dOuSM9Z14zN65C3YFfUFvLgs5aEcPBbFVY8X3CKqYxiOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=InyBR0s+; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="InyBR0s+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=TT
	2VXBvRuAS2yGosi6NJvX6RPHNtr9n4ptKf+8d4C8E=; b=InyBR0s+Y6OvRZihKn
	QKHWUoITeaiXEE1Lh99lTmnKW36W2iwTQ6/v1m8lw1fLXNHWytn7nlBZIVi67SVD
	gLpoOJ32Tu0mvRGXR5t29oLlIoKKmo2erBxdTss/NaIlXWGjvH6FE6gGiyvRuJ4I
	8jpPUI/y8B0XrZh7DVUZMQq74=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wBXlOzxHSNoIutyBA--.524S2;
	Tue, 13 May 2025 18:24:50 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH v2] libtraceevent: Fix the /dev/null redirection compatibility in Makefile
Date: Tue, 13 May 2025 18:23:08 +0800
Message-ID: <20250513102427.36330-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXlOzxHSNoIutyBA--.524S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWkAr1kCFWfZFWfuFyUJrb_yoW8GrW5pw
	1xKFs0kw1DJ3yFq3y8ur48Gr1UJa1vqrW2vrnFq390yF1DX3WxXrZF9rW2kF43GrW5tFWS
	v3y0qayUGFW8Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUga9xUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiEQ5Ma2gi8EeJ5AABsp

The commit c2ea03541453 ("libtraceevent: Add trace.conf for ld.so if needed")
runs with below output message, and the built 'test' will not be removed as
expected.

  INSTALL     /root/linux/libtraceevent/lib/libtraceevent.so.1.8.4      to      /usr/local/lib64
  INSTALL      trace.conf       to       /etc/ld.so.conf.d/
/bin/sh: 1: /root/linux/libtraceevent/test: not found
  DESCEND            plugins

Use more compatible syntax to handle shell null redirection.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
v2:
  - Find the root cause why test is not removed as expected.
v1: https://lore.kernel.org/linux-trace-devel/20250513072617.20706-1-haiyuewa@163.com/
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 0afaef0..b559b6d 100644
--- a/Makefile
+++ b/Makefile
@@ -317,8 +317,8 @@ define install_ld_config
 	if $(LDCONFIG); then \
 		if ! grep -q "^$(libdir)$$" $(LD_SO_CONF_PATH)/* ; then \
 			$(CC) -o $(objtree)/test $(srctree)/test.c -I $(includedir_SQ) \
-				-L $(libdir_SQ) -ltraceevent &> /dev/null; \
-			if ! $(objtree)/test &> /dev/null; then \
+				-L $(libdir_SQ) -ltraceevent > /dev/null 2>&1; \
+			if ! $(objtree)/test > /dev/null 2>&1; then \
 				$(call print_install, trace.conf, $(LD_SO_CONF_PATH)) \
 				echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
 				$(LDCONFIG); \
-- 
2.49.0

