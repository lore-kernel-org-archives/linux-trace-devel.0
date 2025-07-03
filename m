Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A933292B25
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Jul 2025 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543703; cv=none; b=Rdx8t1Fvgl/nVrRtPwRcug0v6SlD0LmaV/OOln9ETDEsLByd6CPvplC5zNLV0Savc8rp+TW9j7MDgVA5xWEuu62lt8/pL76ivhn37RGVlGGULhosvS7eLFK2jI0ZbiZJifYHC9oNoZqQiXB5nsFOus0JH3Ros8gojtPk3zxjaDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543703; c=relaxed/simple;
	bh=z2F0o9jlSUimRdR62RZNj9prNldCtP3G+mafYOj65mc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WA4iFRgrZclPSx7yX0QdzMlpz7c0ePstltAlu6S3tiYpPJGFfmDq0tU3Jfsm7/677nCREWIiQfW3fvUg8WteqCtw1AKQE5j0GoG5LR1kpGh+QTL58gpTFNSTMOL6hmr1urXnauMigI/oH/TTPSfiFFP1rNDyd0FTIvLhCeP352o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xscnpzHA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xscnpzHA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:To:From:Content-Type:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7IyJLAm8j+/MqaNtLmcJSbgOGlgpt4h7TxH6YnHwSuU=;
	t=1751543702; x=1752753302; b=xscnpzHAYrHtfhyijWhQ2hIEPk9DJ6IBgNfZ/UE4IwEcWgY
	fdEXL5cS0a2irm0rrUarBAJue2/x5zOtqc4uqVaOSsRmU6VYZcSBVxoWhZTVsrF43gYjSMaaQbUFA
	NuUmYjZEYtuVVOLTr2bFS9uIUDoMAjl7ApDCuDNyiLdWwisY0WVbxjSvzbo8Lp3ZoSVbW+o9xV3xY
	1eOA0hau29jyJvpw8UfUD48Jlf3itfd5w5cuj21203MzLjpG8RzdmKlJWKvkGu90U44J7rS99tp4Y
	eCNBPzpOnsVyi8iCzMaWcHcWgsmGmuOQdU2SM1Y7PiHikCUYSq9bb5kBfS3TC+dQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uXIWj-00000005JaD-43L3
	for linux-trace-devel@vger.kernel.org;
	Thu, 03 Jul 2025 13:54:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: record: fix glob() return value checks
Date: Thu,  3 Jul 2025 13:53:35 +0200
Message-ID: <20250703115450.14313-3-johannes@sipsolutions.net>
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

Fixes: 6f1c80b937ee ("trace-cmd: Use glob() library call to enable events")
Fixes: 65b7fed7c15c ("trace-cmd: Add filtering of events")
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 tracecmd/trace-record.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b122579bc178..47486e9863df 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2248,7 +2248,8 @@ reset_events_instance(struct buffer_instance *instance)
 	globbuf.gl_offs = 0;
 	ret = glob(path, 0, NULL, &globbuf);
 	tracefs_put_tracing_file(path);
-	if (ret < 0)
+	/* no request flags, so only GLOB_NOSPACE and GLOB_NOMATCH */
+	if (ret != 0)
 		return;
 
 	for (i = 0; i < globbuf.gl_pathc; i++) {
@@ -3210,8 +3211,9 @@ static int expand_event_files(struct buffer_instance *instance,
 	tracefs_put_tracing_file(path);
 	free(p);
 
-	if (ret < 0)
-		die("No filters found");
+	/* no request flags, so only GLOB_NOSPACE and GLOB_NOMATCH */
+	if (ret != 0)
+		return 1;
 
 	for (i = 0; i < globbuf.gl_pathc; i++) {
 		int len;
-- 
2.50.0

