Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE7A1B81F
	for <linux-trace-devel@vger.kernel.org>; Thu, 15 Feb 2024 09:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987767; cv=none; b=N3csvjUa6aFvoWN7l0VJE9DbnOaoNUMtt6QuDsfxdkJqevh566HVV297+42WOQ79CrqDf1TjJnlPj4+bcnEsJZWZYZGS/MB95oNWGFR4wkTlBwK0Okjoh22uNlF0AMuDAqMK1SVEl9ZywlvHO97Gvy0mWJuDB0YtBAIxikGVmCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987767; c=relaxed/simple;
	bh=OxuGFqZU5RwXnupkf9nL/atOWJE3g/FF7zebax1S7Ac=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l/492ZN3NC/NXXg3ZC7IOsXO9ZW8+wjcPHohS0kQjpuCbax5HSFP7IdSb8E+RlhgAMNb1wuLpA9vPQSDbkt7YdB76OnDo4FPkinqjM9UESlDCz5Imn8ax5Ca7Or+8J52jqG/8nvDtrbdh0TRb2cWxOe16sZBlkxDecziZS/mqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPPzS6UY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPPzS6UY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E16F7C43399;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707987765;
	bh=OxuGFqZU5RwXnupkf9nL/atOWJE3g/FF7zebax1S7Ac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IPPzS6UYwlViGefs56Iw5oi2NAalmVCY2hUOGc3KVOOTV0JtgSDv9qNw1nRJt3VMn
	 7V9HdhMhTE8ejhw0Tcs6SS0CAP1WzXVFGVOX7ddropnVBOOlXcECDtAGIsJSMQpUAm
	 pxN0/Yqi8QNZH2INYT+hjjh883xJNzYO3OwQsylTiLI7xmLBCo4fdecfHAlZ9dzBp/
	 /o4VGTva9a79/NbovRL+iV+M49zyu9TX+PoWa638Lw80HeH9UYOpUMWFNbnUILdpPR
	 F18bYs3ICz8xGDE3oxXx8iclKD3YZfkwgaxu3p7lcTi1p5JeWGbn4xm70UE3ZQlyxv
	 URNgBZeUiS0bw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19E7C4829E;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 15 Feb 2024 10:02:43 +0100
Subject: [PATCH 3/3] utest/trace-utest: add missing include
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240215-utest-fixes-v1-3-24678d859de2@gmail.com>
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
In-Reply-To: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1707987764; l=549;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=kXkgaZM5Vzaw8MUgARUr0Feh2OE7CWrfGiYcTXTyl/8=;
 b=P8Vq1ExOF+dEqttcdgMg92axx7De+HVFkNZDuJgY1lm0BBFbGKEMTneb4puXFXjE7386HCfRn
 jjK7X91ODFoBCbPLgIuKjBk+aQf3uuVUCv+9dSIydtQ2+OcECejOlZO
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

