Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B145C3F9F0
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596766; cv=none; b=VYmiQEemuqURpfx9i2YSQLg4sjkMmGOWN1tH/jnOHGvecsbURs7UzyUSO9DFlh24kYnU9SFH5c3Cg2GmiaQnEWL1PfQFmYP7QmPU+yrdGYjSFFw9UA213OYsbdu9gjOkQCLi7xMTLsWdrCh9zok31f7Mjk3tL4cXMvrmH9Aa3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596766; c=relaxed/simple;
	bh=WYbaaROxJ8zpmPOenkC4a6YFj75YP20m2E1WeRaJY9c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GwrPzR8XaUHQoafWS/P5uUhWlwVwSLK6Y7mar/GoJn0Q8wA8PglZAaSHJGBT0eF+qeyJjMIlonnWciRHRR/hr48ZQFkm6oPkIxhqGu2fdil3V5IkYh8vwxhexJ8//MvVk+QLgB2N0BS/crgtuSAv/QM7MANTYlpKN7TgJeUfEGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcwmieH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcwmieH8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F2C9C433F1;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708596766;
	bh=WYbaaROxJ8zpmPOenkC4a6YFj75YP20m2E1WeRaJY9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EcwmieH8xUCDt26Kd/ZNvkmp822feLqX1cpqEIfFBNY8jB8NRmbb9Eg9s7VYI9c4o
	 QEd7VmdsixVNXF9GO+aLaL5Ed1H/ffoyJ9PSQ4c/km5nY7ZH3izbxdWaUSllFXSSJD
	 uNU85wXuYRs2RbV6656w9AmfyhKEu+Oa6UtfrynlHezWD32JL6UJ3F1P0Zrj5QzRVc
	 RxTRZb9p+fhkdzzMZO5FR1BdyfPDh4YrdQX4pHMvsrcP0Y7Nx1z028TFgI3CfoEIwk
	 e0FXSgFoptcf+sGp/q0TUUYpLD/JVQgwls9WVEayCvfN7LVLSqGws2rOfRhthqEQrr
	 E2PYIX9+7Q8AA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAF4C48BEB;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 22 Feb 2024 11:12:44 +0100
Subject: [PATCH v2 1/3] utest/tracefs-utest: include linux/limits.h
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240222-utest-fixes-v2-1-ba9cd06b41d3@gmail.com>
References: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
In-Reply-To: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708596765; l=871;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=fJxacPVoyFtCYtoqXqDtpb725G8Jw3FCfY22Xy5jABM=;
 b=Idf+mPBK8Jeu1EXfl3woR8JPDGgjJ/7P643F1zkJzj9BaGQWJdzDMwDpUn7Uz/N5WMEn7ZlqF
 0Vb23hGg1TyDK2N3Yb23L8eahbKr77dX7Uei4zMEyEurSApH8ZOvF2y
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

From: Miko Larsson <mikoxyzzz@gmail.com>

This fixes the build with musl + clang >=15; musl doesn't define
PATH_MAX anywhere else, and clang >=15 doesn't allow implicit
declarations with >=c99. Without this, the build fails due to PATH_MAX
not being defined.

We could include limits.h from the libc, but AFAIK the libc doesn't
necessarily have to define PATH_MAX, so it's safer to just include
linux/limits.h

Fixes: 845f16976929 ("libtracefs: Add unit tests")
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 utest/tracefs-utest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 963fac7..70bcf3e 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -16,6 +16,8 @@
 #include <kbuffer.h>
 #include <pthread.h>
 
+#include <linux/limits.h>
+
 #include <sys/mount.h>
 #include <sys/syscall.h>
 

-- 
2.43.0

