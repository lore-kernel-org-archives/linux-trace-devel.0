Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76F73F9F5
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596766; cv=none; b=HgdQXgUkfUSiuwKG4C/eiLPR3FNP5fRBDk4w4a78+sNHy81XEENuFR1xqSnldWUHdZxjgnGNHK82DNJDCpwcXIkS4HPppVc9qz8HCWBKlglDVp2plvSbb/UmqVRh2faJSw2o8OOksm+7oZ4QBxKp8EOiKxI3TX9K4jjD/cWSUFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596766; c=relaxed/simple;
	bh=1sVpsr/KveokqtJD6tJodHE+uHJOk2SHtqKyA/DMj8c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g0DkD9gYr9p1Vvm4jFXr4Rlw5wNiNLFgO9oiK+UiFrAD1qRcj7WtMBBafuuOAv15DeR0D83QT950NHtmEKPBUZKqIk9pWUY58K2+GZC9ZBGYhESiyJ5eV0eRBFksUHCs7/hZ5oQ4IjwlQgW5gbfkflRsoBDldDJCMW+c/1dQtDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMNNdloQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMNNdloQ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78CFFC43399;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708596766;
	bh=1sVpsr/KveokqtJD6tJodHE+uHJOk2SHtqKyA/DMj8c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XMNNdloQBfPQDtE5MJ/4Wlo9ogInNdyCrnW9rBb5g3Xta3A1dF4dyOQzRUMBuXv5n
	 Y2jqTlXhxfHphNUFLMV62img4JAE19XIkNgvLwAyLjCEe+0cOjtcqPw+dkT+lwyXHe
	 KRCn5WTAErnuQGW68vN80tLfYJlmUhfMvQF4+lEiSeSufD3Qtv4swLTanCdSFbZMCT
	 OxKSyn0s7/KFslv3sfLDhvM/FL+foLNbsNhl82QEjqW8fdcIz6Q/vChcfr8rJmhsog
	 Mfw/PfkZhcWTR20ZSH6OgYcuirgjmyw8p7QxkpUEIoXBAk/uB3pKEEhvNUwVdY5pag
	 NZwabr5HIun0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68598C48BF8;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 22 Feb 2024 11:12:46 +0100
Subject: [PATCH v2 3/3] utest/trace-utest: include libgen.h
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240222-utest-fixes-v2-3-ba9cd06b41d3@gmail.com>
References: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
In-Reply-To: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708596765; l=667;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=EetEr7KQnL5UP3Nk+LwH32FOuETzJwv3l+Uu0BV2+ng=;
 b=ApgoaBoIwbpv0szrNeoC41jE5sAhyPiQTQK71d+DGhAgbbyYbSeVpJzQSiMQDRKAgAiUL/5Yz
 1sj8NL/YmR5CtOqz4xDsY4ROBeBSACZUEAvpvfWE+DHTOloiO/u55wL
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

From: Miko Larsson <mikoxyzzz@gmail.com>

This fixes the build with musl + clang >=15; musl doesn't declare
basename() anywhere else, and clang >=15 doesn't allow implicit
declarations.

Fixes: 845f16976929 ("libtracefs: Add unit tests")
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 utest/trace-utest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 58d4d4e..39485a1 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
  *
  */
+#include <libgen.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <getopt.h>

-- 
2.43.0

