Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD1B1D5145
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729007112; cv=none; b=ZSq9+HTdRPqVWAgxO7wc7JYjbTePLfjgmnJoDQq799dOl7RdjlCw6OfYav8K0zfabfCFt6LRMXeUTEj+4Jd0Qyl3iXgaxPQkDmn9EeMN92axXT5F2tv9BIEyTvmVcOhJOt+HzHfbadMge+Ae8WM38o2fdHXBLOUqvup59+EyBAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729007112; c=relaxed/simple;
	bh=/NHPTaL6el/rL6vxnrKnM7ZrceLSjv0Q5eBtcykrbtc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hy1LFcqnmnT0oVmKSfO4Y/ZIlZwCK5D08xYhP+3CpTWF8QWLSWQi5IqJOXLecK6r8zuiQqnY12WH3rIzHkpiMY9CEV3C2h1hQOe7X2X9Tu67RMbsOTAIIruhl9qCU6brXzp9ht7+yyi2T41ubjkYJ/wfEFXCIPGoZl8suESikAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B3F91763;
	Tue, 15 Oct 2024 08:45:39 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4963C3F528;
	Tue, 15 Oct 2024 08:45:09 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH] libtracefs .gitignore: Ignore utest/trace-utest in git
Date: Tue, 15 Oct 2024 16:45:02 +0100
Message-Id: <20241015154502.4189900-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 3e72a58..7e61473 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,3 +13,4 @@ tfs_version.h
 *.o
 .*.d
 sqlhist
+utest/trace-utest
-- 
2.34.1

