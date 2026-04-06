Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C18429B78F
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 06:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775456964; cv=none; b=kFJwo6zURcQ77g6D3HE3C4a3U1Gk9UcHzR36RjifnK3rD/eED5iJMXmfhnznu73QAlPXQ9MGCIJ3hxqiymcY3FT41CZagCcSzowiycb3NE47bGVbianPCAmc5quQFi9XXMzaw6fYAaDdQNN8CrV/R6j35o8ugQcNAa7nXlmkKag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775456964; c=relaxed/simple;
	bh=1vKwbNKsH+KdxBMROjwpVpmPVlMgGBix/GCkDP95HSw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=taIoBAHvRxjdAQ8KLWxVKpI+emaBrry9IV12QdTTOwKNPcFpiRm4i0vltIPcS4in2QUmEacGf1XCRTCvFh+Bk5yv51MRjPoH4G9Ha03vbGgpz9n4sfXt67mVgCFA2rpH43kWVK5zRByU/FVXQVQ+RClLESSN40hWRBq2tP8OJTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=f+nD5a80; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="f+nD5a80"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=AD
	vcWqhmT769+eFq6qqmNNzOdQoVhvqrF6wPZVsu0v8=; b=f+nD5a80hUk2dAPJdU
	a1vyjU1NoAziIqFXVbcAN+g5N1LcmSewFfvP86Iu5ksjHbOZGtg+OhLhATRht5Pb
	YXkYfbY/fdr6tbwWfkv0NWaWUS4ca9jlxY7DZEXOHIThzRnh7OWcpq53SSTa529M
	7hTFuR19EozoaGwWDdIsY7o60=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAHDamtUtNp9Bx3Dg--.49875S2;
	Mon, 06 Apr 2026 14:29:03 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	tz.stoyanov@gmail.com,
	create0818@163.com
Subject: [PATCH v2] libtraceevent: avoid racing recursive builds of both libraries
Date: Mon,  6 Apr 2026 14:28:55 +0800
Message-Id: <20260406062855.58598-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260405222102.9204-1-create0818@163.com>
References: <20260405222102.9204-1-create0818@163.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAHDamtUtNp9Bx3Dg--.49875S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF18CrWUWr15Ww4DKrW5Awb_yoW8Xr1Upr
	W5WrsxKw4kJrWIv3Z7Z3yUGr1jvasYq393t3WUWw1rur45XF4UXFyI93y8WF4fA3yktF9F
	ywsY93sFgFyUXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRO4S5UUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6BAQSWnTUrARwwAA3r

A top-level parallel build currently starts separate recursive makes for
libtraceevent.a and libtraceevent.so. Both sub-makes rebuild the same
object files in the same output directory, which can corrupt the .o
files and make the final link fail with file format errors.

The src/ Makefile already builds libtraceevent.so as part of the
libtraceevent.a target. Reflect that at the top level too by making the
shared library target depend on the static library target, so parallel
requests for either or both libraries funnel through a single recursive
make.

This fixes repeated `make -j8`, `make -j8 libs`, and
`make -j8 libtraceevent.a libtraceevent.so` failures in a Linux VM,
where the unfixed tree reproduces the race within a few runs.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217428
Signed-off-by: CaoRuichuang <create0818@163.com>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e1a10a0..6649303 100644
--- a/Makefile
+++ b/Makefile
@@ -211,8 +211,7 @@ libs: libtraceevent.a libtraceevent.so
 $(LIBTRACEEVENT_STATIC): force
 	$(Q)$(call descend,$(src)/src,$@)
 
-$(LIBTRACEEVENT_SHARED): force
-	$(Q)$(call descend,$(src)/src,libtraceevent.so)
+$(LIBTRACEEVENT_SHARED): $(LIBTRACEEVENT_STATIC)
 
 $(bdir)/libtraceevent.so: $(bdir)/libtraceevent.so.$(EP_VERSION)
 	@ln -sf $(<F) $@
-- 
2.39.5 (Apple Git-154)

