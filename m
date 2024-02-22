Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14893F9F1
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596766; cv=none; b=kcJ08cSc7Cw2d2zVpvSkJyyOKo8N9c7Ftj4jhOMEd0vhWrLZ4p8Z8vfv9ZBfc+J0KglAB3fUrMBWR0oacWY159F7WLrDp160jgkv54o50+eIKITcfbPFm9+qR4bZLqVSIWUgmT7wQNz8u6cu2G5oLyXCic0urvsIhJ0lyjpsWus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596766; c=relaxed/simple;
	bh=pf9GRBXf0zWEkISsxP/DHBNGtJ+jdtSV4tq+qMI8LGM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SSD21fq8O9rvZqi1Fw2huMO+dUM3QTfkFjS724PI4l02Rbl8vRz0h/Xq4pj8yzAApBqa6r8W3AgDmzYm0mhAbL1LJxr8qO4fGgu3+kOcm8oxwW6MujrFACwUkrOGVB2R3sOWsa1twSi27e4w8vIl/a/1tXUjEZ1K2nn65jqr2QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULd5P/rI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULd5P/rI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51625C433C7;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708596766;
	bh=pf9GRBXf0zWEkISsxP/DHBNGtJ+jdtSV4tq+qMI8LGM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ULd5P/rIMGT7POqdkjDz0iLhnEB9XeaZcGiU8HWr2Bgmg6Qo/I9cOdEM9QPjxdgsH
	 9KdOwPMeEcDWUQWvzjB2+8B5LhlFi6n9rcRAl6b7OSSuyFlFweiJwsqwxMKiILukX6
	 fXUfbcRUmHyLihFsInScX/2RHnriOn/T+XmXl3UjH0/aUy/uKDuk1LLjjYSiOZ9Oe7
	 l5tOJ6KCWrSerBDGQXQsSPpppre8pZMwh9ZbtI0nnQB77AUhUWqW8YZg9lhqeXBtIq
	 rdEL9R+4UKEKjbF1oTIkM+Er3VYoTTV1DZpih5Hm9xsEQFBB5cwf0vBpoUnodMDu9O
	 W5v48R0l77fwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F24AC48BF8;
	Thu, 22 Feb 2024 10:12:46 +0000 (UTC)
From: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Subject: [PATCH v2 0/3] utest: fix build with musl + clang >=15
Date: Thu, 22 Feb 2024 11:12:43 +0100
Message-Id: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABse12UC/22MQQ6CMBBFr0JmbU07UC2uvIdhAXSESYSatjYa0
 rtbWbt8/+e9DQJ5pgCXagNPiQO7tQAeKhjnfp1IsC0MKLGRqLR4RQpR3PlNQZi2rpUeCFEPUIy
 np/0owq0rPHOIzn/2eFK/9X8nKSEFNqezsUa3lvA6LT0/jqNboMs5fwFWCOQfpgAAAA==
To: linux-trace-devel@vger.kernel.org
Cc: Miko Larsson <mikoxyzzz@gmail.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708596765; l=901;
 i=mikoxyzzz@gmail.com; s=20240215; h=from:subject:message-id;
 bh=pf9GRBXf0zWEkISsxP/DHBNGtJ+jdtSV4tq+qMI8LGM=;
 b=SX0huGv671lRd1WtwcVr+j4+yIYmxOJ0fqSRb681X5sDzzl3GsD71Uf67TY3axSMZkvmVCaBZ
 51TWAOyLy9gBJqBwlnOaOwxxy139O0ZfdpvslbBk65DCsEJI4+YVFGG
X-Developer-Key: i=mikoxyzzz@gmail.com; a=ed25519;
 pk=1WO6EuQa9ZdBA5vCl3bQNjIb6FdQDoTriJmTDrF5mFw=
X-Endpoint-Received:
 by B4 Relay for mikoxyzzz@gmail.com/20240215 with auth_id=130
X-Original-From: Miko Larsson <mikoxyzzz@gmail.com>
Reply-To: <mikoxyzzz@gmail.com>

Clang 15 onwards defaults to -Werror=implicit-function-declaration
which, combined with musl not declaring all the stuff we need without
the missing includes and defines, breaks the utest build. This series
fixes thus by simply adding the missing stuff.

Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
Changes in v2:
- Better commit descriptions, messages
- Link to v1: https://lore.kernel.org/r/20240215-utest-fixes-v1-0-24678d859de2@gmail.com

---
Miko Larsson (3):
      utest/tracefs-utest: include linux/limits.h
      utest/tracefs-utest: define _LARGEFILE64_SOURCE
      utest/trace-utest: include libgen.h

 utest/trace-utest.c   | 1 +
 utest/tracefs-utest.c | 4 ++++
 2 files changed, 5 insertions(+)
---
base-commit: 5f27b7f3fb7d88b29522baf3883cc0e2e28b1af0
change-id: 20240215-utest-fixes-893315be225b

Best regards,
-- 
Miko Larsson <mikoxyzzz@gmail.com>

