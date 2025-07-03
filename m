Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3B4242D87
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Jul 2025 11:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543702; cv=none; b=MFH44b73mBXCP9Ri1yUukegGWLw7z+80v3m6D8XSiWTAt2uAPaHYJZnvWpc5cllRyPeaA/B1n3oXhT6NXNIL8GYmYMTXeSvQKEwTqRehBion6J/8ElB6EU8q5u8LyM4K+K0++T91pOo9kf0+q+33XE7MoUu3IvcW0zFOh0atTzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543702; c=relaxed/simple;
	bh=7+LJBa8Nk3yviewz2mnTEvdy79Y70e1Ykk8k6tMDQDs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qb0yd6tPWT2tBPLEjqHhNxHygE4N/eCCj8vNoC/t9SVvDTF8BR5+GLX3+h/JMarc67MEYEB/I9ACVYVEab02kuXOB4VNvPvw/YddNPDpqHitZ3xnv2P6QAUZNxU2GNgWZctoMxSgVK2+r1rKmOWVxXoyVAs1TCQTkLm9f+CKT8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=s6tUJCHK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="s6tUJCHK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=PZigSTViVPrkgvBTkIx+BkbypDFS6o0NSd/bT9HplQ4=; t=1751543700; x=1752753300; 
	b=s6tUJCHKxbWB2+CYGZt7iCpGSB8J7IRzMfDzBIVFnRX8B76JeIIfJjLBQ8H8ZzqZzhlZGSNwBrQ
	We+an2lva+v09HpryJWIud6m9It4oOnQEGsIfTvDfrwiha1Sewg2HBNgu8DbVVHal6nkxlQEEP/ZJ
	K9Ezl9Nc4yvtDM36vN5uqbpJtbwuwCXtyuGai7lofzZMW+/sxrGTY2zSmGmjiA1mBn1Layq7sBCeI
	5purtl4n7GVppY348+ngCzgLuG+oTpk9RbqKv9PJoCMuU60es53KZc6JLIt1vwoW4B2KKlcZq1ROF
	BszwdX7tabRVFGromnUnsd5441x+qIinyNJQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uXIWi-00000005JaD-32vI
	for linux-trace-devel@vger.kernel.org;
	Thu, 03 Jul 2025 13:54:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: glob() fixes
Date: Thu,  3 Jul 2025 13:53:33 +0200
Message-ID: <20250703115450.14313-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So we were trying to use trace-cmd on Android and something
like "trace-cmd record -e foo_system" doesn't work, while
"trace-cmd record -e foo_system:*" works. Turns out this is
due to API differences in glob(), so here are some fixes.

johannes

Johannes Berg (2):
  trace-cmd: libtrace-cmd: fix glob() return value checks
  trace-cmd: record: fix glob() return value checks

 lib/trace-cmd/trace-output.c | 3 ++-
 tracecmd/trace-record.c      | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.50.0

