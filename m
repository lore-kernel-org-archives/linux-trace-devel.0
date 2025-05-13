Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDBC74059
	for <linux-trace-devel@vger.kernel.org>; Tue, 13 May 2025 07:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747121208; cv=none; b=p3KvDdVcTFAMgIgkP0M2Uo6e7L1II3KFI8fkj6XHIy+tq7ELWPOtdvA/SRKbEtl8E56AKp/sIY/Um36iWwzmbCAnuLWvS1SyoCsyp0fXHmaJSf3U15MnoyqLYtc92NIa5PxjHrMCx0TxlC0uxFb9gl73qyoEdTBwBlTHo0sN6Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747121208; c=relaxed/simple;
	bh=jYW8xe6uuAo7G6MZvgkBty6OLwi9MFFXn+i2OfEWjIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tB+ycV7b4sn//Q6i6VKuznLPiEd9KLxIXZHmmFzFFWi6bs5LnY8nSOjOxUV1uQRaYupYDnj8cymixnFo+JbR8Ce3nVybSLgWRn4QE6h7m1dQDtH7yR3O1qTnSlYM0sAEcpNQQUR3NGwh48iQdcQGTzO2MS+VaX0IrVx5Z4JnIV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LvSxqDPm; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LvSxqDPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3/
	L51P/Vh/vwQetcIBlTQ5DdDG/d1Kkb5vf4SucZJb8=; b=LvSxqDPm+2mrdT3DBY
	s3lzAYbg+X/62Wa+tzZBVSSAd3cuq+gr/VYN7UW0FWqyKXCn3F+QdDCEfl9ldSic
	zqMwFAjubLF+SEGPpxTBtuvn3dcrdzwxaAzOB9xmjEsZcOR0OkDbgh8va+7Semfa
	l6/q6RmBo4sobN6YiQVrKlrk0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wC3H7Uw9CJov9VSBA--.33876S2;
	Tue, 13 May 2025 15:26:41 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH v1] libtraceevent: Add the built binary test to .gitignore
Date: Tue, 13 May 2025 15:26:03 +0800
Message-ID: <20250513072617.20706-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3H7Uw9CJov9VSBA--.33876S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRROJeDUUUU
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiEQRMa2gi8EeJ4wAAsl

The commit c2ea03541453 ("libtraceevent: Add trace.conf for ld.so if needed")
will generate file 'test', add it to .gitignore to make git status clean.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 39a013b..a5ad234 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,3 +16,4 @@ build_uninstall
 ep_version.h
 libtraceevent.pc
 lib/
+test
-- 
2.49.0

