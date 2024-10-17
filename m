Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA3D14E2FD
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 08:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153296; cv=none; b=jIJDmNU2vViFN5CYcMxBNqmi1EKen1aCRhOwieiuE+eR6jQvG8g2yTWvSlp9qEYlpfUaflV7qUQUp1oh5h1bxYGUOUvuN/fuBvc+gbXdlVfT5COOLnIefABTsKY8lNxtjTWaytZZsu5ULJ/5Qp6PV8YR5hL3OPG9voYLsz4jGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153296; c=relaxed/simple;
	bh=h3CdaRENX83DP/anB+F7LHIUPFD1f6xYXFbrnq59SWo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g/t1HrC1hz6ZvqkhcHeT85Jny5ZPBeY3My2muC5vk+C70RcbAEBI4K1YKybf/fhick8wZI1mKM5Nv/ryTDqAhiO/2dxhyW3jF1g20NtNmluh5lirbJr1KL5NOOR+ug/gFTGpgukr8pGdw+mbHjep+WzXR5zxnfDGiQvHo1vcs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DC6FFEC;
	Thu, 17 Oct 2024 01:22:02 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 320293F71E;
	Thu, 17 Oct 2024 01:21:32 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2] trace-cmd .gitignore: Ignore utest/trace-utest in git
Date: Thu, 17 Oct 2024 09:21:19 +0100
Message-Id: <20241017082119.247946-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test program utest/trace-utest is created by "make test" and should
not be tracked by git.

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
Changes since v1:
- Added a commit message (thanks to Steve).
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index eb1b0dbe..a746b856 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,3 +27,4 @@ build_prefix
 build_install
 build_libs_install
 ltc_version.h
+utest/trace-utest
-- 
2.34.1

