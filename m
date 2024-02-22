Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76D93F9F3
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596766; cv=none; b=jMBSrsE6feTubs5tZ7MRyp0DllvwGielJuzxaxWUT2osYHAHtjnLwDWt35E9ukG5foFm86W2OOPqSD2SuyYrV9YsD3itwNLWfIu7eBFv6NgpIzXy5u3GqVr9AkJ4EEYlviVwHEQRhiadRU8Q9Rn/+cnmCJAYVjHhfZFizk9ih7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596766; c=relaxed/simple;
	bh=EoiTx4uct3Fu7kGvIeJgG9RrbZvhuARdQQ4PgLhCS84=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eZATm4Df/zJ9KRl/ZNLVjGbwJocV8CZU4iONCHeMrry6oKYflWQpWApK1fmVqxbGgnmOwVeQ1BdZq2A960+PS28EHgoRMvuOs2j5PdG6PcPGC+/4EwYziIpLnNs2hUtm+Saj41wM38hEXjSbG/vCUJ4If6lH2yRQjxLNbJBefpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sKAihYb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKAihYb6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C899C43390;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708596766;
	bh=EoiTx4uct3Fu7kGvIeJgG9RrbZvhuARdQQ4PgLhCS84=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sKAihYb63tA2SMse1eSnG0KQsxusnX3fPPZrJY1jvBysEOXtqPsH/O4DCOUNLJzMu
	 1FkN98IqwBTn+wLC0WTh3I4bz7ebzqv775qbKsKMObHgKlR9lVoX0oQVaaoynGlSis
	 Oj0GWwFHYZnuyp7mZpVmL6znUcnqKXxDzivaGgcazofBosPMhWLmqVdFcVpxR3WmF5
	 CwPSmk9HF6SYrk9bf2vxdCf2Cp2+xDAEtmqXzFfyjjgrBGPT1FGYkxWeLu/O4HoSxb
	 6qI3w+fhehLnjtnB6VhWTGqK8mogT6vSzY4HVZ6EYkpkIsMI0uDmlYchpZsXlqZe44
	 TRSTI/8LjJo2g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B968C5478C;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 22 Feb 2024 11:12:45 +0100
Subject: [PATCH v2 2/3] utest/tracefs-utest: define _LARGEFILE64_SOURCE
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240222-utest-fixes-v2-2-ba9cd06b41d3@gmail.com>
References: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
In-Reply-To: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708596765; l=712;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=5SeXhPMSZNf3r3OXzTkrJzWyI2EtopiLnN2OK4A1N2s=;
 b=64d3NsTY9uZkTKjNRXuCH/UjaS+3LLBZFfwpz4dJaSHKipbeqWnQdLSaxDl0Pi7P6LfD5pBuK
 MsTpcC1ft6KDINRcQE7QHGrv1cvXMxL6UxQld66CAS9BCfEcBhl68Vb
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

From: Miko Larsson <mikoxyzzz@gmail.com>

This fixes the build with musl + clang >=15; musl doesn't declare
lseek64() otherwise, and clang >=15 doesn't allow implicit declarations.

Fixes: 0f45e68cb04a ("libtracefs: Add unit tests for tracefs_cpu functions")
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 utest/tracefs-utest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 70bcf3e..224903b 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
  *
  */
+#define _LARGEFILE64_SOURCE
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/stat.h>

-- 
2.43.0

