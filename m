Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A8D39867
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596982; cv=none; b=CHYV0Zn4OooYdgu2HtFD0Is/P+L+S7XPqjgAGNxhaVnvE7c/R6ZI1jjDS51I6yH0SCXaVwnh7OrSvFpziUE2ZfylsGHsPm8l4NuepHNfBN6BVZF0EXcwJ4THP9ENwaRFEkWhZOPyUQeVE5vh1RSKS/mnyZcn4Ku3wCxglqguwfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596982; c=relaxed/simple;
	bh=COn/D6pLYDhwL6VPTjSglKlPSGIyImskAEyn6p68szk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=D2AmV8eReX+F+60QzDzAteX+IlAJe9Exgb/mQnMB8c88fht+baCcegu4W0puzxSB2XCoNGI3Mo5wP15IhHFXrxCKyU+ejOucUzJsofeKmMmXE877lpuIIQjywBOLz7LxjK8R8kXuigzgocEHBuRZLZborJP4vyBA+BPQPKhMHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFezQJWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFezQJWM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65A2FC433F1;
	Thu, 22 Feb 2024 10:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708596982;
	bh=COn/D6pLYDhwL6VPTjSglKlPSGIyImskAEyn6p68szk=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=oFezQJWMuOzf25HYsvjAcW9321XnyBOvGUr6bI4Tf+S4fXb5lcp3gF9vkpVZTw0Id
	 M7kSMJzZorUtIgCT8iwvjrt5ZpGnRvPRS0BNv2opnF/95w7RPf3MqueFFhOFk3sHxH
	 wWJkk+gj8NOlwBORvaq2eTjPe9vZWNGKqKc3MQmmHZW5Cd/v+Q6BnqZ7QWDPrUhwPU
	 0fv7dIHEbOhEDrju2ciSKGG2+Su1dA633ZCQLRdCxVqmC6OWRL8R0B5ZsJZ0K6Vgbm
	 dYJfBoZtloFtfJ6hX+t5R1v8wYDOPvaIm+xaxmJwWCS8inoHMiOBR/kbMRKXRijNJF
	 2GeJYTgD4Hu1w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54186C48BF8;
	Thu, 22 Feb 2024 10:16:22 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Date: Thu, 22 Feb 2024 11:16:21 +0100
Subject: [PATCH v2] utest/trace-utest: include libgen.h
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240222-utest-fixes-v2-1-7b8ee8dca0b7@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPQe12UC/22MOw7CMBAFrxJtzSJ/MERU3AOlcOwlWYl8ZBsLF
 PnumNSU855mNogUmCJcmw0CZY68zBXUoQE32nkgZF8ZlFAnoaTBV6KY8MFviui88c5pao3uoRp
 roP2owr2rPHJMS/js8Sx/6/9OlihRu/5iVSuNOPvbMFl+Ht0yQVdK+QJ84vY9pgAAAA==
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708596981; l=995;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=6Ny3lyrBgkhFAqGaBY9h9ovP4pU1KSlRzmaYH3L7vp4=;
 b=g7no27a/CNeGdKT0TxMHMXmvcPkuv8xDcmAf7Rm698Hy/Vf3Rgk/TaxQLRN2KJuzvho4f7Ag7
 YQhZh5hPRoaAemc78tSFkiE3yhglhaxS35QG3/2ZAYDxGKyjbaZdLlu
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

From: Miko Larsson <mikoxyzzz@gmail.com>

This fixes the build with musl + clang >=15; musl doesn't define
basename() anywhere else, and clang >=15 doesn't allow implicit
declarations.

Fixes: 58cbc1b2a84e ("libtraceevent: Add unit test framework for library commands")
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
Changes in v2:
- Better commit description, message
- Link to v1: https://lore.kernel.org/r/20240215-utest-fixes-v1-1-3cb7a281506d@gmail.com
---
 utest/trace-utest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 1403c86..a26e42e 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -6,6 +6,7 @@
  *   Copyright (C) 2021, VMware, Steven Rostedt <rostedt@goodmis.org>
  *
  */
+#include <libgen.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <getopt.h>

---
base-commit: 6f6d5802f31992e7527a4c32b43a32fda6bf6bdf
change-id: 20240215-utest-fixes-cd5dcc3e853b

Best regards,
-- 
Miko Larsson <mikoxyzzz@gmail.com>

