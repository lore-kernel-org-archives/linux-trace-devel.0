Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A0638A72F
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 08:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780302050; cv=none; b=O4wDrCHBkUUF2bePiBKGkIoM8d0ZBwODDT9N7OC84Tt57FD+4MyUsifIA2p4FiZfueHbl2iFdd7ugMPA7qzSTFEsQHhr+SVXh5WpnyVtxOHWs5xMVhoyiKQHsqTgYytiedJiAA6SGFHB2/29J5ideVgI5NM7mSNU98BEBDwMvJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780302050; c=relaxed/simple;
	bh=oBk3Ps9P+UAgjVnsMuJy6p6hOUUbF92vOB8NPm+hR8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iy2e0Q990ErIVdZzA9o4UeiTjtghiYMEQ5Idj+FPzHzrpJePP0bXAUTz1nVRETsOQNgGF5X+k70QW6wegBAdhGzU3CUVQYoHE6HjoNztVcllTkbOgUbwslEuu/7qb+f70YdpJXEUav8ckKYWEg7ZhBizqo4tMbkZpgUC1PCTYIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YCNTpxsV; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YCNTpxsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=WQ
	8CVfFtcBWu7NAkfg1paT7jqHOErBJ+1CZDaPXkGKw=; b=YCNTpxsV4nBwgNbBfG
	aBRKpnx2A618JrCCSfnrcj9eJ9HdX/mDvR7/glNSUJwSCLtVMan1nnJHYoasn/eP
	XRh3KgwlvkqejTb0lS7tV4lMs8lc3yV/IoXY5Oophjx6SUUtclkvFxhXlDorBQJp
	/XemsBuDCqzJiarC10M5wnr38=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCXXZPKQB1qAUIdAw--.56782S2;
	Mon, 01 Jun 2026 16:20:29 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH v3] libtraceevent: avoid racing recursive builds of both libraries
Date: Mon,  1 Jun 2026 16:20:24 +0800
Message-Id: <20260601082024.12269-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260529140730.3ea1859b@fedora>
References: <20260405222102.9204-1-create0818@163.com> <20260406062855.58598-1-create0818@163.com> <20260529140730.3ea1859b@fedora>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXXZPKQB1qAUIdAw--.56782S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF18CrWUXw1xtF1fZw4xWFg_yoW8uF18pr
	W3Gr4akan7JrW8Aas7ZayxGry293ZFq3yfA3WjgF1F9w1rXF1rXFWfKrWkKF17A3yktFy7
	AwsY9wnrWFyDZ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRn2-nUUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCwA8lXmodQM8dpAAA31

A top-level parallel build currently starts separate recursive makes for
libtraceevent.a and libtraceevent.so. Both sub-makes rebuild the same
object files in the same output directory, which can corrupt the .o files
and make the final link fail with file format errors.

The src/Makefile already has the static library depend on the shared
library before running objcopy. Reflect that dependency at the top level
too by also making the static library target depend on the shared library
target. This serializes parallel top-level requests for both libraries
while preserving the shared-before-static build order and the existing
forced static-library recursive make.

This fixes the object-file race seen when top-level parallel builds
request both libraries, for example via `make -j8 libs` or
`make -j8 libtraceevent.a libtraceevent.so`.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217428
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
Changes in v3:
- Follow Steven's review and make the top-level static library target
  depend on the shared library target, matching src/Makefile's dependency
  direction.
- Preserve the existing forced static-library recursive make while
  serializing parallel top-level requests shared-before-static.

Tested on x86_64 Linux with GNU Make 4.3, GCC 11.5.0, and GNU objcopy
2.35.2:
- make -j8 libs
- make -j8 libtraceevent.a libtraceevent.so
- 20 iterations of: make clean && make -j8 libs
- 10 iterations of: make clean && make -j8 libtraceevent.a libtraceevent.so
- make -j8
- make -j8 test

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e1a10a0..d1ceaee 100644
--- a/Makefile
+++ b/Makefile
@@ -208,7 +208,7 @@ libtraceevent.so: $(bdir) $(LIBTRACEEVENT_SHARED)
 
 libs: libtraceevent.a libtraceevent.so
 
-$(LIBTRACEEVENT_STATIC): force
+$(LIBTRACEEVENT_STATIC): force $(LIBTRACEEVENT_SHARED)
 	$(Q)$(call descend,$(src)/src,$@)
 
 $(LIBTRACEEVENT_SHARED): force
-- 
2.39.5 (Apple Git-154)

