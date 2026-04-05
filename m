Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82AE26ED37
	for <linux-trace-devel@vger.kernel.org>; Sun,  5 Apr 2026 22:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775427684; cv=none; b=GXv6txle2Tbvldlb0ELhVQjsxAg2jSbyI53CURY4QN3g78JkxOj0Uph7iisfyTVu51DBwC3aFrEQj+Qg1zPFWPMRudZ99NpypvmN/ANWHRXwMx4Mphn1cERXN2pJciI8w+Rf0pIOmUkjNjpO/x6XCi2atLcg3hXqwlYe3HLoj7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775427684; c=relaxed/simple;
	bh=306TOm6inaZB8lGbwOTZM7rssgHhpli/vgleRRjau04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fUKG7AtwWDpyiG5Lrm+zeTwvXmIdGpetja0fFzsaHbF0Ay+Gta8wm7H9HyeXdeciQx10RyuxG/dp3RmGg5Ie7DzCeJHH2N87uzSlacd37zFn7IwX0KyUz8fnEr/9qplm3k3sAo+62JQLi0uNa4GAWsMlKUK3sXP8uT40AzUdvto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lqVZp6ns; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lqVZp6ns"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ax
	K9CkoA50p1AmlOOIjsYhQswqnVAxR3cN/yYS+Y4hI=; b=lqVZp6nsMezN9gWnMw
	GjKLdOkKzGbeSYBn+mYBBBnALBcNwNG2kquDcKRGvsDp7ccsEXGUvOc2Fvgw0aIi
	0RAcy7FNWtmDCmIeljz/sxnsXH9bwqsuLx1Yvt2MYcD+00acHPY8FN222Qdu7odX
	NZhewMufMlG2JGyafz6HYu6+8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3n8pU4NJpD7f+Uw--.6136S2;
	Mon, 06 Apr 2026 06:21:11 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	tz.stoyanov@gmail.com,
	create0818@163.com
Subject: [PATCH] libtraceevent: avoid racing recursive builds of both libraries
Date: Mon,  6 Apr 2026 06:21:02 +0800
Message-Id: <20260405222102.9204-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD3n8pU4NJpD7f+Uw--.6136S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF18CrWUXw1UtF1xtFWxXrb_yoW8WFWUpr
	WrXrs8t397JrW0v3s3ZryUGr1rJaykX390ga1jkw45ur45XFs3XFyIk3y0ga1fGa92yFy7
	Zw4vg3srKFWUZ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRO4S5UUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6BdclWnS4FeSMAAA3Y

A top-level parallel build currently starts separate recursive makes for
libtraceevent.a and libtraceevent.so. Both sub-makes rebuild the same
object files in the same output directory, which can corrupt the .o
files and make the final link fail with file format errors.

Make the default libs target descend into src/ only once and build the
shared library plus static archive from the same sub-make. Keep the
individual top-level library targets unchanged for direct use.

This reliably fixes repeated `make -j8` and `make -j8 libs` failures in a
Linux VM, where the unfixed tree reproduces the race within a few runs.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217428
Signed-off-by: CaoRuichuang <create0818@163.com>
---
 Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e1a10a0..faaeb6c 100644
--- a/Makefile
+++ b/Makefile
@@ -183,9 +183,9 @@ build := -f $(srctree)/build/Makefile.build dir=. obj
 
 LIB_TARGET := libtraceevent.so libtraceevent.a
 
-CMD_TARGETS = $(LIB_TARGET) $(PKG_CONFIG_FILE)
+CMD_TARGETS = libs $(PKG_CONFIG_FILE)
 
-TARGETS = $(CMD_TARGETS)
+TARGETS = $(LIB_TARGET) $(PKG_CONFIG_FILE)
 
 all: all_cmd plugins
 
@@ -206,7 +206,8 @@ all_cmd: $(CMD_TARGETS)
 libtraceevent.a: $(bdir) $(LIBTRACEEVENT_STATIC)
 libtraceevent.so: $(bdir) $(LIBTRACEEVENT_SHARED)
 
-libs: libtraceevent.a libtraceevent.so
+libs: $(bdir) force
+	$(Q)$(call descend,$(src)/src,libtraceevent.so $(LIBTRACEEVENT_STATIC))
 
 $(LIBTRACEEVENT_STATIC): force
 	$(Q)$(call descend,$(src)/src,$@)
-- 
2.39.5 (Apple Git-154)

