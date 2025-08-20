Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F380626E71E
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Aug 2025 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755724816; cv=none; b=jWesZQKBdzV2ZfxmTwhPVWYEkAQqIUEq8UtUbN7pxv8fJkXhlitDpZ8NNzOIWV9PfIgCj20s5aKR/Z7Gx17oE1gRg7I9RUuDDdQPuppKOs8U1cwQ/U8sYhefCw/zlmZv+Y1tXwIepxZyeG9bdrbo1A0bPWdTAVJ2NfhTh2TkPxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755724816; c=relaxed/simple;
	bh=TiOe19I1L2jODrouKdVdjc4o+RcMbLMXA4NU8ZkDZgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gq3Wbyh3iPM292UtReqTc0Ip35OK7nL3KEWhkwN6ll1nOfR8r30KT3dETbl9wUdCOF4imnoLHxYqlQXS9MrEzlXIRhqdiMH6HIvH3xT7DUHtP5TLFtnSriEYaggsHXxCq4BELYVul006ZYqqtzR4zDZVrD/wfU875/Qn+x/tx2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=PUoA7f0F; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="PUoA7f0F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1755724486;
	bh=TiOe19I1L2jODrouKdVdjc4o+RcMbLMXA4NU8ZkDZgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=PUoA7f0F5KEp3ocd/P4RrbiwJ0w41surmZNuLM1ydRZ48fQDOZWSuxGsCifjOCBva
	 aOrehZbwgNZD4jud/prqRMUV3jMiA+E+MR9mC2ADuP8Tg4oxoHlW4oJbjvl29k2vLt
	 gKtBKrZO81k8Z0NbmWykEURifwX5eAqTDM7hI/+urqw6i3sJgOcR2qJe7K/k+1rQRg
	 gaIpZEWiHINlDGyMv1WIg++Vxnk8V8yZOjTLmNWbIOA9aTBaEkLql4N5F5YlhfnB79
	 R9Qo4iCDGPfVIASR5naYZL0zQAMIcivL7VUCYG0C0LXhWpfgauMl9Sy5vXalMBHaBT
	 lB6+haseqgFcQ==
Received: from integral2.. (unknown [103.216.223.55])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id ABF383127F83;
	Wed, 20 Aug 2025 21:14:44 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH 1/2] ccli: cache: Fix -Wuninitialized warning
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 21 Aug 2025 04:14:33 +0700
Message-Id: <20250820211434.1857859-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
References: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The idx variable is uninitialized and incremented. Clang warns it:

  cache.c:214:28: warning: variable 'idx' is uninitialized when used here [-Wuninitialized]
    214 |         for (i = 0; i < cnt; i++, idx++) {
        |                                   ^~~
  cache.c:184:9: note: initialize the variable 'idx' to silence this warning
    184 |         int idx;
        |                ^
        |                 = 0

Remove the idx variable entierly, it's not used.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 010ddbd1e722..97a24066bf69 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -181,7 +181,6 @@ __hidden int cache_save_fd(struct ccli *ccli, const char *start_tag,
 	char *str;
 	char buf[64];
 	int ret;
-	int idx;
 	int i;
 
 	if (!ccli || !tag || !start_tag || !callback || fd < 0) {
@@ -211,7 +210,7 @@ __hidden int cache_save_fd(struct ccli *ccli, const char *start_tag,
 	if (ret < strlen(buf))
 		return -1;
 
-	for (i = 0; i < cnt; i++, idx++) {
+	for (i = 0; i < cnt; i++) {
 		if (callback(ccli, fd, i, cnt, data) < 0)
 			break;
 	}
-- 
Ammar Faizi

