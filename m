Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3919274651
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Aug 2025 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755724817; cv=none; b=t5PpyB3/Dg6pGLoHkc6nCZdzm/biXjuprOEyeDD4oc5y41Qk6NmCPUfspCRhIs23hsNklEMV3bKg/wj6oUe1YgBy1hVTgiXNrOIwM3u6DtCU/iE0Yt6GJYxZh5NEfVVWsRaRNn7IIvR9VAu39wzEv82nbaEtMu8iKDVrMGS/3h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755724817; c=relaxed/simple;
	bh=JOSkfF8vRZsMA4o7VdO7yVAIcRSH0/3sbRlzRcP/u0I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iJLwrfLG1UomLKVXpmdcN/rMMTCxLdhKEVTuGXh8+NCKeujZfKdYRQr2hEBiOjVfwAPgfLa4tggtUg56K3PynnIFGx3ZN5OC/n1Xd/+Ma0Js9IJnOg4jM9IAl4JZJhrLefqhETA8DoKF4oz5n+1s7iRfi2y28s+aGPfSC/FHv7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=KO04edWV; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="KO04edWV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1755724484;
	bh=JOSkfF8vRZsMA4o7VdO7yVAIcRSH0/3sbRlzRcP/u0I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=KO04edWVKV2zkyCwx4tbvD87RpPOmSxv+H+fSE5IynJunX+ACOi5rptwmuVOkGdbh
	 9Wd4CMIr/K4ozd6vWm9gyldrsznqUHMlZt2ePDSlTDoaSEU5P+EQFRVm/CRoQboZid
	 aWY+ltqIxCnP1RCNpCf0hR09maYdRhggOyV4KtGrnch1gsMTx8pTONIrfacFfXsaZL
	 4QoZ4jVAssEia82H3FALsWB39xm2giSHnKXB3nj1h5F4ak81ySX/D+550E0j80LHG7
	 a/HiN730W4BqgS5lqZ7HmtwUyYJVKv81ngRehFVbEnF7A+Y6Z6Hk9EQCDkKilekb2p
	 AsHF0e/7sscqw==
Received: from integral2.. (unknown [103.216.223.55])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 35F833127F7F;
	Wed, 20 Aug 2025 21:14:41 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH 0/2] ccli: Two small fixes for ccli
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 21 Aug 2025 04:14:32 +0700
Message-Id: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steve,

Alviro and I found two small issues in the ccli code.

The first one is a warning about uninitialized variable in the cache
code. The second one is an optimization issue found when clang warns
about unused return value of strlen() calls.

Fix them.

Ammar Faizi (2):
  ccli: cache: Fix -Wuninitialized warning
  ccli: commands: Fix optimized `strlen()` calls

 src/cache.c      | 3 +--
 src/ccli-local.h | 1 +
 src/commands.c   | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)


base-commit: 418ad6a341a5ab6c21be666565d62a878aa3bd18
-- 
Ammar Faizi

