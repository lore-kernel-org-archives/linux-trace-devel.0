Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52D1B943
	for <linux-trace-devel@vger.kernel.org>; Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987766; cv=none; b=RzEBvfSFdxiI7GhDqBLqekWYEMhaG/Ck7P65biZKu234NgbKqDI/lPHumTI7v8XZQQfsJ2QuclIBSKm+0aZOzfmmNQtIA30SIfW4rgh9I4kqboBxyH8KodvYXl4nPtxTghEbDgEzXZejfw3ypQ/jfr8Jh0puBlNg/0RGIyOlOWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987766; c=relaxed/simple;
	bh=/rNiuekXqfH7463kjm5WZy3JG7cQy6DQQxjQ9sRgopQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Tt1sGX+kWiv0xJfnGGdL3gCFtacq+Xyk4YWjA9SZwU5GH8A1wv1c2xB8eKKwhTuwiASV0K4wLHQNdTSrSm1aPnxetVFD8wmbnyVnArVdGWvNDLZCfpCKNkkRnJ1JYfHfS5PSBmIrbZicyqK+WJTvb/R71LRS4OYk3Zy3t0Jq8ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3OUK4Lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3OUK4Lh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7A70C43390;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707987765;
	bh=/rNiuekXqfH7463kjm5WZy3JG7cQy6DQQxjQ9sRgopQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=T3OUK4Lhw9AQK/+QMRNOnu8yeiCeuBnM/ZhLNh6sxSqpVhZiJlEInAsRNIZPE5vxg
	 lMyWeuZrtaVsVGUFGOcVNCy/t/gddcHRFmMYU/gKBLAm97sV07Pmf2CFVAN48pPoCO
	 Lzs6aTgYzFkT1WYxCcsZzLoyEzK7KTsx0o8kuI9u+1d3CbtfH1UDaeiYW6r0gYhi0S
	 7deYYzlyymzy/f9VyQLLXUJe5agPyTK9px2KPzusYuatCUa3pMHwvuMu7Xme6AgRJZ
	 SyQmRcVCfBweO0YIlRykhOhbCa7F1fxc9cItRXfChF4nSbv3aRWZAfMb2pdCW8k3Y6
	 ICL2wTn4LGgzg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4855C4829E;
	Thu, 15 Feb 2024 09:02:45 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Subject: [PATCH 0/3] utest: fix FTBFS with clang >=15
Date: Thu, 15 Feb 2024 10:02:40 +0100
Message-Id: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADDTzWUC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDI0NT3dKS1OIS3bTMitRiXQtLY2ND06RUIyPTJCWgjoKiVLAEUEN0bG0
 tAE72LLtdAAAA
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1707987764; l=666;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=/rNiuekXqfH7463kjm5WZy3JG7cQy6DQQxjQ9sRgopQ=;
 b=dj4hWfMLYYUyytW96ax2d9b98e+2Jjnh1DiqPvWkK04jP06UVF93uxuJ+GGCNjzvXCjAha/cb
 wtv2XICWYcwCjxUI/YG8aLqm7M7G+XoQ5GPY2fqGvXpc5C3a4i+L8Mt
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

Clang 15 onwards defaults to -Werror=implicit-function-declaration,
which breaks the utest build. This series fixes that by simply adding
the missing include and define directives.

Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
Miko Larsson (3):
      utest/tracefs-utest: add missing include
      utest/tracefs-utest: add missing define
      utest/trace-utest: add missing include

 utest/trace-utest.c   | 1 +
 utest/tracefs-utest.c | 4 ++++
 2 files changed, 5 insertions(+)
---
base-commit: 5f27b7f3fb7d88b29522baf3883cc0e2e28b1af0
change-id: 20240215-utest-fixes-893315be225b

Best regards,
-- 
Miko Larsson <mikoxyzzz@gmail.com>

