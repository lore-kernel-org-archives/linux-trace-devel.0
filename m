Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE037083C
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775489565; cv=none; b=lUH++Natafr/3CCylRG6OL6iZ30CP7hCvFz8xc5ZFm+/majTAc8s+tn7HiB2h9AEgeSjCZ3Vw0RAr32zF3XZmmYxiRV2o30z806getoi89ocwwlY8X0CN3MyRi7hl95sQqKZQHXfY292Ki5SlZYBx/+cvYppTIwEYFD4sVQEl6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775489565; c=relaxed/simple;
	bh=YEPeK+rOZUxz/1zyI//uloL6+iCJ2aNYrEYo02d3Fus=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iYYmp16LC6hXRP7wearhqAyRKp70rIiYeTPZyqtwIVVbi4U3+H9KeSQ/tEPI/p+y9uAoywmfAGqN9l6GSl3F6Ik9V2WCD9NVNqlPJ1TmTjdb7AxQqfP+BSofCmuLtV+SHADOf1sXR136CksU8GdgWi+/hiAVP2bAibsApzmNFZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=OvCye8Ok; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="OvCye8Ok"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=HA
	Uic2bLjJg8vkH+BKKWsdgG3wSTtDAD440RD/8KPXI=; b=OvCye8OkaXH1mpog5t
	zF0Xe2FWSdleWCWQsuj78kcmJairtp3OsPB/xZE1k07kJtkD9O7S32YRAI+imCrh
	4NqMdqXCFLbCaOHJW3oow3F3MKwNfB0WGPRyYgct45AcwVFaBU+2XLwgv9aGHoj1
	wLj7O0eAZpGxsjvQ9x+Em1M6E=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgD3X_kK0tNpJsOqUA--.6632S2;
	Mon, 06 Apr 2026 23:32:28 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	tz.stoyanov@gmail.com
Subject: [PATCH] trace-cmd report: add spacing before raw data flags
Date: Mon,  6 Apr 2026 23:32:21 +0800
Message-Id: <20260406153221.33256-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgD3X_kK0tNpJsOqUA--.6632S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrGF4ftryxtw18Jw1UZw43Wrg_yoWxGFbEga
	4xXa1qkrW5GF9xZasxKryavr1UXr45ur15Aw1FyFWDA3y8Jw48Ga90qws8Kry8Grn0gFWx
	tasxt34Syw4SkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjEksPUUUUU==
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCwAwHQGnT0gyVUAAA3q

Signed-off-by: CaoRuichuang <create0818@163.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 355ee0f4..962ebd89 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -871,7 +871,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 			TEP_PRINT_CPU);
 
 	if (raw_format)
-		trace_seq_printf(&s, "-0x%x",
+		trace_seq_printf(&s, " -0x%x",
 				 tep_data_flags(pevent, record));
 	else
 		tep_print_event(pevent, &s, record,
-- 
2.39.5 (Apple Git-154)

