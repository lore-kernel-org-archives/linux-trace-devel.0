Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E2D3DFC62
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jun 2026 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780671206; cv=none; b=JD0xbo9TEDTwbG/RwU0Ax5JSW3N1ulUY2c+60LaHb2KiL8+Fr+1vywws6xQVPFl4ZqkApxMOrlq1MKL7VEwadpZd2YkOveNdXtTCIPuZysF3GEcB2wcC71xAmQiZLLZTuVEGr/gsrIn7yGi3UxWIalzRyWgioqTqhdJSuu9aDvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780671206; c=relaxed/simple;
	bh=v9r4e5MYaiidmjvX7YaZnRSuif7xnwgmjuQLrFFEFQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MTOwAxbj5PVXVDCLyMeHJB9dmPinen3Tk82qVNqjtriyuzYYscTmi+EDyQHcGo0EBz5SGCJ5f0FEP39H4N6SJXW+bkFMyJvZrfrh+N/uvTNOgk64rTtJDBKcsvscQALRsNnWMATsOaA3fwIiqTHlT7fWxMUOnj3WY/0XQzFqhCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=posteo.de; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 9705E240101
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jun 2026 16:53:21 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gX4Dx1b2Zz9rxG;
	Fri,  5 Jun 2026 16:53:21 +0200 (CEST)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 1/2] libtracefs: Use LIBTRACEFS_STATIC for utest
Date: Fri, 05 Jun 2026 14:53:21 +0000
Message-ID: <20260605145309.2586533-1-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The top-level Makefile already sets `LIBTRACEFS_STATIC`. To allow
overriding the static libtracefs library using just this variable, use
`LIBTRACEFS_STATIC` in the utest Makefile as well.
---
 utest/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/utest/Makefile b/utest/Makefile
index f10b709..9bd3dea 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -10,9 +10,11 @@ OBJS =
 OBJS += trace-utest.o
 OBJS += tracefs-utest.o
 
+LIBTRACEFS_STATIC ?= $(obj)/lib/libtracefs.a
+
 LIBS += -lcunit				\
 	-ldl				\
-	$(obj)/lib/libtracefs.a
+	$(LIBTRACEFS_STATIC)
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
@@ -21,7 +23,7 @@ $(bdir):
 
 $(OBJS): | $(bdir)
 
-$(bdir)/trace-utest: $(OBJS) $(obj)/lib/libtracefs.a
+$(bdir)/trace-utest: $(OBJS) $(LIBTRACEFS_STATIC)
 	$(Q)$(do_app_build)
 
 $(bdir)/%.o: %.c
-- 
2.53.0

