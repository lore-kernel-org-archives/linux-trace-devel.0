Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A11B950
	for <linux-trace-devel@vger.kernel.org>; Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987766; cv=none; b=cIt+7xUYW/HwlSinuM5JQyfpRwNlwf3cikhDN3iE8H1cmBnaDlKQEa+j82fpKlFfb5svsqH8Dmxz4QZVRSofoEtytk4Ly6BEKJZBP0M5pnrBD1P8DcViernWlREN5Ft9Pw6pKKziXoNvDm6weFJVVLAIgWu4cobdlQAXizmP14Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987766; c=relaxed/simple;
	bh=YCe3Qj2vHR0Dn0DXSLdzQyV0T3DSHb726U5hdBBB0GE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DRZ3YkMlVT0cSeA4BO/L9G46ZfbwURJxsLk86B8+LlSMTTqAGekW/yGv3PRd19+yzU+g/BUGWZyMriu49jUH64zUxqcLkLR1WXrZsUTVJx/8f3/FY+/aGgr3VWgzZHIThfOIy25Xri45oTrQhTiUDKZwPFWcPuaHJHXf7TmHfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjAfn7AA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjAfn7AA"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5DF8C43394;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707987765;
	bh=YCe3Qj2vHR0Dn0DXSLdzQyV0T3DSHb726U5hdBBB0GE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DjAfn7AAJoDJ4f6D3i1QzPBXsqf23ML2mLGe2stNC+3TtA24bB0G/6b3S9v4HgTGC
	 W49J/DoJBgQwd8RDXOPly4FZLaCN0n6PQJpKJQmH38hdOO/T7JQTiywh39wnHNMcxW
	 3FUEe6u2UiqzE52M/2r+HHGN9C2KLzTbmPsW1xu6hd5E829o8VLLAT3Wkj25lKloAg
	 Qfko5Od/+EAuhejLYmaKcAPeiLhRqbOjYsdNSHIrQGbGuDLQZ4fWDqhGi1AdSa0Dpl
	 8eEAlnjB3U9Cmh2VY0ky9boCOKObU4oVd7iUbKNfEYBcNMW0MqT/sMocG+IG0cqcPn
	 yjfM+NyaPWyTw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6806C48BEB;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 15 Feb 2024 10:02:41 +0100
Subject: [PATCH 1/3] utest/tracefs-utest: add missing include
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240215-utest-fixes-v1-1-24678d859de2@gmail.com>
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
In-Reply-To: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1707987764; l=532;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=RzwubJwK0n2/ywZtJ5O3qrBEJeAAen2BvWlXzylk00w=;
 b=/aZm0dyIJkZyKx+5XKtxGdfUWZxc3VST5x4tvllBN67s1geqBaMRCQ+l74PD6cTkJ9y/Nhtaw
 4EDmkPH49sJAu1wNcK4pR8aM6/X9t+Qvd/guWd8lO6hm3Bs9AnMie7Y
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

From: Miko Larsson <mikoxyzzz@gmail.com>

Fixes FTBFS with clang >=15

Fixes: 845f16976929 ("libtracefs: Add unit tests")
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 utest/tracefs-utest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 963fac7..a798ace 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -19,6 +19,8 @@
 #include <sys/mount.h>
 #include <sys/syscall.h>
 
+#include <linux/limits.h>
+
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 

-- 
2.43.0

