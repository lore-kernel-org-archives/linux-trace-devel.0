Received: from smtpdh20-1.aruba.it (smtpdh20-1.aruba.it [62.149.155.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AC958AA0
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 20:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="FysGDLzI"
Received: from localhost.localdomain ([84.33.84.190])
	by Aruba Outgoing Smtp  with ESMTPSA
	id NfMErKua0Ppy1NfMErdWI1; Wed, 10 Jan 2024 21:39:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1704919166; bh=zCeYVN+x/zjmXHS/PkD18AAecb/nqdoYh2S5J/SwB1M=;
	h=From:To:Subject:Date:MIME-Version;
	b=FysGDLzIgV5xWCMDEpETTxtSdrn1rUEDjk5I4s9ptX3lv3oK2DQ4zYGLAKH6zenlQ
	 JNJhNv0Qdpcxj+tj7yvv/ba8q6h3zFXTJAcPPlHJvN2bVHEdRIc9JtZzBEwzO+vU/z
	 k/sM5iixcyKVVlDKrQeyu/el78MKxEy02Fileds2y1OCdkW+6YVdbc1L9b9jSQbC6P
	 YLf7mKmdfv7FyycJID3ihT7Ar3MHxc2X6ComsOgtFtBt3+KZP10TKD6JRrR1eoZWHG
	 a9OJgZH/TQCHg2nGn+EINIcmGb3T6sPmdZf6KdB3g7H9ae7pGlIjfKL/Q/pVsnIh4x
	 K4cPFo52Pqyzw==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH] libtracefs meson: build tracefs-mmap by default
Date: Wed, 10 Jan 2024 21:39:25 +0100
Message-Id: <20240110203925.266999-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfHvySdSfda8p8LTCTA6KZKHS0R8uUkoGknflxsvoRjN0DP8sZ+VZwdUXbPGzQNNxJXOmg6Vkqv0IKlN05W1RkRUIvLd/QNW5ZRdoDTZe6M342GEZR3+8
 BUpKBmMtCbHkG6x9k7v383HLDvaSD0Dnyei/10BNeIEcdW2kHx0pBkxYRZEdat6icVobf6EQIaq+wZ8r9ra8FCzmeuWucd50Q3CtntVPDcryWF3wj26o8GAb
 28iNNPjH7Wnwj4rfj602Qz4sawx7CHeT7ZzsgpTGfoP3OApV3pxJJYi1TPXO+txG

Accordingly to Makefile let's add tracefs-mmap.c to build, this is needed
for linking by other object files.

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
 src/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/meson.build b/src/meson.build
index 5b76554..f7a98b9 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -11,6 +11,7 @@ sources= [
    'tracefs-instance.c',
    'tracefs-kprobes.c',
    'tracefs-marker.c',
+   'tracefs-mmap.c',
    'tracefs-record.c',
    'tracefs-sqlhist.c',
    'tracefs-tools.c',
-- 
2.34.1

