Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2E219F108
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Sep 2024 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072699; cv=none; b=Y7Q4n2i8fn7cImIIRGzQEqTiTum1Vddga1PpAOUGKFqqlkEa7Td8z1Go3T5rbxxETqgpz92HWFKrr/dODekRIDk4HRoOyz4Jy3KYCxNVe0+fSW7vJZBTTNx5ldW/RkknmErdgba0YKBhJRYzjvFV1TAIHZll+8g2D5vYHBP9Fis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072699; c=relaxed/simple;
	bh=JWEaOM7tH4RDZnT7IoyE7sSxyrkqVWpCNHuv8y9+vvU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OHEnAzqOMejgeYVkeC571dPJv7irzwcWajklvP3O5E0EKU3Iq3SskT5rgaeV9GrIb5rhrFH/YJtox/j0+eq+VM5j9NmccORpikKsNHJYmxGSryPDKMw68X1QS3xgGsrorfDQqMj1WWgbJsz8j7lhUhFEqs9lt2KFyS7SRIQwbu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AEo2Mgqn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lhlSPE54; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AEo2Mgqn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lhlSPE54; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AEo2Mgqn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lhlSPE54";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AEo2Mgqn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lhlSPE54"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B37821A7C;
	Wed, 11 Sep 2024 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1726072695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RgykzFLGKbwlXxiKhzE/Xg+Ou0Sa6IH+/K2x9RLEyXw=;
	b=AEo2MgqnkTXgW7oo9i4z9gtkG7L4zn5Gvt37pQskFlhqN4KajB7p5nYgTkemjZn1dESOij
	AOZ2dExesWj0LL5P72GKOcCw80gAKfTzx3ZG5uS5AhPZa766RWI5U+2b/TjifUwD4DAlq7
	2XIjFUNI+E/4laT2YYqnlEDY4kz7XvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1726072695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RgykzFLGKbwlXxiKhzE/Xg+Ou0Sa6IH+/K2x9RLEyXw=;
	b=lhlSPE54GjxacNfSaHxQJcLPaxTeXZPLcNhXSsjpO8BEb9O2svb/51WOQh9oJ10vqQ4Fmm
	RtmFjQybWi9cQYDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AEo2Mgqn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lhlSPE54
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1726072695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RgykzFLGKbwlXxiKhzE/Xg+Ou0Sa6IH+/K2x9RLEyXw=;
	b=AEo2MgqnkTXgW7oo9i4z9gtkG7L4zn5Gvt37pQskFlhqN4KajB7p5nYgTkemjZn1dESOij
	AOZ2dExesWj0LL5P72GKOcCw80gAKfTzx3ZG5uS5AhPZa766RWI5U+2b/TjifUwD4DAlq7
	2XIjFUNI+E/4laT2YYqnlEDY4kz7XvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1726072695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RgykzFLGKbwlXxiKhzE/Xg+Ou0Sa6IH+/K2x9RLEyXw=;
	b=lhlSPE54GjxacNfSaHxQJcLPaxTeXZPLcNhXSsjpO8BEb9O2svb/51WOQh9oJ10vqQ4Fmm
	RtmFjQybWi9cQYDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 370A6132CB;
	Wed, 11 Sep 2024 16:38:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3XkBDHfH4WZpBgAAD6G6ig
	(envelope-from <jjindrak@suse.cz>); Wed, 11 Sep 2024 16:38:15 +0000
From: jjindrak@suse.cz
To: linux-trace-devel@vger.kernel.org
Cc: jjindrak@suse.cz
Subject: [PATCH 0/2] trace-cmd lib: Fix potential integer overflows
Date: Wed, 11 Sep 2024 18:36:51 +0200
Message-Id: <20240911163653.12606-1-jjindrak@suse.cz>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-0.01 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	BAYES_HAM(-0.00)[41.69%];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_NO_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -0.01
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 4B37821A7C
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO

From: Jaroslav Jindrak <jjindrak@suse.cz>

There are two possible integer overflows in libtracecmd when reading
CPU data from a file. The first one can cause the size returned by
stat() to overflow when assigned from off_t to an int, which can then
lead to a the read_size and the file size not matching. The second one
occurs when printing such an error because we use %lld to print an
unsigned long long int. These two overflows can lead to a situation
such as this:

libtracecmd: Invalid argument
  did not match size of 3451486208 to -843481088

Jaroslav Jindrak (2):
  trace-cmd lib: Fix potential integer overflow in
    tracecmd_write_cpu_data()
  trace-cmd lib: Use proper printf format specifiers

 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 lib/trace-cmd/trace-output.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.37.1

