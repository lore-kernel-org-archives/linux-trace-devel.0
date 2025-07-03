Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9982D9493
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Jul 2025 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543703; cv=none; b=b5hKqDAWWENnm+4oM4FNU3ILU7yZVxf9BrYNFzQXojMdPzOw9mSVhuCWM3x7aluGSFVGbVVwlTb7d7EBLP9RrDewJOIUtfXWUK5X0KVyzzVtU60W0M4GhsKasFRR8in/nk/kseHfJ9f23Wqv4ZEyU2R43KnWjmpTkqiIqlFg1SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543703; c=relaxed/simple;
	bh=iYQPOVpoCqeit7enyGZSEs8QSR2k241bvv7kmx1jv2w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXhzx5F7rHiLQzZ5I9aXM02RN3C+SgHSMl3VGmv6JCT3eg999ssh3puTFfOmXrMnz7M98bIyaC7+VUIhDzCZ/5OTPENkW1rva4hIMTHMvRHsI6dWcAem0TfL89FYKhBlqapnzkpFEiqTkqs2NZ6iYkhcrf9V84Qf80W7UZmGAII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=MJKvISNH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="MJKvISNH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:To:From:Content-Type:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=89ex0WlZEbRwB3obKMWwapE7fxrG4KGPUTbWiaEZFT0=;
	t=1751543702; x=1752753302; b=MJKvISNHygwcFA/g8aHX+JEhNJpGjQHyDqaGPCnNAX3sGoI
	yfoHrtO8kZ05bJW78vKDvmJ2OGPz0uYNknEyKuXYeLPNe8Lk2Ig2RCBNvh166OfCRkZavhia5/Vo2
	02rPcvHwJPCWVlBHBQrfdoANAo67DEEFz3Dh4ObWSk6ABa+Fe7a4ljvw0Ql/g+CIXeK7GiPINBiBz
	zLmca0Nfi9x3PjoIr78tuyaeOYXjKXV9ZNP1EyDxtENndcgHZCwznjiLDURK4zNbLHCz3lF3gF6K8
	Znsn3NoOIwQ5NFL9SmfGwYR9R2WrYokCMc3fVuC31/imbJ8YY2N+T2j44HY04qwg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uXIWj-00000005JaD-1hgE
	for linux-trace-devel@vger.kernel.org;
	Thu, 03 Jul 2025 13:54:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: libtrace-cmd: fix glob() return value checks
Date: Thu,  3 Jul 2025 13:53:34 +0200
Message-ID: <20250703115450.14313-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703115450.14313-1-johannes@sipsolutions.net>
References: <20250703115450.14313-1-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

glob() is defined to return zero on success or various GLOB_*
error constants, but those are not defined to be negative. In
fact, glibc makes them positive, and as a result the checks
don't do anything at all on glibc, but erroneously abort on
other libc implementations (such as bionic) that use negative
values for GLOB_* errors.

Fix this to compare against 0 only, adding documentation as
to which error result codes are possible.

Fixes: 3de68e3ec662 ("trace-cmd: Only record the formats of the events being recorded")
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 lib/trace-cmd/trace-output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 00b87a196c16..c333553ebf67 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -882,7 +882,8 @@ static void glob_events(struct tracecmd_output *handle,
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
 	free(path);
-	if (ret < 0)
+	/* no request flags, so only GLOB_NOSPACE and GLOB_NOMATCH */
+	if (ret != 0)
 		return;
 
 	for (i = 0; i < globbuf.gl_pathc; i++) {
-- 
2.50.0

