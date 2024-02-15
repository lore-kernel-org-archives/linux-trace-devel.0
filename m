Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5621B94F
	for <linux-trace-devel@vger.kernel.org>; Thu, 15 Feb 2024 09:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987766; cv=none; b=AbpmhQICz0Ka6C0D0Sj0vMUvXrriuhrrhv+owGR+VKGeICPHjEIiAjiIkHFZUuYn3PLvc8E/nfKEqeQdlaNgj9kJY0ccf6VdWxMMNp2dxq3y5ctyJJiEFjDmSTxEGlkiIjc2ViGRRuOpV9ozcEcQnNwrjvMiOqA9BY0wrp7esb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987766; c=relaxed/simple;
	bh=z+rzZ0mKJiTTAr/G+jedalSAy36A0aCunxv4JVTb+M4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RLJWmKe2jitDDMPh7eHuPAMGVnu3oAXRWseeLSoFQDji+VXmaCaverN7vNnusrdd46XuXGZUQ+bDWaMbrVjMobijszwucqkFF9grvtuhshcl1hk2Q6wa50O0yyVykWmJLuWb+K1T3yymXhmZa3xIpCvBWS/UbvjQiuH9xb7OspY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJoODqj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJoODqj2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2D40C433F1;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707987765;
	bh=z+rzZ0mKJiTTAr/G+jedalSAy36A0aCunxv4JVTb+M4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qJoODqj20/xQfA7NK9Y6weDPp+GD/t+sDNP83x2qt08k6GQPs1D3JoHMeVCak88tG
	 yBSmRPReF3wyuBUnxfhpPvoc47gQdi0+fjsGrnaPn31+L27xSoTLZDKW7m1FBhtPdB
	 pqZhNN6jtdMd4yAER0Wb8bqZTtYRoHfyjHvTSfq4pO4LdEjpadogNJDxpkF0KNLs6r
	 vrEQDjgVPFR6O1nDOaxgErPY7Ga9hasmnJvKTioUTr825cm3ayubL60IkJdBxIOfy7
	 dJclit+2Aw9rZWdiqahftY1ulE5G89r0QFVo6w8cFaFi6Y78aRnZHiIeNLb6YnZyvc
	 W/tVSa/I+xWRQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D83C48BF0;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 15 Feb 2024 10:02:42 +0100
Subject: [PATCH 2/3] utest/tracefs-utest: add missing define
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240215-utest-fixes-v1-2-24678d859de2@gmail.com>
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
In-Reply-To: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1707987764; l=600;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=WatW4A5ff1zXd0UKVabbH5FGJ0iBrroLNhZ+TKD11KQ=;
 b=TR7ztiuBuVrFS0D05PaJoFLNX5OXLrZmeCnDJHVnLRAofKi9x6ydjJfxyvQkoOeckUO08rEiJ
 CM4IgZbC4IoCgc+wiUg7TzXtxgx60orE6HCotSfqZHdfWe3EAFaz/Gg
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

From: Miko Larsson <mikoxyzzz@gmail.com>

Fixes FTBFS with clang >=15

Fixes: 0f45e68cb04a ("libtracefs: Add unit tests for tracefs_cpu functions")
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 utest/tracefs-utest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a798ace..e30e8e7 100644
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

