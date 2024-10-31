Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B7F18C325
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Oct 2024 09:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730366399; cv=none; b=SZ0FYrzXHj0YyT5Y39mobhVMUqGnLf+kZCLCaWOoQwu4opSepWzroaQVt+vtmAoTeNJomh9tgMDstoU2slNnTba4uqY+3GYnr69N97NwCGVV7OCf27LVVQm0eHQZ821c3vs+8b+1JyVr4xVkhi6UeTw49bpkd2zrUszIFIlIc2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730366399; c=relaxed/simple;
	bh=lbb01bY9J8CkpbfKXsqZitMYsqNtfwyCyDG2qBpYivI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m0pZ+kIaBqHGYjRtvCnfsczXPxti9L6hIPlxYGBoTWr5sKQFLNnyX9JzvbGegacpwfnIWP9kzq+7Pf4+CiFTzR56rfOIr3XUYhif2u7hQVyHgdNgYq/fB81pBfEV4+22lCRTpvUtGs+tfkHLdhq7uUtWfKWZGoeH8X+OLHZcEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73F891063;
	Thu, 31 Oct 2024 02:20:25 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2C3E43F66E;
	Thu, 31 Oct 2024 02:19:55 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 RESEND] trace-cmd .gitignore: Ignore utest/trace-utest in git
Date: Thu, 31 Oct 2024 09:19:48 +0000
Message-Id: <20241031091948.774299-1-metin.kaya@arm.com>
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

base-commit: bbea061f69dab3a55dc5c077bf89a02f8f08cb6a
-- 
2.34.1

