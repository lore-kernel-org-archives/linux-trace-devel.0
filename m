Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6521AC8A3
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Sep 2024 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072715; cv=none; b=LYRk06LhOhwXPc6Yg9SUk9IRR7ENdD4mhJ7n+cNmdybQzVn3SP7w54hRhXTFgenbrvQe7yFoB0da707HacgSvI9eoZ1jZe0CWRxaVvG44Rz/XpJ8s+TWHA6ud2erbosWCwSEvz5kyd4jJQM6PYTAahqhvif7wtx+nAvSu7jOr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072715; c=relaxed/simple;
	bh=EX2CQONuXimHsHk5cZsbZ5NAF2wsCQfbiChnzvkOWVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=avuy8eq6ShjNZ5+4p+ZqESg4r9jPhAYPwGCUuQgR4bvMuiouJRY9+EL2UaXc5yecCxpvHm/pb02wjN7ZLVIh2FkBYk0vvbO5iP+pph5Jt4iDBbIF1VkMaHuMbNZ1zptDKcrOP6SETl2PGH2w7Un/B0cseNl782QMAIO8/dV5AjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F1k9B+9r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4L0AnYKD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F1k9B+9r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4L0AnYKD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F1k9B+9r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4L0AnYKD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F1k9B+9r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4L0AnYKD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C714A1FD04;
	Wed, 11 Sep 2024 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1726072711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/xIwexRMKQe2eWmI1UZ5I1XlYzZ/TmN2IMne3nWayY=;
	b=F1k9B+9rfVbKbcQP2pgtdg6kC+42qmd9K9ZvA1QNJEl/ZyWmKrgnAmDgVD+BciehNxAu9Q
	klp9RyS2CXOWB5jZtZh4g4uOzsVvq2Su56Y0SfB0UJDAGsbhRaXnTH1JO+IJzEZlZk1dM7
	5OOPKix3JdA9hfoZFkM771q3zhClXnk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1726072711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/xIwexRMKQe2eWmI1UZ5I1XlYzZ/TmN2IMne3nWayY=;
	b=4L0AnYKDm+2mMDtvZNZRfbucosHz3K56ZqgyARdESDu7vboGds9KggI1/aHqju7RGTVYUO
	aCX08RQkRonoOQBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1726072711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/xIwexRMKQe2eWmI1UZ5I1XlYzZ/TmN2IMne3nWayY=;
	b=F1k9B+9rfVbKbcQP2pgtdg6kC+42qmd9K9ZvA1QNJEl/ZyWmKrgnAmDgVD+BciehNxAu9Q
	klp9RyS2CXOWB5jZtZh4g4uOzsVvq2Su56Y0SfB0UJDAGsbhRaXnTH1JO+IJzEZlZk1dM7
	5OOPKix3JdA9hfoZFkM771q3zhClXnk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1726072711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/xIwexRMKQe2eWmI1UZ5I1XlYzZ/TmN2IMne3nWayY=;
	b=4L0AnYKDm+2mMDtvZNZRfbucosHz3K56ZqgyARdESDu7vboGds9KggI1/aHqju7RGTVYUO
	aCX08RQkRonoOQBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B35CF132CB;
	Wed, 11 Sep 2024 16:38:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QLzJKofH4WZpBgAAD6G6ig
	(envelope-from <jjindrak@suse.cz>); Wed, 11 Sep 2024 16:38:31 +0000
From: jjindrak@suse.cz
To: linux-trace-devel@vger.kernel.org
Cc: jjindrak@suse.cz
Subject: [PATCH 2/2] trace-cmd lib: Use proper printf format specifiers
Date: Wed, 11 Sep 2024 18:36:53 +0200
Message-Id: <20240911163653.12606-3-jjindrak@suse.cz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20240911163653.12606-1-jjindrak@suse.cz>
References: <20240911163653.12606-1-jjindrak@suse.cz>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [0.20 / 50.00];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: 0.20
X-Spam-Flag: NO

From: Jaroslav Jindrak <jjindrak@suse.cz>

One of the warnings in out_write_cpu_data() printfs two
unsigned long long values as signed long long:

	tracecmd_warning("did not match size of %lld to %lld",
			 read_size, data_files[i].file_size);

This can lead to misleading values in a warning:

libtracecmd: Invalid argument
  did not match size of 3451486208 to -843481088

Signed-off-by: Jaroslav Jindrak <jjindrak@suse.cz>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 731f08dd..7b4b4b49 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2683,7 +2683,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
-				tracecmd_warning("did not match size of %lld to %lld",
+				tracecmd_warning("did not match size of %llu to %llu",
 						 read_size, data_files[i].file_size);
 				goto out_free;
 			}
-- 
2.37.1

